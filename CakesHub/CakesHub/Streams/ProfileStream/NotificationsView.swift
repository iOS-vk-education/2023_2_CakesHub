//
//  NotificationsView.swift
//  CakesHub
//
//  Created by Milana Shakhbieva on 26.03.2024.
//

import SwiftUI

struct NotificationsView: View {
    var body: some View {

            List {
                Section() {
                    Label("Чаты", systemImage: "message").foregroundColor(Constants.textColor)
                    
                    Label("Заказы", systemImage: "message").foregroundColor(Constants.textColor)
                    
                    Label("Статус заказа", systemImage: "message").foregroundColor(Constants.textColor)
                }
                .padding()
                
                
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Уведомления")
            .background(Constants.bgColor)
    }
    
    
}


struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}

// MARK: - Preview

#Preview {
    NotificationsView()
}


// MARK: - Constants

private extension NotificationsView {
    
    enum Constants {
        static let textColor = CHMColor<TextPalette>.textPrimary.color
        static let userMailColor = CHMColor<TextPalette>.textPrimary.color
        static let bgColor = CHMColor<BackgroundPalette>.bgMainColor.color
    }
}
