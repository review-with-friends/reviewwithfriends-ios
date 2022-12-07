//
//  ActiveView.swift
//  bout
//
//  Created by Colton Lathrop on 11/28/22.
//

import Foundation
import SwiftUI

struct MainView: View {
    var activeTab: some View = Image("TabIndicator").resizable().frame(width: 20.0, height: 5.0)
    
    @State private var selection: Float = 0.0
    
    @EnvironmentObject var auth: Authentication
    
    var body: some View {
            ZStack{
                VStack{
                    MapView()
                }
                VStack{
                    Spacer()
                    HStack {
                        Spacer()
                        TabButton(tag: 0.0, selection: $selection) {
                            Image(systemName: "house.fill").font(.system(size: 24))
                        } activeIndicator: {
                            activeTab
                        }
                        
                        Spacer()
                        
                        TabButton(tag: 1.0, selection: $selection) {
                            Image(systemName: "map").font(.system(size: 24))
                        } activeIndicator: {
                            activeTab
                        }
                        
                        Spacer()
                        
                        TabButton(tag: 2.0, selection: $selection, alerts: 2) {
                            ProfilePicLoader(token: auth.token, userId: auth.user?.id ?? "") { image in
                                ProfilePic(image: image, profilePicSize: .small)
                            } placeholder: {
                                ProfilePic(image: UIImage(named: "default")!, profilePicSize: .small)
                            }
                        } activeIndicator: {
                            activeTab
                        }
                        
                        Spacer()
                    }.padding(.bottom)
                }
            }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().preferredColorScheme(.dark).environmentObject(Authentication.initPreview())
    }
}
