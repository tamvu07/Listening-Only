//
//  ScreenPlashViewController.swift
//  PlayFilemp3
//
//  Created by Vu Minh Tam on 9/9/20.
//  Copyright © 2020 Vu Minh Tam. All rights reserved.
//

import UIKit

class ScreenPlashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: "createFileTXT") == false {
            createFileTXT()
        }


        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            self.performSegue(withIdentifier: "toVCScreenPlashFromVCListAll", sender: nil)
            
        }
        
    }
    

    func createFileTXT() {
        let file = "\(UUID().uuidString).txt"
        let contents = "Some text ..."
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = dir.appendingPathComponent(file)
        do {
            try contents.write(to: fileURL, atomically: false, encoding: .utf8)
            UserDefaults.standard.set(true, forKey: "createFileTXT")
        }
        catch {
          print("Error:\(error)")
        }
    }

}
