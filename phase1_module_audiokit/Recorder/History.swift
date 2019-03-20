//
//  History.swift
//  Recorder
//
//  Created by Zi Wang on 2019/3/19.
//  Copyright © 2019 Laurent Veliscek. All rights reserved.
//

import Foundation

class History{
    var score: String
    var title: String
    var time: String
    var file: String
    
    init(score: String, title: String, time: String, file: String){
        self.score = score
        self.title = title
        self.time = time
        self.file = file
    }
}
