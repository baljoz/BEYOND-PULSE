//
//  PlayerDetailsViewController.swift
//  BEYOND PULSE
//
//  Created by Milos Stosic on 7/7/17.
//  Copyright © 2017 Milos Stosic. All rights reserved.
//

import UIKit

class PlayerDetailsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        playerImage.image = pl.playerImage
        playerImage.contentMode = .scaleAspectFit
        playerName.text = pl.firstName+" "+pl.middleName+" "+pl.lastName
        playerPosition.text = pl.postition
        playerBirth.text = pl.dob
        
        beltID.text = "Belt ID:"+"  "+pl.beltName
        beltBatery.text = "Battery:"+"N/A"
        beltStatus.text = "??"
        
        tranningSesion.backgroundColor = UIColor.clear
        
        tranningSesion.separatorStyle = .none
        tranningSesion.allowsSelection = false
        
        connectButton.layer.cornerRadius=10
        
        self.navigationTitle.title = pl.firstName+" "+pl.lastName
       
        idTeam = sing.teamSelectId
        
        JSON.getTraningSesionOnPlayer(token: sing.loadingInfo.token, idTeam: idTeam, idPlayer: pl.id){( ses:[traningSesion])->Void in
        
            self.session = ses
            DispatchQueue.main.async(execute: {

                self.tranningSesion.reloadData() } )
            
            }
        
    
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
        newViewController.players = sing.serverData.playerOnTeam
          newViewController.ses = sing.serverData.sesion
        newViewController.pageOfSesion = pageOfSeeions
        revealviewcontroller.pushFrontViewController(newViewController, animated: true)
     
       
    }
    @IBAction func clickSync(_ sender: Any) {
        let message = NSAttributedString(string: "You are about to unpair this player device from Beyond Pulse application.", attributes: [
            NSFontAttributeName:UIFont.systemFont(ofSize: 15),
            NSForegroundColorAttributeName : UIColor.white
            ])
        let title = NSAttributedString(string: "Unpair Device", attributes: [
            NSFontAttributeName:UIFont.systemFont(ofSize: 25),
            NSForegroundColorAttributeName : UIColor.white
            ])
        
        
        let menu = UIAlertController(title:"",message:"",preferredStyle: .alert)
        
        menu.setValue(message, forKey: "attributedMessage")
        menu.setValue(title, forKey: "attributedTitle")
        
     menu.view.backgroundColor = UIColor(red: (0/255.0), green: (0/255.0), blue: (0/255.0), alpha: 0.2)
        
        
      //  subview.backgroundColor = UIColor(red: (0/255.0), green: (0/255.0), blue: (0/255.0), alpha: 0.2)
        
        menu.view.tintColor = UIColor.orange
        
       
        let retry = UIAlertAction(title:"Unpair",style : .default,handler:{(alert : UIAlertAction!)-> Void in
            print("retry")
        })
        let cancle = UIAlertAction(title:"Cancel",style : .default,handler:{(alert : UIAlertAction!)-> Void in
            print("Cancle")
        })
         menu.addAction(cancle)
        menu.addAction(retry)
     
        
        present(menu,animated: true , completion: nil)

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
