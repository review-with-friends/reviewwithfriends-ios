//
//  ChangeProfileButton.swift
//  spotster
//
//  Created by Colton Lathrop on 1/10/23.
//

import Foundation

import Foundation
import SwiftUI

struct ChangeProfileButton: View {
    
    @EnvironmentObject var auth: Authentication
    
    var body: some View {
        Button(action:{
            auth.resetCachedOnboarding()
        }){
            HStack {
                Text("Change Profile")
                Spacer()
                Image(systemName: "chevron.right").foregroundColor(.secondary)
            }
        }
    }
}
