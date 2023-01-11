//
//  FriendsOnlyToggle.swift
//  spotster
//
//  Created by Colton Lathrop on 12/28/22.
//

import Foundation
import SwiftUI
import MapKit

struct FriendsOnlyToggle: View {
    @Binding var isOn: Bool
    
    var body: some View {
            Button(action: {
                self.isOn.toggle()
            }){
                VStack{
                    if isOn {
                        Image(systemName:"person.fill")
                    } else {
                        Image(systemName:"person")
                    }
                }.padding(.horizontal, 8)
                    .padding(.top, 12)
                    .padding(.bottom, 4)
            }
    }
}
