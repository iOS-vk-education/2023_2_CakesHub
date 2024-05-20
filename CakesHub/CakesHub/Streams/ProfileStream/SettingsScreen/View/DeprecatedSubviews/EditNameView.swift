//
//  EditNameView.swift
//  CakesHub
//
//  Created by Milana Shakhbieva on 24.04.2024.
//

import SwiftUI

struct EditNameView: View {
    @State private var newusername = ""
    @EnvironmentObject private var root: RootViewModel
    @EnvironmentObject private var profileVM: ProfileViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Spacer()

            TextField("New nickname", text: $newusername)
                .modifier(SettingButtonsModifier(kind: .textField))

            Spacer()

            Button(action: {
                root.updateUserName(newNickname: newusername)
                profileVM.updateUsername(name: newusername)
                Task {
                    var oldUserInfo = root.currentUser
                    oldUserInfo.nickname = newusername
                    try? await UserService.shared.updateUserInfo(with: oldUserInfo)
                    dismiss()
                }
            }) {
                Text(String(localized: "Save"))
                    .modifier(SettingButtonsModifier(kind: .button))
                    .foregroundStyle(.white)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CHMColor<BackgroundPalette>.bgMainColor.color)
        .onAppear {
            newusername = profileVM.user.name
        }
    }
}

// MARK: - Preview

#Preview {
    EditNameView()
}
