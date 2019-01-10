//
//  SoundtrackCell.swift
//  Recorder
//
//  Created by Zi Wang on 2019/1/9.
//  Copyright © 2019 Laurent Veliscek. All rights reserved.
//

import UIKit

class SoundtrackCell: UITableViewCell {

    /*
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    */
    
    
    
    @IBOutlet weak var musicTitle: UILabel!
    
    func setSoundtrack(Soundtrack: Soundtrack){
        musicTitle.text = Soundtrack.title
    }
    
}
