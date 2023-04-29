//
//  SearchForFriendsList.swift
//  app
//
//  Created by Colton Lathrop on 3/1/23.
//

import Foundation
import SwiftUI
import Contacts

struct DiscoverFriendsList: View {
    @Binding var path: NavigationPath
    
    var navigatable: Bool
    
    @State var results: [User] = []
    @State var numbers: [String] = []
    
    
    @State var successfulLoad = false
    @State var pending = false
    @State var failed = false
    
    @State var accessGranted = false
    
    @EnvironmentObject var friendsCache: FriendsCache
    @EnvironmentObject var auth: Authentication
    
    func requestContactAccess() {
        CNContactStore().requestAccess(for: .contacts) { granted, error in
            if granted {
                self.accessGranted = true
            }
        }
    }
    
    func getContactPhoneNumbers() {
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        
        request.mutableObjects = false
        request.unifyResults = true
        
        
        DispatchQueue(label: "test", qos: .background).async {
            do {
                var numbers: [String] = []
                try CNContactStore().enumerateContacts(with: request, usingBlock: {
                    (contact, stopPointer) in
                    for phone in contact.phoneNumbers {
                        var label = phone.label
                        if label != nil {
                            label = CNLabeledValue<CNPhoneNumber>.localizedString(forLabel: label!)
                        }
                        
                        let formattedNumber = cleanPhoneNumber(number: phone.value.stringValue)
                        
                        numbers.append(formattedNumber)
                    }
                })
                
                self.numbers = numbers

            } catch {
                
            }
        }
    }
    
    func discoverFriends() async {
        self.successfulLoad = false
        self.failed = false
        self.pending = true
        
        let result = await app.discoverFriendsWithNumbers(token: auth.token, numbers: self.numbers)
        
        switch result {
        case .success(let users):
            self.results = users
            self.successfulLoad = true
        case .failure(_):
            self.failed = true
        }
        
        self.pending = false
    }
    
    var body: some View {
        VStack {
            if !self.accessGranted {
                VStack {
                    EnableContactAccessView()
                    Spacer()
                }
            } else {
                if self.results.count == 0 && self.successfulLoad {
                    VStack {
                        Spacer()
                        Image("discover")
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(50).overlay {
                                VStack {
                                    Spacer()
                                    VStack {
                                        HStack {
                                            HStack {
                                                Text("Looks like we can't find any of your contacts already on here.").font(.title2.bold()).padding()
                                            }.background(.black).cornerRadius(25)
                                            Spacer()
                                        }.padding(.horizontal)
                                        HStack {
                                            Spacer()
                                            HStack {
                                                Text("You should send us to your friends!").font(.title2.bold()).padding()
                                            }.background(.gray).cornerRadius(25)
                                        }.padding()
                                    }
                                }.shadow(radius: 5)
                            }.unsplashToolTip(URL(string: "https://unsplash.com/@elevatebeer")!)
                        Spacer()
                    }
                } else if self.results.count == 0 {
                    VStack {
                        Spacer()
                        ProgressView().onAppear {
                            self.getContactPhoneNumbers()
                        }.onChange(of: self.numbers, perform: { numbers in
                            Task {
                                await self.discoverFriends()
                            }
                        })
                        Spacer()
                    }
                } else {
                    ScrollView {
                        VStack {
                            ForEach(self.results) { user in
                                DiscoverFriendsListItem(path: self.$path, user: user, navigatable: self.navigatable)
                            }
                        }.padding(.horizontal)
                    }.refreshable {
                        Task {
                            await self.discoverFriends()
                        }
                    }
                }
            }
        }.navigationTitle("Discover Friends")
            .padding(.top)
            .onAppear {
                self.requestContactAccess()
            }
    }
}


func cleanPhoneNumber(number: String) -> String {
    var output = ""
    
    let onlyNumbers = number.filter("0123456789".contains)
    
    if onlyNumbers.count == 10 {
        output = "1" + onlyNumbers
    }
    
    if onlyNumbers.count == 11 {
        output = onlyNumbers
    }
    
    return output
}
