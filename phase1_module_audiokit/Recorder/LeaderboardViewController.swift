//
//  LeaderboardViewController.swift
//  Recorder
//
//  Created by Zi Wang on 2019/3/20.
//  Copyright © 2019 Laurent Veliscek. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class LeaderboardViewController: UIViewController {

    // Element Format: [rank, score, username, fileLocation, timestamp]
    var rankList: [[String]]=[]
    
    var waitingStatus:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var tableView: UITableView!
    
    var audioPlayer = AVAudioPlayer()
    var avPlayer: AVPlayer!
    
    var soundtrackTitle=""
    var fileName=""
    var userNameInput=""
    
    var model: UIAlertController!
    var uploaded = false
    
    let group = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Leaderboard"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Upload", style: .done, target: self, action: #selector(uploadRequest))
        // Do any additional setup after loading the view.

        print("=====> File Name: "+self.fileName)
        // AJAX Call
        
        self.waitingStatus.center = self.view.center
        self.waitingStatus.hidesWhenStopped = true
        self.waitingStatus.style = UIActivityIndicatorView.Style.gray
        view.addSubview(self.waitingStatus)
        self.waitingStatus.startAnimating()
        
        var counter = 1
        self.uploaded = false
        
        print("=====> loaded filename: "+fileName)
        
        if(soundtrackTitle=="分手后不要做朋友"){
            soundtrackTitle = "FenShouHouBuYaoZuoPengYou"
        }else if(soundtrackTitle=="离人"){
            soundtrackTitle = "LiRen"
        }else if(soundtrackTitle=="富士山下"){
            soundtrackTitle = "FuShiShanXia"
        }else if(soundtrackTitle=="青花瓷"){
            soundtrackTitle = "QingHuaCi"
        }else if(soundtrackTitle=="喜帖街"){
            soundtrackTitle = "XiTieJie"
        }else{
            let formatter = soundtrackTitle.replacingOccurrences(of: " ", with: "")
            soundtrackTitle = formatter
        }
        
        rankList = []
        
        print("=====> submitting request to: "+"https://ece496-sing8.herokuapp.com/api/leaderboard/"+soundtrackTitle)
        self.group.enter()
        AF.request("https://ece496-sing8.herokuapp.com/api/leaderboard/"+soundtrackTitle.replacingOccurrences(of: " ", with: "")).responseString { response in
            print("=====>"+response.result.value!)
            var dic = self.convertStringToDictionary(text: response.result.value ?? "")
            let status = dic!["status"] as! String
            if(status=="ok"){
                for element in dic!["result"] as! [AnyObject]{
                    var temp = [String]()
                    temp.append(String(counter))
                    for sub in element as! [AnyObject]{
                        temp.append(String(describing: sub))
                    }
                    self.rankList.append(temp)
                    counter+=1;
                }

            }else{
                let alert = UIAlertController(title: "Emm...", message: "No record found under this soundtrack.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            
        }
        self.group.leave()
        self.group.notify(queue: .main){
            print("==============================")
            print("Count: " + String(self.rankList.count))
            for element in self.rankList{
                for subelement in element{
                    print(subelement)
                }
            }
            print("==============================")
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.waitingStatus.stopAnimating()
        }

        //rankList.append(["1","100","kwanstyle","1.mp3","2012-03-01-10-00"])
        //rankList.append(["2","100","kwanstyle","2.mp3","2012-03-01-10-00"])
        //rankList.append(["3","100","kwanstyle","3.mp3","2012-03-01-10-00"])
        //print("Count: " + String(self.rankList.count))
        

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func backButtonPressed(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    // Reference: https://www.jianshu.com/p/210254495d57
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.init(rawValue: 0)]) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    @objc func uploadRequest(){
        if(self.uploaded==true){
            self.model.dismiss(animated: true, completion: nil);
            self.model = UIAlertController(title: "Error", message: "You can not upload this recording twice!", preferredStyle: .alert)
            self.model.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(self.model, animated:true)
            return
        }
        // Refers to: https://www.youtube.com/watch?v=Czr5wY7SHOY
        self.model = UIAlertController(title: "Prepare to upload", message: "Please provide your preferred name to us. Only alphabetic and numeric characters accepted.", preferredStyle: .alert)
        self.model.addTextField()
        self.model.addAction(UIAlertAction(title: "Upload", style: .default, handler: {(_) in
            self.userNameInput = (self.model.textFields?[0].text)!
            //print("---->"+self.userNameInput);
            //print("xxxxx> "+self.fileName)
            self.confirmUpload(user: self.userNameInput, file: self.fileName)
        }))
        self.model.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(self.model, animated:true)
    }
    
    func confirmUpload(user: String, file: String){
        //print("---->"+user);
        //print("---->"+file);
        
        // Prepare POST call to the server-side
        //AF.request("/api/leaderboard", method: .post, parameters[])
        
        let cache = file.components(separatedBy: "+")
        let manager = FileManager.default
        let urlForDocument = manager.urls(for: .documentDirectory, in:.userDomainMask)
        let url = urlForDocument[0] as URL
        print("=====> Root Location: "+url.absoluteString)
        print("=====> File Name: "+self.fileName)
        let mp3FileURL = URL.init(string: url.absoluteString+self.fileName)
        print("=====> File Location: "+mp3FileURL!.absoluteString)
        //var uploadContent = ["score": cache[3], "username": user, "music":soundtrackTitle, "timestamp":cache[1]]
        if(user.count==0){
            self.model.dismiss(animated: true, completion: nil);
            self.model = UIAlertController(title: "Upload Cancelled", message: "Your must provide your username.", preferredStyle: .alert)
            self.model.addAction(UIAlertAction(title: "Retry", style: .cancel, handler: nil))
            self.present(self.model, animated:true)
        }else{
            self.model.dismiss(animated: true, completion: nil);
            self.waitingStatus.center = self.view.center
            self.waitingStatus.hidesWhenStopped = true
            self.waitingStatus.style = UIActivityIndicatorView.Style.gray
            view.addSubview(self.waitingStatus)
            self.waitingStatus.startAnimating()
            self.group.enter()
            // Refers to https://juejin.im/post/5a605a166fb9a01ca713807e
            
            /*AF.upload(multipartFormData: {(form) in
                var formField = cache[3]
                form.append(formField.data(using: String.Encoding.utf8)!, withName: "score")
                formField = user
                form.append(formField.data(using: String.Encoding.utf8)!, withName: "username")
                formField = self.soundtrackTitle
                form.append(formField.data(using: String.Encoding.utf8)!, withName: "music")
                formField = cache[1]
                form.append(formField.data(using: String.Encoding.utf8)!, withName: "timestamp")
                do{
                    try{
                        form.append(Data(contentsOf: mp3FileURL!, options: [.alwaysMapped , .uncached ]), withName: "file")
                    }
                }catch{
                    print("enen")
                    print(error)
                    }
                
             }, *//*AF.upload(multipartFormData: { (MFData) in
                do {
                    let music = try Data(contentsOf: URL.init(string: url.absoluteString+self.fileName)!)
                    MFData.append(music as Data, withName: "file")
                } catch {
                    print("Error loading image : \(error)")
                }
                
             }, to: "https://ece496-sing8.herokuapp.com/api/leaderboard", method: .post, headers: ["Content-type": "multipart/form-data"]).responseString { response in
                print("Response String: \(response.result.value)")
                var dic = self.convertStringToDictionary(text: response.result.value ?? "")
                let status = dic!["status"] as! String
                if(status=="ok"){
                    print("==============================")
                    print("Uploaded successfully!")
                    print("==============================")
                    self.uploaded=true
                }else{
                    print("==============================")
                    print("Failed to upload!")
                    print("==============================")
                    self.uploaded=false
                }
            }*/
                AF.upload(
                    //URL.init(fileURLWithPath: Bundle.main.path(forResource: soundtrack?.title, ofType: "mp3")!)
                    multipartFormData: { form in
                        var formField = cache[3]
                        form.append(formField.data(using: String.Encoding.utf8)!, withName: "score")
                        formField = user
                        form.append(formField.data(using: String.Encoding.utf8)!, withName: "username")
                        formField = self.soundtrackTitle
                        form.append(formField.data(using: String.Encoding.utf8)!, withName: "music")
                        formField = cache[1]
                        form.append(formField.data(using: String.Encoding.utf8)!, withName: "timestamp")
                        
                        //let docUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                        //let url = docUrl.appendingPathComponent("eSignature.html")
                        //let data = try? Data(contentsOf: url)
                        //print("==-="+url.absoluteString)
                        
                        // Refers to: https://stackoverflow.com/questions/29005381/get-image-from-documents-directory-swift
                        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
                        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
                        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
                        if let dirPath          = paths.first
                        {
                            let recordingURL = URL(fileURLWithPath: dirPath).appendingPathComponent(self.fileName)
                            //let image    = UIImage(contentsOfFile: imageURL.path)
                            // Do whatever you want with the image
                            form.append(recordingURL, withName: "file")
                        }
                        
                },
                    to: "https://ece496-sing8.herokuapp.com/api/leaderboard"
                    ).responseString { response in
                        print("Response String: \(response.result.value)")
                        var dic = self.convertStringToDictionary(text: response.result.value ?? "")
                        let status = dic!["status"] as! String
                        if(status=="ok"){
                            print("==============================")
                            print("Uploaded successfully!")
                            print("==============================")
                            self.uploaded=true
                        }else{
                            print("==============================")
                            print("Failed to upload!")
                            print("==============================")
                            self.uploaded=false
                        }
                        
            }
            
                self.group.leave()
                self.group.notify(queue: .main){
                    //if(self.uploaded){
                        self.waitingStatus.stopAnimating()
                        self.model = UIAlertController(title: "Congratulations!", message: "Your recording is uploaded successfully.", preferredStyle: .alert)
                    self.model.addAction(UIAlertAction(title: "OK", style: .default, handler: {(_) in
                        print("refreshing...")
                        //self.view.setNeedsDisplay()
                        //self.viewDidLoad()
                        _ = self.navigationController?.popViewController(animated: true)
                    }))
                        self.present(self.model, animated:true)
                    
                    
                   /* }else{
                        self.waitingStatus.stopAnimating()
                        self.model = UIAlertController(title: "Error", message: "Failed to upload your recording. Please try again later.", preferredStyle: .alert)
                        self.model.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(self.model, animated:true)
                    }*/
                
                
            }
            self.view.setNeedsLayout()
        }
    }
    
    public func downloadAndPlay(fileLocation: String, wavName:String){
        
        // Refers to https://www.jianshu.com/p/8feb8b0df1d0
        /*let fileManager = FileManager.default
        print("yah=> "+fileLocation+wavName)
        let filePath:String = NSHomeDirectory() + wavName
        let exist = fileManager.fileExists(atPath: filePath)
        if(exist){
            print("yah=> 1")
            let manager = FileManager.default
            let urlForDocument = manager.urls(for: .documentDirectory, in:.userDomainMask)
            let url = urlForDocument[0] as URL
            let localFileURL = URL.init(string: url.absoluteString+wavName)
            print("Ready to play music: "+localFileURL!.absoluteString)
            self.avPlayer = AVPlayer(url: localFileURL!)
            // Refers to: https://stackoverflow.com/questions/44152949/how-to-track-when-song-finished-playing-in-avplayer
            NotificationCenter.default.addObserver(self, selector: #selector(self.finishedPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.avPlayer.currentItem)
            
            self.avPlayer.play();
            print("playing music!")
            self.title = "Playing"
        }else{*/
        let manager = FileManager.default
        let urlForDocument = manager.urls(for: .documentDirectory, in:.userDomainMask)
        let url = urlForDocument[0] as URL
        let mp3FileURL = URL.init(string: url.absoluteString+wavName)
        if FileManager.default.fileExists(atPath: mp3FileURL!.path) {
            do{
                try FileManager.default.removeItem(atPath: mp3FileURL!.path)
            }catch{
                print("Handle Exception")
            }
        }
            print("fetching audio from: "+fileLocation)
            
            self.group.enter()
            
            
            AF.download(fileLocation, to: DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)).downloadProgress { progress in
                print("Download Progress: \(progress.fractionCompleted)")
                }.response { response in
                print(response)
                
                if(response.error == nil){
                    //avPlayer = AVPlayer(url: url!)
                    let manager = FileManager.default
                    let urlForDocument = manager.urls(for: .documentDirectory, in:.userDomainMask)
                    let url = urlForDocument[0] as URL
                    let localFileURL = URL.init(string: url.absoluteString+wavName)
                    print("Ready to play music: "+localFileURL!.absoluteString)
                    self.avPlayer = AVPlayer(url: localFileURL!)
                    // Refers to: https://stackoverflow.com/questions/44152949/how-to-track-when-song-finished-playing-in-avplayer
                    NotificationCenter.default.addObserver(self, selector: #selector(self.finishedPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.avPlayer.currentItem)
                    
                    self.avPlayer.play();
                    print("playing music!")
                    self.title = "Playing"
                }
            }
            //let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
            //AF.download(fileLocation, to: destination)
            self.group.leave()
            self.group.notify(queue: .main){}
        //}
    }

}

extension LeaderboardViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rankList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let temp = rankList[indexPath.row]
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell") as! LeaderboardCell
        tableCell.setMember(rankNew: temp[0], scoreNew: temp[1], userName: temp[2], fileLocation: temp[3], timestamp: temp[4])
        tableCell.selectionStyle = .none
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("section: \(indexPath.section)")
        print("row: \(indexPath.row)")
        
        downloadAndPlay(fileLocation: "https://ece496-sing8.herokuapp.com/"+rankList[indexPath.row][3], wavName: rankList[indexPath.row][3])
    }
    

        

    
    
    @objc func finishedPlaying( _ myNotification:NSNotification) {
        print("Stop playing music!")
        self.title = "Leaderboard"
    }
    
    private func bgmStop(){
        avPlayer.pause()
        avPlayer.seek(to: .zero)
        print("Stop playing music!")
        self.title = "Leaderboard"
    }
}

