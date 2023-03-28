//
//  DisabledPrimaryButton.swift
//  app
//
//  Created by Colton Lathrop on 3/6/23.
//

import Foundation
import SwiftUI

struct DisabledPrimaryButton: View {
    var title: String

    var body: some View {
        Button(action: {}){
            HStack {
                Spacer()
                Text(self.title)
                    .font(.title3.weight(.semibold))
                    .padding()
                Spacer()
            }.foregroundColor(.black)
        }.background(.tertiary).cornerRadius(50).padding(.horizontal).disabled(true)
    }
}


struct DisabledPrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            DisabledPrimaryButton(title: "Get Started")
        }.preferredColorScheme(.dark)
    }
}
