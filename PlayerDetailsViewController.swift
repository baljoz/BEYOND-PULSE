//
//  PlayerDetailsViewController.swift
//  BEYOND PULSE
//
//  Created by Milos Stosic on 7/7/17.
//  Copyright © 2017 Milos Stosic. All rights reserved.
//

import UIKit

class PlayerDetailsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    var pl = Players()
    var idTeam = Int()
    var session = [traningSesion]()
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerPosition: UILabel!
    @IBOutlet weak var playerBirth: UILabel!
    @IBOutlet weak var beltID: UILabel!
    @IBOutlet weak var beltBatery: UILabel!
    @IBOutlet weak var beltStatus: UILabel!
    var JSON = serverCommunications()
    var sing = MySingleton.sharedInstance
    var pageOfSeeions = Int()
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var tranningSesion: UITableView!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    @IBOutlet weak var playerHeartRate: UILabel!
    @IBOutlet weak var playerHeight: UILabel!
    @IBOutlet weak var playerGender: UILabel!
    @IBOutlet weak var playerWeight: UILabel!
    
    @IBOutlet weak var connectImage: UIImageView!
    
    var playerId = Int()
    //var BL = BLEController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
       // self.sing.BL.delegate = self
        
        
        playerImage.image = pl.playerImage
        playerImage.contentMode = .scaleAspectFit
        playerName.text = pl.firstName+" "+pl.middleName+" "+pl.lastName
        playerPosition.text = pl.postition
        playerBirth.text = pl.dob
        
        beltID.text = pl.beltName
        beltBatery.text = "Battery:"+"  N/A"
        
        
        tranningSesion.backgroundColor = UIColor.clear
        
        tranningSesion.separatorStyle = .none
        tranningSesion.allowsSelection = false
        
        connectButton.layer.cornerRadius=10
        let gradient:CAGradientLayer = CAGradientLayer()
        let colorBottom = UIColor(red: 158.0/255.0, green: 33.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        let colorTop = UIColor(red: 255.0/255.0, green: 156.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        //colorBottom
        gradient.colors = [colorTop, colorBottom]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.frame = connectButton.bounds
        gradient.cornerRadius = 10
        
       connectButton.layer.addSublayer(gradient)

        
        self.navigationTitle.title = pl.firstName+" "+pl.lastName
       
        idTeam = sing.teamSelectId
        
        JSON.getTraningSesionOnPlayer(token: sing.loadingInfo.token, idTeam: idTeam, idPlayer: pl.id){( ses:[traningSesion])->Void in
        if self.sing.loadingInfo.stat.statusCode == "BP_200"
        {
            self.session = ses
            DispatchQueue.main.async(execute: {

                self.tranningSesion.reloadData() } )
            
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
        
       playerImage.layer.masksToBounds = true
        playerImage.layer.cornerRadius = 10
        
        playerGender.text = pl.gender
        playerWeight.text = String(pl.weight)
        playerHeight.text = String(pl.height)
        playerHeartRate.text = String(pl.maxHeartRate)
    
        if(self.sing.playerConnected[playerId])
        {
            connectImage.image = UIImage(named:"connectedIco")
           connectButton.setTitle("Unpair", for: .normal)
            beltStatus.text = "CONNECTED"
            let color = UIColor(red: 131.0/255.0, green: 145.0/255.0, blue: 95.0/255.0, alpha: 1.0)
            beltStatus.textColor = color
        }
        else
        {
            connectImage.image = UIImage(named:"x")
            connectButton.setTitle("Pair", for: .normal)
            beltStatus.text = "NOT CONNECTED"
            beltStatus.textColor = UIColor.red
        }
        //var image = UIImageView(image: UIImage(named:"brokenLinkIco2"))
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tranningSesion.dequeueReusableCell(withIdentifier: "tsesion") as! TraningSesionTableViewCell
        
        cell.date.text = session[indexPath.row].started.charOfString(start:0,end:10)
       // cell.date.text = session[indexPath.row].started
        var time  = session[indexPath.row].started.charOfString(start:12,end:19)
        time = time+"/"
        time  = time + session[indexPath.row].ended.charOfString(start:12,end:19)
        cell.time.text = time
        cell.cellView.layer.cornerRadius=10
       
        
                
        
        cell.backgroundColor = UIColor.clear
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(session.count)
      return session.count
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func clickOnBack(_ sender: Any) {
              let revealviewcontroller:SWRevealViewController = self.revealViewController()
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "selP") as! PlayerViewController
        newViewController.players = sing.playerOnTeam
          newViewController.ses = sing.Sesion
        newViewController.pageOfSesion = pageOfSeeions
        revealviewcontroller.pushFrontViewController(newViewController, animated: true)
     
       
    }
    @IBAction func clickSync(_ sender: Any) {
               
        
        
        let popUp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "alterView") as! AlterViewController
      
        self.addChildViewController(popUp)
        popUp.view.frame = self.view.frame
        self.view.addSubview(popUp.view)
        if(self.sing.BL.isDeviceConnected())
        {
            popUp.comButt = "Unpair"
        popUp.comitButton.setTitle("Unpair", for: .normal)
            
            sing.playerConnected[playerId] = true
            
        }
        else
        {
          popUp.comitButton.setTitle("Pair", for: .normal)
            sing.playerConnected[playerId] = true
        }
        popUp.comitButton.addTarget(self, action:  #selector(pressComit), for: .touchUpInside)
        popUp.didMove(toParentViewController: self)
        


    }

   func pressComit()
   {
    if(!self.sing.BL.isDeviceConnected())
    {
        self.sing.BL.beltNumber = beltID.text
    self.sing.BL.loadUserPeripheral()
        connectButton.setTitle("Unpair", for: .normal)
        
        beltStatus.text = "CONNECTED"
        let color = UIColor(red: 131.0/255.0, green: 145.0/255.0, blue: 95.0/255.0, alpha: 1.0)
        beltStatus.textColor = color
        connectImage.image = UIImage(named:"connectedIco")
        connectButton.setImage(UIImage(named:"brokenLinkIco"), for: .normal)
    }
    else
    {
        self.sing.BL.cancelConnectionSilent(true, byUser: true)
        connectButton.setTitle("Pair", for: .normal)
        
        beltStatus.text = "NOT CONNECTED"
        beltStatus.textColor = UIColor.red
        connectImage.image = UIImage(named:"x")
    }

    
    
    //removeFromSuperview()
    
    }
    
    func   newHeartRateValue(_ bpm :UInt8)
    {
        print("delegiraaaaa", bpm)
    }

}
extension String {
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
 
    func count() -> Int{
        return self.characters.count
    }
    func charOfString(start :Int , end:Int)->String
    {
        var g = String()
        for i in start...end
        {
            g = g+self[i]
        }
        return  g
    }
}
