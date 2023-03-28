//
//  PrimaryButtonRed.swift
//  app
//
//  Created by Colton Lathrop on 3/14/23.
//

import Foundation
import SwiftUI

struct PrimaryButtonRed: View {
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
        }.background(.red).cornerRadius(50).padding(.horizontal)
    }
}


struct PrimaryButtonRed_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            PrimaryButtonRed(title: "Get Started", action: {})
        }.preferredColorScheme(.dark)
    }
}
