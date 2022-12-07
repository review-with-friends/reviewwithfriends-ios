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
    @State var phase: OnboardingPhase = .SetNames
    var showPreviewError: Bool?
    
    @StateObject var errorDisplay: ErrorDisplay = ErrorDisplay()
    
    var body: some View {
        VStack {
            if errorDisplay.displayError {
                VStack {
                    HStack {
                        
                    }.frame(minHeight: 10.0)
                    HStack {
                        Spacer()
                        Text(errorDisplay.errorMessage).padding(.bottom)
                        Spacer()
                        Button(action: {
                            errorDisplay.closeError()
                        }){
                            Image(systemName: "x.circle.fill")
                        }.foregroundColor(.secondary).padding(.trailing).padding(.bottom)
                    }
                }
                .background(.red)
                .animation(.easeInOut(duration: 0.75), value: errorDisplay.displayError)
            }
            BoutTitle()
            switch phase {
            case .SetNames:
                SetNamesView(phase: $phase).transition(.opacity)
            case .SetProfilePic:
                SetProfilePicView(phase: $phase).transition(.opacity)
            case .GetStarted:
                GetStartedView(phase: $phase).transition(.opacity)
            }
        }
        .environmentObject(errorDisplay).onAppear {
            if let showError = self.showPreviewError {
                if showError {
                    self.errorDisplay.showError(message: "this is a test error")
                }
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(showPreviewError: true).preferredColorScheme(.dark).environmentObject(Authentication.initPreview())
        OnboardingView().preferredColorScheme(.dark).environmentObject(Authentication.initPreview())
    }
}
