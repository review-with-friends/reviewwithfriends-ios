//
//  PrimaryButtonGreen.swift
//  app
//
//  Created by Colton Lathrop on 3/14/23.
//

import Foundation
import SwiftUI

struct PrimaryButtonGreen: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: self.action){
            HStack {
                Spacer()
                Text(self.title)
                    .font(.title3.weight(.semibold))
                    .padding()
                Spacer()
            }.foregroundColor(.black).disabled(false)
        }.background(.green).cornerRadius(50).padding(.horizontal)
    }
}


struct PrimaryButtonGreen_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            PrimaryButtonGreen(title: "Get Started", action: {})
        }.preferredColorScheme(.dark)
    }
}
