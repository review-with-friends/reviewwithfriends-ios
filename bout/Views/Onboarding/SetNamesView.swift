//
//  SetNamesView.swift
//  bout
//
//  Created by Colton Lathrop on 11/29/22.
//

import Foundation
import SwiftUI

struct SetNamesView: View {
    @Binding var phase: OnboardingPhase
    @Binding var phone: String
    var body: some View {
        VStack {
            Spacer()
            Image("rock")
            Spacer()
        }
    }
}

struct SetNamesView_Previews: PreviewProvider {
    static var previews: some View {
        SetNamesView(phase: .constant(OnboardingPhase.SetNames), phone: .constant("7014910059")).preferredColorScheme(.dark)
    }
}
