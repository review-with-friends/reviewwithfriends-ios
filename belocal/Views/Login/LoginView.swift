//
//  OnboardingView.swift
//  belocal
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
    @State var path = NavigationPath()
    @State var phone: String = ""
    
    var body: some View {
        NavigationStack(path: self.$path) {
            VStack{
                WelcomeView(path: self.$path)
            }
            .navigationDestination(for: GetCode.self) { _ in
                GetCodeView(path: self.$path, phone: $phone)
            }
            .navigationDestination(for: SubmitCode.self) { _ in
                SubmitCodeView(path: self.$path, phone: $phone)
            }
        }.accentColor(.primary)
    }
}

struct GetCode: Hashable {}
struct SubmitCode: Hashable {}
