//
//  SessionViewController.swift
//  BEYOND PULSE
//
//  Created by Milos Stosic on 7/6/17.
//  Copyright © 2017 Milos Stosic. All rights reserved.
//

import UIKit

class SessionViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    @IBOutlet weak var sesionTable: UITableView!
var sing = MySingleton.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //sesionCell
        
         let cell = self.sesionTable.dequeueReusableCell(withIdentifier: "sesionCell") as! SessionTableViewCell
        print(sing.serverData.playerOnTeam[indexPath.row].firstName)
        cell.playerName.text = sing.serverData.playerOnTeam[indexPath.row].firstName+" "+sing.serverData.playerOnTeam[indexPath.row].middleName+" "+sing.serverData.playerOnTeam[indexPath.row].lastName
        cell.positionPlayer.text = sing.serverData.playerOnTeam[indexPath.row].postition
        cell.connectionPlayer.text = sing.serverData.playerOnTeam[indexPath.row].dataUploaded
        cell.imagePlayer.image = sing.serverData.playerOnTeam[indexPath.row].playerImage
        cell.imagePlayer.contentMode = .scaleAspectFit
        cell.connectionImage.image = UIImage(named: "ok")
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(sing.serverData.playerOnTeam.count)
        return sing.serverData.playerOnTeam.count
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
