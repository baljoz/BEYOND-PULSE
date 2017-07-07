//
//  PlayerViewController.swift
//  BEYOND PULSE
//
//  Created by Milos Stosic on 6/14/17.
//  Copyright © 2017 Milos Stosic. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var playerTable: UITableView!
    var name = [String]()
    var position  = [String]()
    var img = [UIImage]()
    var connected = [String]()
    var imgPlayer  = [UIImage]()
     var sing = MySingleton.sharedInstance
    var JSON = serverCommunications()
    var indexTeam = Int()
    
    var players = [Players]()
    
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    var date = [String]()
    var time = [String]()
    var device = [String]()
    
    @IBOutlet weak var tranningTable: UITableView!
    
    @IBOutlet weak var tabControl: UISegmentedControl!
    var navTitleName = String()
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var startTrening: UIButton!
    
     var ses = [traningSesion]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        
        tranningTable.isHidden=true
        tranningTable.backgroundColor = UIColor.clear
        tranningTable.separatorStyle = .none
        
        playerTable.backgroundColor = UIColor.clear
 
        tabControl.setTitle("Players ("+String(sing.serverData.playerOnTeam.count) + ")", forSegmentAt: 0)
        
        menuButton.target=revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
         navigationBar.topItem?.title = navTitleName
        
        startTrening.layer.cornerRadius = 1;
        startTrening.layer.borderWidth = 1;
        startTrening.layer.cornerRadius=10
        
        playerTable.separatorStyle = .none

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tabControl.selectedSegmentIndex == 0 {
            return players.count
        }
        else
        {
        return ses.count
        }
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        

        
        if tabControl.selectedSegmentIndex == 0
        {
            let cell = self.playerTable.dequeueReusableCell(withIdentifier: "playercell") as! PlayerTableViewCell
               cell.playerName.text = players[indexPath.row].firstName+" "+players[indexPath.row].middleName+" "+players[indexPath.row].lastName
        cell.playerPosition.text = players[indexPath.row].postition
        if indexPath.row != 3 {
        cell.playerConection.textColor = UIColor.red
        }
        cell.playerImage.image = players[indexPath.row].playerImage
         cell.playerImage.contentMode = .scaleAspectFit
        
        cell.connectionImage.contentMode = .scaleAspectFit
            cell.layer.cornerRadius=10
          cell.cellView.layer.cornerRadius=10
            cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.backgroundColor = UIColor.clear
        return cell
        }
        
            let cell = self.tranningTable.dequeueReusableCell(withIdentifier: "traningSesion") as! TraningSesionTableViewCell

        
    
        
        cell.date.text = ses[indexPath.row].started.charOfString(start:0,end:10)
    
        var time  = ses[indexPath.row].started.charOfString(start:12,end:19)
        time = time+"/"
        time  = time+cell.time.text!+ses[indexPath.row].ended.charOfString(start:12,end:19)
        cell.time.text = time
        cell.cellView.layer.cornerRadius=10
        
        
        
        
        cell.backgroundColor = UIColor.clear
           // cell.date.text = sing.serverData.sesion[indexPath.row].started
            //cell.time.text = sing.serverData.sesion[indexPath.row].ended
            cell.device.text = sing.serverData.sesion[indexPath.row].uploadStatus
       
        //textfieldView.layer.borderColor = UIColor(red: 128, green: 128, blue: 128, alpha: 1).cgColor
        //   login.layer.cornerRadius=10
        cell.layer.cornerRadius=10
        
        if indexPath.row == 0
        {
            cell.device.textColor = UIColor.red
        }
        else if indexPath.row == 1
        {
            cell.device.textColor = UIColor.yellow
        }
        else
        {
            cell.device.textColor = UIColor.green
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.backgroundColor = UIColor.clear
        cell.cellView.layer.cornerRadius=10
            return cell
            
        
      
    }

    @IBAction func onClickToSegment(_ sender: Any) {
        if tabControl.selectedSegmentIndex == 0
        {
            tranningTable.isHidden = true
            playerTable.isHidden = false
            playerTable.reloadData()
        }
        else  //        JSON.getPlayersOfTeam(token:sing.serverData.res.token , id: sing.serverData.teams[indexPath.row].id) { ( player:[Players])-> Void in
        {
            if ses.count == 0 {
                JSON.getTraningSesionOfTeam(token: self.sing.serverData.res.token, id:indexTeam){  ( se:[traningSesion])-> Void in

                 self.sing.serverData.sesion = self.JSON.sesion
                self.ses = self.JSON.sesion
                DispatchQueue.main.async(execute: {
     
                self.playerTable.isHidden = true
                self.tranningTable.isHidden = false
                self.tranningTable.reloadData()
                })
            }
           
        }
            else
            {
                self.playerTable.isHidden = true
                self.tranningTable.isHidden = false
                self.tranningTable.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       if tabControl.selectedSegmentIndex == 0
       {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "pdetails") as! PlayerDetailsViewController
        newViewController.pl = sing.serverData.playerOnTeam[indexPath.row]
        print(indexPath.row)
        newViewController.idTeam = indexTeam
        DispatchQueue.main.async(execute: {

        self.present(newViewController, animated: true, completion: nil)
        })
        }
       else{
        
        JSON.getPlayersOfSesionTranning(token: self.sing.serverData.res.token, idTeam:indexTeam,idSesion: ses[indexPath.row].id){  ( se:[Players])-> Void in
            
            DispatchQueue.main.async(execute: {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "sesion") as! SessionViewController
                newViewController.player = self.JSON.playerOnTeam
                newViewController.session = self.JSON.sesion
                self.present(newViewController, animated: true, completion: nil)

            })

        }
    }
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
