//
//  TranslateViewController.swift
//  PlayFilemp3
//
//  Created by Vu Minh Tam on 8/28/20.
//  Copyright © 2020 Vu Minh Tam. All rights reserved.
//

import UIKit

protocol IDProtocol : class{
    func updateID(IDUpdate: Int)
}

class TranslateViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    var ID:Int = 0
    var sentenceOfPhrase: SentenceOfPhrase?
   
    @IBOutlet weak var sldVolume: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        scrollView.delegate = self
        tableView.tableFooterView = UIView()
        
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is ListAllViewController {
                    (viewController as! ListAllViewController).IDUpdateDelegate = self
                    break
                }
            }
        }
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        playAudio(ID: ID)
        tableView.reloadData()
    }
    
    func playAudio(ID: Int){
        sentenceOfPhrase = ListMusic().getdataOneMusic(ID: ID)
        textView.text = sentenceOfPhrase?.text
        
    }
   
        
    @IBAction func sldVolumeChange(_ sender: Any) {
        let volume:[String: Float] = ["V": sldVolume.value]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateVolume"), object: nil, userInfo: volume)
       
    }
    
    
}

    

extension TranslateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sentenceOfPhrase?.phrase.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTranslate", for: indexPath) as! cellTranslate
        cell.lbNumber.text = String(indexPath.row + 1)
        cell.lbtextTranslate.text = sentenceOfPhrase?.phrase[indexPath.row]
        if sentenceOfPhrase?.secondAudio.count != 0 {
            cell.lbTime.text = sentenceOfPhrase?.secondAudio[indexPath.row]
        }else {
            cell.lbTime.text = ""
        }
        

        cell.lbtextTranslate.layer.masksToBounds = true
        cell.viewLbTranslate.layer.backgroundColor = UIColor.white.cgColor
        cell.viewLbTranslate.layer.borderWidth = 1
        cell.viewLbTranslate.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        cell.viewLbTranslate.layer.cornerRadius = 4
        cell.viewLbTranslate.layer.masksToBounds = true

        return cell
    }


}

extension TranslateViewController: UITableViewDelegate{

}

extension TranslateViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x/scrollView.frame.width
        mainStore.dispatch(
            CounterActionPageControl(counterPageControl: Int(page))
        );
    }
}

extension TranslateViewController: IDProtocol {
    func updateID(IDUpdate: Int) {
        ID = IDUpdate
    }
    
   
    
    
}
