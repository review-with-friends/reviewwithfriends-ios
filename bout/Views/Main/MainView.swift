//
//  ActiveView.swift
//  bout
//
//  Created by Colton Lathrop on 11/28/22.
//

import Foundation
import SwiftUI
import MapKit

struct MainView: View {
    var activeTab: some View = Image("TabIndicator").resizable().frame(width: 20.0, height: 5.0)
    
    @State private var selection: Float = 1.0
    
    @StateObject private var overlayManager = OverlayManager()
    
    @EnvironmentObject var auth: Authentication
    
//    var body: some View {
//        ZStack{
//            VStack{
//                switch selection {
//                case 0.0:
//                    RecentActivityView()
//
//                case 1.0:
//                    MapScreenView()
//
//                case 2.0:
//                    MyProfileView()
//
//                case _:
//                    Text("nuttin")
//                }
//            }
//            VStack{
//                Spacer()
//                HStack {
//                    Spacer()
//                    TabButton(tag: 0.0, selection: $selection) {
//                        Image(systemName: "house.fill").font(.system(size: 24))
//                    } activeIndicator: {
//                        activeTab
//                    }
//
//                    Spacer()
//
//                    TabButton(tag: 1.0, selection: $selection) {
//                        Image(systemName: "map").font(.system(size: 24))
//                    } activeIndicator: {
//                        activeTab
//                    }
//
//                    Spacer()
//
//                    TabButton(tag: 2.0, selection: $selection, alerts: 2) {
//                        ProfilePicLoader(token: auth.token, userId: auth.user?.id ?? "", picSize: .small)
//                    } activeIndicator: {
//                        activeTab
//                    }
//
//                    Spacer()
//                }.padding(.bottom)
//            }
//            Overlay()
//        }.environmentObject(self.overlayManager)
//    }
    @State var tab = 1
    
    var body: some View {
        ZStack{
            TabView (selection: $tab){
                RecentActivityView()
                    .tabItem {
                        Label("Recent", systemImage: "house.fill")
                    }.tag(0).toolbarBackground(.ultraThinMaterial, for: .tabBar).toolbarBackground(.visible, for: .tabBar)
                MapScreenView()
                        .tabItem {
                            Label("Map", systemImage: "map")
                        }.tag(1).toolbarBackground(.ultraThinMaterial, for: .tabBar).toolbarBackground(.visible, for: .tabBar)
                MyProfileView()
                        .badge("2")
                        .tabItem {
                            Label("Profile", systemImage: "person.crop.circle.fill")
                        }.tag(2).toolbarBackground(.ultraThinMaterial, for: .tabBar).toolbarBackground(.visible, for: .tabBar)
            }
            Overlay()
        }.environmentObject(self.overlayManager)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().preferredColorScheme(.dark).environmentObject(Authentication.initPreview())
    }
}
