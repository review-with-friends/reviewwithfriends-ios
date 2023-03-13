//
//  Loading.swift
//  belocal
//
//  Created by Colton Lathrop on 12/6/22.
//

import Foundation
import SwiftUI

struct Loading: View {
    var body: some View {
        VStack{
            Spacer()
            ProgressLoader()
            Spacer()
        }.ignoresSafeArea()
    }
}

struct Loading_Previews: PreviewProvider {
    static var previews: some View {
        Loading().preferredColorScheme(.dark)
    }
}
