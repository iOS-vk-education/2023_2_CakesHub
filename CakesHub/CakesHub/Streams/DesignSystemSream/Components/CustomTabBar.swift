//
//  CustomTabBar.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 08.03.2024.
//

import SwiftUI

struct CustomTabBarView: View {
    @EnvironmentObject var nav: Navigation
    @State private var allTabs: [AnimatedTab] = TabBarItem.allCases.compactMap {
        AnimatedTab(TabBarItem: $0)
    }
    
    var body: some View {
        CustomTabBar
            .shadow(color: CHMColor<ShadowPalette>.tabBarShadow.color, radius: 10)
    }
}

// MARK: - Private Subviews

private extension CustomTabBarView {

    @ViewBuilder
    var CustomTabBar: some View {
        HStack(spacing: 0) {
            ForEach($allTabs) { $animatedTab in
                let TabBarItem = animatedTab.TabBarItem
                VStack(spacing: 4) {
                    Image(systemName: TabBarItem.rawValue)
                        .font(.title2)
                        .symbolEffect(.bounce.down.byLayer, value: animatedTab.isAnimating)

                    Text(TabBarItem.title)
                        .font(.caption2)
                        .textScale(.secondary)
                }
                .frame(maxWidth: .infinity)
                .foregroundStyle(
                    nav.activeTab == TabBarItem ? Constants.iconSelectedColor : Constants.iconUnselectedColor
                )
                .padding(.vertical, 5)
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.bouncy, completionCriteria: .logicallyComplete) {
                        nav.activeTab = TabBarItem
                        animatedTab.isAnimating = true
                    } completion: {
                        var trasnaction = Transaction()
                        trasnaction.disablesAnimations = true
                        withTransaction(trasnaction) {
                            animatedTab.isAnimating = nil
                        }
                    }

                }
            }
        }
        .background(CHMColor<BackgroundPalette>.bgMainColor.color)
    }
}

// MARK: - Preview

#Preview {
    CustomTabBarView()
        .environmentObject(Navigation())
}

// MARK: - Constants

struct AnimatedTab: Identifiable {
    var id = UUID()
    var TabBarItem: TabBarItem
    var isAnimating: Bool?
}

private extension View {

    @ViewBuilder
    func setUpTab(_ TabBarItem: TabBarItem) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .tag(TabBarItem)
            .toolbar(.hidden, for: .tabBar)
    }
}

private extension CustomTabBarView {

    enum Constants {
        static let iconSelectedColor: Color = CHMColor<IconPalette>.iconRed.color
        static let iconUnselectedColor: Color = CHMColor<IconPalette>.iconGray.color
    }
}
