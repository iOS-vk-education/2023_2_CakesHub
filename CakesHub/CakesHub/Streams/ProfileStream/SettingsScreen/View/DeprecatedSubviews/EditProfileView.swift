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

    @State private var selectedItem: PhotosPickerItem?
    @State private var avatarData: Data?
    @State private var headerData: Data?
    @State private var showPicker = false
    @State private var selectedMode: Modes?
    @EnvironmentObject private var root: RootViewModel
    @EnvironmentObject private var profileVM: ProfileViewModel

    var body: some View {
        List {
            Section("Avatar") {
                AvatarBlock
                    .listRowInsets(.init())
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
            }

            Section("Profile Header") {
                HeaderBlock
                    .listRowInsets(.init())
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
            }

            Section(header: Text("Editing a profile")) {
                Group {
                    Button(action: {
                        showPicker = true
                        selectedMode = .avatar
                    }) {
                        Text("Change your avatar")
                            .foregroundStyle(CHMColor<TextPalette>.textSecondary.color)
                    }

                    Button(action: {
                        showPicker = true
                        selectedMode = .header
                    }) {
                        Text("Change the profile header")
                            .foregroundStyle(CHMColor<TextPalette>.textSecondary.color)
                    }

                    NavigationLink(destination: EditNameView().environmentObject(profileVM) ) {
                        Text("Edit a nickname")
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
                case let .success(data):
                    guard let data else { return }

                    switch selectedMode {
                    case .avatar:
                        self.avatarData = data
                        if let uiImage = UIImage(data: data) {
                            profileVM.updateUserAvatar(imageKind: .uiImage(uiImage))
                        }

                        updateImage(data: data, kind: .avatar)
                    case .header:
                        self.headerData = data
                        if let uiImage = UIImage(data: data) {
                            profileVM.updateUserHeader(imageKind: .uiImage(uiImage))
                        }

                        updateImage(data: data, kind: .header)
                    case .none:
                        break
                    }
                    selectedItem = nil
                case let.failure(failure):
                    Logger.log(kind:.error, message: failure)
                }
            }
        }
        .photosPicker(isPresented: $showPicker, selection: $selectedItem, matching: .images)
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

    func updateImage(data: Data?, kind: UserService.UserImageKind) {
        guard let data else { return }
        Task {
            let url = try? await UserService.shared.updateUserImage(
                userID: root.currentUser.uid,
                imageData: data,
                kind: kind
            )
            if kind == .avatar {
                let newImageString = url?.absoluteString
                root.updateUserImage(newAvatarString: newImageString)
            } else if kind == .header {
                root.updateUserHeaderImage(newHeaderString: url?.absoluteString)
            }
        }
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
