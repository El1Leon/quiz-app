//
//  QuizAppApp.swift
//  QuizApp
//
//  Created by Edwar Ricardo on 7/17/26.
//

import SwiftUI

@main
struct QuizAppApp: App {
    @State private var store = QuizStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(store)
        }
    }
}
