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
        result.append(Soundtrack(title:"FenShouHouBuYaoZuoPengYou"));
        result.append(Soundtrack(title:"XiTieJie"));
        return result
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        AF.request("https://ece496-sing8.herokuapp.com/api/leaderboard/test").responseJSON { response in
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
        }

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
        performSegue(withIdentifier: "soundtrackToRecord", sender: chosen)
    }
    
}
