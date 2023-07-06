//
//  DeliveredTag.swift
//  app
//
//  Created by Colton Lathrop on 6/6/23.
//

import Foundation
import SwiftUI

struct DeliveredTag: View {
    var body: some View {
        HStack {
            Text("Delivered")
            Image(systemName: "takeoutbag.and.cup.and.straw.fill")
        }.padding(.horizontal, 16).padding(.vertical, 4).background(APP_BACKGROUND).cornerRadius(36.0)
    }
}

struct DeliveredTag_Preview: PreviewProvider {
    static var previews: some View {
        VStack{
            DeliveredTag()
                .preferredColorScheme(.dark)
        }
    }
}
