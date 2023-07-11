//
//  SearchForFriendsList.swift
//  app
//
//  Created by Colton Lathrop on 1/11/23.
//

import Foundation
import SwiftUI

struct SearchForFriendsList: View {
    @Binding var path: NavigationPath
    
    @State var results: [User] = []
    @State var searchText = ""
    
    @State var inflightSearch = ""
    @State var pending = false
    
    @State var failed = false
    
    @EnvironmentObject var friendsCache: FriendsCache
    @EnvironmentObject var auth: Authentication
    
    func searchForUsers() async {
        if self.searchText.isEmpty {
            return
        }
        
        self.failed = false
        
        if self.pending {
            self.inflightSearch = self.searchText
            return
        }
        self.pending = true
        
        let result = await app.searchUserByName(token: auth.token, name: searchText)
        
        switch result {
        case .success(let users):
            self.results = users
        case .failure(_):
            self.failed = true
        }
        
        self.pending = false
        
        if self.searchText != self.inflightSearch {
            await self.searchForUsers()
        }
        
    }
    
    var body: some View {
        VStack {
            HStack {
                TextField("Search", text: $searchText).onChange(of: searchText, perform: { text in
                    Task {
                        await self.searchForUsers()
                    }
                }).padding(8)
            }.background(.quaternary).cornerRadius(8).padding()
            ScrollView {
                VStack {
                    ForEach(self.results) { user in
                        FriendsListItemLoader(path: self.$path, userId: user.id, requestId: "", itemType: .SearchItem, atFilter: nil)
                    }
                }.padding(.horizontal)
            }.scrollDismissesKeyboard(.immediately)
        }.navigationTitle("Search for Friends").padding(.top)
    }
}
