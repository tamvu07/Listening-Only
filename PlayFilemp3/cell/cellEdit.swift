//
//  cellEdit.swift
//  PlayFilemp3
//
//  Created by Vũ Thiên on 9/5/20.
//  Copyright © 2020 Vu Minh Tam. All rights reserved.
//

import UIKit

class cellEdit: UITableViewCell {

    @IBOutlet weak var contraintsHeightTextView: NSLayoutConstraint!
    @IBOutlet weak var textViewTranscriptTextOrTime: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textViewTranscriptTextOrTime.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


extension cellEdit: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
//        let tag = textView.tag
//        textViewTranscriptTextOrTime.text = textView.text
        let volume:[String: String] = ["Tag": String(textView.tag), "T" : textView.text]
              NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateTextOrTime"), object: nil, userInfo: volume)
        
    }
}
