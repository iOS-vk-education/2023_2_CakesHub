//
//
//  flip.swift
//  CakesHub
//
//  Created by Milana Shakhbieva on 18.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

struct flip: View {
    @State private var showView: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    if showView {
                    RoundedRectangle(cornerRadius: 25)
                            .fill(.black.gradient)
                            .transition(.reverseFlip)
                    } else {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(.red.gradient)
                            .transition(.flip)
                    }
                }
                .frame(width: 200, height: 300)
                
                Button(showView ? "Hide" : "Reveal") {
                    withAnimation(.bouncy(duration: 2)) {
                        showView.toggle()
                    }
                }
                .padding(.top, 30)
            }
        }
    }
}

#Preview {
    flip()
}

struct FlipTransaction: ViewModifier, Animatable {
    var progress: CGFloat = 0
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    func body(content: Content) -> some View {
        content
            .opacity(progress < 0 ? (-progress < 0.5 ? 1 : 0) : (progress < 0.5 ? 1 : 0))
            .rotation3DEffect(
                .init(degrees: progress * 180),
                axis: (x: 0.0, y: 1.0, z: 0.0)
            )
    }
}

extension AnyTransition {
    static let flip: AnyTransition = .modifier(
        active: FlipTransaction(progress: -1),
        identity: FlipTransaction()
        )
    
    static let reverseFlip: AnyTransition = .modifier(
        active: FlipTransaction(progress: 1),
        identity: FlipTransaction()
        )
}


//import SwiftUI
//
//struct ContentView: View {
//    @State private var showView: Bool = false
//    @State private var currentScreen: Int = 0
//    
//    var body: some View {
//        NavigationStack {
//            VStack {
//                // Экраны, которые будут переключаться
//                ScreenView(screenNumber: currentScreen)
//                   .frame(width: 200, height: 300)
//                
//                Button(showView ? "Hide" : "Reveal") {
//                    withAnimation(.bouncy(duration: 2)) {
//                        showView.toggle()
//                    }
//                }
//               .padding(.top, 30)
//            }
//        }
//    }
//}
//
//// Представление экрана
//struct ScreenView: View {
//    var screenNumber: Int
//    
//    var body: some View {
//        switch screenNumber {
//        case 0:
//            Text("Screen 1")
//               .background(Color.red)
//               .cornerRadius(25)
//        case 1:
//            Text("Screen 2")
//               .background(Color.blue)
//               .cornerRadius(25)
//        default:
//            EmptyView()
//        }
//    }
//}
//
//// Примеры переходов
//struct FlipTransition: ViewModifier, Animatable {
//    var progress: CGFloat = 0
//    var animatableData: CGFloat {
//        get { progress }
//        set { progress = newValue }
//    }
//    
//    func body(content: Content) -> some View {
//        content
//           .scaleEffect(x: progress, y: progress)
//           .rotation3DEffect(.degrees(-90), axis: (x: 0, y: 1, z: 0))
//           .offset(y: progress > 0 ? UIScreen.main.bounds.height / 2 : -UIScreen.main.bounds.height / 2)
//    }
//}
//
//extension AnyTransition {
//    static let flip: AnyTransition = .modifier(
//        active: FlipTransition(progress: 1),
//        identity: FlipTransition(progress: 0)
//    )
//    
//    static let reverseFlip: AnyTransition = .modifier(
//        active: FlipTransition(progress: -1),
//        identity: FlipTransition(progress: 0)
//    )
//}
