//
//  ConversationForm.swift
//  SwiftUI-Audio-Conversation-Lesson
//
//  Created by Waleerat Gottlieb on 2021-09-29.
//

import SwiftUI

struct ConversationForm: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var voiceVM = VoiceVM()
    @EnvironmentObject var conversationVM: ConversationVM

    // Note: - Input Fields
    @Binding var isReload: Bool
    @State var lessonObjectId:String  = ""
    
    @State var textInThai:String  = ""
    @State var textInEnglish:String  = ""
    @State var audioFile:String  = ""
    @State var isAudioInThaiRecording: Bool = false
    
    // Note: - helper variables
    @State var isSaved: Bool = false
    @State var isNewLesson:Bool = false
    @State var whoSpeak: Int = 0
    @State var person1: PersonModel?
    @State var person2: PersonModel?
    @State var currentLesson: ConversationLessonModel?
    @State var currentConversation: [ConversationModel] = []
    @State var conversationObjectId: String = ""
    @State var titleThai: String = ""
    @State var titleEnglish: String = ""
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            Color(kBackgroundColor)
                .ignoresSafeArea(.all)
            // MARK: - Start
            VStack(spacing: 2){
               
                HStack(spacing: 10) {
                    
                    ButtonWithIconWithClipShapeCircleAction(systemName: "arrow.backward", action: {
                        withAnimation() {
                            isReload = true
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    })
                    Text("Conversation").modifier(TextBoldModifier(fontStyle: .title))
                    Spacer()
                    ButtonTextAction(buttonLabel: .constant(conversationVM.selectedRow == nil ? "Save" : "Update") , isActive: .constant((currentConversation.count > 0)), frameWidth: 60) {
                        
                        saveToFirebase(lessonObjectId: lessonObjectId)
                        
                    }.disabled(currentConversation.count == 0)
                     
                }//: HSTACK conversationVM.currentConversation
                
                ConversationFormPreviewView(currentLesson: $currentLesson, currentConversation: $currentConversation, audioFile: $audioFile, isAudioInThaiRecording: $isAudioInThaiRecording)
                    .environmentObject(conversationVM)
                 
                Spacer()
                // Note: - Start Form
                VStack (spacing: 20){
                        // Note: - Form
                        VStack(spacing: 10){
                            HStack{
                                
                                Picker("", selection: $whoSpeak) {
                                    Text((person1 != nil) ? person1!.name : "Erik").tag(0)
                                    Text((person2 != nil) ? person2!.name : "Emma").tag(1)
                                }
                                .pickerStyle(.segmented)
                                
                                Spacer()
                                ButtonTextAction(buttonLabel: .constant("Ok") , isActive: .constant(!textInThai.isEmpty), frameWidth: 60) {
                                    // Note: - Add new conversation to array
                                    addNewConversation()
                                    
                                }.disabled(textInThai.isEmpty)
                            }
                            
                            HStack(spacing: 10){
                                Spacer()
                                FormPreviewAudioIconView(objectId: conversationObjectId, audiofieldName: "audioInThai", audioURL: $audioFile)
                                    .environmentObject(voiceVM)
                                
                                Button {
                                    if !voiceVM.isRecording {
                                        voiceVM.startRecording(fileName: kAudioPrefix + conversationObjectId)
                                        isAudioInThaiRecording.toggle()
                                    } else {
                                        voiceVM.stopRecording()
                                        audioFile = voiceVM.featchRecordingByPrefix(fileName: kAudioPrefix + conversationObjectId) ?? ""
                                        isAudioInThaiRecording.toggle()
                                        
                                    }
                                } label: {
                                    microphoneRecordingView(isRecording: $isAudioInThaiRecording)
                                }
                                //.offset(x: 0, y: -10)
                            }
                            .padding(.horizontal)
                            
                            TextField("Thai", text: $textInThai).modifier(TextInputModifier())
                            TextField("English", text: $textInEnglish).modifier(TextInputModifier())
                        }//:VStack
                   
                }
                .padding()
                .background(Color(kForegroundColor).opacity(0.1))
                .cornerRadius(10)
                // Note: - End Form
            }
            .onAppear() {
                generateConversationObjcectId()
                if let selectedRow = conversationVM.selectedRow {
                    lessonObjectId = selectedRow.id
                    currentLesson = selectedRow
                    currentConversation = selectedRow.conversation
                } else {
                   isNewLesson.toggle()
                }
            }
            .onChange(of: isSaved, perform: { _ in
                if isSaved {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isSaved = true
                        self.presentationMode.wrappedValue.dismiss()
                   }
                }
            })
            .blur(radius: (isSaved)  ? 8.0 : 0, opaque: false)
            .blur(radius: (isNewLesson)  ? 8.0 : 0, opaque: false)
            .modifier(NavigationBarHiddenModifier())
            .padding(.horizontal, 10)
            //: VSTACK
            
            // Note: - If Conversation Lesson is empty
            if isNewLesson {
                ZStack(alignment: .center) {
                    BlankView(
                    backgroundColor: Color.gray,
                      backgroundOpacity: 0.7)
                      .onTapGesture {
                        withAnimation() {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                      }
                    
                    VStack (spacing: 20){
                        Text("New Conversation")
                            .modifier(TextBoldModifier(fontStyle: .header))
                        
                        TextField("Lesson in Thai", text: $titleThai).modifier(TextInputModifier())
                            .background(Color(kBackgroundColor).opacity(0.7))
                        TextField("Lesson in English", text: $titleEnglish).modifier(TextInputModifier())
                            .background(Color(kBackgroundColor).opacity(0.7))
                        
                        
                        ButtonTextAction(buttonLabel: .constant("Continue") , isActive: .constant(!textInThai.isEmpty), frameWidth: screenSize.width * 0.7) {
                            
                            // Note: - Add New lesson and close screen
                            addNewLesson()
                            
                        }.disabled(titleThai.isEmpty)
                    }
                    .onTapGesture {
                        withAnimation() {
                            hideKeyboard()
                        }
                      }
                    .padding(7)
                   // .frame(width: screenSize.width * 0.9, height: screenSize.height * 0.6)
                    .background(Color(kForegroundColor).opacity(0.3))
                    .cornerRadius(10)
                    .padding(5) 
                }
                
            }
            // MARK: - End
        } //: ZSTACK
    }//: BODY
    
    func generateConversationObjcectId(){
        conversationObjectId = UUID().uuidString
    }
    
    func addNewLesson(){
        lessonObjectId = UUID().uuidString
        currentConversation = []
        // Note: - Random Person form PersonModel
        person1 = person.randomElement()!
        // Note: - remove person1 from array so name won't be duplicate
       // person.remove(at: person.filter({ $0.name == person1.name }).map({ $0.name })))
        person2 = person.randomElement()!
       
        currentLesson = ConversationLessonModel(id: lessonObjectId, titleThai: titleThai, titleEnglish: titleEnglish,person1: person1!.name, person2: person2!.name, conversation: [])
        // Note: - Close View
        isNewLesson.toggle()
    }
    
    func addNewConversation(){
        // Note: - Stop Recording
        if voiceVM.isRecording {
            voiceVM.stopRecording()
            audioFile = voiceVM.featchRecordingByPrefix(fileName: kAudioPrefix + conversationObjectId) ?? ""
        }
        
        // Note: - Add Conversation to array
        let order = currentConversation.count + 1
        currentConversation.append(
            ConversationModel(id: UUID().uuidString,
                              order: order,
                              alignment: whoSpeak == 0 ? .left : .right,
                              name: whoSpeak == 0 ? (person1 != nil) ? person1!.name : "Erik" : (person2 != nil) ? person2!.name : "Emma" ,
                              textInThai: textInThai,
                              textInEnglish: textInEnglish,
                              audioFile: audioFile)
        )
        // Note: - generate the new conversationId
        generateConversationObjcectId()
        // Note: - reset form
        textInThai = ""
        textInEnglish = ""
        audioFile = ""
        // Note: - Dismiss keyboard
        withAnimation() {
          hideKeyboard()
        }
    }
 
    func saveToFirebase(lessonObjectId: String) {
        
        conversationVM.SaveRecord(lessonObjectId: lessonObjectId, lesson: currentLesson!) { _ in
            // Blur Screen
            print(">> Save to firebase")
            isSaved = true
            isReload = true
            
            conversationVM.saveConversation(lessonObjectId: lessonObjectId, conversation: currentConversation) { _ in
              }
        }
    
    }
    
}
 
