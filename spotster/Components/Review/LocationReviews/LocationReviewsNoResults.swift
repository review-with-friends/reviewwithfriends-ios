//
//  LocationReviewsNoResults.swift
//  spotster
//
//  Created by Colton Lathrop on 3/7/23.
//

import Foundation
import SwiftUI

struct LocationReviewsNoResults: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("We couldn't find any reviews.").foregroundColor(.secondary)
                Spacer()
            }
            HStack {
                Spacer()
                Text("You should write one 🤩").foregroundColor(.secondary)
                Spacer()
            }
            Spacer()
        }.listRowSeparator(.hidden)
    }
}
