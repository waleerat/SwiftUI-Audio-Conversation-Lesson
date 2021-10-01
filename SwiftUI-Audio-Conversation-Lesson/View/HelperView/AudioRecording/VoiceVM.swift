//
//  VoiceVm.swift
//  Sawasdee By WGO
//
//  Created by Waleerat Gottlieb on 2021-08-25.
//

import Foundation
import AVFoundation

class VoiceVM : NSObject , ObservableObject , AVAudioPlayerDelegate {
    
    var audioRecorder : AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    
    // Note: - creating a variable to check if recording has started , we will need it while playing with UI
    @Published var isRecording : Bool = false
    // Note: - creating an Array to store our URL of recordings and some details , and the type of that array is Recording . Recording struct is also there. You can find that in Model folder in project repositry.
    
    // Note: - initialising and we will call a function here letter .
    override init(){
        super.init()
    }
    
    // Note: - Fatching a audiofile
    func featchRecordingByPrefix(fileName: String) -> String?{
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
        
        // Note: -  traveling in our directory of recordings and appending the recording in our array .
        for i in directoryContents {
            let urlString: String = i.absoluteString
            if urlString.contains(fileName) {
                return urlString
            }
        }
        return nil
    }
    
    // Note: - the start recording function and doing some formalities , but there are some lines to understand are as follow .
    func startRecording(fileName: String){
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Can not setup the Recording")
        }
        
        // Note: - The path will contain the directory of the recording.
        let fileName = URL(string: getFullAudioPath(fileName: "\(fileName)\(kAudioFileType)"))!
      
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            // Note: - When we started our recording successfully , then we are doing true that variable .
            isRecording = true
        } catch {
            print(">> Failed to Setup the Recording")
        }
    }
    
    // Note: - creating a function to stop the recording and converting that recording variable as false .
    func stopRecording(){
        audioRecorder.stop()
        isRecording = false
    }
    
    
    // Note: - Playing & Stoping the Audio. passing the url of recorded file , so that we can play that audio url only .
    func startPlaying(url : URL) {
        
        let playSession = AVAudioSession.sharedInstance()
            
        do {
            try playSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
        }
            
        do {
            audioPlayer = try AVAudioPlayer(contentsOf : url)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch {
            print(">>> Playing Failed \(url.absoluteString)")
        }
                
    }
    
    func startPlayingFromFirestoreURL(url : URL) {
       
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { [weak self](URL, response, error) -> Void in
            self?.startPlaying(url: URL!)
            })
                
            downloadTask.resume()
    }
    
    // Note: - Stop playing will stop all the playing audios , but the reason we are taking the url is to toggle the variable in our list of recordings .
    func stopPlaying(url : URL){
        
        if audioPlayer!.isPlaying {
            audioPlayer.stop()
        }
      
    }
    
    // Note: - To delete the recording from the system , we need their url .
    func deleteRecording(url : URL){ 
        do {
            // Note: - deleting that recording .
            try FileManager.default.removeItem(at : url)
        } catch {
            print("Can't delete")
        }
    }
    
    func deleteAllAudioFiles(){
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
        
        // Note: -  traveling in our directory of recordings and appending the recording in our array .
        for i in directoryContents {
            deleteRecording(url : i)
        }
        
    }
    
    func getFullAudioPath(fileName: String) -> String{
        return FileManagerVM.fileInDocumentsDirectory(filename: fileName)
    }
    
}


 
