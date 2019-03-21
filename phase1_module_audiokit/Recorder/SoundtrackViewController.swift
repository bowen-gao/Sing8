//
//  SoundtrackViewController.swift
//  Recorder
//
//  Created by Zi Wang on 2019/1/9.
//  Copyright © 2019 Laurent Veliscek. All rights reserved.
//

import UIKit
import Alamofire

class SoundtrackViewController: UIViewController {

    @IBOutlet weak var soundtrackTableView: UITableView!
    
    var soundtrackList: [Soundtrack] = []
    
    func initSoundtrackList() -> [Soundtrack] {
        var result: [Soundtrack] = []
        result.append(Soundtrack(title:"分手后不要做朋友"));
        result.append(Soundtrack(title:"离人"));
        result.append(Soundtrack(title:"青花瓷"));
        result.append(Soundtrack(title:"喜帖街"));
        result.append(Soundtrack(title:"Jingle Bells"));
        result.append(Soundtrack(title:"Just give me a reason"));
        result.append(Soundtrack(title:"Lonely Christmas"));
        result.append(Soundtrack(title:"My Heart Will Go On"));
        result.append(Soundtrack(title:"Someone Like You"));
        result.append(Soundtrack(title:"Yesterday Once More"));
        return result
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.title = "Soundtrack"
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "soundtrackToRecord"{
            let nextView = segue.destination as! RecordViewController
            nextView.soundtrack = sender as? Soundtrack
             
        }
    }
    
    //@IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    //}

}

extension SoundtrackViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soundtrackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let temp = soundtrackList[indexPath.row]
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "SoundtrackCell") as! SoundtrackCell
        tableCell.setSoundtrack(Soundtrack: temp)
        tableCell.selectionStyle = .none
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let chosen = soundtrackList[indexPath.row]
        print("====> Chosen: "+chosen.title)
        performSegue(withIdentifier: "soundtrackToRecord", sender: chosen)
    }
    
}
