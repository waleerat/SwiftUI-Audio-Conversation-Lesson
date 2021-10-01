//
//  PersonModel.swift
//  SwiftUI-Audio-Conversation-Lesson
//
//  Created by Waleerat Gottlieb on 2021-09-29.
//

import SwiftUI

struct PersonModel: Identifiable, Hashable, Codable {
    var id: String
    var name: String
    var gendar: String
    var imageURL: String?
    
    
    init(_id: String, _name: String, _gendar: String) {
        id = _id
        name = _name
        gendar = _gendar
    }
}

// Note: - Sample person
var person: [PersonModel] = [
    PersonModel(_id: UUID().uuidString, _name: "Lucas", _gendar: "boy"),
    PersonModel(_id: UUID().uuidString, _name: "William", _gendar: "boy"),
    PersonModel(_id: UUID().uuidString, _name: "Elias", _gendar: "boy"),
    PersonModel(_id: UUID().uuidString, _name: "Noah", _gendar: "boy"),
    PersonModel(_id: UUID().uuidString, _name: "Hugo", _gendar: "boy"),
    PersonModel(_id: UUID().uuidString, _name: "Oliver", _gendar: "boy"),
    PersonModel(_id: UUID().uuidString, _name: "Oscar", _gendar: "boy"),
    PersonModel(_id: UUID().uuidString, _name: "Adam", _gendar: "boy"),
    PersonModel(_id: UUID().uuidString, _name: "Matteo", _gendar: "boy"),
    PersonModel(_id: UUID().uuidString, _name: "Lars", _gendar: "boy"),
    PersonModel(_id: UUID().uuidString, _name: "Mikael", _gendar: "boy"),
    PersonModel(_id: UUID().uuidString, _name: "Thomas", _gendar: "boy"),
    PersonModel(_id: UUID().uuidString, _name: "Emma", _gendar: "girl"),
    PersonModel(_id: UUID().uuidString, _name: "Lena", _gendar: "girl"),
    PersonModel(_id: UUID().uuidString, _name: "Sara", _gendar: "girl"),
    PersonModel(_id: UUID().uuidString, _name: "Kristina", _gendar: "girl"),
    PersonModel(_id: UUID().uuidString, _name: "Karin", _gendar: "girl"),
    PersonModel(_id: UUID().uuidString, _name: "Eva", _gendar: "girl"),
    PersonModel(_id: UUID().uuidString, _name: "Maria", _gendar: "girl"),
    PersonModel(_id: UUID().uuidString, _name: "Lilly", _gendar: "girl"),
    PersonModel(_id: UUID().uuidString, _name: "Wilma", _gendar: "girl"),
    PersonModel(_id: UUID().uuidString, _name: "Ella", _gendar: "girl"),
    PersonModel(_id: UUID().uuidString, _name: "Ebba", _gendar: "girl"),
    PersonModel(_id: UUID().uuidString, _name: "Vera", _gendar: "girl"),
    PersonModel(_id: UUID().uuidString, _name: "Maja", _gendar: "girl"),
    PersonModel(_id: UUID().uuidString, _name: "Astrid", _gendar: "girl"),
    PersonModel(_id: UUID().uuidString, _name: "Olivia", _gendar: "girl"),
    PersonModel(_id: UUID().uuidString, _name: "Alice", _gendar: "girl"),
]
 
