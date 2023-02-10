//
//  ReviewPic.swift
//  spotster
//
//  Created by Colton Lathrop on 12/20/22.
//

import Foundation
import SwiftUI

/// Actually renders the ReviewPic and like button overlay.
/// We could break this up a bit more but it's w/e for now.
struct ReviewPicOverlay: View {
    @Binding var path: NavigationPath
    
    var likes: [Like]
    var reviewId: String
    var reloadCallback: () async -> Void
    
    @State var isPending = false
    @State var failed = false
    
    @EnvironmentObject var auth: Authentication
    
    var body: some View {
            VStack{
                Spacer()
                HStack{
                    let alreadyLiked = likes.filter({$0.userId == auth.user?.id ?? ""}).count >= 1
                    Spacer()
                    Button(action: {
                        self.isPending = true
                        self.failed = false
                        Task {
                            var result: Result<(), RequestError>
                            if alreadyLiked {
                                result = await spotster.unlikeReview(token: auth.token, reviewId: reviewId)
                            } else{
                                result = await spotster.likeReview(token: auth.token, reviewId: reviewId)
                            }
                            
                            switch result {
                            case .success():
                                await reloadCallback()
                                break
                            case .failure(_):
                                withAnimation {
                                    self.failed = true
                                }
                                break
                            }
                            
                            isPending = false
                        }
                    }) {
                        ZStack {
                            Rectangle()
                                .frame(width: 42, height: 42)
                                .foregroundColor(.black)
                                .cornerRadius(8.0)
                            if alreadyLiked {
                                Image(systemName: "heart.fill")
                                    .resizable()
                                    .frame(width: 28, height: 24)
                                    .foregroundColor(.primary)
                            } else {
                                Image(systemName: "heart")
                                    .resizable().frame(width: 28, height: 24)
                                    .foregroundColor(.primary)
                            }
                                Image(systemName: "xmark.circle.fill")
                                    .resizable().frame(width: 16, height: 16)
                                    .foregroundColor(.red)
                                    .offset(x: 20, y: -20)
                                    .opacity(self.failed ? 1.0 : 0.0)
                                    .animation(.easeInOut(duration: 0.5), value: 1.0)
                        }.shadow(radius: 4).animation(.easeInOut(duration: 0.4), value: 1.0)
                    }
                }.padding()
            }
    }
}

struct ReviewPic_Preview: PreviewProvider {
    static func test() async -> Void {
        
    }
    static var previews: some View {
        VStack{
            ReviewPicOverlay(path: .constant(NavigationPath()), likes: [], reviewId: "123", reloadCallback: test).preferredColorScheme(.dark).environmentObject(Authentication.initPreview())
            ReviewPicOverlay(path: .constant(NavigationPath()), likes: [Like(id: "123", created: Date(), userId: "123", reviewId: "123")], reviewId: "123", reloadCallback: test).preferredColorScheme(.dark).environmentObject(Authentication.initPreview())
        }
    }
}
