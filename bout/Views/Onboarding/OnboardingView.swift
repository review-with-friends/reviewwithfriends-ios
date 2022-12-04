//
//  OnboardingView.swift
//  bout
//
//  Created by Colton Lathrop on 11/28/22.
//

import Foundation
import SwiftUI

enum OnboardingPhase {
    case SetNames
    case SetProfilePic
    case GetStarted
}

struct OnboardingView: View {
    @State var phone: String = ""
    @State var phase: OnboardingPhase = .SetProfilePic
    
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
            case .SetNames:
                SetNamesView(phase: $phase)
            case .SetProfilePic:
                SetProfilePicView(phase: $phase)
            case .GetStarted:
                GetStartedView(phase: $phase, phone: $phone)
            }
        }.environmentObject(errorDisplay)
    }
}

struct GetStartedView: View {
    @Binding var phase: OnboardingPhase
    @Binding var phone: String
    var body: some View {
        Text("GetStartedView")
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView().preferredColorScheme(.dark).environmentObject(Authentication.initPreview())
    }
}
