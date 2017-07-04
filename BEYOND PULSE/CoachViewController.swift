//
//  CoachViewController.swift
//  BEYOND PULSE
//
//  Created by Milos Stosic on 6/9/17.
//  Copyright © 2017 Milos Stosic. All rights reserved.
//

import UIKit

class CoachViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var coachImage: UIImageView!

    @IBOutlet weak var coachName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var JSON = serverCommunications()
    
    @IBOutlet weak var settingButton: UIButton!
    var teamName = [String]()
    var teamImg = [UIImage]()
    
    var sing = MySingleton.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        teamName.append("FC Munchester United")
        teamName.append("FC Real Madrid")
        teamName.append("FC Barcelona")
        
        teamImg.append(UIImage(named: "mancester")!)
        teamImg.append(UIImage(named: "real")!)
        teamImg.append(UIImage(named: "barca")!)

        
        coachImage.layer.cornerRadius = 2;
        coachImage.layer.borderWidth = 1;
        coachImage.layer.borderColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1).cgColor
     
        
        coachImage.layer.cornerRadius=10

        
        tableView.separatorStyle = .none
        coachImage.contentMode = .scaleAspectFit
        coachImage.image = sing.serverData.coatchRes.image
        coachName.text = sing.serverData.coatchRes.firstName+" "+sing.serverData.coatchRes.middleName+" "+sing.serverData.coatchRes.lastName
           }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sing.serverData.teams.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "coatchcell") as! TeamTableViewCell
        cell.imageTeam.image = teamImg[indexPath.row]
        cell.nameTeam.text = sing.serverData.teams[indexPath.row].name
       cell.imageTeam.layer.borderWidth = 1
       
        
         cell.imageTeam.layer.borderColor = UIColor.black.cgColor
         cell.imageTeam.layer.cornerRadius = cell.imageTeam.frame.height/2
        cell.imageTeam.clipsToBounds = true
        cell.imageTeam.backgroundColor = UIColor.black
        cell.selectionStyle = .none
        
        
        cell.imageTeam.contentMode = .scaleAspectFit

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       /* let revealviewcontroller:SWRevealViewController = self.revealViewController()
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "selP") as! PlayerViewController
        print(teamName[indexPath.row])
        newViewController.navTitleName = teamName[indexPath.row]
        newViewController.navigationItem.title = teamName[indexPath.row]
        revealviewcontroller.pushFrontViewController(newViewController, animated: true)*/
        self.JSON.playerOnTeam.removeAll()
        let revealviewcontroller:SWRevealViewController = self.revealViewController()
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        JSON.getPlayersOfTeam(token:sing.serverData.res.token , id: sing.serverData.teams[indexPath.row].id) { ( player:[Players])-> Void in
            
            self.sing.serverData.playerOnTeam = self.JSON.playerOnTeam
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "selP") as! PlayerViewController
            
            newViewController.navTitleName = self.sing.serverData.teams[indexPath.row].name
            newViewController.navigationItem.title = self.sing.serverData.teams[indexPath.row].name
            DispatchQueue.main.async(execute: {
                revealviewcontroller.pushFrontViewController(newViewController, animated: true)
            })
        }

    }
 
    @IBAction func clickOnSettongs(_ sender: Any) {
        
        let revealviewcontroller:SWRevealViewController = self.revealViewController()
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "settings") as! SettingsViewController
      
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
