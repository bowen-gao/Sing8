//
//  LeaderboardCell.swift
//  Recorder
//
//  Created by Zi Wang on 2019/3/20.
//  Copyright © 2019 Laurent Veliscek. All rights reserved.
//

import UIKit

class LeaderboardCell: UITableViewCell {

    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var score: UILabel!
    
    func setMember(rankNew: String, scoreNew: String, userName: String, fileLocation: String, timestamp: String){
        rank.text = rankNew
        username.text = userName
        time.text = timestamp
        score.text = "Score: "+scoreNew
    }

}
