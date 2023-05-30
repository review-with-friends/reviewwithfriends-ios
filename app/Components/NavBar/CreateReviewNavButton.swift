//
//  SearchNavButton.swift
//  app
//
//  Created by Colton Lathrop on 2/9/23.
//

import Foundation
import SwiftUI

struct CreateReviewNavButton: View {
    @Binding var path: NavigationPath
    
    @State var scale = 1.0
    @State var pressed = false
    
    var body: some View {
        VStack {
            Button(action: {
                if self.pressed {
                    return
                }
                self.pressed = true
                
                withAnimation {
                    self.scale = 0.9
                }
                Task {
                    // let the scale down play out
                    try await Task.sleep(for:Duration.seconds(0.1))
                    let generator = UISelectionFeedbackGenerator()
                    generator.selectionChanged()
                    withAnimation {
                        self.scale = 1.0
                    }
                    // let the scale up play out
                    try await Task.sleep(for:Duration.seconds(0.1))
                    
                    self.path.append(CreateReviewFromImageDestination())
                    
                    self.pressed = false
                }
            }) {
                ZStack {
                    Circle().frame(width: 64).foregroundColor(.primary).shadow(radius: 8)
                    Image(systemName: "plus").resizable().frame(width: 28, height: 28).padding(.horizontal).bold().foregroundColor(.black)
                }
            }.accentColor(.primary)
                .buttonStyle(FlatLinkStyle())
                .scaleEffect(self.scale)
                .animation(.easeInOut(duration: 0.1), value: scale)
        }.offset(y: -20)
    }
}

struct CreateReviewNavButton_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            CreateReviewNavButton(path: .constant(NavigationPath()))
        }.preferredColorScheme(.dark)
    }
}

struct FlatLinkStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
