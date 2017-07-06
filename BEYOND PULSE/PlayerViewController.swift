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
    
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    var date = [String]()
    var time = [String]()
    var device = [String]()
    
    @IBOutlet weak var traningSesion: UITableView!
    @IBOutlet weak var tabControl: UISegmentedControl!
    var navTitleName = String()
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var startTrening: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        name.append("Wayne Rooney")
        name.append("Zlatan Ibrahimmovic")
        name .append("Marcus Rashford")
        name.append("Marouane Fellaini")
        name.append("Henrikh Mkhitaryan")
        
        position.append("DEFENDER")
        position.append("FORWARD")
        position.append("MIDDLE")
        position.append("FORWARD")
        position.append("FORWARD")
        
        connected.append("NOT CONNECTED")
         connected.append("NOT CONNECTED")
         connected.append("NOT CONNECTED")
         connected.append("NOT PEAR")
         connected.append("NOT CONNECTED")
        
        img.append(UIImage(named: "cancle")!)
        img.append(UIImage(named: "cancle")!)
        img.append(UIImage(named: "cancle")!)
        img.append(UIImage(named: "pear")!)
        img.append(UIImage(named: "cancle")!)
        
        imgPlayer.append(UIImage(named:"rony")!)
        imgPlayer.append(UIImage(named:"zlatan")!)
        imgPlayer.append(UIImage(named:"rasvord")!)
        imgPlayer.append(UIImage(named:"felaini")!)
        imgPlayer.append(UIImage(named:"mikitarijan")!)
        
        traningSesion.isHidden=true
        traningSesion.backgroundColor = UIColor.clear
        traningSesion.separatorStyle = .none
        
        playerTable.backgroundColor = UIColor.clear
        
        date.append("22/6/2017")
        time.append("1:30 AM - 2:30 AM")
        device.append("Device not synced")
    
        
        date.append("2/6/2017")
        time.append("3:30 PM - 5:30 PM")
        device.append("Device partiril synced")
        
        date.append("22/6/2017")
        time.append("7:45 AM - 9:30 AM")
        device.append("Device  synced")
        
        tabControl.setTitle("Players ("+String(img.count) + ")", forSegmentAt: 0)
        
        menuButton.target=revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
         navigationBar.topItem?.title = navTitleName
        
        startTrening.layer.cornerRadius = 1;
        startTrening.layer.borderWidth = 1;
        startTrening.layer.cornerRadius=10

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tabControl.selectedSegmentIndex == 0 {
            return sing.serverData.playerOnTeam.count
        }
        else
        {
        return sing.serverData.sesion.count
        }
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        

        
        if tabControl.selectedSegmentIndex == 0
        {
            let cell = self.playerTable.dequeueReusableCell(withIdentifier: "playercell") as! PlayerTableViewCell
               cell.playerName.text = sing.serverData.playerOnTeam[indexPath.row].firstName+" "+sing.serverData.playerOnTeam[indexPath.row].middleName+" "+sing.serverData.playerOnTeam[indexPath.row].lastName
        cell.playerPosition.text = sing.serverData.playerOnTeam[indexPath.row].postition
    //    cell.connectionImage.image = img[indexPath.row]
      //  cell.playerConection.text = connected[indexPath.row]
        if indexPath.row != 3 {
        cell.playerConection.textColor = UIColor.red
        }
        cell.playerImage.image = sing.serverData.playerOnTeam[indexPath.row].playerImage
         cell.playerImage.contentMode = .scaleAspectFit
        
        cell.connectionImage.contentMode = .scaleAspectFit
            
       //     cell.layer.cornerRadius = 1;
         //   cell.layer.borderWidth = 1;
            //textfieldView.layer.borderColor = UIColor(red: 128, green: 128, blue: 128, alpha: 1).cgColor
            //   login.layer.cornerRadius=10
            cell.layer.cornerRadius=10
            cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
        }
        
            let cell = self.traningSesion.dequeueReusableCell(withIdentifier: "traningSesion") as! TraningSesionTableViewCell

            cell.date.text = sing.serverData.sesion[indexPath.row].started
            cell.time.text = sing.serverData.sesion[indexPath.row].ended
            cell.device.text = sing.serverData.sesion[indexPath.row].uploadStatus
        cell.layer.cornerRadius = 1;
        cell.layer.borderWidth = 1;
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
            return cell
            
        
      
    }

    @IBAction func onClickToSegment(_ sender: Any) {
        if tabControl.selectedSegmentIndex == 0
        {
            traningSesion.isHidden = true
            playerTable.isHidden = false
            playerTable.reloadData()
        }
        else  //        JSON.getPlayersOfTeam(token:sing.serverData.res.token , id: sing.serverData.teams[indexPath.row].id) { ( player:[Players])-> Void in
        {
            if sing.serverData.sesion.count == 0 {
JSON.getTraningSesionOfTeam(token: self.sing.serverData.res.token, id: sing.serverData.teams[indexTeam].id){  ( se:[traningSesion])-> Void in

                 self.sing.serverData.sesion = self.JSON.sesion
                DispatchQueue.main.async(execute: {
     
                self.playerTable.isHidden = true
                self.traningSesion.isHidden = false
                self.traningSesion.reloadData()
                })
            }
           
        }
            else
            {
                self.playerTable.isHidden = true
                self.traningSesion.isHidden = false
                self.traningSesion.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if playerTable.isHidden == false
        {
         
            
            
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
