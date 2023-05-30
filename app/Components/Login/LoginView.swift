//
//  OnboardingView.swift
//  app
//
//  Created by Colton Lathrop on 12/1/22.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @State var path = NavigationPath()
    @State var phone: String = ""
    
    @State var recoveryPhone: String = ""
    @State var newPhone: String = ""
    
    var body: some View {
        NavigationStack(path: self.$path) {
            VStack {
                WelcomeView(path: self.$path)
            }
            .navigationDestination(for: GetCode.self) { _ in
                GetCodeView(path: self.$path, phone: $phone)
            }
            .navigationDestination(for: SubmitCode.self) { _ in
                SubmitCodeView(path: self.$path, phone: $phone)
            }
            .navigationDestination(for: RecoverGetStarted.self) { _ in
                RecoveryGetStartedView(path: self.$path, phone: $recoveryPhone)
            }
            .navigationDestination(for: RecoveryGetTextCode.self) { _ in
                RecoveryGetPhoneCodeView(path: self.$path, phone: $newPhone)
            }
            .navigationDestination(for: RecoverySubmitCode.self) { _ in
                RecoverySubmitCodeView(path: self.$path, oldPhone: $recoveryPhone, newPhone: $newPhone)
            }
        }.accentColor(.primary)
    }
}

struct GetCode: Hashable {}
struct SubmitCode: Hashable {}
struct RecoverGetStarted: Hashable {}
struct RecoveryGetTextCode: Hashable {}
struct RecoverySubmitCode: Hashable {}
