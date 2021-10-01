//
//  InputSectionView.swift
//  WhatIsThis-WGO
//
//  Created by Waleerat Gottlieb on 2021-09-16.
//

import SwiftUI

struct ConversationFormPreviewView: View {
    @EnvironmentObject var conversationVM: ConversationVM
    
    @ObservedObject var voiceVM = VoiceVM()
    @ObservedObject private var keyboard = KeyboardInfo.shared
    
    @Binding var currentLesson: ConversationLessonModel?
    @Binding var currentConversation: [ConversationModel]
    @Binding var audioFile:String
    @Binding var isAudioInThaiRecording: Bool
    
    // Note: - helper variables
    @State var objectId: String = ""
    @State var audioInThaiFromDB: String = ""
    @State var audioInEnglishFromDB: String = ""
    
    var body: some View{
        
        VStack (spacing: 10){
            if let currentRow = currentLesson {
                HStack{
                    VStack(alignment: .leading) {
                        Text(currentRow.titleThai).modifier(TextBoldModifier(fontStyle: .title))
                        Text(currentRow.titleEnglish).modifier(TextBoldModifier(fontStyle: .title))
                    }
                    Spacer()
                } 
                 
                ScrollView{
                    VStack (spacing: 15){
                        ForEach (currentConversation) { row in
                            
                            HStack {
                                ZStack(alignment: (row.alignment == .left) ? .topLeading : .topTrailing) {
                                    ConversactionRow(currentRow: row)
                                     ConversationIconsView(currentConversation: $currentConversation,currentRow: row)
                                        .environmentObject(conversationVM)
                                }
                                Spacer()
                            }
                            //
                            .id(row.id)
                        }
                    }
                    .padding(.vertical)
                  
                }
               
            }
            //:: VSTACK
        }
        //:VSTACK
        .onAppear() {
            // Note: - Load default value
            if let row = currentLesson{
                 objectId = row.id
             }
        }
        .onTapGesture {
            withAnimation() {
                hideKeyboard()
            }
          }
    }
}

struct ConversactionRow : View {
    @State var currentRow: ConversationModel
    var body: some View {
        if currentRow.alignment == .left {
            HStack{
                VStack(alignment: (currentRow.alignment == .left) ? .leading : .trailing , spacing: 5) {
                    Text(currentRow.textInThai)
                    Text(currentRow.textInEnglish)
                }
                .padding(.top)
                .modifier(ConversationModifier(backgroundColor: Color((currentRow.alignment == .left) ? kConversationBG2 : kConversationBG1).opacity(0.1)))
                Spacer()
            }
        } else {
            HStack{
                Spacer()
                VStack(alignment: (currentRow.alignment == .left) ? .leading : .trailing , spacing: 5) {
                    Text(currentRow.textInThai)
                    Text(currentRow.textInEnglish)
                }
                .padding(.top)
                .modifier(ConversationModifier(backgroundColor: Color((currentRow.alignment == .left) ? kConversationBG2 : kConversationBG1).opacity(0.1)))
            }
        }
    }
}


struct ConversationIconsView: View {
    @EnvironmentObject var conversationVM: ConversationVM
    
    @ObservedObject var voiceVM = VoiceVM()
    @Binding var currentConversation: [ConversationModel]
    @State var currentRow: ConversationModel
    var body : some View {
        HStack {
            // Note: - Play sound
            if let audioFile = currentRow.audioFile {
                if !audioFile.isEmpty {
                    Button {
                        playSound()
                    } label: {
                        ZStack{
                            Circle()
                                .fill(Color(kBackgroundColor).opacity(0.5))
                                .frame(width: 27, height: 27)
                            
                            Circle()
                                .fill(Color(kForegroundColor))
                                .frame(width: 25, height: 25)
                            
                            Image(systemName: "mic.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color(kBackgroundColor))
                                .frame(width: 20, height: 20)
                        }
                    }
                }
            }
             
            
            // Note: - Delete conversation
            Button {
                deleteConversation()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color(kForegroundColor))
                    .frame(width: 25, height: 25)
            }
        }
    }
    
    func playSound(){
        if let audioFile = currentRow.audioFile {
            if audioFile.contains("firebasestorage.googleapis.com") {
                if let url = URL(string: audioFile) {
                    voiceVM.startPlayingFromFirestoreURL(url : url)
                }
            } else {
                if !audioFile.isEmpty {
                    voiceVM.startPlaying(url : URL(string: audioFile)!)
                }
            }
        }
    }
    
    func deleteConversation(){
        // Note: - Delete record form Firebase
        conversationVM.removeConversation(selectedRow: currentRow) { _ in
            // Note: - Remove from list
            let objIndex = currentConversation.firstIndex { $0.id == currentRow.id }
            currentConversation.remove(at: objIndex!)
        }
    }
}
