//
//  FCollectionReference.swift
//  LetsMeet
//
//  Created by David Kababyan on 30/06/2020.
//

import Foundation
import Firebase

enum FCollectionReference: String {
    case Lesson = "pia_lesson"
    case Conversation = "pia_conversation"
} 

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    
    return Firestore.firestore().collection(collectionReference.rawValue)
}
