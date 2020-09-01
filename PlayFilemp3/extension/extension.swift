//
//  extension.swift
//  PlayFilemp3
//
//  Created by Vũ Thiên on 8/29/20.
//  Copyright © 2020 Vu Minh Tam. All rights reserved.
//

import UIKit

extension UIViewController {
    func popUp(vct: UIViewController,v: UIView,lb: UILabel, msg: String, withView: NSLayoutConstraint) {
        lb.text = msg
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 10
        v.fadeIn(duration: 0.5, delay: 0.0) { (value: Bool) in
            v.isHidden = false
        }
        v.fadeOut(duration: 2.0, delay: 2.0) { (value: Bool) in
            v.isHidden = true
        }
       
        let withString = msg.widthOfString(usingFont: UIFont.systemFont(ofSize: 16))
        if (withString >= ( vct.view.bounds.size.width - 20) ) {
            withView.constant = (vct.view.bounds.size.width - 20)
        }else {
            withView.constant = withString + 30
        }
    }
}

extension UIView {
    func fadeIn(duration: TimeInterval, delay: TimeInterval, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
        self.alpha = 0.0

        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.isHidden = false
            self.alpha = 1.0
        }, completion: completion)
    }

    func fadeOut(duration: TimeInterval, delay: TimeInterval, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
        self.alpha = 1.0

        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.isHidden = true
            self.alpha = 0.0
        }, completion: completion)
    }
}


extension String {

    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }

    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }

    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
}
