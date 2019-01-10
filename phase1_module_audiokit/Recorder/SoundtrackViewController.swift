//
//  SoundtrackViewController.swift
//  Recorder
//
//  Created by Zi Wang on 2019/1/9.
//  Copyright © 2019 Laurent Veliscek. All rights reserved.
//

import UIKit

class SoundtrackViewController: UIViewController {

    @IBOutlet weak var soundtrackTableView: UITableView!
    
    var soundtrackList: [Soundtrack] = []
    
    func initSoundtrackList() -> [Soundtrack] {
        var result: [Soundtrack] = []
        result.append(Soundtrack(title:"FenShouHouBuYaoZuoPengYou"));
        result.append(Soundtrack(title:"XiTieJie"));
        return result
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        soundtrackList = initSoundtrackList();
        soundtrackTableView.delegate = self
        soundtrackTableView.dataSource = self
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

extension SoundtrackViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soundtrackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let temp = soundtrackList[indexPath.row]
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "SoundtrackCell") as! SoundtrackCell
        tableCell.setSoundtrack(Soundtrack: temp)
        return tableCell
    }
    
    /* Referenced to:
       https://stackoverflow.com/questions/32004557/swipe-able-table-view-cell-in-ios-9
    */
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let history = UITableViewRowAction(style: .normal, title: "History") { action, index in
            print("1111111")
        }
        history.backgroundColor = .lightGray
        return [history]
    }
    
}
