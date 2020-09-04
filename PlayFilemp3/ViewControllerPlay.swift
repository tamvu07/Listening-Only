//
//  ViewController.swift
//  PlayFilemp3
//
//  Created by Vu Minh Tam on 8/26/20.
//  Copyright © 2020 Vu Minh Tam. All rights reserved.
//

import UIKit
import AVFoundation
import ReSwift



class ViewControllerPlay: UIViewController, StoreSubscriber {
    
    typealias StoreSubscriberStateType = AppState
    var player:AVAudioPlayer!
    
    @IBOutlet weak var txtStart: UITextField!
    @IBOutlet weak var txtEnd: UITextField!
    @IBOutlet weak var lbStart: UILabel!
    @IBOutlet weak var lbEnd: UILabel!
    @IBOutlet weak var btPlayMain: UIButton!
    @IBOutlet weak var sldtime: UISlider!
    @IBOutlet weak var btPlay0: UIButton!
    @IBOutlet weak var viewTranslate: UIView!
    @IBOutlet weak var lbNameMusic: UILabel!
    @IBOutlet weak var constraintBottomViewBottom: NSLayoutConstraint!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var viewToast: UIView!
    @IBOutlet weak var lbToast: UILabel!
    @IBOutlet weak var widthViewToast: NSLayoutConstraint!
    @IBOutlet weak var ViewPersonListen: UIView!
    @IBOutlet weak var imagePersonListen: UIImageView!
    
    
    
    var flag0: Bool = false
    var flagMain: Bool = false
    var x:Int = 0
    var y:Int = 0
    var ID:Int?
    var urlMp3: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // quan trong nhat : mainStore
        mainStore.subscribe(self)
        
