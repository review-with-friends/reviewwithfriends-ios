//
//  PrimaryButton.swift
//  belocal
//
//  Created by Colton Lathrop on 3/2/23.
//

import Foundation
import SwiftUI

struct PrimaryButton: View {
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
        }.background(.primary).cornerRadius(50).padding(.horizontal)
    }
}


struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            PrimaryButton(title: "Get Started", action: {})
        }.preferredColorScheme(.dark)
    }
}
