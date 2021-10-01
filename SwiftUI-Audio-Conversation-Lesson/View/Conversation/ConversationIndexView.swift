//
//  ConversationIndexView.swift
//  SwiftUI-Audio-Conversation-Lesson
//
//  Created by Waleerat Gottlieb on 2021-09-29.
//

import SwiftUI

struct ConversationIndexView: View {
     
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var voiceVM = VoiceVM()
    @ObservedObject var conversationVM = ConversationVM()
    
   // @State var isShowFormView: Bool = false
    @State var isReload: Bool = false
    @State var selectionLink:String?
    
    var body: some View {
        VStack(spacing: 20){
            HStack {
                Text("Conversations")
                    .modifier(TextBoldModifier(fontStyle: .header))
                Spacer()
                NavigationLink {
                    ConversationForm(isReload: $isReload).environmentObject(conversationVM)
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.accentColor)
                        .padding()
                        .background(Color.accentColor.opacity(0.3))
                        .clipShape(Circle())
                }
            }//: HSTACK
            
            // Note: - Conversation Rows
            List{
                // Note: - Row preview
                ForEach(conversationVM.contentRows) { row in
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(row.titleThai).modifier(TextRegularModifier(fontStyle: .description))
                            Text(row.titleEnglish).modifier(TextRegularModifier(fontStyle: .common))
                        }
                        Spacer()
                    }
                   .onTapGesture(perform: {
                       // Note: - Open Sheet to update
                       selectionLink = "ConversationForm"
                       conversationVM.selectedRow = row
                    })
                   .padding()
                   .frame(width: screenSize.width * 0.90)
                   .background(Color(kForegroundColor).opacity(0.1))
                   .cornerRadius(7)
                  
                }
                .onDelete(perform: delete)
                .listRowBackground(Color(kBackgroundColor))
                //: END LOOP CONTENT ROWS
            }
            .listStyle(PlainListStyle()) 
            
            Spacer()
            
            NavigationLink(destination: ConversationForm(isReload: $isReload).environmentObject(conversationVM), tag: "ConversationForm", selection: $selectionLink) { EmptyView() }
            
        }//: VSTACK
        .onChange(of: isReload, perform: { _ in
            if isReload {
                //DispatchQueue.main.async {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    conversationVM.loadAll()
                }
                isReload.toggle()
            }
        })
        .onAppear() {
            // Note: - delete all temp audio file
            voiceVM.deleteAllAudioFiles()
            // Note: - Clear slected row
            conversationVM.selectedRow = nil
        }
        .padding(.horizontal, 10)
    }
    
    // MARK: - HELPER FUNCTIONS
    func delete(at offsets: IndexSet) {
       conversationVM.removeLesson(selectedRow: conversationVM.contentRows[offsets.first!]) { (isSuccess) in
           // Note: - remove object form content row
           conversationVM.contentRows.remove(atOffsets: offsets) 
       }
    }
}

struct ConversationIndexView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationIndexView()
    }
}
