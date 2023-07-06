//
//  DeliveredToggle.swift
//  app
//
//  Created by Colton Lathrop on 6/6/23.
//

import Foundation
import SwiftUI

struct DeliveredToggle: View {
    @Binding var delivered: Bool
    
    var body: some View {
        Toggle(isOn: self.$delivered) {
            HStack {
                Text("Delivered").font(.title3).bold()
                Image(systemName: "takeoutbag.and.cup.and.straw.fill")
            }
        }
    }
}

struct DeliveredToggle_Preview: PreviewProvider {
    static var previews: some View {
        VStack{
            DeliveredToggle(delivered: .constant(true))
                .preferredColorScheme(.dark)
        }
    }
}
