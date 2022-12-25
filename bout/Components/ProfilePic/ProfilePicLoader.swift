//
//  ProfilePicView.swift
//  bout
//
//  Created by Colton Lathrop on 12/3/22.
//

import Foundation
import SwiftUI

struct ProfilePicLoader: View {
    @State var uiImage: UIImage?
    
    let profilePicSize: ProfilePicSize
    let token: String
    let userId: String
    
    @EnvironmentObject var userCache: UserCache
    
    init(
        token: String,
        userId: String,
        picSize: ProfilePicSize
    ){
        self.token = token
        self.userId = userId
        self.profilePicSize = picSize
    }
    
    var body: some View {
        if let uiImage = uiImage {
            ProfilePic(image: uiImage, profilePicSize: self.profilePicSize)
        } else {
            ProfilePic(image: UIImage(named: "default")!, profilePicSize: self.profilePicSize)
                .task {
                    let result = await userCache.getProfilePic(token: self.token, userId: self.userId)
                    
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
