//
//  LikeSelector.swift
//  app
//
//  Created by Colton Lathrop on 6/6/23.
//

import Foundation
import SwiftUI

struct LikeSelector: View {
    /// An escaping callback for when action is triggered.
    var callback: (String) async -> Void
    
    @State var scale = 0.0
    
    let emojiBarEmojis = ["🔥", "😍", "😢", "🤣"]
    
    var body: some View {
        VStack {
            HStack {
                ForEach(self.emojiBarEmojis, id: \.self) { emoji in
                    Button (action: {
                        Task {
                            await self.callback(emoji)
                        }
                    }) {
                        Text(emoji).font(.title).padding(.horizontal)
                    }
                }
            }.padding().background(.black).cornerRadius(16.0).shadow(radius: 6.0)
        }.scaleEffect(self.scale)
            .onAppear {
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                withAnimation(.interpolatingSpring(stiffness: 100, damping: 8)) {
                    self.scale = 1.0
                }
            }
    }
}

struct LikeSelector_Preview: PreviewProvider {
    static func callback(emoji: String) async {}
    
    static var previews: some View {
        VStack {
            LikeSelector(callback: callback)
        }.preferredColorScheme(.dark)
    }
}
