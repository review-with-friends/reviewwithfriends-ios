//
//  Loading.swift
//  bout
//
//  Created by Colton Lathrop on 12/6/22.
//

import Foundation
import SwiftUI

struct Loading: View {
    @State private var isRotating = 0.0
    
    var body: some View {
        VStack{
            Text("Bout")
                .font(.system(size: 128).bold())
                .scaledToFit()
                .padding()
            Circle()
                .fill(
                        AngularGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]), center: .center)
                    )
                .frame(width: 150, height: 150).mask {
                    HStack {
                        Circle().frame(width: 40, height: 40).padding(.trailing)
                        Circle().frame(width: 40, height: 40)
                    }
                        .rotationEffect(.degrees(isRotating))
                        .onAppear {
                            withAnimation(
                                .linear(duration: 1)
                                .speed(0.2)
                                .repeatForever(autoreverses: false)) {
                                    isRotating = 360.0
                                }
                        }
                }.rotationEffect(.degrees(isRotating))
                .onAppear {
                    withAnimation(
                        .linear(duration: 1)
                        .speed(0.1)
                        .repeatForever(autoreverses: false)) {
                            isRotating = 360.0
                        }
                }
                    
        }
    }
}

struct Loading_Previews: PreviewProvider {
    static var previews: some View {
        Loading().preferredColorScheme(.dark)
    }
}
