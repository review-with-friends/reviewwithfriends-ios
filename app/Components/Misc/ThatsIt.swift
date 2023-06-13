//
//  ThatsIt.swift
//  app
//
//  Created by Colton Lathrop on 6/13/23.
//

import Foundation
import SwiftUI

struct ThatsIt: View {
    var body: some View {
            HStack {
                Image(systemName: "checkmark.circle")
                Text("Thats it!").font(.caption)
            }.foregroundColor(.secondary)
    }
}
