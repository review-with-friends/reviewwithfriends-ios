//
//  SearchNavButton.swift
//  belocal
//
//  Created by Colton Lathrop on 2/9/23.
//

import Foundation
import SwiftUI

struct SearchNavButton: View {
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            VStack {
                Button(action: {
                    self.path.append(SearchDestination())
                }) {
                    ZStack {
                        Image(systemName: "magnifyingglass").font(.title).padding(.horizontal)
                    }
                }.accentColor(.primary)
            }
        }
    }
}

struct SearchNavButton_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            SearchNavButton(path: .constant(NavigationPath()))
        }.preferredColorScheme(.dark)
    }
}
