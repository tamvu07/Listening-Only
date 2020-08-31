//
//  cellListAll.swift
//  PlayFilemp3
//
//  Created by Vu Minh Tam on 8/28/20.
//  Copyright © 2020 Vu Minh Tam. All rights reserved.
//

import UIKit

class cellListAll: UITableViewCell {
    
    
    @IBOutlet weak var imageOne: UIImageView!
    @IBOutlet weak var lbNumber: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbdetail: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
       imageOne.layer.borderWidth = 1
       imageOne.layer.masksToBounds = false
       imageOne.layer.borderColor = UIColor.black.cgColor
       imageOne.layer.cornerRadius = imageOne.frame.height/3
       imageOne.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
