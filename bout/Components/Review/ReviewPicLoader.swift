//
//  ReviewPicLoader.swift
//  bout
//
//  Created by Colton Lathrop on 12/20/22.
//

import Foundation
import SwiftUI

struct ReviewPicLoader: View {
    @State var uiImage: UIImage?
    @State var isLoading = true
    
    let getImage: (_: String, _: String) async -> Result<UIImage, RequestError>
    let token: String
    let fullReview: FullReview
    let reloadCallback: () async -> Void
    
    init(
        token: String,
        fullReview: FullReview,
        reloadCallback: @escaping () async -> Void
    ){
        self.getImage = bout.getReviewPic
        self.token = token
        self.fullReview = fullReview
        self.reloadCallback = reloadCallback
    }
    
    var body: some View {
        if self.isLoading {
            ReviewPicSkeleton().task {
                self.isLoading = true;
                let result = await getImage(self.token, self.fullReview.review.id)
                
                switch result {
                case .success(let image):
                    self.isLoading = false
                    self.uiImage = image
                case .failure(_):
                    self.isLoading = false
                    break
                }
            }
        } else if let uiImage = uiImage {
            ReviewPic(image: uiImage, likes: self.fullReview.likes, reviewId: self.fullReview.review.id, reloadCallback: reloadCallback)
        } else {
            // not loading and no image. we only could have failed
            Text("failed loading")
        }
    }
}
