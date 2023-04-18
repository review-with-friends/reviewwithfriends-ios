//
//  DangerousIconButton.swift
//  app
//
//  Created by Colton Lathrop on 4/17/23.
//

import Foundation
import SwiftUI

struct DangerousIconButton: View {
    var icon: String
    var action: () -> Void
    
    var body: some View {
        Button(action: self.action){
            ZStack {
                Image(systemName: icon).foregroundColor(.red)
            }.disabled(false)
        }.cornerRadius(50)
    }
}


struct DangerousIconButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            DangerousIconButton(icon: "car.fill", action: {})
        }.preferredColorScheme(.dark)
    }
}
