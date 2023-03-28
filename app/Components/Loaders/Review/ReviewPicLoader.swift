//
//  ReviewPicLoader.swift
//  app
//
//  Created by Colton Lathrop on 12/20/22.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct ReviewPicLoader: View {
    @Binding var path: NavigationPath
    
    let pic: Pic
    
    @State var reloadHard = false
    
    var body: some View {
        if self.reloadHard {
            ReviewPicSkeleton(loading: true, width: pic.width, height: pic.height)
        } else {
            WebImage(url: URL(string: "https://bout.sfo3.cdn.digitaloceanspaces.com/" + pic.id))
                .placeholder {
                    ReviewPicSkeleton(loading: true, width: pic.width, height: pic.height)
                }
                .resizable()
                .scaledToFit()
                .cornerRadius(16)
        }
    }
}
