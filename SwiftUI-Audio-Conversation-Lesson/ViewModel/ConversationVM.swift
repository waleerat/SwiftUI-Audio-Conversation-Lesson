//
//  ConversationVM.swift
//  SwiftUI-Audio-Conversation-Lesson
//
//  Created by Waleerat Gottlieb on 2021-09-30.
//
import Foundation

class ConversationVM: ObservableObject {
    @Published var contentRows: [ConversationLessonModel] = []
    @Published var allConversationRows: [FirebaseConversationModel] = []
    
    @Published var selectedRow: ConversationLessonModel?
    @Published var currentConversation: [ConversationModel]?
    
    
    init() {
        print(">> init ")
        loadAll()
    }
    
    func loadAll(){
        print(">> Load All")
        getRecords()
        
    }
    
    func  getRecords() {
        
        self.getAllConversations { _ in
            print("self.allConversationRows \(self.allConversationRows.count)")
            self.contentRows = []
            FirebaseReference(.Lesson).getDocuments { [self] (snapshot, error) in
                
                guard let snapshot = snapshot else { return }
                
                if !snapshot.isEmpty {
                    for snapshot in snapshot.documents {
                        let rowData = snapshot.data()
                        let rowStructure = dictionaryToStructrue(rowData)
                        self.contentRows.append(rowStructure)
                    }
                }
            }
        }
        
        
    }
    
    func getAllConversations(completion: @escaping (_ isCompleted: Bool?) -> Void) {
        self.allConversationRows = []
        FirebaseReference(.Conversation)
            .order(by: "order", descending: false)
            .getDocuments { [self] (snapshot, error) in
            
            guard let snapshot = snapshot else { return }
            
            if !snapshot.isEmpty {
                for snapshot in snapshot.documents {
                    let rowData = snapshot.data()
                    let rowStructure = conversationDictionaryToStructrue(rowData)
                     
                    self.allConversationRows.append(rowStructure) 
                }
                completion(true)
                return
            }
           completion(true)
        }
    }
    
    func getSelectedRow(selectedRow: ConversationLessonModel) {
        self.selectedRow = selectedRow
    }
    
