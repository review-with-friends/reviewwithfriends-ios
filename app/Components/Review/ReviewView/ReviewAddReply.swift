//
//  ReviewAddReply.swift
//  app
//
//  Created by Colton Lathrop on 1/5/23.
//

import Foundation
import SwiftUI

struct ReviewAddReply: View {
    @Binding var showOverlay: Bool
    @Binding var path: NavigationPath
    var reloadCallback: () async -> Void
    var fullReview: FullReview
    var scrollProxy: ScrollViewProxy?
    
    let emojiBarEmojis = ["❤️", "🔥", "😍", "😮", "😢", "🤣" ]
    
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
            self.showOverlay = false
            self.feedRefreshManager.push(review_id: self.fullReview.review.id)
        case .failure(let error):
            showError = true
            errorText = error.description
        }
        
        pending = false
    }
    
    var emojiRow: some View {
        HStack {
            ForEach(emojiBarEmojis, id: \.self) { emoji in
                Spacer()
                Button(emoji) {
                    self.text += emoji
                }
            }
            Spacer()
        }.padding(.vertical)
    }
    
    var body: some View {
        VStack {
            VStack {
                Rectangle().foregroundColor(.black).opacity(0.5)
            }.ignoresSafeArea(.all)
                .onTapGesture{
                    self.showOverlay = false
                }.padding(-10)
            VStack {
                self.emojiRow
                HStack {
                    TextField("Write a reply", text: $text, axis: .vertical)
                        .lineLimit(4...)
                        .font(.caption)
                        .overlay {
                            if pending {
                                ProgressView()
                            }
                        }.focused($focusedField, equals: .ReplyText)
                }.padding()
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
                }.padding()
            }.background(.black)
        }.accentColor(.primary).onAppear {
            withAnimation {
                self.focusedField = FocusField.ReplyText
            }
        }
    }
}

struct ReviewAddReply_Preview: PreviewProvider {
    static func dummyCallback() async {
        
    }
    
    static var previews: some View {
        VStack {
            ReviewAddReply(showOverlay: .constant(true), path: .constant(NavigationPath()), reloadCallback: dummyCallback, fullReview: generateFullReviewPreviewData()).preferredColorScheme(.dark).environmentObject(Authentication.initPreview()).environmentObject(UserCache())
        }
    }
}

