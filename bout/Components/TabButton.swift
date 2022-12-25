//
//  TabButton.swift
//  bout
//
//  Created by Colton Lathrop on 12/7/22.
//

import Foundation
import SwiftUI

struct TabButton<Content: View, Indicator: View>: View {
    var tag: Float
    @Binding var selection: Float
    var alerts: Int?
    
    var content: () -> Content
    var activeIndicator: () -> Indicator
    
    var body: some View {
        VStack{
            ZStack {
                Button(action: {
                    self.selection = tag
                }){
                    VStack {
                        content()
                        if self.selection == tag {
                            //activeIndicator()
                        }
                    }.padding()
                }.foregroundColor(tag == selection ? .primary : .secondary).frame(width: 64.0, height: 64.0)
                if alerts != nil && alerts != 0 {
                    ZStack {
                        Circle().foregroundColor(.red).frame(width: 16, height: 16)
                        if let alert_count = alerts {
                            Text(alert_count.description).font(.system(size: 12))
                        }
                    }.offset(x: 12, y: -12)
                }
            }.background(.quaternary)
        }.animation(.easeInOut(duration: 0.33), value: selection).background().cornerRadius(16.0)
    }
}
