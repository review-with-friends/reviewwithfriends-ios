//
//  Loading.swift
//  spotster
//
//  Created by Colton Lathrop on 12/6/22.
//

import Foundation
import SwiftUI

struct Loading: View {
    @State private var isRotating = 0.0
    
    var body: some View {
        VStack{
            Spacer()
            ProgressView()
            Spacer()
            CreatedBy()
        }
    }
}

struct Loading_Previews: PreviewProvider {
    static var previews: some View {
        Loading().preferredColorScheme(.dark)
    }
}
