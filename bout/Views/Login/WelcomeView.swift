//
//  WelcomeView.swift
//  bout
//
//  Created by Colton Lathrop on 12/6/22.
//

import Foundation
import SwiftUI
import SafariServices

struct WelcomeView: View {
    @Binding var phase: LoginPhase
    
    @State private var isRotating = 0.0
    @State private var showSafari: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Button(action: {
                self.phase = .GetCode
            }){
                Text("Get Started")
                    .font(.title.bold())
                    .padding().foregroundColor(.black)
            }.background(.primary).cornerRadius(16.0)
            HStack {
                Text("By continuing you are accepting our")
                Button(action: {
                    self.showSafari = true
                }){
                    Text("privacy policy.")
                    
                }.foregroundColor(.primary)
            }.padding().font(.caption).foregroundColor(.secondary)
            
            Spacer()
            
            Circle()
                .fill(
                    AngularGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]), center: .center)
                )
                .rotationEffect(.degrees(isRotating))
                .onAppear {
                    withAnimation(
                        .linear(duration: 1)
                        .speed(0.2)
                        .repeatForever(autoreverses: false)) {
                            isRotating = 360.0
                        }
                }.mask(){
                    Text("Created by").font(.caption)
                    Text("Spacedog Labs")
                }.frame(width: 144, height: 144)
        }
        .fullScreenCover(isPresented: $showSafari, content: {
                SFSafariViewWrapper(url: URL(string: "https://spacedoglabs.com/bout/privacypolicy.html")!)
        })
    }
}

struct SFSafariViewWrapper: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SFSafariViewWrapper>) {
        return
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(phase: .constant(LoginPhase.Welcome)).preferredColorScheme(.dark)
    }
}
