//
//  BoutTitleView.swift
//  bout
//
//  Created by Colton Lathrop on 12/6/22.
//

import Foundation
import SwiftUI

struct BoutTitle: View {
    var body: some View {
        Text("Bout")
            .font(.largeTitle.bold())
            .padding()
    }
}

struct BoutTitle_Previews: PreviewProvider {
    static var previews: some View {
        BoutTitle().preferredColorScheme(.dark)
    }
}
