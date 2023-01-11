//
//  OnboardingView.swift
//  spotster
//
//  Created by Colton Lathrop on 12/1/22.
//

import Foundation
import SwiftUI

enum LoginPhase {
    case Welcome
    case GetCode
    case SubmitCode
}

struct LoginView: View {
    @State var phone: String = ""
    @StateObject var navigationManager = NavigationManager()
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            VStack{
                WelcomeView()
            }
            .navigationDestination(for: GetCode.self) { _ in
                GetCodeView(phone: $phone)
            }
            .navigationDestination(for: SubmitCode.self) { _ in
                SubmitCodeView(phone: $phone)
            }
        }.environmentObject(self.navigationManager).accentColor(.primary)
    }
}

struct GetCode: Hashable {}
struct SubmitCode: Hashable {}
