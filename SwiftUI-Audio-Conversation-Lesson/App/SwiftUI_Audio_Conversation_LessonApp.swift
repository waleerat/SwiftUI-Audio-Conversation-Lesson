//
//  SwiftUI_Audio_Conversation_LessonApp.swift
//  SwiftUI-Audio-Conversation-Lesson
//
//  Created by Waleerat Gottlieb on 2021-09-29.
//

import SwiftUI
import Firebase

@main
struct SwiftUI_Audio_Conversation_LessonApp: App {
    init(){
        setupFirebaseApp()
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    private func setupFirebaseApp() {
       guard let plistPath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
                      let options =  FirebaseOptions(contentsOfFile: plistPath)
                      else { return }
                  if FirebaseApp.app() == nil{
                      FirebaseApp.configure(options: options)
                  }
    
    }
}
