//
//  ReviewDataEditor.swift
//  app
//
//  Created by Colton Lathrop on 3/16/23.
//

import Foundation
import SwiftUI

struct ReviewDataEditor: View {
    @State var model: CreateReviewModel
    
    var postAction: () -> Void
    
    var body: some View {
        VStack {
            if self.model.showError {
                Text(self.model.errorText).foregroundColor(.red)
            }
            VStack {
                HStack{
                    Spacer()
                    ReviewStarsSelector(stars: self.$model.stars).padding()
                    Spacer()
                }.padding()
                HStack {
                    DatePicker(
                        "",
                        selection: self.$model.date,
                        displayedComponents: [.date]
                    )
                }
                HStack {
                    VStack {
                        TextField("Write a caption", text: self.$model.text, axis: .vertical).lineLimit(3...)
                        if self.model.text.count > 400 {
                            Text("too long").foregroundColor(.red)
                        }
                    }.padding().background(.quaternary).cornerRadius(8)
                }
            }
            Spacer()
            PrimaryButton(title: "Post", action: self.postAction)
        }
    }
}
