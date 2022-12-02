//
//  MainView.swift
//  bout
//
//  Created by Colton Lathrop on 11/29/22.
//

import Foundation
import SwiftUI

struct MainView: View {
    @EnvironmentObject var authentication: Authentication
    var body: some View {
        VStack{
            if authentication.authenticated {
                ActiveView()
            } else {
                LoginView()
            }
        }
    }
}
