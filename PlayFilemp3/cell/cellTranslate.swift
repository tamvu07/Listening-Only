//
//  cellTranslate.swift
//  PlayFilemp3
//
//  Created by Vu Minh Tam on 8/28/20.
//  Copyright © 2020 Vu Minh Tam. All rights reserved.
//

import UIKit


class cellTranslate: UITableViewCell {
    
    @IBOutlet weak var lbNumber: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var btOpen: UIButton!
    @IBOutlet weak var lbtextTranslate: UILabel!
    
    @IBOutlet weak var viewLbTranslate: UIView!
    @IBOutlet weak var viewHideViewTranslate: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btOpenOnClick(_ sender: Any) {


        
        if btOpen.isSelected {
            btOpen.isSelected = false
            viewHideViewTranslate.isHidden = false
        }else {
            btOpen.isSelected = true
            viewHideViewTranslate.isHidden = true
        }
    }
    
    
    
}
