//
//  ProfilePicSkeleton.swift
//  belocal
//
//  Created by Colton Lathrop on 1/10/23.
//

import Foundation
import SwiftUI

struct ProfilePicSkeleton: View {
    var loading: Bool
    var profilePicSize: ProfilePicSize
    var error = false
    
    var body: some View {
        Rectangle()
            .frame(width: profilePicSize.rawValue, height: profilePicSize.rawValue)
            .clipShape(Circle())
            .foregroundColor(.secondary)
            .opacity(0.2)
            .overlay {
                if loading {
                    ProgressView()
                }
                if error {
                    VStack {
                        Image(systemName: "exclamationmark.triangle").padding(.bottom, 4)
                        Text("Tap to retry").font(.caption)
                    }
                }
            }
    }
}

struct ProfilePicSkeleton_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            ProfilePicSkeleton(loading: true, profilePicSize: .large).preferredColorScheme(.dark).environmentObject(Authentication.initPreview())
            ProfilePicSkeleton(loading: false, profilePicSize: .large, error: true).preferredColorScheme(.dark).environmentObject(Authentication.initPreview())
            ProfilePicSkeleton(loading: true, profilePicSize: .medium).preferredColorScheme(.dark).environmentObject(Authentication.initPreview())
        }
    }
}
