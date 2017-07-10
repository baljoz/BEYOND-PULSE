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
    var pageOfSesion : Int = 0
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
        
      //  if self.revealViewController() != nil {
        //    menuButton.target = self.revealViewController()
      //      menuButton.action = "revealToggle:"
      //      self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
     //   }
        
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

        cell.time.text?.removeAll()
    
        
        cell.date.text = ses[indexPath.row].started.charOfString(start:0,end:10)
    
        var time  = ses[indexPath.row].started.charOfString(start:12,end:19)
        time = time+"/"
        time  = time+cell.time.text!+ses[indexPath.row].ended.charOfString(start:12,end:19)
        cell.time.text = time
        cell.cellView.layer.cornerRadius=10
        
        
        
        
        cell.backgroundColor = UIColor.clear
           // cell.date.text = sing.serverData.sesion[indexPath.row].started
            //cell.time.text = sing.serverData.sesion[indexPath.row].ended
            cell.device.text = ses[indexPath.row].uploadStatus
       
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
        else
        {
            if ses.count == 0 {
                
                JSON.getTraningSesionOfTeam(token: self.sing.serverData.res.token, id:indexTeam,page:pageOfSesion){  ( se:[traningSesion])-> Void in

                 self.sing.serverData.sesion = self.JSON.sesion
                self.ses = self.JSON.sesion
                    self.pageOfSesion = self.pageOfSesion + 1
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
        /*
 
         
         let revealviewcontroller:SWRevealViewController = self.revealViewController()
         
        
         let newViewController = storyBoard.instantiateViewController(withIdentifier: "selP") as! PlayerViewController
         
         newViewController.navTitleName = self.sing.serverData.teams[indexPath.row].name
         newViewController.navigationItem.title = self.sing.serverData.teams[indexPath.row].name
         newViewController.players = self.sing.serverData.playerOnTeam
         newViewController.indexTeam = self.sing.serverData.teams[indexPath.row].id
         DispatchQueue.main.async(execute: {
         revealviewcontroller.pushFrontViewController(newViewController, animated: true)
 */
         let revealviewcontroller:SWRevealViewController = self.revealViewController()
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "pdetails") as! PlayerDetailsViewController
        JSON.getPlayerDetails(token: sing.serverData.res.token, idTeam: indexTeam, idPlayer: sing.serverData.playerOnTeam[indexPath.row].id){ ( player:[Players])-> Void in
        newViewController.pl = self.JSON.playerOnTeam[0]
       
        newViewController.idTeam = self.indexTeam
        DispatchQueue.main.async(execute: {
 revealviewcontroller.pushFrontViewController(newViewController, animated: true)
       // self.present(newViewController, animated: true, completion: nil)
        })
        }
        }
       else{
        
        JSON.getPlayersOfSesionTranning(token: self.sing.serverData.res.token, idTeam:indexTeam,idSesion: ses[indexPath.row].id){  ( se:[Players])-> Void in
             let revealviewcontroller:SWRevealViewController = self.revealViewController()
            DispatchQueue.main.async(execute: {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "sesion") as! SessionViewController
                newViewController.player = self.JSON.playerOnTeam
               // newViewController.session = self.JSON.sesion
                newViewController.idTeam = self.indexTeam
               
               // self.present(newViewController, animated: true, completion: nil)
                revealviewcontroller.pushFrontViewController(newViewController, animated: true)


            })

        }
    }
}
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if tabControl.selectedSegmentIndex == 1 {
            self.JSON.sesion.removeAll()
            JSON.getTraningSesionOfTeam(token: self.sing.serverData.res.token, id:indexTeam,page:pageOfSesion){  ( se:[traningSesion])-> Void in
                
                for s in self.JSON.sesion{
                
                self.ses.append(s)
            }
                DispatchQueue.main.async(execute: {
                    
                    self.playerTable.isHidden = true
                    self.tranningTable.isHidden = false
                    self.tranningTable.reloadData()
                })
                self.pageOfSesion = self.pageOfSesion + 1
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
