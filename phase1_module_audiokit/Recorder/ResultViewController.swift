//
//  ResultViewController.swift
//  Recorder
//
//  Created by Zi Wang on 2019/3/9.
//  Copyright © 2019 Laurent Veliscek. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var pitchScoreLabel: UILabel!
    @IBOutlet weak var volumeScoreLabel: UILabel!
    @IBOutlet weak var commentTextLabel: UILabel!
    
    var musicTitle = ""
    var totalScore = 0
    var volumeScore = 0
    var pitchScore = 0
    var comment = ""
    var fileName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        songTitleLabel.text = "(Song: "+musicTitle+")"
        totalScoreLabel.text = String(totalScore)
        pitchScoreLabel.text = String(pitchScore)+"%"
        volumeScoreLabel.text = String(volumeScore)+"%"
        commentTextLabel.text = comment
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func SharedPressed(_ sender: Any) {
        
        //Set the default sharing message.
        
//        let message = "Hello!"
//        let link = NSURL(string: "http://test.com/")
        
        // Screenshot:
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, true, 0.0)
        self.view.drawHierarchy(in: self.view.frame, afterScreenUpdates: false)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Set the link, message, image to share.

        let objectsToShare = [img] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
        self.present(activityVC, animated: true, completion: nil)
    }
    

    @IBAction func showLeaderboard(_ sender: Any) {
        performSegue(withIdentifier: "LeaderboardEntry", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="LeaderboardEntry"){
            let nextView = segue.destination as! LeaderboardViewController
            nextView.soundtrackTitle = self.musicTitle
            nextView.fileName = self.fileName
        }
    }
}
