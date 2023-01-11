//
//  ProfilePicView.swift
//  spotster
//
//  Created by Colton Lathrop on 12/6/22.
//

import Foundation
import SwiftUI

struct ProfilePic: View {
    var image: Image
    var profilePicSize: ProfilePicSize
    
    var body: some View {
        image
            .resizable()
            .scaledToFill()
            .frame(width: profilePicSize.rawValue, height: profilePicSize.rawValue)
            .clipShape(Circle()).padding(.bottom, -6)
    }
}

enum ProfilePicSize: CGFloat {
    case small = 28.0
    case medium = 48.0
    case large = 256.0
}

struct ProfilePicView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ProfilePic(image: Image(uiImage: UIImage(named: "default")!), profilePicSize: .large).preferredColorScheme(.dark).environmentObject(Authentication.initPreview())
            ProfilePic(image: Image(uiImage: UIImage(named: "default")!), profilePicSize: .medium).preferredColorScheme(.dark).environmentObject(Authentication.initPreview())
            ProfilePic(image: Image(uiImage: UIImage(named: "default")!), profilePicSize: .small).preferredColorScheme(.dark).environmentObject(Authentication.initPreview())
        }
    }
}
