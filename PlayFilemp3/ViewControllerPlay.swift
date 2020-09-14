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

import MediaPlayer


@available(iOS 10.0, *)
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
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var lbNameMusic: UILabel!
    @IBOutlet weak var constraintBottomViewBottom: NSLayoutConstraint!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var viewToast: UIView!
    @IBOutlet weak var lbToast: UILabel!
    @IBOutlet weak var widthViewToast: NSLayoutConstraint!
    @IBOutlet weak var ViewPersonListen: UIView!
    @IBOutlet weak var imagePersonListen: UIImageView!
    @IBOutlet weak var constraintBottomViewTranslate: NSLayoutConstraint!
    @IBOutlet weak var constraintTopViewTranslate: NSLayoutConstraint!
    @IBOutlet weak var viewHome: UIView!
    @IBOutlet weak var viewHomeAdd: UIView!
    
    @IBOutlet weak var tableViewHome: UITableView!
    @IBOutlet weak var constraintHeightViewHome: NSLayoutConstraint!
    
    
    var flag0: Bool = false
    var flagMain: Bool = false
    var x:Int = 0
    var y:Int = 0
    var ID:Int?
    var urlMp3: URL?
    var checkTextFieldOrTextView = true

    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // quan trong nhat : mainStore
        mainStore.subscribe(self)
        tableViewHome.delegate = self
        tableViewHome.dataSource = self
        tableViewHome.tableFooterView = UIView()
        
        initalSlider()
        initalViewHome()
        initalTextField()
        pageControl.numberOfPages = 3
        
        playAudio(id: ID!)
        txtStart.delegate = self
        txtEnd.delegate = self
       NotificationCenter.default.addObserver(self, selector: #selector(self.updateVolume(_:)), name: NSNotification.Name(rawValue: "updateVolume"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateVolume(_:)), name: NSNotification.Name(rawValue: "textViewshowKeyBoard"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(viewTopHide), name: NSNotification.Name(rawValue: "viewTopHide"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(viewTopShow), name: NSNotification.Name(rawValue: "viewTopShow"), object: nil)
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (time) in
            self.addPulse()
        }
        setBackgroundPlayAudio()
        
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "updateVolume"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "textViewshowKeyBoard"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "viewTopHide"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "viewTopShow"), object: nil)
    }

    @objc func addPulse() {
        let pulse = Pulsing(numberOfPulses: 1, radius: 60, position: imagePersonListen.center)
        pulse.animationDuration = 0.8
         pulse.backgroundColor = #colorLiteral(red: 0.7956557274, green: 0.8827135563, blue: 0.957783401, alpha: 1)
        self.ViewPersonListen.layer.insertSublayer(pulse, below: imagePersonListen.layer)
    }
    
    func setBackgroundPlayAudio() {
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try recordingSession.setActive(true)
          
        } catch {
            print("Failed to set audio session category.")
        }
        
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.bookmarkCommand.isActive = true
        commandCenter.playCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
          self.audioPlayClicked()
            self.btPlayMain.isSelected = true
          return .success
        }
        commandCenter.pauseCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
          self.audioPauseClicked()
            self.btPlayMain.isSelected = false
          return .success
        }
        commandCenter.stopCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
          self.audioStopClicked()
            self.btPlayMain.isSelected = false
          return .success
        }
        
        commandCenter.nextTrackCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
          self.playMp3Next()
          return .success
        }
        
        commandCenter.previousTrackCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
          self.playMp3Previous()
          return .success
        }
    }
    
    func setupNowPlaying(player: AVAudioPlayer, title: String, timeCurrent: Float, duration: Float) {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = title

        if let image = UIImage(named: "LOGO") {
            nowPlayingInfo[MPMediaItemPropertyArtwork] =
                MPMediaItemArtwork(boundsSize: image.size) { size in
                    return image
            }
        }
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = timeCurrent
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = duration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player.rate

        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    func audioPlayClicked() {
        player.play()
    }
    
    func audioPauseClicked() {
        player.pause()
    }
    
    func audioStopClicked() {
        player.stop()
    }

    
    @objc func updateVolume(_ notification: NSNotification) {
        
        if let V = notification.userInfo?["V"] as? Float {
            player.volume = V
        }
    }
    
    @objc func textViewshowKeyBoard(_ notification: NSNotification) {
        
        if let K = notification.userInfo?["K"] as? Bool {
            checkTextFieldOrTextView = K
        }
    }
    
    @objc func viewTopHide() {
        viewTop.isHidden = true
        constraintTopViewTranslate.constant = -viewTop.frame.size.height
        viewTranslate.layer.masksToBounds = false
        viewTranslate.layer.borderWidth = 0
        viewTranslate.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        viewTranslate.layer.cornerRadius = 0
        viewTranslate.layer.masksToBounds = false
        pageControl.isHidden = true
    }
    
    @objc func viewTopShow() {
        viewTop.isHidden = false
        constraintTopViewTranslate.constant = 10
        viewTranslate.layer.masksToBounds = true
        viewTranslate.layer.borderWidth = 1
        viewTranslate.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        viewTranslate.layer.cornerRadius = 10
        viewTranslate.layer.masksToBounds = true
        pageControl.isHidden = false
    }

    override func viewDidDisappear(_ animated: Bool) {
        player.stop()
    }

    override func viewDidAppear(_ animated: Bool) {
        btPlayMain.isSelected = true
        player.play()
        flagMain = true
    }
    
    func playAudio(id: Int){
        ID = id
        lbNameMusic.text =  ListMusic().getNameMusic(ID: id)
        let sentenceOfPhrase = ListMusic().getdataOneMusic(ID: id)
        
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
                        
                        // set time for background
                        self.setupNowPlaying(player: self.player, title: ListMusic().getNameMusic(ID: id), timeCurrent: Float(self.player.currentTime), duration: Float(self.player.duration))
                        
                    }
                    player.volume = 0.5
                    
                    // set background play aoudio
                    var audioSession = AVAudioSession.sharedInstance()
                    do {
                        try audioSession.setCategory(AVAudioSession.Category.playback)
                    }
                }catch {
                    print("error player !!!")
                }
    }
    
    
    func newState(state: AppState) {
        pageControl.currentPage = mainStore.state.counterPageControl
    }

    func initalViewHome() {
        viewHome.layer.masksToBounds = true
        viewHome.layer.borderWidth = 1
        viewHome.layer.borderColor = UIColor.orange.cgColor
        viewHome.layer.cornerRadius = 5
        viewHome.layer.masksToBounds = true
        setLeftTriangle()
        
    }
    
    func setLeftTriangle(){
           let heightWidth = viewHomeAdd.frame.size.width
           let path = CGMutablePath()
           path.move(to: CGPoint(x: 0, y: 0))
           path.addLine(to: CGPoint(x:heightWidth/2, y: 0))
        path.addLine(to: CGPoint(x:heightWidth, y:viewHomeAdd.frame.size.height))

           let shape = CAShapeLayer()
           shape.path = path
           shape.fillColor = UIColor.orange.cgColor

           viewHomeAdd.layer.insertSublayer(shape, at: 0)
       }
    
    func initalSlider() {
        sldtime.maximumTrackTintColor = .gray
        sldtime.minimumTrackTintColor = .orange
        sldtime.setThumbImage(UIImage(named: ""), for: .normal)
        
        viewTranslate.layer.masksToBounds = true
        viewTranslate.layer.borderWidth = 1
        viewTranslate.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        viewTranslate.layer.cornerRadius = 10
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
                if checkTextFieldOrTextView == false {
                    self.constraintBottomViewBottom.constant = -keyBoardHeight
                    viewTranslate.isHidden = true
                    ViewPersonListen.isHidden = false
                }else {
                    constraintBottomViewTranslate.constant = -keyBoardHeight + viewBottom.frame.size.height
                    viewTranslate.isHidden = false
                    ViewPersonListen.isHidden = true
                    
                }

            }
        }
    }
    
    @objc func handKeyboardNotificationHide(notification: Notification){
        if checkTextFieldOrTextView == false {
            checkTextFieldOrTextView = true
            self.constraintBottomViewBottom.constant = 0
            viewTranslate.isHidden = false
            ViewPersonListen.isHidden = true
        }else {
            
            constraintBottomViewTranslate.constant = 0
        }

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
            
//            if self.flagMain == true {
//                return
//            }

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
                btPlayMain.isSelected = false
                player.pause()
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
    
    @IBAction func btHomeOnClick(_ sender: Any) {
        if viewHome.isHidden == false {
            viewHome.isHidden = true
            viewHomeAdd.isHidden = true
        }else {
            viewHome.isHidden = false
            viewHomeAdd.isHidden = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.viewHome.isHidden = true
            self.viewHomeAdd.isHidden = true
        }
        
    }
    
    @IBAction func btPreviousOnClick(_ sender: Any) {
        playMp3Previous()
    }
    
    @IBAction func btNextOnClick(_ sender: Any) {
        playMp3Next()
    }
    
    func playMp3Previous() {
        if ID! > 1 {
            player.stop()
            btPlay0.isSelected = false
            flag0 = false
            self.btPlayMain.isSelected = false
            txtStart.text = ""
            txtEnd.text = ""
            playAudio(id: ID! - 1)
            updateContentNextOrBackMP3(id: ID!)
            player.play()
            self.btPlayMain.isSelected = true
        }
    }
    
    func playMp3Next() {
        let countArray =  ListMusic().getAllData().count
        if ID! < countArray {
            player.stop()
            btPlay0.isSelected = false
            flag0 = false
            self.btPlayMain.isSelected = false
            txtStart.text = ""
            txtEnd.text = ""
            playAudio(id: ID! + 1)
            updateContentNextOrBackMP3(id: ID!)
            player.play()
            self.btPlayMain.isSelected = true
        }


    }
    
    func updateContentNextOrBackMP3(id: Int) {
        let id:[String: Int] = ["id": ID!]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "nextOrBackMP3"), object: nil, userInfo: id)
    }
    
    
}


extension ViewControllerPlay: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        print("da end")
        player.play()
    }
    

    
}

extension ViewControllerPlay: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtStart {
          checkTextFieldOrTextView = false
        }
        if textField == txtEnd {
             checkTextFieldOrTextView = false
        }
        return true
    }
}

extension ViewControllerPlay: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        constraintHeightViewHome.constant = 1 * 40
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "cellHome", for: indexPath) as! cellHome
        cell.lbName.text = "Instruction"
        return cell
    }
    
    
}

extension ViewControllerPlay: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewHome.isHidden = true
        viewHomeAdd.isHidden  = true
        self.performSegue(withIdentifier: "toVCListAllFromVCInstruction", sender: self)

    }
}



