//
//  ReviewAddReply.swift
//  spotster
//
//  Created by Colton Lathrop on 1/5/23.
//

import Foundation
import SwiftUI

struct ReviewAddReply: View {
    var reloadCallback: () async -> Void
    var fullReview: FullReview
    var scrollProxy: ScrollViewProxy
    
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
        
        let result = await spotster.addReplyToReview(token: auth.token, reviewId: fullReview.review.id, text: text)
        
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
            HStack {
                VStack {
                    TextField("Max 400 characters.", text: $text, axis: .vertical)
                        .lineLimit(3...)
                        .padding(12)
                        .font(.caption)
                        .overlay {
                            if pending {
                                ProgressView()
                            }
                        }.id("replyInput")
                        .onTapGesture {
                            withAnimation {
                                scrollProxy.scrollTo("replyInput", anchor: .center)
                            }
                        }
                }.background(.quaternary).cornerRadius(8)
                Button(action: {
                    Task {
                        await self.postReply()
                    }
                }){
                    Text("Reply")
                }
            }
            if showError {
                Text(errorText).foregroundColor(.red)
            }
        }.accentColor(.primary)
    }
}
