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

    
    var player = [Players]()
    var session = [traningSesion]()
    var pageOfSeeions = Int()
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
        
            cell.playerName.text = player[indexPath.row].firstName+" "+player[indexPath.row].middleName+" "+player[indexPath.row].lastName
        cell.positionPlayer.text = player[indexPath.row].postition
        cell.connectionPlayer.text = player[indexPath.row].dataUploaded
        cell.imagePlayer.image = player[indexPath.row].playerImage
        cell.imagePlayer.contentMode = .scaleAspectFit
        cell.connectionImage.image = UIImage(named: "ok")
        cell.connectionImage.contentMode = .scaleAspectFit
        cell.backgroundColor = UIColor.clear
        cell.viewCell.layer.cornerRadius = 10
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
             print(player.count)
              return player.count
    }
    @IBAction func clickOnBack(_ sender: Any) {
        
        let revealviewcontroller:SWRevealViewController = self.revealViewController()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "selP") as! PlayerViewController
        newViewController.players = sing.serverData.playerOnTeam
        newViewController.ses = sing.serverData.sesion
     
        
        newViewController.pageOfSesion = pageOfSeeions
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
