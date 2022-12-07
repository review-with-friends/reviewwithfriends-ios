//
//  ProfilePicView.swift
//  bout
//
//  Created by Colton Lathrop on 12/3/22.
//

import Foundation
import SwiftUI

struct ProfilePicLoader<Content: View, Placeholder: View>: View {
    @State var uiImage: UIImage?
    
    let getImage: (_: String, _: String) async -> Result<UIImage, RequestError>
    let content: (UIImage) -> Content
    let placeholder: () -> Placeholder
    
    let token: String
    let userId: String
    
    init(
        token: String,
        userId: String,
        @ViewBuilder content: @escaping (UIImage) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ){
        self.getImage = bout.getProfilePic
        self.content = content
        self.placeholder = placeholder
        self.token = token
        self.userId = userId
    }
    
    var body: some View {
        if let uiImage = uiImage {
            content(uiImage)
        }else {
            placeholder()
                .task {
                    let result = await getImage(self.token, self.userId)
                    
                    switch result {
                    case .success(let image):
                        self.uiImage = image
                    case .failure(_):
                        break
                    }
                }
        }
    }
}
