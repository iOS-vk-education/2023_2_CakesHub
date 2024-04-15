//
//  AddProductImages.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 07.04.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import SwiftUI
import PhotosUI

struct AddProductImages: View {
    
    @State private var selectedItems: [PhotosPickerItem] = []
    @Binding var selectedPhotosData: [Data]
    @EnvironmentObject var viewModel: CreateProductViewModel
    var backAction: CHMVoidBlock

    var body: some View {
        VStack {
            BackButton
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)

            Text("Выберите фотографии товара")
                .style(18, .semibold, CHMColor<TextPalette>.textPrimary.color)
                .padding(.top)

            PhotoPicker

            ScrollView(.horizontal) {
                HStack {
                    ForEach(selectedPhotosData, id: \.self) { data in
                        if let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 200, height: 200)
                                .clipShape(.rect(cornerRadius: 16))
                        }
                    }
                }
                .padding()
            }
            .scrollIndicators(.hidden)
            .frame(maxWidth: .infinity)
            .padding(.top)

            Spacer()
        }
        .onAppear {
            selectedPhotosData = viewModel.inputProductData.productImages
        }
    }
}

// MARK: - Subviews

private extension AddProductImages {

    var SelectButton: some View {
        Label {
            Text("Select images")
        } icon: {
            Image(systemName: "photo")
        }
        .foregroundStyle(Color.white)
        .padding(.horizontal, 15)
        .padding(.vertical, 8)
        .background(.pink)
        .clipShape(.rect(cornerRadius: 10))
    }

    var PhotoPicker: some View {
        PhotosPicker(
            selection: $selectedItems,
            selectionBehavior: .continuous,
            matching: .images,
            preferredItemEncoding: .automatic
        ) {
            SelectButton
        }
        .foregroundStyle(.red)
        .onChange(of: selectedItems) { oldValue, newValue in
            if oldValue.count > newValue.count {
                oldValue.forEach { item in
                    Task {
                        if !newValue.contains(item), 
                            let data = try? await item.loadTransferable(type: Data.self) {
                            if let index = selectedPhotosData.firstIndex(where: { $0 == data }) {
                                selectedPhotosData.remove(at: index)
                            }
                        }
                    }
                }
                return
            }

            let setData = Set(selectedPhotosData)
            newValue.forEach { item in
                Task {
                    if let data = try? await item.loadTransferable(type: Data.self), !setData.contains(data) {
                        selectedPhotosData.append(data)
                    }
                }
            }
        }
        .photosPickerStyle(.compact)
        .frame(height: 150)
        .photosPickerDisabledCapabilities([.selectionActions])
        .photosPickerAccessoryVisibility(.hidden)
    }

    var BackButton: some View {
        Button(action: backAction, label: {
            Image(systemName: "chevron.left")
                .foregroundStyle(CHMColor<IconPalette>.iconRed.color)
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(Color.black.opacity(0.4), in: .rect(cornerRadius: 10))
        })
    }
}

// MARK: - Preview

#Preview {
    AddProductImages(selectedPhotosData: .constant([])) {}
        .environmentObject(CreateProductViewModel.mockData)
}

#Preview {
    CreateProductView(viewModel: .mockData)
        .environmentObject(Navigation())
        .environmentObject(RootViewModel())
}
