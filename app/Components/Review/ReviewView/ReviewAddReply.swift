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
    
    @EnvironmentObject var auth: Authentication
    
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
        case .failure(let error):
            showError = true
            errorText = error.description
        }
        
        pending = false
    }
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    if let user = self.auth.user {
                        ProfilePicLoader(path: self.$path, userId: user.id, profilePicSize: .medium, navigatable: false, ignoreCache: false)
                    }
                    TextField("Write a reply", text: $text, axis: .vertical)
                        .lineLimit(3...)
                        .font(.caption)
                        .overlay {
                            if pending {
                                ProgressView()
                            }
                        }.id("replyInput")
                        .onTapGesture {
                            withAnimation {
                                if let scroll = self.scrollProxy {
                                    scroll.scrollTo("replyInput", anchor: .center)
                                }
                            }
                        }
                }.padding(8).background(APP_BACKGROUND_DARK).cornerRadius(8)
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

