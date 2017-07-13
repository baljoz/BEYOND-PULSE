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
 
        tabControl.setTitle("Players ("+String(sing.playerOnTeam.count) + ")", forSegmentAt: 0)
        
        
        JSON.getTraningSesionOfTeam(token: self.sing.loadingInfo.token, id:indexTeam,page:pageOfSesion){  ( session:[traningSesion])-> Void in
            
            self.sing.serverData.sesion = session
        }
    
    
        
        menuButton.target=revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
         navigationBar.topItem?.title = navTitleName
        
        startTrening.layer.cornerRadius = 1;
        startTrening.layer.borderWidth = 1;
        startTrening.layer.cornerRadius=10
        
        playerTable.separatorStyle = .none
        
        indexTeam = sing.teamSelectId
        players = sing.playerOnTeam
        
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
        
            cell.device.text = ses[indexPath.row].uploadStatus
       
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
                if sing.serverData.sesion.count == 0 {
                JSON.getTraningSesionOfTeam(token: self.sing.loadingInfo.token, id:indexTeam,page:pageOfSesion){  ( session:[traningSesion])-> Void in

                 self.sing.serverData.sesion = session
                    }
                }
                self.ses = self.sing.serverData.sesion
                    self.pageOfSesion = self.pageOfSesion + 1
                DispatchQueue.main.async(execute: {
     
                self.playerTable.isHidden = true
                self.tranningTable.isHidden = false
                self.tranningTable.reloadData()
                    
                })
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
        JSON.playerOnTeam.removeAll()
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let revealviewcontroller:SWRevealViewController = self.revealViewController()
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "pdetails") as! PlayerDetailsViewController
        
        JSON.getPlayerDetails(token: sing.loadingInfo.token, idTeam: indexTeam, idPlayer: sing.playerOnTeam[indexPath.row].id){ ( player:Players)-> Void in
        newViewController.pl = player
       newViewController.pageOfSeeions = self.pageOfSesion
      
            DispatchQueue.main.async(execute: {
 revealviewcontroller.pushFrontViewController(newViewController, animated: true)  })
        }
        }
       else{
          let revealviewcontroller:SWRevealViewController = self.revealViewController()
        JSON.getPlayersOfSesionTranning(token: self.sing.loadingInfo.token, idTeam:indexTeam,idSesion: ses[indexPath.row].id){  ( pos:playerOfSessions)-> Void in
          
            DispatchQueue.main.async(execute: {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "sesion") as! SessionViewController
                newViewController.player = pos.player
                
                
               newViewController.pageOfSeeions = self.pageOfSesion
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
    
    @IBAction func connectAndStartTraning(_ sender: Any) {
        
      /*  let message = NSAttributedString(string: "Some of the devices failed to connect.Platers are euther out of rage or batteries are too low.", attributes: [
            NSFontAttributeName:UIFont.systemFont(ofSize: 15),
            NSForegroundColorAttributeName : UIColor.white
            ])
        let title = NSAttributedString(string: "Unable to connect to all devices.", attributes: [
            NSFontAttributeName:UIFont.systemFont(ofSize: 25),
            NSForegroundColorAttributeName : UIColor.white
            ])

        
        let menu = UIAlertController(title:"",message:"",preferredStyle: .actionSheet)
    
       menu.setValue(message, forKey: "attributedMessage")
        menu.setValue(title, forKey: "attributedTitle")

        let subview = (menu.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        
     
        subview.backgroundColor = UIColor(red: (0/255.0), green: (0/255.0), blue: (0/255.0), alpha: 0.2)
        
        menu.view.tintColor = UIColor.orange
        
        let startTranning = UIAlertAction(title:"Start Training Session Anyway",style : .default,handler:{(alert : UIAlertAction!)-> Void in
            let revealviewcontroller:SWRevealViewController = self.revealViewController()
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "starttranning") as! StartTraningViewController
                revealviewcontroller.pushFrontViewController(newViewController, animated: true)
        })
      
        let retry = UIAlertAction(title:"Retry",style : .default,handler:{(alert : UIAlertAction!)-> Void in
            print("retry")
        })
        let cancle = UIAlertAction(title:"Cancel",style : .default,handler:{(alert : UIAlertAction!)-> Void in
            print("Cancle")
        })
        menu.addAction(startTranning)
        menu.addAction(retry)
        menu.addAction(cancle)
    
        present(menu,animated: true , completion: nil)*/
       
        if let view2 = Bundle.main.loadNibNamed("actionSheet", owner: self, options: nil)?.first as? actionSheet
        {
            view2.frame = CGRect(x:20,y:self.view.frame.maxY-view2.frame.maxY-20,width:self.view.frame.width-40,height:view2.frame.height)
            view2.layer.cornerRadius = 10
      
            view2.continueButton.addTarget(self, action: #selector(pressContinue), for: .touchUpInside)
         
            view2.backgroundColor = UIColor.black.withAlphaComponent(0.9)
            
            self.view.addSubview(view2)
            
        }
       
    }
    
    func pressContinue()
    {
        
      JSON.updatePlayerTraningSessionsData(token: sing.loadingInfo.token, idTeam: indexTeam, idSession: 4, beltNumber: "111222336", data: "2222ppbbbbmmmm", idPlayer: 6)
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
extension UIView
{
    func searchVisualEffectsSubview() -> UIVisualEffectView?
    {
        if let visualEffectView = self as? UIVisualEffectView
        {
            return visualEffectView
        }
        else
        {
            for subview in subviews
            {
                if let found = subview.searchVisualEffectsSubview()
                {
                    return found
                }
            }
        }
        
        return nil
    }
}
