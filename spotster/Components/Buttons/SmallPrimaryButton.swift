//
//  SmallPrimaryButton.swift
//  spotster
//
//  Created by Colton Lathrop on 3/6/23.
//

import Foundation
import SwiftUI

struct SmallPrimaryButton: View {
    var title: String
    var icon: String?
    var action: () -> Void
    
    var body: some View {
        Button(action: self.action){
            HStack {
                Text(self.title)
                if let icon = self.icon {
                    Image(systemName: icon)
                }
            }.foregroundColor(.black).disabled(false).padding(8).padding(
                .horizontal)
        }.background(.primary).cornerRadius(50)
    }
}


struct SmallPrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SmallPrimaryButton(title: "Get Started", action: {})
            SmallPrimaryButton(title: "Directions", icon: "car.fill", action: {})
        }.preferredColorScheme(.dark)
    }
}
