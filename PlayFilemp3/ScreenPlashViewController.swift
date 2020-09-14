//
//  ScreenPlashViewController.swift
//  PlayFilemp3
//
//  Created by Vu Minh Tam on 9/9/20.
//  Copyright © 2020 Vu Minh Tam. All rights reserved.
//

import UIKit

class ScreenPlashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        // https://dictionary.cambridge.org/vi/media/english/uk_pron/u/ukf/ukfau/ukfault029.mp3
//        // https://dictionary.cambridge.org/vi/media/english/uk_pron/u/uki/uking/ukingra015.mp3
//        //https://dictionary.cambridge.org/vi/media/english/uk_pron/u/ukm/ukmes/ukmesh_001.mp3
        
//        guard let url = URL(string: "https://dictionary.cambridge.org/vi/media/english/uk_pron/u/ukf/ukfau/ukfault029.mp3") else {return}
//        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
//        let downloadTask = urlSession.downloadTask(with: url)
//        downloadTask.resume()
        
        if UserDefaults.standard.bool(forKey: "createFileTXT") == false {
            createFileTXT()
        }


        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            self.performSegue(withIdentifier: "toVCScreenPlashFromVCListAll", sender: nil)
            
        }
        
    }
    

    func createFileTXT() {
        let file = "\(UUID().uuidString).txt"
        let contents = "Some text ..."
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = dir.appendingPathComponent(file)
        do {
            try contents.write(to: fileURL, atomically: false, encoding: .utf8)
            UserDefaults.standard.set(true, forKey: "createFileTXT")
        }
        catch {
          print("Error:\(error)")
        }
    }

}

//extension ScreenPlashViewController: URLSessionDownloadDelegate {
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
//        print("File Download", location)
//        guard let url = downloadTask.originalRequest?.url else {
//            return
//        }
////        let docsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
//        let docsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let destinationPath = docsPath.appendingPathComponent(url.lastPathComponent)
//        
//        try? FileManager.default.removeItem(at: destinationPath)
//        
//        do {
//            try FileManager.default.copyItem(at: location, to: destinationPath)
//
//        }catch {
//            print("copy Error : \(error.localizedDescription)")
//        }
//        
//    }
//}
