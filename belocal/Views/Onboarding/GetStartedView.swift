//
//  GetStartedView.swift
//  belocal
//
//  Created by Colton Lathrop on 2/28/23.
//

import Foundation
import SwiftUI

struct GetStartedView: View {
    @Binding var path: NavigationPath
    
    @EnvironmentObject var auth: Authentication
    
    let photos = [GetStartedPhoto(id: "like"), GetStartedPhoto(id: "find"), GetStartedPhoto(id: "map_friends"), GetStartedPhoto(id: "search")]
    
    func moveToNextScreen() {
        self.path.append(DiscoverFriends())
    }
    
    var body: some View {
        VStack {
            TabView {
                ForEach(self.photos) { photo in
                    Image(photo.id).resizable().scaledToFit()
                }
            }.tabViewStyle(PageTabViewStyle())
                .padding()
            Spacer()
            PrimaryButton(title: "Get Started", action: {
                self.moveToNextScreen()
            })
        }
    }
}

struct GetStartedPhoto: Identifiable {
    let id: String
}

struct GetStartedView_Previews: PreviewProvider {
    static var previews: some View {
        GetStartedView(path: .constant(NavigationPath())).preferredColorScheme(.dark).environmentObject(Authentication.initPreview()).environmentObject(UserCache())
    }
}
