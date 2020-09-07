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
        customDoneButtonOnKeyboardTxtPhoneMunber()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func customDoneButtonOnKeyboardTxtPhoneMunber()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.hideKeyBoardTxtPhoneMunber))
        doneBtn.tintColor = .black
        
        let items = [flexSpace, doneBtn]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.textViewTranscriptTextOrTime.inputAccessoryView = doneToolbar
    }
    
    @objc func hideKeyBoardTxtPhoneMunber() {
        self.textViewTranscriptTextOrTime.resignFirstResponder()
    }

}


extension cellEdit: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let volume:[String: String] = ["Tag": String(textView.tag), "T" : textView.text]
              NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateTextOrTime"), object: nil, userInfo: volume)
        
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        let volume:[String: Bool] = ["K": true]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "textViewshowKeyBoard"), object: nil, userInfo: volume)
        return true
    }
    
}
