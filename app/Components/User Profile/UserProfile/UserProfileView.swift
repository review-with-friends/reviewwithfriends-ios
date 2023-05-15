//
//  UserProfileView.swift
//  app
//
//  Created by Colton Lathrop on 1/30/23.
//

import Foundation
import SwiftUI


struct UserProfileView: View {
    @Binding var path: NavigationPath
    var user: User
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    @StateObject var model = PaginatedReviewModel()
    
    @State var showGrid = getCachedGridPreference()
    @State var showReportSheet: Bool = false
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var userCache: UserCache
    @EnvironmentObject var friendsCache: FriendsCache
    
    func createActionCallback(page: Int) async -> Result<[Review], RequestError> {
        return await app.getReviewsForUser(token: self.auth.token, userId: self.user.id, page: page)
    }
    
    static func getCachedGridPreference() -> Bool {
        let value = AppStorage.init(wrappedValue: false, "GRID_PREFERENCE")
        return value.wrappedValue
    }
    
    func setCachedGridPreference() {
        var value = AppStorage.init(wrappedValue: false, "GRID_PREFERENCE")
        value.wrappedValue = self.showGrid
        value.update()
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if let loggedInUser = self.auth.user {
                    if loggedInUser.id != self.user.id {
                        HStack {
                            Spacer()
                            UserProfileCommandBar(path: self.$path, showReportSheet: self.$showReportSheet, userId: self.user.id)
                        }.padding(.bottom.union(.trailing))
                    } else {
                        HStack {
                            Spacer()
                            IconButton(icon: "person.2.fill", action: {
                                self.path.append(ManageFriendsDestination())
                            }).padding(8).overlay {
                                VStack {
                                    if self.friendsCache.fullFriends.incomingRequests.count > 0 {
                                        VStack {
                                            Circle().foregroundColor(.red).frame(width: 16).overlay {
                                                Text(self.friendsCache.getIncomingFriendRequestCountString()).font(.caption)
                                            }.offset(x: 16, y: -10)
                                        }
                                    }
                                }
                            }
                            IconButton(icon: "gearshape.fill", action: {
                                self.path.append(SettingsDestination())
                            }).padding(8)
                        }
                    }
                }
                HStack {
                    Spacer()
                    VStack {
                        ProfilePicLoader(path: self.$path, userId: user.id, profilePicSize: .large, navigatable: false, ignoreCache: true)
                        HStack {
                            VStack {
                                Text(user.displayName).padding(4)
                                Text("@" + user.name).font(.caption)
                                    .padding(.bottom)
                                UserActions(path: self.$path, user: user).padding(.bottom)
                            }
                        }
                    }
                    Spacer()
                }
                if self.friendsCache.areFriends(userId: self.user.id) {
                    HStack {
                        Spacer()
                        Picker("", selection: $showGrid) {
                            Image(systemName: "photo.stack").tag(false)
                            Image(systemName: "rectangle.grid.3x2.fill").tag(true)
                        }.onChange(of: showGrid) { g in
                            self.setCachedGridPreference()
                        }
                        .pickerStyle(.segmented)
                        Spacer()
                    }
                    
                    if self.showGrid {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 125))]) {
                            ForEach(self.model.reviewsToRender) { review in
                                ReviewGridItem(path: self.$path, fullReview: review.fullReview)
                            }
                        }
                    }
                    else {
                        ForEach(self.model.reviewsToRender) { review in
                            ReviewLoaderA(path: self.$path, review: review, showListItem: true, showLocation: true)
                        }
                    }
                    VStack {
                        if self.model.noMorePages {
                            Text("Thats it!").foregroundColor(.secondary).padding(50).font(.caption)
                        }
                        else {
                            ProgressView().padding()
                        }
                    }.onAppear {
                        Task {
                            await self.model.onItemAppear(auth: self.auth, userCache: self.userCache, action: self.createActionCallback)
                        }
                    }
                }
            }
            if self.model.failed {
                Text(self.model.error)
                
                Button(action: {
                    Task {
                        await self.model.hardLoadReviews(auth: self.auth, userCache: self.userCache, action: self.createActionCallback)
                    }
                }){
                    Text("Retry Loading")
                }
            }
        }.scrollIndicators(.hidden).refreshable {
            Task {
                await self.model.hardLoadReviews(auth: self.auth, userCache: self.userCache, action: self.createActionCallback)
            }
        }.onAppear {
            Task {
                await self.model.loadReviews(auth: self.auth, userCache: self.userCache, action: self.createActionCallback)
                if self.showGrid {
                    await self.model.onItemAppear(auth: self.auth, userCache: self.userCache, action: self.createActionCallback)
                }
                // ignore errors here, its fine and best effort
                let _ = await self.friendsCache.refreshFriendsCache(token: self.auth.token)
            }
        }.sheet(isPresented: self.$showReportSheet) {
            ReportUser(showReportSheet: self.$showReportSheet, userId: self.user.id)
                .presentationDetents([.fraction(0.33)])
                .presentationDragIndicator(.visible)
        }
    }
}
