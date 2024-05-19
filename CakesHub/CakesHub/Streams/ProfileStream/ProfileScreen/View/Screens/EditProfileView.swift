//
//  EditProfileView.swift
//  CakesHub
//
//  Created by Milana Shakhbieva on 16.04.2024.
//

import SwiftUI
import PhotosUI
import FirebaseCoreInternal

struct EditProfileView: View {
    @State var selectedItem: PhotosPickerItem?
    @State var data: Data?
    @State private var showPicker = false
    
    var body: some View {
        NavigationView {
            VStack {
                if let data = data, let uiimage = UIImage(data: data) {
                    Image(uiImage: uiimage)
                        .resizable()
                        .aspectRatio(contentMode:.fill)
                        .frame(width: 180, height: 180)
                        .clipShape(.circle)
                } else {
                    Image(uiImage:.bestGirl)
                        .resizable()
                        .aspectRatio(contentMode:.fill)
                        .frame(width: 180, height: 180)
                        .clipShape(.circle)
                }
                
                List {
                    Section(header: Text("Редактирование профиля")) {
                        Button(action: {
                            showPicker = true
                        }) {
                            Text("Редактировать фото")
                        }
                        NavigationLink(destination: EditNameView()) {
                            Text("Редактировать никнейм")
                        }
                        NavigationLink(destination: EditStatusView()) {
                            Text("Редактировать статус")
                        }
                    }
                }
            }
            .photosPicker(isPresented: $showPicker, selection: $selectedItem, matching:.images)
            .onChange(of: selectedItem) { _, newValue in
                guard let item = newValue else { return }
                
                item.loadTransferable(type: Data.self) { result in
                    switch result {
                    case let.success(data):
                        self.data = data
                    case let.failure(failure):
                        Logger.log(kind:.error, message: failure)
                    }
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    EditProfileView ()
}

// MARK: - Constants

private extension EditProfileView {
    
    enum Constants {
        static let textColor = CHMColor<TextPalette>.textPrimary.color
        static let deleteColor = CHMColor<TextPalette>.textWild.color
        static let userMailColor = CHMColor<TextPalette>.textPrimary.color
        static let bgColor = CHMColor<BackgroundPalette>.bgMainColor.color
    }
}
