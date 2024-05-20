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
    enum Modes {
        case avatar
        case header
    }
    @State var selectedItem: PhotosPickerItem?
    @State var avatarData: Data?
    @State var headerData: Data?
    @State private var showPicker = false
    @State private var selectedMode: Modes?
    @EnvironmentObject private var root: RootViewModel

    var body: some View {
        List {
            Section("Аватарка") {
                AvatarBlock
                    .listRowInsets(.init())
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
            }

            Section("Шапка профиля") {
                HeaderBlock
                    .listRowInsets(.init())
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
            }

            Section(header: Text("Редактирование профиля")) {
                Group {
                    Button(action: {
                        showPicker = true
                        selectedMode = .avatar
                    }) {
                        Text("Сменить аватар")
                            .foregroundStyle(CHMColor<TextPalette>.textSecondary.color)
                    }

                    Button(action: {
                        showPicker = true
                        selectedMode = .header
                    }) {
                        Text("Сменить шапку профиля")
                            .foregroundStyle(CHMColor<TextPalette>.textSecondary.color)
                    }

                    NavigationLink(destination: EditNameView()) {
                        Text("Редактировать никнейм")
                            .foregroundStyle(CHMColor<TextPalette>.textSecondary.color)
                    }
                }
                .listRowBackground(CHMColor<BackgroundPalette>.bgCommentView.color)
            }
        }
        .scrollContentBackground(.hidden)
        .onChange(of: selectedItem) { _, newValue in
            guard let item = newValue else { return }

            item.loadTransferable(type: Data.self) { result in
                switch result {
                case let.success(data):
                    switch selectedMode {
                    case .avatar:
                        self.avatarData = data
                    case .header:
                        self.headerData = data
                    case .none:
                        break
                    }
                    selectedItem = nil
                case let.failure(failure):
                    Logger.log(kind:.error, message: failure)
                }
            }
        }
        .photosPicker(isPresented: $showPicker, selection: $selectedItem, matching:.images)
        .background(CHMColor<BackgroundPalette>.bgMainColor.color)
    }

    @ViewBuilder
    var HeaderBlock: some View {
        if let data = headerData, let uiimage = UIImage(data: data) {
            Image(uiImage: uiimage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 200)

        } else {
            MKRImageView(
                configuration: .basic(
                    kind: .string(root.currentUser.headerImage ?? .clear),
                    imageShape: .rectangle
                )
            )
            .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 200)
        }
    }

    @ViewBuilder
    var AvatarBlock: some View {
        if let data = avatarData, let uiimage = UIImage(data: data) {
            Image(uiImage: uiimage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: Constants.imageSize, height: Constants.imageSize)
                .clipShape(.circle)

        } else {
            MKRImageView(
                configuration: .basic(
                    kind: .string(root.currentUser.avatarImage ?? .clear),
                    imageShape: .capsule
                )
            )
            .frame(width: Constants.imageSize, height: Constants.imageSize)
        }
    }
}

// MARK: - Actions

extension EditProfileView {

    func updateHeaderImage(data: Data) {
        Task {
//            UserService.shared.addUserAddress(for:address:)
        }
    }

    func updateAvatarImage(data: Data) {

    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        EditProfileView()
    }
    .environmentObject(RootViewModel.mockData)
}

// MARK: - Constants

private extension EditProfileView {
    
    enum Constants {
        static let textColor = CHMColor<TextPalette>.textPrimary.color
        static let deleteColor = CHMColor<TextPalette>.textWild.color
        static let userMailColor = CHMColor<TextPalette>.textPrimary.color
        static let bgColor = CHMColor<BackgroundPalette>.bgMainColor.color
        static let imageSize: CGFloat = 100
    }
}
