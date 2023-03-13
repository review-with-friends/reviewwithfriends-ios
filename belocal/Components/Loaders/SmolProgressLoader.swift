//
//  SmolProgressLoader.swift
//  belocal
//
//  Created by Colton Lathrop on 3/11/23.
//

import Foundation
import SwiftUI

struct SmolProgressLoader: View {
    @State private var offset = -10.00
    
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
                        offset = 10
                    }
            }.frame(width: 16)
    }
}

struct SmolProgressLoader_Preview: PreviewProvider {
    static var previews: some View {
        SmolProgressLoader().preferredColorScheme(.dark)
    }
}
