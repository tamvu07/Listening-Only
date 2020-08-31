//
//  dataMusic.swift
//  PlayFilemp3
//
//  Created by Vu Minh Tam on 8/26/20.
//  Copyright © 2020 Vu Minh Tam. All rights reserved.
//

import Foundation

struct  mp3 {
    var ID: Int
    var Name: String
    var audio: sentence
}

//struct phrase {
//    var phrase: [sentence]
//}
struct sentence {
    var sentence: String
    var timeAudio: String
}

//struct arraysentence {
//    var sentenceOfPhrase: [sentenceOfPhrase]
//}

struct sentenceOfPhrase {
    var name: String?
    var text: String?
    var phrase:[String]
    var secondAudio:[String]
}


struct databaseInital {
    var name: String
    var text: String
    var audio: String
}
