//
//  LogoutButton.swift
//  spotster
//
//  Created by Colton Lathrop on 1/10/23.
//

import Foundation
import SwiftUI

struct LogoutButton: View {
    
    @EnvironmentObject var auth: Authentication
    
    var body: some View {
        Button(action:{}){
            HStack {
                Text("Logout")
                Spacer()
                Image(systemName: "chevron.right").foregroundColor(.secondary)
            }
        }
    }
}
