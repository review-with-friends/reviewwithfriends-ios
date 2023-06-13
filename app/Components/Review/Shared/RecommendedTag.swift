//
//  RecommendedTag.swift
//  app
//
//  Created by Colton Lathrop on 6/8/23.
//

import Foundation
import SwiftUI

struct RecommendedTag: View {
    var body: some View {
        HStack {
            Text("Recommended")
            Image(systemName: "star.fill")
        }.padding(.horizontal, 16).padding(.vertical, 4).background(APP_BACKGROUND).cornerRadius(36.0)
    }
}

struct RecommendedTag_Preview: PreviewProvider {
    static var previews: some View {
        VStack{
            RecommendedTag()
                .preferredColorScheme(.dark)
        }
    }
}
