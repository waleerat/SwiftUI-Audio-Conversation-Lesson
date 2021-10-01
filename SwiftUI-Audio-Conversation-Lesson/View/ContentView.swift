//
//  ContentView.swift
//  SwiftUI-Audio-Conversation-Lesson
//
//  Created by Waleerat Gottlieb on 2021-09-29.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ConversationIndexView()
                .modifier(ScreenModifier())
                .modifier(NavigationBarHiddenModifier())
        }.navigationViewStyle(StackNavigationViewStyle())
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
