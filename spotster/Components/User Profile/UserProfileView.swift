//
//  UserProfileView.swift
//  spotster
//
//  Created by Colton Lathrop on 12/27/22.
//

import Foundation
import SwiftUI

struct UserProfileView: View {
    var user: User
    
    var body: some View {
        VStack{
            Text(user.id)
        }
    }
}

struct UserProfileView_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            UserProfileView(user: generateUserPreviewData()).preferredColorScheme(.dark)
        }
    }
}
