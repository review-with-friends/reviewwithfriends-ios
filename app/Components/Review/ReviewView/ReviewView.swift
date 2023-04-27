//
//  ReviewView.swift
//  app
//
//  Created by Colton Lathrop on 1/4/23.
//

import Foundation
import SwiftUI

struct ReviewView: View {
    @Binding var path: NavigationPath
    
    var reloadCallback: () async -> Void
    var user: User
    var fullReview: FullReview
    var showLocation = true
    
    @State var lastLoad = Date()
    @State var showOverlay = false
    
    @State var isReplyingToReply = false;
    @State var replyToReplyTo = "";
    
    @EnvironmentObject var auth: Authentication
    
    func setIsReplyingTo(id: String) {
        self.isReplyingToReply = true
        self.replyToReplyTo = id
    }
    
    func resetIsReplyingTo() {
        self.isReplyingToReply = false
        self.replyToReplyTo = ""
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack {
                    ReviewHeader(path: self.$path, user: user, fullReview: fullReview)
                    ReviewPicCarousel(path: self.$path, fullReview: fullReview, reloadCallback: reloadCallback)
                    VStack {
                        ReviewText(path: self.$path, fullReview: self.fullReview, reloadCallback: self.reloadCallback)
                        HStack {
                            Spacer()
                            SmallPrimaryButton(title: "Comment", icon: "square.and.pencil", action: {
                                withAnimation {
                                    self.resetIsReplyingTo()
                                    self.showOverlay = true
                                }
                            })
                        }
                        ReviewReplies(path: self.$path, showReplyOverlay:self.$showOverlay, setReplyingTo: self.setIsReplyingTo, reloadCallback: self.reloadCallback, fullReview: self.fullReview)
                    }.padding(.horizontal)
                }
            }.scrollDismissesKeyboard(.immediately)
                .refreshable {
                    Task {
                        await self.reloadCallback()
                    }
                }.navigationBarTitleDisplayMode(.inline)
        }.onAppear {
            if self.lastLoad.addingTimeInterval(TimeInterval(5)) < Date() {
                self.lastLoad = Date()
                Task {
                    await self.reloadCallback()
                }
            }
        }.scrollIndicators(.hidden).overlay {
            if self.showOverlay {
                ReviewAddReply(showOverlay: self.$showOverlay, path: self.$path, resetReplyTo: self.resetIsReplyingTo, replies: self.fullReview.replies, isReplyingTo: self.isReplyingToReply, replyTo: self.replyToReplyTo, reloadCallback: reloadCallback, fullReview: fullReview)
            }
        }
    }
}

struct ReviewView_Previews: PreviewProvider {
    static func dummyCallback() async {}
    
    static var previews: some View {
        ReviewView(path: .constant(NavigationPath()), reloadCallback: dummyCallback, user: generateUserPreviewData(), fullReview: generateFullReviewPreviewData()).preferredColorScheme(.dark).environmentObject(Authentication.initPreview()).environmentObject(UserCache())
    }
}
