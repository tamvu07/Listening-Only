//
//  TranslateViewController.swift
//  PlayFilemp3
//
//  Created by Vu Minh Tam on 8/28/20.
//  Copyright © 2020 Vu Minh Tam. All rights reserved.
//nhapm develop

import UIKit

protocol IDProtocol : class{
    func updateID(IDUpdate: Int)
}


class TranslateViewController: UIViewController {

    
    @IBOutlet weak var tableViewTranslate: UITableView!
    @IBOutlet weak var tableViewEdit: UITableView!
    
    @IBOutlet weak var textViewTranscriptAll: UITextView!
    @IBOutlet weak var textViewEdit: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var ID:Int = 0
    var sentenceOfPhrase: SentenceOfPhrase?
    var OneMp3DatabaseInital: DatabaseInital?
    var txtTextEdidtUpdate = ""
    var txtTimeEdidtUpdate = ""
    @IBOutlet weak var sldVolume: UISlider!
    @IBOutlet weak var viewToast: UIView!
    @IBOutlet weak var lbToast: UILabel!
    @IBOutlet weak var widthViewToast: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewTranslate.dataSource = self
        tableViewTranslate.delegate = self
        tableViewEdit.dataSource = self
        tableViewEdit.delegate = self
        scrollView.delegate = self
        tableViewTranslate.tableFooterView = UIView()
        tableViewEdit.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTextOrTime(_:)), name: NSNotification.Name(rawValue: "updateTextOrTime"), object: nil)
        
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
//        tableViewTranslate.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "updateTextOrTime"), object: nil)
    }
    
    @objc func updateTextOrTime(_ notification: NSNotification) {
        
        if let T = notification.userInfo?["Tag"] as? String {
            if Int(T) == 0 {
                txtTextEdidtUpdate = (notification.userInfo?["T"] as? String)!
            }
            if Int(T) == 1 {
                txtTimeEdidtUpdate = (notification.userInfo?["T"] as? String)!
            }
        }
    }
    
    func playAudio(ID: Int){
        sentenceOfPhrase = ListMusic().getdataOneMusic(ID: ID)
        textViewTranscriptAll.text = sentenceOfPhrase?.text
        tableViewEdit.reloadData()
        tableViewTranslate.reloadData()
    }
   
        
    @IBAction func sldVolumeChange(_ sender: Any) {
        let volume:[String: Float] = ["V": sldVolume.value]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateVolume"), object: nil, userInfo: volume)
       
    }
    
    @IBAction func btEditOnClick(_ sender: Any) {
       OneMp3DatabaseInital =  ListMusic().getOneMp3DatabaseInital(name: (sentenceOfPhrase?.name)!)
         txtTextEdidtUpdate = String(OneMp3DatabaseInital!.text)
         txtTimeEdidtUpdate = String(OneMp3DatabaseInital!.audio)
        tableViewEdit.reloadData()
       setView(view: textViewEdit, hidden: false)
       
    }
    
    func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 1, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        })
    }
    
    @IBAction func btCancelOnClick(_ sender: Any) {
        textViewEdit.isHidden = true
    }
    
    @IBAction func btSaveOnClick(_ sender: Any) {
        
        if txtTextEdidtUpdate.last != "*" || txtTimeEdidtUpdate.last != "*" {
              popUp(vct: self,v: viewToast, lb: lbToast, msg: "The End of Text must be character * ", withView: widthViewToast)
            return
        }
    
        
        let data = DatabaseInital()
        data.url = OneMp3DatabaseInital?.url as! String
        data.name = OneMp3DatabaseInital?.name as! String
        data.text = txtTextEdidtUpdate
        data.audio = txtTimeEdidtUpdate
        DatabaseManager.shareInstance.updateToDB(object: data)
        playAudio(ID: ID)
        tableViewEdit.reloadData()
        tableViewTranslate.reloadData()
        setView(view: textViewEdit, hidden: true)
    }
    
}

    


extension TranslateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRowsInSection = 0
        if tableView.tag == 1 {
            numberOfRowsInSection = sentenceOfPhrase?.phrase.count ?? 0
        }
        if tableView.tag == 2 {
            numberOfRowsInSection = 1
        }


        return numberOfRowsInSection
       
   
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        if tableView.tag == 1 {
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
        
        if tableView.tag == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellEdit", for: indexPath) as! cellEdit
            cell.contraintsHeightTextView.constant = tableView.frame.height / 2
            if indexPath.section == 0 {
                cell.textViewTranscriptTextOrTime.tag = 0
                cell.textViewTranscriptTextOrTime.text =   OneMp3DatabaseInital?.text
            }
            if indexPath.section == 1 {
                cell.textViewTranscriptTextOrTime.tag = 1
                cell.textViewTranscriptTextOrTime.text = OneMp3DatabaseInital?.audio
            }
            
            
            return cell
        }


        
        let cell = UITableViewCell()
        return cell
         
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tableViewEdit {
            return 2
        }else {
            return 1
        }

    }

}


extension TranslateViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tableViewEdit {
            return 20
        }
        return 0
    }
    

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tableViewEdit {
             let headerView = Bundle.main.loadNibNamed("HeaderViewText", owner: self, options: nil)?.first as! HeaderViewText
                   if section == 0 {
                        headerView.lbTitle.text = "Transcript"
                   }
                   if section == 1 {
                        headerView.lbTitle.text = "Time"
                   }
                  
                   return headerView
        }else {
            let View = UIView()
            return View
        }
        
        
       
       
    }

   

    
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
