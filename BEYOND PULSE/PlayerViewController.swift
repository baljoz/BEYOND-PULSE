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
    var indexOfTeam = Int()
    var teamId = Int()
    var pageOfSesion : Int = 0
    var players = [Players]()
    
    let gradient:CAGradientLayer = CAGradientLayer()
    
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    
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

        
        indexOfTeam =  sing.indexOfSelectedTeam
        
        
        tranningTable.isHidden=true
        tranningTable.backgroundColor = UIColor.clear
        tranningTable.separatorStyle = .none
        
        playerTable.backgroundColor = UIColor.clear
 
        tabControl.setTitle("Players ("+String(sing.playerOnTeam.count) + ")", forSegmentAt: 0)

        
        menuButton.target=revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        
     
        if let butView =  Bundle.main.loadNibNamed("buttonView", owner: self, options: nil)?.first as? CustomButton
        {
            butView.buttonImage.image = UIImage(named:"arrow")
            butView.buttonName.text = "Coutch \n Website"
            
            rightBarButton.customView?.layer.addSublayer(butView.layer)
            butView.sizeToFit()
        }

   
   
        startTrening.layer.cornerRadius=10

        
        
           let colorBottom = UIColor(red: 254.0/255.0, green: 92.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
          let  colorTop = UIColor(red: 255.0/255.0, green: 186.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        
        gradient.colors = [colorTop, colorBottom]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        
        gradient.frame = startTrening.layer.frame
        gradient.masksToBounds = true
        gradient.cornerRadius = 10
        
        //startTrening.layer = gradient
        
       startTrening.layer.insertSublayer(gradient, at: 1)

        
        
        playerTable.separatorStyle = .none
        
        teamId = sing.teamSelectId
        players = sing.playerOnTeam
        
        
        if let navView =  Bundle.main.loadNibNamed("navigationView", owner: self, options: nil)?.first as? NavigationView
        {
            print(teamId)
            navView.image.image = self.sing.coatch.team[indexOfTeam].img
            navView.title.text = self.sing.coatch.team[indexOfTeam].name
     
           // navView.center = self.navigationBar.center
            navView.image.contentMode = .scaleAspectFit
            self.navigationBar.topItem?.titleView = navView
            self.navigationBar.topItem?.titleView?.center.x = self.view.center.x
            
            navView.sizeToFit()
        }
        if self.sing.Sesion.count == 0
        {
        JSON.getTraningSesionOfTeam(token: self.sing.loadingInfo.token, id:teamId,page:pageOfSesion){  ( session:[traningSesion])-> Void in
            
            if self.sing.loadingInfo.stat.statusCode == "BP_200"
            {
            self.sing.Sesion = session
            self.ses = session
            }
            else{
                DispatchQueue.main.async {
                    let popUp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "alterView") as! AlterViewController
                    popUp.custom = true
                    popUp.titles = "Erorr"
                    popUp.message = self.sing.loadingInfo.stat.statusDescription
                    
                    //popUp.comitButton.isHidden = true
                    self.addChildViewController(popUp)
                    popUp.view.frame = self.view.frame
                    self.view.addSubview(popUp.view)
                    
                    popUp.didMove(toParentViewController: self)
                }
            }
        }
        }
        else
        {
            ses = sing.Sesion
        }
        
 
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
          print("session")
            return ses.count
        }
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        

        
        if tabControl.selectedSegmentIndex == 0
        {
            let cell = self.playerTable.dequeueReusableCell(withIdentifier: "playercell") as! PlayerTableViewCell
            
        cell.playerName.text = players[indexPath.row].firstName+" "+players[indexPath.row].middleName+" "+players[indexPath.row].lastName
            
        cell.playerPosition.text = players[indexPath.row].postition
        cell.playerImage.image = players[indexPath.row].playerImage
         cell.playerImage.contentMode = .scaleAspectFit
        
        cell.connectionImage.contentMode = .scaleAspectFit
            cell.layer.cornerRadius=10
          cell.cellView.layer.cornerRadius=10
            cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.backgroundColor = UIColor.clear
            
            
            if sing.playerConnected[indexPath.row]
            {
            cell.playerConection.text = "CONNECTED"
                cell.connectionImage.image = UIImage(named:"checkmark")
                cell.cellView.backgroundColor = UIColor.gray
            }
            else{
            cell.playerConection.text = "NOT CONNECTED"
                cell.connectionImage.image = UIImage(named:"x")
                cell.cellView.backgroundColor = UIColor.black
            }
            
            let gradient:CAGradientLayer = CAGradientLayer()
            var colorBottom : CGColor
            var colorTop : CGColor
            
            
            if  cell.playerConection.text! == "NOT CONNECTED"
            {
                colorBottom = UIColor(red: 158.0/255.0, green: 33.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
                colorTop = UIColor(red: 255.0/255.0, green: 156.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
            }
            else if cell.playerConection.text! == "CONNECTED"
            {
                colorBottom = UIColor(red: 38.0/255.0, green: 93.0/255.0, blue: 201.0/255.0, alpha: 1.0).cgColor
                colorTop = UIColor(red: 131.0/255.0, green: 197.0/255.0, blue: 45.0/255.0, alpha: 1.0).cgColor
            }
            else
            {
                
                colorBottom = UIColor(red: 213.0/255.0, green: 133.0/255.0, blue: 7.0/255.0, alpha: 1.0).cgColor
                colorTop = UIColor(red: 255.0/255.0, green: 254.0/255.0, blue: 148.0/255.0, alpha: 1.0).cgColor
            }
            gradient.colors = [colorTop, colorBottom]
            gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
            gradient.frame = cell.connectionView.bounds
           
            
            cell.connectionView.layer.addSublayer(gradient)
            
            
            cell.connectionView.layer.addSublayer(cell.playerConection.layer)
            cell.connectionView.layer.addSublayer(cell.connectionImage.layer)

            cell.maxHR.text = String(players[indexPath.row].maxHeartRate)
            cell.connectionView.roundCorners(corners: [.bottomRight, .bottomLeft], radius: 10)

        return cell
        }
        print(indexPath.row)
        let cell = self.tranningTable.dequeueReusableCell(withIdentifier: "traningSesion") as! TraningSesionTableViewCell

        cell.time.text?.removeAll()
    
        
        cell.date.text = ses[indexPath.row].started.charOfString(start:0,end:10)
    
        var time  = ses[indexPath.row].started.charOfString(start:12,end:19)
        time = time+"/"
        time  = time+cell.time.text!+ses[indexPath.row].ended.charOfString(start:12,end:19)
        cell.time.text = time
       
        
        
        
        
        cell.backgroundColor = UIColor.clear
        
        cell.sessionConnectionView.roundCorners(corners: [.bottomRight, .bottomLeft], radius: 10)
       
       
        
        let gradient:CAGradientLayer = CAGradientLayer()
        var colorBottom : CGColor
        var colorTop : CGColor
        
        cell.device.text = ses[indexPath.row].uploadStatus
        
        if  cell.device.text! == "PENDING"
        {
            colorBottom = UIColor(red: 158.0/255.0, green: 33.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
             colorTop = UIColor(red: 255.0/255.0, green: 156.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        }
        else if cell.device.text! == "COMPLETED"
        {
            colorBottom = UIColor(red: 38.0/255.0, green: 93.0/255.0, blue: 201.0/255.0, alpha: 1.0).cgColor
            colorTop = UIColor(red: 131.0/255.0, green: 197.0/255.0, blue: 45.0/255.0, alpha: 1.0).cgColor
        }
        else
        {
           
            colorBottom = UIColor(red: 213.0/255.0, green: 133.0/255.0, blue: 7.0/255.0, alpha: 1.0).cgColor
            colorTop = UIColor(red: 255.0/255.0, green: 254.0/255.0, blue: 148.0/255.0, alpha: 1.0).cgColor
        }
       
        //kako da zamaskiram gornji deo viewa da mi se ne zakrivuje nego da ima ostre ivice |-
        gradient.colors = [colorTop, colorBottom]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.frame = cell.sessionConnectionView.bounds
      
      
        cell.sessionConnectionView.layer.addSublayer(gradient)
        
        
        cell.sessionConnectionView.layer.addSublayer(cell.device.layer)
        cell.sessionConnectionView.layer.addSublayer(cell.connectionImage.layer)
        
        
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
            self.startTrening.isHidden = false
            
        }
        else
        {
           // playerTable.
            if ses.count == 0 {
                if sing.Sesion.count == 0 {
                JSON.getTraningSesionOfTeam(token: self.sing.loadingInfo.token, id:teamId,page:pageOfSesion){  ( session:[traningSesion])-> Void in
                    if self.sing.loadingInfo.stat.statusCode == "BP_200"
                    {
                 self.sing.Sesion = session
                    }
                    else{
                        DispatchQueue.main.async {
                            let popUp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "alterView") as! AlterViewController
                            popUp.custom = true
                            popUp.titles = "Erorr"
                            popUp.message = self.sing.loadingInfo.stat.statusDescription
                            
                            //popUp.comitButton.isHidden = true
                            self.addChildViewController(popUp)
                            popUp.view.frame = self.view.frame
                            self.view.addSubview(popUp.view)
                            
                            popUp.didMove(toParentViewController: self)
                        }
                    }
                    }
                }
                self.ses = self.sing.Sesion
                    self.pageOfSesion = self.pageOfSesion + 1
                DispatchQueue.main.async(execute: {
                self.playerTable.isHidden = true
                self.tranningTable.isHidden = false
                self.tranningTable.reloadData()
                self.startTrening.isHidden = true
                })
                
            }
           
        
            else
            {
                self.startTrening.isHidden = true
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
        
        JSON.getPlayerDetails(token: sing.loadingInfo.token, idTeam: teamId, idPlayer: sing.playerOnTeam[indexPath.row].id){ ( player:Players)-> Void in
            
            if self.sing.loadingInfo.stat.statusCode == "BP_200"
            {
        newViewController.pl = player
       newViewController.pageOfSeeions = self.pageOfSesion
            newViewController.playerId = indexPath.row
            DispatchQueue.main.async(execute: {
                revealviewcontroller.pushFrontViewController(newViewController, animated: true)  })
            }
            else
            {
                DispatchQueue.main.async {
                    let popUp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "alterView") as! AlterViewController
                    popUp.custom = true
                    popUp.titles = "Erorr"
                    popUp.message = self.sing.loadingInfo.stat.statusDescription
                    
                    //popUp.comitButton.isHidden = true
                    self.addChildViewController(popUp)
                    popUp.view.frame = self.view.frame
                    self.view.addSubview(popUp.view)
                    
                    popUp.didMove(toParentViewController: self)
                }
            }
        }
        }
       else{
          let revealviewcontroller:SWRevealViewController = self.revealViewController()
        JSON.getPlayersOfSesionTranning(token: self.sing.loadingInfo.token, idTeam:teamId,idSesion: ses[indexPath.row].id){  ( pos:playerOfSessions)-> Void in
          if self.sing.loadingInfo.stat.statusCode == "BP_200"
          {
            DispatchQueue.main.async(execute: {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "sesion") as! SessionViewController
                newViewController.player = pos.player
                newViewController.session = pos.sesion
                
               newViewController.pageOfSeeions = self.pageOfSesion
               // self.present(newViewController, animated: true, completion: nil)
                revealviewcontroller.pushFrontViewController(newViewController, animated: true)


            })
            }
          else{
            DispatchQueue.main.async {
                let popUp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "alterView") as! AlterViewController
                popUp.custom = true
                popUp.titles = "Erorr"
                popUp.message = self.sing.loadingInfo.stat.statusDescription
                
                //popUp.comitButton.isHidden = true
                self.addChildViewController(popUp)
                popUp.view.frame = self.view.frame
                self.view.addSubview(popUp.view)
                
                popUp.didMove(toParentViewController: self)
            }
            }
        }
    }
}
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if tabControl.selectedSegmentIndex == 1 {
            self.JSON.sesion.removeAll()
            JSON.getTraningSesionOfTeam(token: self.sing.loadingInfo.token, id:teamId,page:pageOfSesion){  ( se:[traningSesion])-> Void in
                if self.sing.loadingInfo.stat.statusCode == "BP_200"
                {
                for s in se{
                
                self.ses.append(s)
                self.sing.Sesion = self.ses
            }
                DispatchQueue.main.async(execute: {
                    
                    self.playerTable.isHidden = true
                    self.tranningTable.isHidden = false
                    self.tranningTable.reloadData()
                })
                self.pageOfSesion = self.pageOfSesion + 1
                }
                else{
                    DispatchQueue.main.async {
                        let popUp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "alterView") as! AlterViewController
                        popUp.custom = true
                        popUp.titles = "Erorr"
                        popUp.message = self.sing.loadingInfo.stat.statusDescription
                        
                        //popUp.comitButton.isHidden = true
                        self.addChildViewController(popUp)
                        popUp.view.frame = self.view.frame
                        self.view.addSubview(popUp.view)
                        
                        popUp.didMove(toParentViewController: self)
                    }
                }
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
       /*
        if let view2 = Bundle.main.loadNibNamed("actionSheet", owner: self, options: nil)?.first as? actionSheet
        {
            view2.frame = CGRect(x:20,y:self.view.frame.maxY-view2.frame.maxY-20,width:self.view.frame.width-40,height:view2.frame.height)
            view2.layer.cornerRadius = 10
      
            view2.continueButton.addTarget(self, action: #selector(pressContinue), for: .touchUpInside)
             view2.continueButton.addTarget(self, action: #selector(pressCancel), for: .touchUpInside)
         
            view2.backgroundColor = UIColor.black.withAlphaComponent(0.9)
            
            self.view.addSubview(view2)
            
        }*/
      let popUp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUp") as! ActionSheetViewController
        
        self.addChildViewController(popUp)
        popUp.view.frame = self.view.frame
        self.view.addSubview(popUp.view)
        
        popUp.didMove(toParentViewController: self)
        popUp.startTranningSessions.addTarget(self, action:  #selector(pressContinue), for: .touchUpInside)
        
    /*    let revealviewcontroller:SWRevealViewController = self.revealViewController()
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "sessions") as! StartTraningViewController
        
        revealviewcontroller.pushFrontViewController(newViewController, animated: true)*/
    }
    func pressCancel()
    {
        self.view.removeFromSuperview()
    }
    func pressContinue()
    {
        
     // JSON.updatePlayerTraningSessionsData(token: sing.loadingInfo.token, idTeam: teamId, idSession: 4, beltNumber: "111222336", data: "2222ppbbbbmmmm", idPlayer: 6)
        let revealviewcontroller:SWRevealViewController = self.revealViewController()
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "sessions") as! StartTraningViewController
        for i in 0...players.count
        {
            if self.sing.playerConnected[i]
            {
                newViewController.player.append(players[i])
            }
        }
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
extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

/*extension UIView
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
}*/
