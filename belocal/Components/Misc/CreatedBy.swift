//
//  CreatedBy.swift
//  belocal
//
//  Created by Colton Lathrop on 12/29/22.
//

import Foundation
import SwiftUI

struct CreatedBy: View {
    @State private var isRotating = 0.0
    
    var body: some View {
        Circle()
            .fill(
                AngularGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]), center: .center)
            )
            .rotationEffect(.degrees(isRotating))
            .onAppear {
                withAnimation(
                    .linear(duration: 1)
                    .speed(0.2)
                    .repeatForever(autoreverses: false)) {
                        isRotating = 360.0
                    }
            }.mask(){
                VStack {
                    Text("Created by").font(.caption)
                    Text("Spacedog Labs")
                }.frame(width: 144, height: 144)
            }.frame(width: 128, height: 128)
    }
}
