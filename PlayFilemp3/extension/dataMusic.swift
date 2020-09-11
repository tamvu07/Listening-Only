//
//  dataMusic.swift
//  PlayFilemp3
//
//  Created by Vu Minh Tam on 8/26/20.
//  Copyright © 2020 Vu Minh Tam. All rights reserved.
//

import Foundation
import RealmSwift

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

struct OnePhrase {
    var transcript: String?
    var flag: Bool?
}

class DatabaseInital: Object {
    @objc dynamic var url: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var text: String = ""
    @objc dynamic var audio: String = ""
    
    
//    override static func primaryKey() -> String? {
//        return "name"
//    }
    
}


