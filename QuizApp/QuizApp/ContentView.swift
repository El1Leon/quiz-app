//
//  ContentView.swift
//  QuizApp
//
//  Created by Edwar Ricardo on 7/17/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            QuizListView()
        }
    }
}

#Preview {
    ContentView()
        .environment(QuizStore())
}
