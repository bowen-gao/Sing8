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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Leaderboard"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Upload", style: .done, target: self, action: #selector(uploadRequest))
        // Do any additional setup after loading the view.

        
        // AJAX Call
        
        waitingStatus.center = self.view.center
        waitingStatus.hidesWhenStopped = true
        waitingStatus.style = UIActivityIndicatorView.Style.gray
        view.addSubview(waitingStatus)
        waitingStatus.startAnimating()
        
        var counter = 1
        let group = DispatchGroup()
        
        print("=====> loaded filename: "+fileName)
        
        group.enter()
        AF.request("https://ece496-sing8.herokuapp.com/api/leaderboard/"+soundtrackTitle).responseString { response in
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
        group.leave()
        group.notify(queue: .main){
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
        // Refers to: https://www.youtube.com/watch?v=Czr5wY7SHOY
        let modal = UIAlertController(title: "Prepare to upload", message: "Please provide your preferred name to us. Only alphabetic and numeric characters accepted.", preferredStyle: .alert)
        modal.addTextField()
        modal.addAction(UIAlertAction(title: "Upload", style: .default, handler: {(_) in
            self.userNameInput = (modal.textFields?[0].text)!
            //print("---->"+self.userNameInput);
            self.confirmUpload(user: self.userNameInput, file: self.fileName)
        }))
        modal.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(modal, animated:true)
    }
    
    func confirmUpload(user: String, file: String){
        //print("---->"+user);
        //print("---->"+file);
        
        // Prepare POST call to the server-side
        //AF.request("/api/leaderboard", method: .post, parameters[])
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
        
        bgmPlay(fileLocation: "https://ece496-sing8.herokuapp.com/"+rankList[indexPath.row][3])
    }
    
    func bgmPlay(fileLocation: String){
        
        print("fetching audio from: "+fileLocation)
        
        let url = URL(string: fileLocation)
        
        avPlayer = AVPlayer(url: url!)
        
        // Refers to: https://stackoverflow.com/questions/44152949/how-to-track-when-song-finished-playing-in-avplayer
        NotificationCenter.default.addObserver(self, selector: #selector(self.finishedPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)
        
        avPlayer.play();
        print("playing music!")
    }
    
    @objc func finishedPlaying( _ myNotification:NSNotification) {
        print("Stop playing music!")
    }
    
    private func bgmStop(){
        avPlayer.pause()
        avPlayer.seek(to: .zero)
        print("Stop playing music!")
    }
}

