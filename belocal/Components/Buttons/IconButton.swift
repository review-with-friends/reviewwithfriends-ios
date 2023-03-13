//
//  IconButton.swift
//  belocal
//
//  Created by Colton Lathrop on 3/8/23.
//

import Foundation
import SwiftUI

struct IconButton: View {
    var icon: String
    var action: () -> Void
    
    var body: some View {
        Button(action: self.action){
            HStack {
                    Image(systemName: icon)
            }.foregroundColor(.black).disabled(false).padding(4).padding(
                .horizontal)
        }.background(.primary).cornerRadius(50)
    }
}


struct IconButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            IconButton(icon: "car.fill", action: {})
        }.preferredColorScheme(.dark)
    }
}
