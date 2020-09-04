//
//  dataMusic.swift
//  PlayFilemp3
//
//  Created by Vu Minh Tam on 8/26/20.
//  Copyright © 2020 Vu Minh Tam. All rights reserved.
//

import Foundation

struct  Mp3 {
    var ID: Int
    var url: String
    var Name: String
    var audio: Sentence
}

//struct phrase {
//    var phrase: [sentence]
//}
struct Sentence {
    var sentence: String
    var timeAudio: String
}

//struct arraysentence {
//    var sentenceOfPhrase: [sentenceOfPhrase]
//}

struct SentenceOfPhrase {
    var url: String?
    var name: String?
    var text: String?
    var phrase:[String]
    var secondAudio:[String]
}


struct DatabaseInital {
    var url: String
    var name: String
    var text: String
    var audio: String
    
    init(url : String , name : String , text : String , audio : String) {
        self.url = url
        self.name = name
        self.text = text
        self.audio = audio
    }
    
}


