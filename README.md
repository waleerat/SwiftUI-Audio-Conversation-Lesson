# SwiftUI-Audio-Conversation-Lesson 

### Xcode Version 13.0
###### SwiftUI, Firebase, Firestore

Example for audio recording, chat layout, upload/delete in Firestore.

## Screenshots
<img src="https://github.com/waleerat/GitHub-Photos-Shared/blob/main/SwiftUI-Audio-Conversation-Lesson/Conversation-3.png" width="20%" height="20%"> |
<img src="https://github.com/waleerat/GitHub-Photos-Shared/blob/main/SwiftUI-Audio-Conversation-Lesson/Conversation-02.png" width="20%" height="20%"> |
<img src="https://github.com/waleerat/GitHub-Photos-Shared/blob/main/SwiftUI-Audio-Conversation-Lesson/conversation-1.png" width="20%" height="20%"> |


## How to setup project
1. Clone project to your Mac
2. Setup firebase  [See](https://firebase.google.com/docs/ios/setup)
3. Enable Firebase and Firestore [See](https://console.firebase.google.com/)
4. import your own GoogleService-Info.plist to the project
5. run pod install in Terminal

```sh
 run pod install
```
5.  Close project and open again
<img src="https://github.com/waleerat/GitHub-Photos-Shared/blob/main/SwiftUI-Audio-Conversation-Lesson/finder.png" width="20%" height="20%">

## Check these files

#### SwiftUI_Audio_Conversation_LessonApp.swift

`note`  I use `UITableView.appearance().backgroundColor = .clear` to clear list background
 

if you want to separate to difference Firebase for development and production so you can use this code otherwise you can just use `FirebaseApp.configure()`

```sh
    private func setupFirebaseApp() {
        
       guard let plistPath = Bundle.main.path(
        forResource: "GoogleService-Info", ofType: "plist"),
             let options =  FirebaseOptions(contentsOfFile: plistPath)
                      else { return }
        
          if FirebaseApp.app() == nil{
              FirebaseApp.configure(options: options)
          }
    }
```

Example for Config 2 difference Firebase.


```sh
     private func setupFirebaseApp() {
        #if DEBUG
            let kGoogleServiceInfoFileName = "DEVELOPMENT-GoogleService-Info"
        #else
            let kGoogleServiceInfoFileName = "GoogleService-Info"
        #endif
        
       guard let plistPath = Bundle.main.path(
        forResource: kGoogleServiceInfoFileName, ofType: "plist"),
             let options =  FirebaseOptions(contentsOfFile: plistPath)
                      else { return }
        
          if FirebaseApp.app() == nil{
              FirebaseApp.configure(options: options)
          }
    }
```

#### Constants.swift 

The constants values that I use in the project. 

`public let kFileRefference = "gs://sample-project.appspot.com"`  Enter you Firestorage folder path  
`public let kFileStoreRootDirectory = "Example-Project/"` Root folder 


#### FCollectionReference.swift
Collections for firebase

```sh
enum FCollectionReference: String {
    case Lesson = "pia_lesson"
    case Conversation = "pia_conversation"
} 

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    
    return Firestore.firestore().collection(collectionReference.rawValue)
} 
```

How to use :


```sh
FirebaseReference(.Conversation).document(objectId).delete() { error in }
```

#### FileManagerVM.swift
Manage local images

#### FileStorage.swift
Manage upload/download images from Firestore. 

#### If you can't run project

> Note: `The project at ‘/Users/lia/Documents/MVVM-and-Design-Pattern/MVVM-and-Design-Pattern.xcodeproj’ cannot be opened because it is in a future Xcode project file format. Adjust the project format using a compatible version of Xcode to allow it to be opened by this version of Xcode.` 
