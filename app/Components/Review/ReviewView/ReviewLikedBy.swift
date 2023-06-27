//
//  ReviewLikedBy.swift
//  app
//
//  Created by Colton Lathrop on 4/12/23.
//

import Foundation
import SwiftUI

struct ReviewLikedBy: View {
    @Binding var path: NavigationPath
    
    var fullReview: FullReview
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var feedRefreshManager: FeedRefreshManager
    
    var body: some View {
            VStack {
                if self.fullReview.likes.count > 0 {
                    HStack {
                        HStack {
                            ForEach(self.fullReview.likes.sorted(by: { a, b in
                                a.created < b.created
                            }).prefix(8)) { like in
                                ProfilePicLoader(path: self.$path, userId: like.userId, profilePicSize: .smallMedium, navigatable: false, ignoreCache: false).overlay {
                                    VStack {
                                        HStack {
                                            Text(app.getEmojiFromNumber(number: like.likeType).emoji).font(.caption2).padding(.horizontal, -4)
                                            Spacer()
                                        }
                                        Spacer()
                                    }
                                }.padding(.horizontal, -10)
                            }
                        }.onTapGesture {
                            self.path.append(self.fullReview.likes)
                        }
                    }
                }
            }
    }
}

struct ReviewLikedBy_Preview: PreviewProvider {
    static var previews: some View {
        VStack{
            ReviewLikedBy(path: .constant(NavigationPath()), fullReview: generateFullReviewPreviewData())
                .preferredColorScheme(.dark)
                .environmentObject(Authentication.initPreview())
                .environmentObject(UserCache())
        }
    }
}