        initalSlider()
        initalTextField()
        pageControl.numberOfPages = 3
        lbNameMusic.text =  ListMusic().getNameMusic(ID: ID!)
        playAudio()
         callScreenViewTranslateDetail()
       NotificationCenter.default.addObserver(self, selector: #selector(self.updateVolume(_:)), name: NSNotification.Name(rawValue: "updateVolume"), object: nil)

         let recordingSession = AVAudioSession.sharedInstance()
         do {
             // Set the audio session category, mode, and options.
             try recordingSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
             try recordingSession.setActive(true)
         } catch {
             print("Failed to set audio session category.")
         }
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (time) in
            self.addPulse()
        }
        
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "updateVolume"), object: nil)
    }
    
    @objc func addPulse() {
        let pulse = Pulsing(numberOfPulses: 1, radius: 60, position: imagePersonListen.center)
        pulse.animationDuration = 0.8
         pulse.backgroundColor = #colorLiteral(red: 0.7956557274, green: 0.8827135563, blue: 0.957783401, alpha: 1)
        self.ViewPersonListen.layer.insertSublayer(pulse, below: imagePersonListen.layer)
    }
    
    @objc func updateVolume(_ notification: NSNotification) {

     if let V = notification.userInfo?["V"] as? Float {
        player.volume = V
     }
    }

    override func viewDidDisappear(_ animated: Bool) {
        player.stop()
    }

    
    func playAudio(){
        
        let sentenceOfPhrase = ListMusic().getdataOneMusic(ID: ID!)
        
//        let path:String = Bundle.main.path(forResource: sentenceOfPhrase.name, ofType: ".mp3")!
//                let url:URL = URL(fileURLWithPath: path)
        
//        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//
//        do {
//            // Get the directory contents urls (including subfolders urls)
//            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil)
//            print(directoryContents)
//
//            // if you want to filter the directory contents you can do like this:
//            let mp3Files = directoryContents.filter{ $0.pathExtension == "mp3" }
//            urlMp3 = mp3Files[2]
//            print("mp3 urls:",mp3Files)
//            let mp3FileNames = mp3Files.map{ $0.deletingPathExtension().lastPathComponent }
//            print("mp3 list:", mp3FileNames)
//
//        } catch {
//            print(error)
//        }
        
        

        
        
        urlMp3 =  URL(fileURLWithPath: sentenceOfPhrase.url!)
        
                do{
                    player = try AVAudioPlayer(contentsOf: urlMp3!)
                    player.delegate =  self
                    sldtime.maximumValue = Float(player.duration)
                    lbStart.text = String(Int(self.player.currentTime))
                    lbEnd.text =  String(Int(self.player.duration))

                    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (time) in
                        if self.player.currentTime  == self.player.duration {
                            self.flagMain = false
                            self.player.stop()
                        }
                        if self.flag0 == true {
                            
                            self.sldtime.value = Float(self.player.currentTime)
                            let a = Int(self.player.currentTime )
                            let b = Int(self.y)
                            if  a == b {
                                self.player.stop()
                                self.flag0 = false
                                self.btPlay0.isSelected = false
                            }
                        }
                        self.sldtime.value = Float(self.player.currentTime)
                        self.lbStart.text = String(Int(self.player.currentTime))
                    }
                    player.volume = 0.5
                }catch {
                    print("error player !!!")
                }
    }
    
    
    func newState(state: AppState) {
        pageControl.currentPage = mainStore.state.counterPageControl
    }

    func initalSlider() {
        sldtime.maximumTrackTintColor = .gray
        sldtime.minimumTrackTintColor = .orange
        sldtime.setThumbImage(UIImage(named: ""), for: .normal)
        
        viewTranslate.layer.masksToBounds = true
        viewTranslate.layer.borderWidth = 1
        viewTranslate.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        viewTranslate.layer.cornerRadius = 2
        viewTranslate.layer.masksToBounds = true
    }
    
    func initalTextField() {
        txtStart.keyboardType = .numberPad
        txtEnd.keyboardType = .numberPad
        customDoneButtonOnKeyboardTxtPhoneMunber()
        NotificationCenter.default.addObserver( self,
        selector: #selector(handKeyboardNotificationShow(notification:)),
        name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver( self,
        selector: #selector(handKeyboardNotificationHide(notification:)),
        name: UIResponder.keyboardWillHideNotification, object: nil)
        
        txtStart.layer.borderWidth = 1
        txtStart.layer.cornerRadius = 5
        txtStart.layer.masksToBounds = false
        txtStart.layer.borderColor = UIColor.lightGray.cgColor
        txtStart.clipsToBounds = true
        
        txtEnd.layer.borderWidth = 1
        txtEnd.layer.cornerRadius = 5
        txtEnd.layer.masksToBounds = false
        txtEnd.layer.borderColor = UIColor.lightGray.cgColor
        txtEnd.clipsToBounds = true
        
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
        
        self.txtStart.inputAccessoryView = doneToolbar
        self.txtEnd.inputAccessoryView = doneToolbar

    }
    
    @objc func hideKeyBoardTxtPhoneMunber() {
        self.txtStart.resignFirstResponder()
        self.txtEnd.resignFirstResponder()
    }
    
    @objc func handKeyboardNotificationShow(notification: Notification){
        if let userInfo = notification.userInfo as? Dictionary<String,AnyObject>{
            let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
            let keyBoarRect = frame?.cgRectValue
            if let keyBoardHeight = keyBoarRect?.height {
                self.constraintBottomViewBottom.constant = -keyBoardHeight
                viewTranslate.isHidden = true
                ViewPersonListen.isHidden = false
            }
        }
    }
    
    @objc func handKeyboardNotificationHide(notification: Notification){
        self.constraintBottomViewBottom.constant = 0
        viewTranslate.isHidden = false
        ViewPersonListen.isHidden = true
    }
    
    @IBAction func btOnClickPlayMain(_ sender: Any) {

        
        if self.flag0 == true {
            return
        }
        
        if btPlayMain.isSelected {
            btPlayMain.isSelected = false
            player.pause()
            flagMain = false
        }else {
            btPlayMain.isSelected = true
            
            player.play()
            flagMain = true
        }
    }
    
        @IBAction func btOnClickPlay0(_ sender: Any) {
            
            if self.flagMain == true {
                return
            }

            if txtStart.text == "" {
                 popUp(vct: self,v: viewToast, lb: lbToast, msg: "Fill out time start", withView: widthViewToast)
                return
            }
            
            if txtEnd.text == "" {
                 popUp(vct: self,v: viewToast, lb: lbToast, msg: "Fill out time end", withView: widthViewToast)
                return
            }
            
            guard let x1 = Int(txtStart.text!) else {
                 popUp(vct: self,v: viewToast, lb: lbToast, msg: "Number must type Integer", withView: widthViewToast)
                return
            }
            
            guard let y1 = Int(txtEnd.text!) else {
                popUp(vct: self,v: viewToast, lb: lbToast, msg: "Number must type Integer", withView: widthViewToast)
                return
            }

            if (x1 > Int(self.player.duration))  {
                popUp(vct: self,v: viewToast, lb: lbToast, msg: "Time Start not exists", withView: widthViewToast)
                return
            }
            
            if (y1 > Int(self.player.duration))  {
                popUp(vct: self,v: viewToast, lb: lbToast, msg: "Time END not exists", withView: widthViewToast)
                return
            }
        
            if (y1 < x1)  {
                popUp(vct: self,v: viewToast, lb: lbToast, msg: "Time END must > Time Start", withView: widthViewToast)
                return
            }
            
            if btPlay0.isSelected {
                btPlay0.isSelected = false
                player.pause()
                flag0 = false
            }else {
                btPlay0.isSelected = true
                player.play()
                flag0 = true
                x = x1
                y = y1
                self.player.currentTime = TimeInterval(self.x)
            }
    }
    
    @IBAction func sldTimeOnClick(_ sender: Any) {
        
        if flagMain == true {
            player.currentTime = TimeInterval(Float(sldtime.value))
             player.play()
        }
    }
    
    @IBAction func btBackOnClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func callScreenViewTranslateDetail() {
        let data = ID
//        self.performSegue(withIdentifier: "toVCListAllFromVCPlayDetail", sender: data)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toVCListAllFromVCPlayDetail" {
//            if let nextVC  = segue.destination as? TranslateViewController {
//                nextVC.ID = sender as! Int
//            }
//        }
//    }
}

extension ViewControllerPlay: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        print("da end")
        player.play()
    }
    

    
}



    
    

