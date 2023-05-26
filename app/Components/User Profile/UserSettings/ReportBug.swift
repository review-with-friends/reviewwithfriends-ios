//
//  ReportBug.swift
//  app
//
//  Created by Colton Lathrop on 5/19/23.
//

import Foundation
import SwiftUI

struct ReportBug: View {
    @State var complete: Bool = false
    @State var error: Bool = false
    
    @State var title = ""
    @State var description = ""
    
    @EnvironmentObject var auth: Authentication
    
    func reportBug() async {
        self.error = false
        
        let reportResult = await app.reportBug(token: auth.token, title: self.title, description: self.description)
        
        switch reportResult {
        case .success(_):
            self.complete = true
            Task {
                
            }
        case .failure(_):
            self.error = true
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Submit Bug Report").font(.title).bold()
                Image(systemName: "ladybug.fill").font(.title).foregroundColor(.red)
            }.padding()
            HStack {
                Text("Our team is directly notified of these bugs! If you submit a bug, and we fix it, we'll call you out in our patch notes on the update it's fixed in!").foregroundColor(.secondary)
            }.padding()
            if !self.complete {
                VStack {
                    VStack {
                        TextField("Issue Subject", text: self.$title, axis: .vertical).lineLimit(1)
                        if self.title.count > 64 {
                            Text("too long").foregroundColor(.red)
                        }
                    }.padding().background(.quaternary).cornerRadius(8)
                    VStack {
                        TextField("Describe the issue", text: self.$description, axis: .vertical).lineLimit(3...)
                        if self.description.count > 1024 {
                            Text("too long").foregroundColor(.red)
                        }
                    }.padding().background(.quaternary).cornerRadius(8)
                    if self.error {
                        Text("Failed to submit bug report. Please try again.").foregroundColor(.red)
                    }
                    PrimaryButton(title: "Submit Bug Report", action: {
                        Task {
                            await self.reportBug()
                        }
                    }).padding()
                }.padding()
            } else {
                Text("Thank you for submitting a report! 🎉").font(.title).bold()
            }
            Spacer()
        }
    }
}

struct ReportBug_Preview: PreviewProvider {
    static var previews: some View {
        VStack{
            ReportBug()
                .preferredColorScheme(.dark)
                .environmentObject(Authentication.initPreview())
        }
    }
}
