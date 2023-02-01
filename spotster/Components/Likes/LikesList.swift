//
//  LikesList.swift
//  spotster
//
//  Created by Colton Lathrop on 1/30/23.
//

import Foundation
import SwiftUI

struct LikesList: View {
    var likes: [Like]
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(self.likes) { like in
                    LikesListItem(userId: like.userId, date: like.created)
                }
            }.padding(.horizontal)
        }.navigationTitle("Likes").padding(.top)
    }
}
