//
//  TextViewO2App.swift
//  TextViewO2
//
//  Created by Max87 on 16/04/2025.
//

import SwiftUI

@main
struct TextViewO2App: App {
    var body: some Scene {
        WindowGroup {
            ContentScreen()
        }
    }
}
struct ContentScreen: View {
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 20) {
            ReusableInputView(
                title: "Email",
                placeholder: "Zadajte email",
                text: $email,
                isEmail: true,
                borderWidth: 2,
                borderShadowRadius: 6,
                borderShadowOpacity: 0.3
            )

            PasswordInputView()
        }
        .padding()
    }
}
