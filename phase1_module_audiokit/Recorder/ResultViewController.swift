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
    @IBOutlet weak var pitchScoreTitle: UILabel!
    @IBOutlet weak var volumeScoreTitle: UILabel!
    
    var musicTitle = ""
    var totalScore = 0
    var volumeScore = 0
    var pitchScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        songTitleLabel.text = "(Song: "+musicTitle+")"
        totalScoreLabel.text = String(totalScore)
        pitchScoreTitle.text = String(pitchScore)+"%"
        volumeScoreTitle.text = String(volumeScore)+"%"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
