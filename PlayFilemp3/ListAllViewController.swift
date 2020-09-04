//
//  ListAllViewController.swift
//  PlayFilemp3
//
//  Created by Vu Minh Tam on 8/28/20.
//  Copyright © 2020 Vu Minh Tam. All rights reserved.
//
// UIFileSharingEnabled
//  LSSupportsOpeningDocumentsInPlace


import UIKit

class ListAllViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewBottom: UIView!
    
    @IBOutlet weak var AvatarImage: UIImageView!
    @IBOutlet weak var ViewEmpty: UIView!
    
    
    var arrayAllData: [Mp3] = []
     weak var IDUpdateDelegate: IDProtocol? = nil
    var IDNext:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getListMP3()

        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        
        AvatarImage.isUserInteractionEnabled = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ListAllViewController.addPulse))
        tapGestureRecognizer.numberOfTouchesRequired  = 1
        AvatarImage.addGestureRecognizer(tapGestureRecognizer)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (time) in
            self.addPulse()
        }
        
    }
    
    func getListMP3() {


        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil)
            let mp3Files = directoryContents.filter{ $0.pathExtension == "mp3" }
            print("mp3 urls:",mp3Files)
            let mp3FileNames = mp3Files.map{ $0.deletingPathExtension().lastPathComponent }
            print("mp3 list:", mp3FileNames)
            if mp3Files.count == 0 {
                ViewEmpty.isHidden = false
                return
            }else {
                ViewEmpty.isHidden = true
            }
            
            
            if DatabaseManager.shareInstance.getDataFromDB() == false {
                for i in 0..<mp3FileNames.count {
                    let urlString = "\(mp3Files[i])"
                    let pathURL = URL(string: urlString)!
                    DatabaseManager.shareInstance.addData(url: pathURL.path, name: mp3FileNames[i], text: "", audio: "")
                }
                if DatabaseManager.shareInstance.getDataFromDB() == true {
                    arrayAllData =  ListMusic().getAllData()
                }
            }else {
               let DB = DatabaseManager.shareInstance.getDataRealmIntial()
                for i in 0..<mp3FileNames.count {
                    let urlString = "\(mp3Files[i])"
                    let pathURL = URL(string: urlString)!
                    
                    if DB[i].name == mp3FileNames[i] {
                        let data = DatabaseInital()
                        data.url = pathURL.path
                        data.name = mp3FileNames[i]
                        data.text = ""
                        data.audio = ""
                        DatabaseManager.shareInstance.updateToDB(object: data)
                    }
                    if DatabaseManager.shareInstance.getDataFromDB() == true {
                        arrayAllData =  ListMusic().getAllData()
                    }
                }
            }
            
            

            
            
            
           /* if ( UserDefaults.standard.bool(forKey: "listMp3") ){
                for i in 0..<mp3FileNames.count {
                    let urlString = "\(mp3Files[i])"
                    let pathURL = URL(string: urlString)!
                    let data = DatabaseInital()
                    data.ID = i + 1
                    data.url = pathURL.path
                    data.name = mp3FileNames[i]
                    data.text = ""
                    data.audio = ""
                    DatabaseManager.shareInstance.updateToDB(object: data)
                }
                DatabaseManager.shareInstance.getDataFromDB()
                arrayAllData =  ListMusic().getAllData()
            }else {
                for i in 0..<mp3FileNames.count {
                    let urlString = "\(mp3Files[i])"
                    let pathURL = URL(string: urlString)!
                    DatabaseManager.shareInstance.addData(ID: i + 1, url: pathURL.path, name: mp3FileNames[i], text: "", audio: "")
                }
                UserDefaults.standard.set(true, forKey: "listMp3")
                DatabaseManager.shareInstance.getDataFromDB()
                arrayAllData =  ListMusic().getAllData()
            }
            */
        } catch {
            print(error)
        }
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidDisappear(_ animated: Bool) {
        IDUpdateDelegate?.updateID(IDUpdate: IDNext!)
    }

    @objc func addPulse() {
        let pulse = Pulsing(numberOfPulses: 2, radius: 50, position: AvatarImage.center)
        pulse.animationDuration = 0.8
        pulse.backgroundColor = UIColor.white.cgColor
        self.viewBottom.layer.insertSublayer(pulse, at: UInt32(AvatarImage.animationDuration))
    }
    
}
 
extension ListAllViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = arrayAllData[indexPath.row].ID
        self.performSegue(withIdentifier: "toVCListAllFromVCPlay", sender: data)
        IDNext = data
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toVCListAllFromVCPlay" {
            if let nextVC  = segue.destination as? ViewControllerPlay {
                nextVC.ID = sender as! Int
            }
        }
    }
}


extension ListAllViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayAllData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellListAll", for: indexPath) as! cellListAll
        cell.lbNumber.text = String(indexPath.row + 1)
        cell.lbName.text = arrayAllData[indexPath.row].Name
        cell.lbdetail.text = "Not Thing"
        return cell
    }
    
    
}



