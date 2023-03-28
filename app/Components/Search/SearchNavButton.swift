//
//  SearchNavButton.swift
//  app
//
//  Created by Colton Lathrop on 2/9/23.
//

import Foundation
import SwiftUI

struct CreateReviewNavButton: View {
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            VStack {
                Button(action: {
                    self.path.append(CreateReviewFromImageDestination())
                }) {
                    ZStack {
                        Image(systemName: "plus.app").font(.title).padding(.horizontal)
                    }
                }.accentColor(.primary)
            }
        }
    }
}

struct CreateReviewNavButton_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            CreateReviewNavButton(path: .constant(NavigationPath()))
        }.preferredColorScheme(.dark)
    }
}
