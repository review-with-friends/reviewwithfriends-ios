//
//  RemovePhotoView.swift
//  app
//
//  Created by Colton Lathrop on 4/27/23.
//

import Foundation
import SwiftUI

struct RemovePhotoView: View {
    @Binding var path: NavigationPath
    
    var refreshFullReview: () async -> Void
    
    @State var fullReview: FullReview
    @State var selectedPhoto: Int = 0
    
    @EnvironmentObject var auth: Authentication
    
    func removePic() async {
        if let pic = self.fullReview.pics.first(where: { $0.hashValue == self.selectedPhoto }) {
            let result = await app.removeReviewPic(token: auth.token, picId: pic.id, reviewId: self.fullReview.review.id)
            switch result {
            case .success():
                await refreshFullReview()
                self.path.removeLast()
            case .failure(_):
                return
            }
        }
    }
    
    var body: some View {
        VStack {
            PrimaryButton(title: "Remove Photo", action: {
                Task {
                    await self.removePic()
                }
            })
            TabView(selection: $selectedPhoto) {
                ForEach(self.fullReview.pics) { pic in
                    ReviewPicLoader(path: self.$path, pic: pic).tag(pic.hashValue)
                }
            }.tabViewStyle(PageTabViewStyle())
        }
    }
}
