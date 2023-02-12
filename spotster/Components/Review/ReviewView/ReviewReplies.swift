//
//  ReviewReplies.swift
//  spotster
//
//  Created by Colton Lathrop on 12/23/22.
//

import Foundation
import SwiftUI

struct ReviewReplies: View {
    @Binding var path: NavigationPath
    
    var reloadCallback: () async -> Void
    var fullReview: FullReview
    
    var body: some View {
        VStack{
            ForEach(fullReview.replies.sorted { $0.created > $1.created }) { reply in
                ReviewReply(path: self.$path, reloadCallback: reloadCallback, reply: reply)
            }
        }
    }
}

struct ReviewReply: View {
    @Binding var path: NavigationPath
    
    var reloadCallback: () async -> Void
    var reply: Reply
    
    @State var showDeleteConfirmation = false
    @State var showDeleteError = false
    @State var deleteErrorMessage = ""
    
    @EnvironmentObject var auth: Authentication
    
    func deleteReply() async {
        let result = await spotster.removeReplyFromReview(token: self.auth.token, reviewId: self.reply.reviewId, replyId: self.reply.id)
        
        switch result {
        case .success(_):
            await reloadCallback()
        case .failure(let error):
            self.deleteErrorMessage = error.description
            self.showDeleteError = true
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    ProfilePicLoader(path: self.$path, userId: reply.userId, profilePicSize: .medium, navigatable: true, ignoreCache: false)
                    Spacer()
                }
                VStack {
                    Text(reply.text).font(.caption)
                    Spacer()
                }
                Spacer()
                VStack {
                    VStack {
                        SlimDate(date: reply.created)
                        if let user = auth.user {
                            if reply.userId == user.id {
                                HStack {
                                    Spacer()
                                    Button(action:{
                                        self.showDeleteConfirmation = true
                                    }){
                                        Image(systemName: "trash")
                                    }.padding(.top, 1).accentColor(.secondary)
                                }
                            }
                        }
                    }.fixedSize().alert(
                        "Are you sure you want to delete this reply?",
                        isPresented: $showDeleteConfirmation
                    ) {
                        Button(role: .destructive) {
                            Task {
                                await self.deleteReply()
                            }
                        } label: {
                            Text("Delete Reply")
                        }
                    }.alert(
                        "Delete Failed. Do you want to retry?",
                        isPresented: $showDeleteError,
                        presenting: self.deleteErrorMessage
                    ) { message in
                        Button("Cancel", role: nil){
                            self.deleteErrorMessage = ""
                        }
                        Button("Retry", role: nil) {
                            Task {
                                await self.deleteReply()
                            }
                        }
                    } message: { message in
                        Text(message)
                    }
                    Spacer()
                }
            }.padding().background(.quaternary).cornerRadius(8)
        }
    }
}

struct ReviewReplies_Preview: PreviewProvider {
    static func dummyCallback() async {
        
    }
    
    static var previews: some View {
        VStack {
            ReviewReplies(path: .constant(NavigationPath()), reloadCallback: dummyCallback, fullReview: generateFullReviewPreviewData()).preferredColorScheme(.dark).environmentObject(Authentication.initPreview()).environmentObject(UserCache())
        }
    }
}
