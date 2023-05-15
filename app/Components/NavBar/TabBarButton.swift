//
//  TabBarButton.swift
//  app
//
//  Created by Colton Lathrop on 5/11/23.
//

import Foundation
import SwiftUI

struct TabBarButton: View {
    var callback: () -> Void
    var imageName: String
    var isActive: Bool
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var friendsCache: FriendsCache
    @EnvironmentObject var notificationManager: NotificationManager
    
    var body: some View {
        HStack {
            VStack {
                Image(systemName:self.imageName).font(.system(size: 24))
            }.padding(12)
                .frame(minWidth: 72)
                .foregroundColor(isActive ? .primary : .secondary)
                .onTapGesture {
                    self.callback()
                }
        }
    }
}


struct TabBarButton_Preview: PreviewProvider {
    static func callback() -> Void {}
    static var previews: some View {
        VStack {
            TabBarButton(callback: callback , imageName: "house.fill", isActive: true)
        }.preferredColorScheme(.dark).environmentObject(Authentication.initPreview()).environmentObject(UserCache()).environmentObject(FriendsCache.generateDummyData()).environmentObject(NotificationManager())
    }
}
