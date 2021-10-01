//
//  ConversationModel.swift
//  SwiftUI-Audio-Conversation-Lesson
//
//  Created by Waleerat Gottlieb on 2021-09-29.
//

import SwiftUI
// Note: - For FirebaseCollection
struct FirebaseLessonModel: Identifiable {
    var id: String
    var titleThai: String
    var titleEnglish: String
    var person1: String
    var person2: String
}

struct FirebaseConversationModel: Identifiable {
    var id: String
    var order:Int
    var lessonId: String
    var alignment: String
    var name: String
    var textInThai: String
    var textInEnglish: String
    var audioFile:String?
    let createdAt:Date = Date()
}

// Note: - For ViewModel

enum alignment {
    case right
    case left
}

struct ConversationLessonModel: Identifiable {
    var id: String
    var titleThai: String
    var titleEnglish: String
    var person1: String
    var person2: String
    var conversation: [ConversationModel]
}

struct ConversationModel: Identifiable {
    var id: String
    var order:Int
    var alignment: alignment
    var name: String
    var textInThai: String
    var textInEnglish: String
    var audioFile:String?
}
