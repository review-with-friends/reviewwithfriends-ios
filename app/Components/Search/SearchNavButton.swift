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
        VStack {
            Button(action: {
                self.path.append(CreateReviewFromImageDestination())
            }) {
                ZStack {
                    Circle().frame(width: 64).foregroundColor(.primary).shadow(radius: 8)
                    Image(systemName: "plus").resizable().frame(width: 28, height: 28).padding(.horizontal).bold().foregroundColor(.black)
                }
            }.accentColor(.primary)
        }.offset(y: -20)
    }
}

struct CreateReviewNavButton_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            CreateReviewNavButton(path: .constant(NavigationPath()))
        }.preferredColorScheme(.dark)
    }
}
