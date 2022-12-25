//
//  Overlay.swift
//  bout
//
//  Created by Colton Lathrop on 12/12/22.
//

import Foundation
import SwiftUI

struct Overlay: View {
    @EnvironmentObject var manager: OverlayManager
    
    var body: some View {
            ZStack {
                if manager.showOverlay {
                    Rectangle()
                        .foregroundColor(.black)
                        .opacity(0.6)
                        .onTapGesture {
                            self.manager.closeOverlay()
                        }.ignoresSafeArea(.all)
                    VStack {
                        Spacer()
                        VStack {
                            ZStack{
                                Rectangle()
                                    .clipShape(CornerRadiusShape())
                                    .foregroundColor(.black)
                                    .ignoresSafeArea(.all)
                                VStack {
                                    ScrollView {
                                        HStack{
                                            Spacer()
                                            self.manager.view
                                            Spacer()
                                        }
                                        Spacer()
                                    }.padding()
                                }
                            }
                        }.padding(.top, 100.0)
                    }.transition(AnyTransition.asymmetric(
                        insertion: .move(edge: .bottom),
                        removal: .move(edge: .bottom)
                    ))
                }
            }
    }
}

class OverlayManager: ObservableObject {
    @Published var view: AnyView = AnyView(Text("123"))
    @Published var showOverlay = false
    
    func closeOverlay(){
        withAnimation {
            self.showOverlay = false
        }
    }
    
    func openOverlay(view: AnyView) {
        withAnimation {
            self.showOverlay = true
            self.view = view
        }
    }
    
    private func getInitialInitialView() -> some View {
        return Text("Placeholder")
    }
}

struct CornerRadiusShape: Shape {
    var radius = 32.0
    var corners = UIRectCorner.topLeft.union(.topRight)

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
