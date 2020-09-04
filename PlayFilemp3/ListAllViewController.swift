//
//  ListAllViewController.swift
//  PlayFilemp3
//
//  Created by Vu Minh Tam on 8/28/20.
//  Copyright © 2020 Vu Minh Tam. All rights reserved.
//

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
        arrayAllData =  ListMusic().getAllData()
        print("ar : \(arrayAllData)")
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
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil)

            // if you want to filter the directory contents you can do like this:
            let mp3Files = directoryContents.filter{ $0.pathExtension == "mp3" }
            if mp3Files.count == 0 {
                ViewEmpty.isHidden = false
                return
            }else {
                ViewEmpty.isHidden = true
            }
            print("mp3 urls:",mp3Files)
            let mp3FileNames = mp3Files.map{ $0.deletingPathExtension().lastPathComponent }
            print("mp3 list:", mp3FileNames)
            
            for i in 0..<mp3Files.count {
                let urlString = "\(mp3Files[i])"
                let pathURL = URL(string: urlString)!
                var databaseInitals =  DatabaseInital.init(url: pathURL.path ,
                                                           name: mp3FileNames[i],
                                                           text: "abc*123*ggg*",
                                                           audio: "9-0*2-4*4-8*")

                database.shareInstance.arrDB.append(databaseInitals)
            }
            
            
            

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



