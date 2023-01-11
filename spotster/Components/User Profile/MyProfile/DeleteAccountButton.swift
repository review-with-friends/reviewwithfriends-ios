//
//  DeleteAccountButton.swift
//  spotster
//
//  Created by Colton Lathrop on 1/10/23.
//

import Foundation
import SwiftUI

struct DeleteAccountButton: View {
    
    @EnvironmentObject var auth: Authentication
    
    var body: some View {
        Button(action:{}){
            HStack {
                Text("Delete Account").foregroundColor(.red)
                Spacer()
                Image(systemName: "chevron.right").foregroundColor(.secondary)
            }
        }
    }
}
