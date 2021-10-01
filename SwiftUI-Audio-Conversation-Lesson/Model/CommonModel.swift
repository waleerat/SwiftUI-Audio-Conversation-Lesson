//
//  CommonModel.swift
//  WhatIsThis-WGO
//
//  Created by Waleerat Gottlieb on 2021-09-18.
//

import Foundation

struct CommonModel: Identifiable, Hashable, Codable {
    var id: String
    var textInThai: String
    var textInEnglish: String
    var imageURL: String
    
     
    // Note: - CMS Data
    init(_id: String,
         _textInThai: String,
         _textInEnglish: String,
         _imageURL: String
         
    ) {
        id = _id
        textInThai = _textInThai
        textInEnglish = _textInEnglish
        imageURL = _imageURL
    }
    
}
