//
//  StarsSelector.swift
//  app
//
//  Created by Colton Lathrop on 1/2/23.
//

import Foundation
import SwiftUI

struct ReviewStarsSelector: View {
    @Binding var stars: Int
    
    var body: some View {
        VStack {
            HStack(spacing: 2) {
                ForEach((1...5), id: \.self) {
                    let num = $0
                    if num <= self.stars {
                        Button (action: {
                            if stars == 1 && num == 1 {
                                stars = 0
                                return
                            }
                            stars = num
                        }) {
                            Image(systemName:"star.fill").resizable()
                                .scaledToFill().frame(width: 36, height: 36)
                        }
                    } else {
                        Button (action: {
                            if stars == 1 && num == 1 {
                                stars = 0
                                return
                            }
                            stars = num
                        }) {
                            Image(systemName:"star").resizable()
                                .scaledToFill().frame(width: 36, height: 36)
                        }
                    }
                    
                }
            }
        }
    }
}

struct ReviewStarsSelector_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            ReviewStarsSelector(stars: .constant(0)).preferredColorScheme(.dark)
            ReviewStarsSelector(stars: .constant(1)).preferredColorScheme(.dark)
            ReviewStarsSelector(stars: .constant(2)).preferredColorScheme(.dark)
            ReviewStarsSelector(stars: .constant(3)).preferredColorScheme(.dark)
            ReviewStarsSelector(stars: .constant(4)).preferredColorScheme(.dark)
            ReviewStarsSelector(stars: .constant(5)).preferredColorScheme(.dark)
        }
    }
}
