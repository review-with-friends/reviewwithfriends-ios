//
//  Loading.swift
//  app
//
//  Created by Colton Lathrop on 12/6/22.
//

import Foundation
import SwiftUI

struct Loading: View {
    var body: some View {
        VStack{
            Spacer()
            Image("loader").resizable().scaledToFit()
            Spacer()
        }.ignoresSafeArea()
    }
}

struct Loading_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Loading().preferredColorScheme(.dark)
        }
    }
}
