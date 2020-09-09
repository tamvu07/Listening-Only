//
//  IntructionViewController.swift
//  PlayFilemp3
//
//  Created by Vu Minh Tam on 9/9/20.
//  Copyright © 2020 Vu Minh Tam. All rights reserved.
//

import UIKit

class InstructionViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        pageControl.numberOfPages = 5
    }
//    override func viewDidLayoutSubviews() {
//        pageControl.subviews.forEach {
//            $0.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
//        }
//    }
    
    @IBAction func btBackOnClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    

}

extension InstructionViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
          let page = scrollView.contentOffset.x/scrollView.frame.width
            pageControl.currentPage = Int(page)
      }
}
