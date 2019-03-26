//
//  HistoryViewController.swift
//  Recorder
//
//  Created by Zi Wang on 2019/3/19.
//  Copyright © 2019 Laurent Veliscek. All rights reserved.
//

import UIKit
import AVFoundation

class HistoryViewController: UIViewController {

    var historyList: [History] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    var audioPlayer = AVAudioPlayer()
    var avPlayer: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "History"
        historyList = initHistoryList()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func initHistoryList() -> [History] {
        var result: [History] = []
        
        // Refers to: https://www.jianshu.com/p/8feb8b0df1d0
        let manager = FileManager.default
        let urlForDocument = manager.urls(for: .documentDirectory, in:.userDomainMask)
        let url = urlForDocument[0] as URL
        print(url)
        let contentsOfPath = try? manager.contentsOfDirectory(atPath: url.path)
        //print("contentsOfPath: \(contentsOfPath)")
        for i in contentsOfPath! {
            //let tempFileName = i
            let decoded = i.removingPercentEncoding
            let cache = decoded!.components(separatedBy: "+")
            if(cache.count==5 && cache[0]=="record"){
                // Reformat the time
                let time_cache = cache[1].components(separatedBy: "-")
                let newTime = time_cache[3]+":"+time_cache[4]+" on "+DateFormatter().monthSymbols[Int.init(time_cache[1])! - 1]+" "+time_cache[2]+", "+time_cache[0]
                result.append(History(score: cache[3], title: cache[2], time: newTime, file: i.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!))
            }
        }
        return result
    }
}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let temp = historyList[indexPath.row]
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as! HistoryCell
        tableCell.setHistory(history: temp)
        tableCell.selectionStyle = .none
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("section: \(indexPath.section)")
        print("row: \(indexPath.row)")
        print(historyList[indexPath.row].file)
        
        let manager = FileManager.default
        let urlForDocument = manager.urls(for: .documentDirectory, in:.userDomainMask)
        let url = urlForDocument[0] as URL
        let mp3FileURL = URL.init(string: url.absoluteString+historyList[indexPath.row].file)
        print("Ready to play music: "+mp3FileURL!.absoluteString)
        bgmPlay(fileLocation: mp3FileURL!)
        
    }
    
    func bgmPlay(fileLocation: URL){
        avPlayer = AVPlayer(url: fileLocation)
        
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
