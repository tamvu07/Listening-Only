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

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            self.performSegue(withIdentifier: "toVCScreenPlashFromVCListAll", sender: nil)
            
        }
        
    }
    


}
