//
//  View+Extentions.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 04.02.2024.
//

import SwiftUI

// MARK: - SCROLL VIEW

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View {

    @ViewBuilder
    func offsetX(completion: @escaping (CGFloat) -> Void) -> some View {
        overlay {
            GeometryReader {
                let minX = $0.frame(in: .scrollView(axis: .horizontal)).minX

                Color.clear
                    .preference(key: OffsetKey.self, value: minX)
                    .onPreferenceChange(OffsetKey.self, perform: completion)
            }
        }
    }

    func tabMask(_ progress: CGFloat) -> some View {
        ZStack {
            self
                .foregroundStyle(CHMColor<TextPalette>.textSecondary.color)

            self
                .foregroundStyle(CHMColor<TextPalette>.textPrimary.color)
                .mask {
                    GeometryReader {
                        let size = $0.size
                        let capsuleWidth = size.width / CGFloat(CategoriesTab.allCases.count)
                        Capsule()
                            .frame(width: capsuleWidth)
                            .offset(x: progress * (size.width - capsuleWidth))
                    }
                }
        }
    }
}

// MARK: - Default features

extension View {

    func frame(edge size: CGFloat) -> some View {
        self.frame(width: size, height: size)
    }

    func viewSize(size: Binding<CGSize>) -> some View {
        background {
            GeometryReader { proxy in
                Color.clear
                    .onAppear {
                        size.wrappedValue = proxy.size
                    }
            }
        }
    }

    func onBackSwipe(perform action: @escaping () -> Void) -> some View {
        gesture(
            DragGesture()
                .onEnded { value in
                    if value.startLocation.x < 50 && value.translation.width > 80 {
                        action()
                    }
                }
        )
    }
}

// MARK: - Sheet View

extension View {

    func blurredSheet<Content: View>(
        _ style: AnyShapeStyle,
        show: Binding<Bool>,
        onDismiss: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        sheet(isPresented: show, onDismiss: onDismiss) {
            content()
                .background(RemovebackgroundColor())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    Rectangle()
                        .fill(style)
                        .ignoresSafeArea(.container, edges: .all)
                )
        }
    }
}

// MARK: Helper

struct RemovebackgroundColor: UIViewRepresentable {

    func makeUIView(context: Context) -> UIView {
        UIView()
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            uiView.superview?.superview?.backgroundColor = .clear
        }
    }
}
