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

    
    @IBOutlet weak var tableViewTranslate: UITableView!
    @IBOutlet weak var tableViewEdit: UITableView!
    
    @IBOutlet weak var textViewTranscriptAll: UITextView!
    @IBOutlet weak var textViewEdit: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var ID:Int = 0
    var sentenceOfPhrase: SentenceOfPhrase?
    var arrOnePhrase: [OnePhrase] = []
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateButtomTranscript(_:)), name: NSNotification.Name(rawValue: "updateButtomTranscript"), object: nil)
        intialTextViewEdit()
               NotificationCenter.default.addObserver(self, selector: #selector(self.nextOrBackMP3(_:)), name: NSNotification.Name(rawValue: "nextOrBackMP3"), object: nil)
        
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
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "updateButtomTranscript"), object: nil)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "nextOrBackMP3"), object: nil)
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
    
    @objc func updateButtomTranscript(_ notification: NSNotification) {
       
        if let T = notification.userInfo?["Tag"] as? Int {
            arrOnePhrase = ListMusic().updateValueOnePhrase(arr: arrOnePhrase, row: T)
             tableViewTranslate.reloadData()
        }
    }
    @objc func nextOrBackMP3(_ notification: NSNotification) {
        if let id = notification.userInfo?["id"] as? Int {
            playAudio(ID: id)
        }
    }

    
    func playAudio(ID: Int){
        sentenceOfPhrase = ListMusic().getdataOneMusic(ID: ID)
        arrOnePhrase = ListMusic().setValueOnePhrase(arr: sentenceOfPhrase!.phrase)
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
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "viewTopHide"), object: nil)
       setView(view: textViewEdit, hidden: false)
        scrollView.isScrollEnabled = false
    }
    
    func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 1, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        })
    }
    
    @IBAction func btCancelOnClick(_ sender: Any) {
        textViewEdit.isHidden = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "viewTopShow"), object: nil)
        scrollView.isScrollEnabled = true
        tableViewEdit.reloadData()
    }
    
    @IBAction func btSaveOnClick(_ sender: Any) {
        if txtTextEdidtUpdate == "" {
            txtTextEdidtUpdate = ""
        }else {
            if txtTextEdidtUpdate.last != "*" {
                popUp(vct: self,v: viewToast, lb: lbToast, msg: "The End of text transcript must be character * ", withView: widthViewToast)
                return
            }
        }
        if txtTimeEdidtUpdate == "" {
            txtTimeEdidtUpdate = ""

        }else {
            if txtTimeEdidtUpdate.last != "*" {
                popUp(vct: self,v: viewToast, lb: lbToast, msg: "The End of text time must be character * ", withView: widthViewToast)
                return
            }
        }
        
        let data = DatabaseInital()
        data.url = OneMp3DatabaseInital?.url as! String
        data.name = OneMp3DatabaseInital?.name as! String
        data.text = txtTextEdidtUpdate
        data.audio = txtTimeEdidtUpdate
        DatabaseManager.shareInstance.updateToDB(object: data)
        var arr1 = arrOnePhrase
        playAudio(ID: ID)
        var arr2 = arrOnePhrase
       arrOnePhrase = ListMusic().updateStatusOnePhrase(arr1: arr1, arr2: arr2)
        tableViewEdit.reloadData()
        tableViewTranslate.reloadData()
        setView(view: textViewEdit, hidden: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "viewTopShow"), object: nil)
        scrollView.isScrollEnabled = true
    }
    
    func intialTextViewEdit() {
        textViewEdit.layer.masksToBounds = true
         textViewEdit.layer.borderWidth = 1
         textViewEdit.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
         textViewEdit.layer.cornerRadius = 5
         textViewEdit.layer.masksToBounds = true
        
    }
}

    


extension TranslateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRowsInSection = 0
        if tableView.tag == 1 {
            let x = sentenceOfPhrase?.phrase.count ?? 0
            let y = sentenceOfPhrase?.secondAudio.count ?? 0
            if x > y {
                numberOfRowsInSection = x
            }else if x < y {
                numberOfRowsInSection = x
            }else if x == y{
                numberOfRowsInSection = x
            }else {
                numberOfRowsInSection = 0
            }
        }
        if tableView.tag == 2 {
            numberOfRowsInSection = 1
        }
        return numberOfRowsInSection
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1 {
            let x = sentenceOfPhrase?.phrase.count ?? 0
            let y = sentenceOfPhrase?.secondAudio.count ?? 0
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellTranslate", for: indexPath) as! cellTranslate
            cell.lbNumber.text = String(indexPath.row + 1)
            
            if x > y || x == y{
//                cell.lbtextTranslate.text = sentenceOfPhrase?.phrase[indexPath.row]
                cell.lbtextTranslate.text = arrOnePhrase[indexPath.row].transcript
                if y != 0 {
                    if indexPath.row + 1 > y {
                        cell.lbTime.text = ""
                    }else {
                        cell.lbTime.text = sentenceOfPhrase?.secondAudio[indexPath.row]
                    }
                }else {
                    cell.lbTime.text = ""
                }
            }else if y > x {
                 cell.lbTime.text = sentenceOfPhrase?.secondAudio[indexPath.row]
                if x != 0 {
                    if indexPath.row + 1 > x {
                        cell.lbtextTranslate.text = ""
                    }else {
//                        cell.lbtextTranslate.text = sentenceOfPhrase?.phrase[indexPath.row]
                        cell.lbtextTranslate.text = arrOnePhrase[indexPath.row].transcript
                    }
                    
                }else {
                    cell.lbtextTranslate.text = ""
                }
            }
            cell.lbtextTranslate.layer.masksToBounds = true
            cell.viewLbTranslate.layer.backgroundColor = UIColor.white.cgColor
            cell.viewLbTranslate.layer.borderWidth = 1
            cell.viewLbTranslate.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            cell.viewLbTranslate.layer.cornerRadius = 4
            cell.viewLbTranslate.layer.masksToBounds = true
            cell.btOpen.tag = indexPath.row
            if arrOnePhrase[indexPath.row].flag! {
                cell.viewHideViewTranslate.isHidden = true
                cell.imageEye.image = UIImage(named: "eyeOpen")
            }else {
                cell.imageEye.image = UIImage(named: "eyeClose")
                cell.viewHideViewTranslate.isHidden = false
            }
            
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
