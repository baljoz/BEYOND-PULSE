//
//  SessionViewController.swift
//  BEYOND PULSE
//
//  Created by Milos Stosic on 7/6/17.
//  Copyright © 2017 Milos Stosic. All rights reserved.
//

import UIKit

class SessionViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var sesionTable: UITableView!
    var idTeam = Int()
    var player = [Players]()
    var session = [traningSesion]()
    
var sing = MySingleton.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
    
       // backButton.action = #selector(SWRevealViewController.revealToggle(_:))
        // Do any additional setup after loading the view.
        sesionTable.backgroundColor = UIColor.clear
        sesionTable.separatorStyle = .none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
         let cell = self.sesionTable.dequeueReusableCell(withIdentifier: "sesionCell") as! SessionTableViewCell
        print(sing.serverData.playerOnTeam[indexPath.row].firstName)
        cell.playerName.text = sing.serverData.playerOnTeam[indexPath.row].firstName+" "+sing.serverData.playerOnTeam[indexPath.row].middleName+" "+sing.serverData.playerOnTeam[indexPath.row].lastName
        cell.positionPlayer.text = sing.serverData.playerOnTeam[indexPath.row].postition
        cell.connectionPlayer.text = sing.serverData.playerOnTeam[indexPath.row].dataUploaded
        cell.imagePlayer.image = sing.serverData.playerOnTeam[indexPath.row].playerImage
        cell.imagePlayer.contentMode = .scaleAspectFit
        cell.connectionImage.image = UIImage(named: "ok")
        cell.connectionImage.contentMode = .scaleAspectFit
        cell.backgroundColor = UIColor.clear
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(sing.serverData.playerOnTeam.count)
        return sing.serverData.playerOnTeam.count
    }
    @IBAction func clickOnBack(_ sender: Any) {
        
        let revealviewcontroller:SWRevealViewController = self.revealViewController()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "selP") as! PlayerViewController
        newViewController.players = sing.serverData.playerOnTeam
        newViewController.ses = sing.serverData.sesion
        newViewController.indexTeam = idTeam
         revealviewcontroller.pushFrontViewController(newViewController, animated: true)
         
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
