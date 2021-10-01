//
//  RecordingModel.swift
//  Sawasdee By WGO
//
//  Created by Waleerat Gottlieb on 2021-08-25.
//

import Foundation

 

struct RecordingModel: Identifiable, Hashable {
    var id : String
    var fileURL : URL
    var createdAt:String
    var isPlaying: Bool
     
}

