//
//  HistoryCell.swift
//  Recorder
//
//  Created by Zi Wang on 2019/3/19.
//  Copyright © 2019 Laurent Veliscek. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {

    @IBOutlet weak var scoreView: UILabel!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var timeView: UILabel!
    
    var history: History!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setHistory(history: History){
        self.history = history
        
        scoreView.text = history.score
        titleView.text = history.title
        timeView.text = history.time
        
        if(Int.init(history.score)!>=75){
            scoreView.textColor = #colorLiteral(red: 0.3058823529, green: 0.7411764706, blue: 0.7490196078, alpha: 1)
        }else if(Int.init(history.score)!<75 && Int.init(history.score)!>=50){
            scoreView.textColor = #colorLiteral(red: 1, green: 0.7959753477, blue: 0.1955898088, alpha: 1)
        }else{
            scoreView.textColor = #colorLiteral(red: 0.8457252979, green: 0.8457252979, blue: 0.8457252979, alpha: 1)
        }
    }
}
