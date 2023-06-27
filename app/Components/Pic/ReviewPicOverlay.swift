//
//  ReviewPic.swift
//  app
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
    
    @State var showHeart = false
    @State var tooltipOpen = false
    @State var isPending = false
    @State var failed = false
    
    @EnvironmentObject var auth: Authentication
    
    func isAlreadyLiked() -> Bool {
        likes.filter({$0.userId == auth.user?.id ?? ""}).count >= 1
    }

    func likeReview(emoji: String) async {
        let alreadyLiked = self.isAlreadyLiked()
        
        if self.isPending {
            return
        }
        self.isPending = true
        self.failed = false
        
        let emoji = app.getEmojiFromEmoji(emoji: emoji)
        
        var result: Result<(), RequestError>
        if alreadyLiked {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            result = await app.unlikeReview(token: auth.token, reviewId: reviewId)
        } else {
            Task {
                withAnimation {
                    showHeart = true
                }
                
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                
                do {
                    try await Task.sleep(for: Duration.milliseconds(300))
                    withAnimation {
                        showHeart = false
                    }
                }
                catch {}
            }
            result = await app.likeReview(token: auth.token, reviewId: reviewId, likeType: emoji.id)
        }
        
        switch result {
        case .success():
            self.tooltipOpen = false
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
    
    var body: some View {
        VStack{
            Spacer()
            ZStack {
                Rectangle()
                    .foregroundColor(.black)
                    .opacity(0.00001)
                    .cornerRadius(8.0)
                    .onTapGesture(count: 2) {
                        Task {
                            await self.likeReview(emoji: "❤️")
                        }
                    }.onLongPressGesture {
                        if self.isAlreadyLiked() {
                            return
                        }
                        self.tooltipOpen = true
                    }.onTapGesture {
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                        self.tooltipOpen = false
                    }.overlay {
                        if self.tooltipOpen {
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    LikeSelector(callback: self.likeReview)
                                    Spacer()
                                }.padding()
                            }
                        } else {
                            
                        }
                    }
                if self.showHeart {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 128))
                        .foregroundColor(.primary)
                        .transition(.asymmetric(insertion: .scale, removal: .opacity))
                }
            }
        }.padding()
    }
}

struct ReviewPic_Preview: PreviewProvider {
    static func test() async -> Void {
        
    }
    static var previews: some View {
        VStack{
            ReviewPicOverlay(path: .constant(NavigationPath()), likes: [], reviewId: "123", reloadCallback: test).preferredColorScheme(.dark).environmentObject(Authentication.initPreview())
            ReviewPicOverlay(path: .constant(NavigationPath()), likes: [Like(id: "123", created: Date(), userId: "123", reviewId: "123", likeType: 1)], reviewId: "123", reloadCallback: test).preferredColorScheme(.dark).environmentObject(Authentication.initPreview())
        }
    }
}
