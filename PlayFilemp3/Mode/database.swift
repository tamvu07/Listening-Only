//
//  database.swift
//  PlayFilemp3
//
//  Created by Vũ Thiên on 8/29/20.
//  Copyright © 2020 Vu Minh Tam. All rights reserved.
//

import Foundation
import  RealmSwift

class DatabaseManager {
    
//    var arrDB: [databaseInital] = [
//                                    databaseInital(name: "049 Track049", text: "who is in charge of purchasing office supplies?* Alice supplies the coffee.* That would be our office manager, Alice. * The supplies are in the main office.*", audio: "0.80-0.11* 0.14-0.1*0.19-0.22*0.24-0.27*"),
//                                    databaseInital(name: "050 Track050", text: "which catering company did we hire for the banquet? *The one we used last year. *Just a few waiters. *A large ballroom.*", audio: ""),
//                                    databaseInital(name: "051 Track051", text: "when did Johansson say the meeting was? *He didn’t say what time. *He did an excellent job. *The meeting was cut short.*", audio: ""),
//                                    databaseInital(name: "052 Track052", text: "How often is the office cleaned? *I’ll do it tonight.*No, she’s out today.*At least once a week.*", audio: ""),
//                                    databaseInital(name: "053 Track053", text: "where can I ask for directions? *At the information booth.*That’s why I brought a map.*I never noticed that sign.*", audio: ""),
//                                    databaseInital(name: "054 Track054", text: "Whose car is this?*This is bigger than we need.*Bobby’s, from accounting.*I bought the car.*", audio: ""),
//                                    databaseInital(name: "055 Track055", text: "why did Ms.Anderson not sign the contract?*She hasn’t finished yet.*I didn’t see the contract.*She never gave a reason.*", audio: ""),
//                                    databaseInital(name: "Test 01", text: "why did Ms.Anderson not sign the contract?*She hasn’t finished yet.*I didn’t see the contract.*She never gave a reason.*", audio: "")
//                                ]
    var arrDB: Results<DatabaseInital>!
    
    private var database: Realm

    static var shareInstance = DatabaseManager()
    
    private init() {
        database = try! Realm()
        
    }
    
    func getDataRealmIntial() -> Results<DatabaseInital>{
         let result: Results<DatabaseInital> = database.objects(DatabaseInital.self)
        return result
     }
    
    func getDataFromDB() -> Bool {
        let result: Results<DatabaseInital> = database.objects(DatabaseInital.self)
        if result.count == 0 {
            return false
        }else {
             arrDB = result
            return true
        }
       
    }
    
    func addData(url: String, name: String, text: String, audio: String) {
        let object = DatabaseInital()
        object.url = url
        object.name = name
        object.text = text
        object.audio = audio
        try! database.write{
            database.add(object)
        }
    }
    
    func updateToDB(object: DatabaseInital) -> Bool {
        let result = database.objects(DatabaseInital.self).filter("name = %@", object.name)
        do {
            try database.write{
                result.first?.name = object.name
                result.first?.audio = object.audio
                result.first?.text = object.text
                result.first?.url = object.url
            }
            return true
        }catch {
            return false
        }
    }
    
    func deleteOneFromDB(object: DatabaseInital) -> Bool {
        do {
            let dataToDelete = database.objects(DatabaseInital.self).filter("name = %@",object.name)
            try database.write{
                
                database.delete(dataToDelete)
            }
            return true
        }catch {
            return false
        }
    }
    
    func deleteAllFromDB() -> Bool {
        do {
            try database.write{
                database.deleteAll()
            }
            return true
        }catch {
            return false
        }
    }
    
}
