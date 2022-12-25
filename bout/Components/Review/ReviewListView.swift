//
//  ReviewsView.swift
//  bout
//
//  Created by Colton Lathrop on 12/19/22.
//

import Foundation
import SwiftUI

struct ReviewListView: View {
    
    @Binding var reviews: [Review]
    
    var body: some View {
        VStack{
            ForEach($reviews) { review in
                ReviewView(review: review)
            }
        }
    }
}
