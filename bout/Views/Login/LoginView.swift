//
//  OnboardingView.swift
//  bout
//
//  Created by Colton Lathrop on 12/1/22.
//

import Foundation
import SwiftUI

enum LoginPhase {
    case GetCode
    case SubmitCode
}

struct LoginView: View {
    @State var phone: String = ""
    @State var phase: LoginPhase = .GetCode
    @StateObject var errorDisplay: ErrorDisplay = ErrorDisplay()
    
    var body: some View {
        VStack {
            if errorDisplay.displayError {
                HStack {
                    Spacer()
                    Text(errorDisplay.errorMessage).padding(.bottom)
                    Spacer()
                    Button(action: {
                        errorDisplay.closeError()
                    }){
                        Image(systemName: "x.circle.fill")
                    }.foregroundColor(.secondary).padding(.trailing).padding(.bottom)
                }.background(.red).animation(.easeInOut(duration: 0.75), value: errorDisplay.displayError)
            }
            Text("Bout")
                .font(.largeTitle.bold())
                .padding()
            switch phase {
            case .GetCode:
                GetCodeView(phase: $phase, phone: $phone)
            case .SubmitCode:
                SubmitCodeView(phase: $phase, phone: $phone)
            }
        }.environmentObject(errorDisplay)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView().preferredColorScheme(.dark)
    }
}
