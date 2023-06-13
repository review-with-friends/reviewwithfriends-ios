//
//  LikeSelector.swift
//  app
//
//  Created by Colton Lathrop on 6/6/23.
//

import Foundation
import SwiftUI

struct LikeSelector: View {
    /// An escaping callback for when action is triggered.
    var callback: () async -> Void
    
    var body: some View {
        VStack {
            
        }
    }
}

struct LikeSelector_Preview: PreviewProvider {
    static func callback() async {}
    
    static var previews: some View {
        VStack {
            LikeSelector(callback: callback)
        }.preferredColorScheme(.dark)
    }
}
