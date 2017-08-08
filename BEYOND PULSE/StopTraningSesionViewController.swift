//
//  StopTraningSesionViewController.swift
//  BEYOND PULSE
//
//  Created by Milos Stosic on 8/3/17.
//  Copyright © 2017 Milos Stosic. All rights reserved.
//

import UIKit

class StopTraningSesionViewController: UIViewController,UITableViewDataSource,UITableViewDelegate  {
    var players =  [Players]()
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var playerTable: UITableView!
    var sing = MySingleton.sharedInstance
    @IBOutlet weak var navigationBar: UINavigationBar!
    var indexOfTeam = Int()
    var JSON = serverCommunications()
    var heartRate = [Int]()
    var strideRate = [Int]()
    var numberOfSteps=[Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(red: 33.0/255.0, green: 33.0/255.0, blue: 33.0/255.0, alpha: 1.0)
        playerTable.backgroundColor = UIColor.clear
        playerTable.separatorColor = UIColor.clear
        
        uploadButton.layer.cornerRadius=10
        
        let gradient:CAGradientLayer = CAGradientLayer()
        let colorBottom = UIColor(red: 254.0/255.0, green: 92.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        let  colorTop = UIColor(red: 255.0/255.0, green: 186.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        
        gradient.colors = [colorTop, colorBottom]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        
        gradient.frame = uploadButton.layer.bounds
        gradient.masksToBounds = true
        gradient.cornerRadius = 10
        
        
        uploadButton.layer.addSublayer(gradient)
        
        if let navView =  Bundle.main.loadNibNamed("navigationView", owner: self, options: nil)?.first as? NavigationView
        {
         
            navView.image.image = self.sing.coatch.team[indexOfTeam].img
            navView.title.text = self.sing.coatch.team[indexOfTeam].name
            
            navView.image.contentMode = .scaleAspectFit
            self.navigationBar.topItem?.titleView = navView
            self.navigationBar.topItem?.titleView?.center.x = self.view.center.x
            
            
            navView.sizeToFit()
        }
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
            return players.count
      
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.playerTable.dequeueReusableCell(withIdentifier: "stopSessionCell") as! PlayerTableViewCell
        
       cell.playerName.text = players[indexPath.row].firstName+" "+players[indexPath.row].middleName+" "+players[indexPath.row].lastName
        
        cell.playerPosition.text = players[indexPath.row].postition
        cell.playerImage.image = players[indexPath.row].playerImage
        cell.playerImage.contentMode = .scaleAspectFit
        
        cell.connectionImage.contentMode = .scaleAspectFit
        cell.layer.cornerRadius=10
        cell.cellView.layer.cornerRadius=10
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.backgroundColor = UIColor.clear
        
        let gradient:CAGradientLayer = CAGradientLayer()
        var colorBottom : CGColor
        var colorTop : CGColor

        
        cell.playerConection.text = "NOT SYNCED"
        colorBottom = UIColor(red: 158.0/255.0, green: 33.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        colorTop = UIColor(red: 255.0/255.0, green: 156.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        if  cell.playerConection.text! == "NOT SYNCED"
        {
            colorTop = UIColor(red: 255.0/255.0, green: 188.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
            colorBottom = UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
            cell.connectionImage.image = UIImage(named:"synced")
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onClickUpoload(_ sender: Any) {
        let popUp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUp") as! ActionSheetViewController
        
        self.addChildViewController(popUp)
        popUp.view.frame = self.view.frame
        popUp.titleLabel.text = "Unable to sync all devices"
        popUp.messageLabel.text = "Some of the devices failed to sync. Players are either out of range or batteries are too low."
        popUp.startTranningSessions.setTitle("Continue to Upload", for: .normal)
          popUp.startTranningSessions.addTarget(self, action:  #selector(pressContinue), for: .touchUpInside)
        self.view.addSubview(popUp.view)
       
        popUp.didMove(toParentViewController: self)
       // popUp.startTranningSessions.addTarget(self, action:  #selector(pressContinue), for: .touchUpInside)
    }
    func pressContinue()
    {
        var id = [Int]()
        for  i in players
        {
            id.append(i.id)
        }
        JSON.createNewTraningSessins(token: sing.loadingInfo.token, idTeam: sing.coatch.team[indexOfTeam].id, sessionStart: "2017-06-30T15:02:38Z", sessionEnd: "2017-06-30T16:03:38Z", idPlayers:id ){( id : Int)-> Void in
    
        self.JSON.updatePlayerTraningSessionsData(token: self.sing.loadingInfo.token, idTeam: self.sing.coatch.team[self.indexOfTeam].id
            , idSession: id, beltNumber: self.players[0].beltName, idPlayer: self.players[0].id, strideRate: self.strideRate, numberOfSteps: self.numberOfSteps, heartRate: self.heartRate)
        }
    }
    @IBAction func pressBack(_ sender: Any) {
        let revealviewcontroller:SWRevealViewController = self.revealViewController()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "selP") as! PlayerViewController
              // self.present(newViewController, animated: true, completion: nil)
        revealviewcontroller.pushFrontViewController(newViewController, animated: true)
        

    }
   
}
