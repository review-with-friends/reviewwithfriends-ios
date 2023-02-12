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
    
    @State var showHeart = false
    
    @State var isPending = false
    @State var failed = false
    
    @EnvironmentObject var auth: Authentication
    
    
    var body: some View {
        VStack{
            let alreadyLiked = likes.filter({$0.userId == auth.user?.id ?? ""}).count >= 1
            Spacer()
            ZStack {
                Rectangle()
                    .foregroundColor(.black)
                    .opacity(0.00001)
                    .cornerRadius(8.0)
                    .onTapGesture(count: 2) {
                        self.isPending = true
                        self.failed = false
                        Task {
                            var result: Result<(), RequestError>
                            if alreadyLiked {
                                let generator = UINotificationFeedbackGenerator()
                                generator.notificationOccurred(.success)
                                
                                result = await spotster.unlikeReview(token: auth.token, reviewId: reviewId)
                            } else {
                                Task {
                                    withAnimation {
                                        showHeart = true
                                    }
                                    
                                    let generator = UIImpactFeedbackGenerator(style: .light)
                                    generator.impactOccurred()
                                    
                                    do {
                                        try await Task.sleep(for: Duration.milliseconds(250))
                                        withAnimation {
                                            showHeart = false
                                        }
                                    }
                                    catch {}
                                }
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
            ReviewPicOverlay(path: .constant(NavigationPath()), likes: [Like(id: "123", created: Date(), userId: "123", reviewId: "123")], reviewId: "123", reloadCallback: test).preferredColorScheme(.dark).environmentObject(Authentication.initPreview())
        }
    }
}
