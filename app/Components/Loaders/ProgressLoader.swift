//
//  ProgressLoader.swift
//  app
//
//  Created by Colton Lathrop on 3/11/23.
//

import Foundation
import SwiftUI

struct ProgressLoader: View {    
    @State private var offset = -20.00
    
    var body: some View {
        Circle()
            .fill(
                .white
            )
            .offset(y: self.offset)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 1)
                    .speed(1.3)
                    .repeatForever(autoreverses: true)) {
                        offset = 20
                    }
            }.frame(width: 64)
    }
}

struct ProgressLoader_Preview: PreviewProvider {
    static var previews: some View {
        ProgressLoader().preferredColorScheme(.dark)
    }
}
