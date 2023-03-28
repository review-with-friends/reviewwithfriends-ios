//
//  FriendsOnlyToggle.swift
//  app
//
//  Created by Colton Lathrop on 12/28/22.
//

import Foundation
import SwiftUI
import MapKit

struct FriendsOnlyToggle: View {
    @Binding var isOn: Bool
    var callBack: () -> Void
    
    var body: some View {
            Button(action: {
                self.callBack()
            }){
                VStack{
                    if isOn {
                        Image(systemName:"person.2.fill")
                    } else {
                        Image(systemName:"person.2")
                    }
                }.padding(.horizontal, 8)
                    .padding(.top, 12)
                    .padding(.bottom, 4)
            }
    }
}