    // Note: - Create/Update Record
    func SaveRecord(lessonObjectId: String, lesson: ConversationLessonModel, completion: @escaping (_ isCompleted: Bool?) -> Void) {
        
        FirebaseReference(.Lesson).document(lessonObjectId).setData(self.lessonStructureToDictionary(lesson)) {
            error in
            if error != nil {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    func saveConversation(lessonObjectId: String, conversation: [ConversationModel], completion: @escaping (_ isCompleted: Bool?) -> Void){
        for conversationRow in conversation {
            
            FirebaseReference(.Conversation)
                .document(conversationRow.id)
                .setData(self.conversationStructureToDictionary(lessonId: lessonObjectId, row: conversationRow))
            { _ in
                
                if let audioFile = conversationRow.audioFile {
                    // Note: - Upload audio new recording file
                    self.doUploadAudio(lessonObjectId: lessonObjectId, audioFile: audioFile) { uploadedURL in
                        if let uploadedURL = uploadedURL {
                            // Note: - update audioFile in Firebase
                            let someFields = ["audioFile" : uploadedURL]
                            self.updateByFieldName(objectId: conversationRow.id, someFields: someFields as [String : Any]) { _ in }
                        }
                    }
                    
                    
                }
            }
        }
    }
    
    
    func updateByFieldName(objectId: String, someFields: [String : Any] , completion : @escaping (_ isUpdated: Bool?) -> Void) {
        
        FirebaseReference(.Conversation).document(objectId).updateData(someFields) {
            error in
            if error != nil {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    // Note: - Delete Record
    func removeLesson(selectedRow: ConversationLessonModel?, completion: @escaping (_ isCompleted:Bool?) -> Void) {
        if let row = selectedRow {
            // Note: - Delete lesson
            FirebaseReference(.Lesson).document(row.id).delete() { error in
                // Note: - Delete conversation
                for conversationRow in row.conversation {
                    self.removeConversation(selectedRow: conversationRow) { _ in  }
                }
            }
        }
    }
    
    
    func removeConversation(selectedRow: ConversationModel?, completion: @escaping (_ isCompleted:Bool?) -> Void) {
        
        if let row = selectedRow {
            FirebaseReference(.Conversation).document(row.id).delete() { error in
                if let _ = error {
                    completion(false)
                } else {
                    if let audioFile = row.audioFile {
                        if audioFile.contains("firebasestorage.googleapis.com") {
                            DispatchQueue.main.async {
                                FileStorage.removeFileFromFirestore(fileURL: audioFile)
                            }
                        }
                    }
                    completion(true)
                }
            }
        }
       
    }
    
    
    func doUploadAudio(lessonObjectId:String, audioFile: String, completion : @escaping (_ uploadedURL: String?) -> Void) {
        
        let filename = FileManagerVM.getFilenameFromURL(fileURL: audioFile)
        if FileManagerVM.fileExistsAt(filename: filename) {
            FileStorage.uploadFile(filename: filename, rootDirectory: kFileStoreRootDirectory , directory: lessonObjectId) { uploadedURL in
                if let fileURL = uploadedURL {
                    completion(fileURL)
                    return
                } else {
                    completion(nil)
                    return
                }
            }
        } else {
            completion(nil)
        }
    }
    
    func conversationDictionaryToStructrue(_ dictionaryRow : [String : Any]) -> FirebaseConversationModel {
       
        return FirebaseConversationModel(id: dictionaryRow["id"] as? String ?? "",
                                         order: dictionaryRow["order"] as? Int ?? 0,
                                         lessonId: dictionaryRow["lessonId"] as? String ?? "",
                                         alignment: dictionaryRow["alignment"] as? String ?? "",
                                         name: dictionaryRow["name"] as? String ?? "",
                                         textInThai: dictionaryRow["textInThai"] as? String ?? "",
                                         textInEnglish: dictionaryRow["textInEnglish"] as? String ?? "",
                                         audioFile: dictionaryRow["audioFile"] as? String ?? nil)
    }
    
    func dictionaryToStructrue(_ dictionaryRow : [String : Any]) -> ConversationLessonModel {
        
        var conversations : [ConversationModel] = []
        let lessonId = dictionaryRow["id"] as? String ?? ""
        
        if (lessonId != "") {
            print(">> Get Conversations : \(allConversationRows.count) ")
            if allConversationRows.count > 0 {
                let FConversations = allConversationRows.filter { $0.lessonId == lessonId }
                
                for row in FConversations { 
                    
                    conversations.append(
                        ConversationModel(id: row.id,
                                          order: row.order,
                                          alignment: (row.alignment == "left") ? .left : .right,
                                          name: row.name,
                                          textInThai: row.textInThai,
                                          textInEnglish: row.textInEnglish,
                                          audioFile: row.audioFile))
                    
                }
            }
        }
        
        return ConversationLessonModel(id: dictionaryRow["id"] as? String ?? "",
                                       titleThai: dictionaryRow["titleThai"] as? String ?? "",
                                       titleEnglish: dictionaryRow["titleEnglish"] as? String ?? "",
                                       person1: dictionaryRow["person1"] as? String ?? "",
                                       person2: dictionaryRow["person2"] as? String ?? "",
                                       conversation: conversations)
    }
    
    func lessonStructureToDictionary(_ row : ConversationLessonModel) -> [String : Any] {
        return NSDictionary(
            objects:
                [row.id,
                 row.titleThai,
                 row.titleEnglish,
                 row.person1,
                 row.person2
                ],
            forKeys: [
                "id" as NSCopying,
                "titleThai" as NSCopying,
                "titleEnglish" as NSCopying,
                "person1" as NSCopying,
                "person2" as NSCopying,
            ]
        ) as! [String : Any]
    }
     
    func conversationStructureToDictionary(lessonId: String, row : ConversationModel) -> [String : Any] {
       let alignment = (row.alignment == .left) ? "left" : "right"
       
      
        return NSDictionary(
            objects:
                [row.id,
                 row.order,
                 lessonId,
                 alignment,
                 row.name,
                 row.textInThai,
                 row.textInEnglish,
                 row.audioFile ?? "",
                 Date().dateAndTimetoString()
                ],
            forKeys: [
                "id" as NSCopying,
                "order" as NSCopying,
                "lessonId" as NSCopying,
                "alignment" as NSCopying,
                "name" as NSCopying,
                "textInThai" as NSCopying,
                "textInEnglish" as NSCopying,
                "audioFile" as NSCopying,
                "createdAt"  as NSCopying,
            ]
        ) as! [String : Any]
    }
    
}
