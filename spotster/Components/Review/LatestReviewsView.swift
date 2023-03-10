//
//  LatestReviewsView.swift
//  spotster
//
//  Created by Colton Lathrop on 1/5/23.
//

import Foundation
import SwiftUI

struct LatestReviewsView: View {
    @Binding var path: NavigationPath
    
    @StateObject var model = PaginatedReviewModel()
    
    @State var lastLoad = Date()
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var userCache: UserCache
    @EnvironmentObject var notificationManager: NotificationManager
    
    @Environment(\.scenePhase) var scenePhase
    
    func createActionCallback(page: Int) async -> Result<[Review], RequestError> {
        return await spotster.getLatestReviews(token: auth.token, page: page)
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action:{
                    Task {
                        await self.model.hardLoadReviews(auth: self.auth, userCache: self.userCache, action: self.createActionCallback)
                        await self.notificationManager.getNotifications(token: self.auth.token)
                    }
                }) {
                    Text("Spotster").font(.title).fontWeight(.bold)
                }.accentColor(.primary)
                Spacer()
                SearchNavButton(path: self.$path)
                NotificationNavButton(path: self.$path)
            }.padding(.horizontal)
            ScrollView {
                LazyVStack {
                    ForEach(self.model.reviewsToRender) { review in
                        ReviewLoaderA(path: self.$path, review: review, showListItem: true, showLocation: true)
                    }
                    VStack {
                        if self.model.noMorePages {
                            Text("Hmmm, no more reviews...").foregroundColor(.secondary).padding(50).font(.caption)
                        }
                        else {
                            ProgressView().padding()
                        }
                    }.onAppear {
                        Task {
                            await self.model.onItemAppear(auth: self.auth, userCache: self.userCache, action: self.createActionCallback)
                        }
                    }
                }.listStyle(.plain).buttonStyle(BorderlessButtonStyle())
            }.scrollIndicators(.hidden)
            
            if self.model.failed {
                Text(self.model.error)
                
                Button(action: {
                    
                }){
                    Text("Retry Loading")
                }
            }
        }.refreshable {
            Task {
                await self.model.hardLoadReviews(auth: self.auth, userCache: self.userCache, action: self.createActionCallback)
                await self.notificationManager.getNotifications(token: self.auth.token)
            }
        }.onAppear {
            Task {
                /// The model handles loading correctly. Though a byproduct is several tab navigations can lead to loading more pages.
                await self.model.loadReviews(auth: self.auth, userCache: self.userCache, action: self.createActionCallback)
            }
        }.onChange(of: scenePhase) { newPhase in
            /// When opening the app from the background, an active event is fired here.
            /// We hook onto this and check if the last time we loaded data was. If it was recent, we hard refresh.
            if newPhase == .active {
                if self.lastLoad.addingTimeInterval(TimeInterval(300)) < Date() {
                    self.lastLoad = Date()
                    Task {
                        await self.model.hardLoadReviews(auth: self.auth, userCache: self.userCache, action: self.createActionCallback)
                    }
                }
            }
        }
    }
}
