//
//  ReviewAddReply.swift
//  app
//
//  Created by Colton Lathrop on 1/5/23.
//

import Foundation
import SwiftUI

struct ReviewAddReply: View {
    @Binding var path: NavigationPath
    var reloadCallback: () async -> Void
    var fullReview: FullReview
    var scrollProxy: ScrollViewProxy?
    
    @State var text = ""
    
    @State var pending = false
    
    @State var showError = false
    @State var errorText = ""
    
    @State var showTextInput = false
    @FocusState private var focusedField: FocusField?
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var feedRefreshManager: FeedRefreshManager
    
    enum FocusField: Hashable {
        case ReplyText
    }
    
    func showError(error: String) {
        showError = true
        errorText = error
    }
    
    func hideError() {
        showError = false
        errorText = ""
    }
    
    func postReply() async {
        if pending {
            return
        }
        
        pending = true
        
        if text.isEmpty {
            showError = true
            errorText = "Use your words 😮"
            pending = false
            return
        }
        
        let result = await app.addReplyToReview(token: auth.token, reviewId: fullReview.review.id, text: text)
        
        switch result {
        case .success(_):
            text = ""
            await reloadCallback()
            self.feedRefreshManager.push(review_id: self.fullReview.review.id)
        case .failure(let error):
            showError = true
            errorText = error.description
        }
        
        pending = false
    }
    
    var userIcon: some View {
        VStack {
            if let user = self.auth.user {
                ProfilePicLoader(path: self.$path, userId: user.id, profilePicSize: .medium, navigatable: false, ignoreCache: false)
            }
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    SmallPrimaryButton(title: "Write Comment",icon: "text.bubble.fill", action: {
                        withAnimation {
                            self.showTextInput = true
                            self.focusedField = .ReplyText
                        }
                    })
                }
            }
            VStack {
                if self.showTextInput {
                    VStack {
                        VStack {
                            Rectangle().foregroundColor(.black).opacity(0.5)
                        }.background(.quaternary).ignoresSafeArea(.all)
                        VStack {
                            VStack {
                                HStack {
                                    self.userIcon
                                    TextField("Write a reply", text: $text, axis: .vertical)
                                        .lineLimit(3...)
                                        .font(.caption)
                                        .overlay {
                                            if pending {
                                                ProgressView()
                                            }
                                        }.focused($focusedField, equals: .ReplyText)
                                }
                                HStack {
                                    Spacer()
                                    if showError {
                                        Text(errorText).foregroundColor(.red)
                                    }
                                    Spacer()
                                    SmallPrimaryButton(title: "Send",icon: "paperplane.fill", action: {
                                        Task {
                                            await self.postReply()
                                        }
                                    })
                                }
                            }.padding()
                        }.background(.black)
                    }
                }
            }
        }.accentColor(.primary)
    }
}

struct ReviewAddReply_Preview: PreviewProvider {
    static func dummyCallback() async {
        
    }
    
    static var previews: some View {
        VStack {
            ReviewAddReply(path: .constant(NavigationPath()), reloadCallback: dummyCallback, fullReview: generateFullReviewPreviewData()).preferredColorScheme(.dark).environmentObject(Authentication.initPreview()).environmentObject(UserCache())
        }
    }
}

