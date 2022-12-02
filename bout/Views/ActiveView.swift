//
//  ActiveView.swift
//  bout
//
//  Created by Colton Lathrop on 11/28/22.
//

import Foundation
import SwiftUI

struct ActiveView: View {
    @EnvironmentObject var auth: Authentication
    var body: some View {
        VStack {
            if let userId = auth.user?.id {
                Text(userId)
            }
            Button(action: {
                auth.logout()
            }){
                Text("Logout").font(.title)
            }
        }
    }
}
