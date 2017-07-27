//
//  SelectTeamViewController.swift
//  BEYOND PULSE
//
//  Created by Milos Stosic on 6/9/17.
//  Copyright © 2017 Milos Stosic. All rights reserved.
//

import UIKit

class SelectTeamViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

  
    @IBOutlet weak var rightNavigatioButton: UIBarButtonItem!
    @IBOutlet weak var clubNameLabel: UILabel!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var teamTable: UITableView!

    
    var JSON = serverCommunications()
    var team = [Team]()
    var coatch = [coachResponese]()
    
    var sing = MySingleton.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
     
        team = sing.coatch.team
        
        menuButton.target=revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
       teamTable.separatorStyle = .none
        
       /* let button = UIButton(type: .system)
        button.titleLabel!.lineBreakMode = .byWordWrapping
        button.setTitle("Coaches \nWebsite", for: .normal)
        button.titleLabel?.textColor = UIColor.white
   
        button.sizeToFit()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)*/

        let backUnderground = UIColor(red: 33.0/255.0, green: 33.0/255.0, blue: 33.0/255.0, alpha: 1.0)
        teamTable.backgroundColor = backUnderground
        clubNameLabel.text = sing.coatch.coutchClub.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return team.count
    }
  
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.teamTable.dequeueReusableCell(withIdentifier: "teamCell") as! TeamTableViewCell
        
        
        cell.imageTeam.image = team[indexPath.row].img
        cell.nameTeam.text = team[indexPath.row].name
        
        cell.imageTeam.contentMode = .scaleAspectFit
        cell.backgroundColor = UIColor.clear
        return cell
    }
  
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let revealviewcontroller:SWRevealViewController = self.revealViewController()
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        JSON.getPlayersOfTeam(token:sing.loadingInfo.token , id: sing.coatch.team[indexPath.row].id) { ( player:[Players])-> Void in
        if self.sing.loadingInfo.stat.statusCode == "BP_200"{
            
            self.sing.playerOnTeam = player
       let newViewController = storyBoard.instantiateViewController(withIdentifier: "selP") as! PlayerViewController
            newViewController.indexTeam = indexPath.row
            
            newViewController.players = player
            self.sing.teamSelectId = self.sing.coatch.team[indexPath.row].id
            DispatchQueue.main.async(execute: {
        revealviewcontroller.pushFrontViewController(newViewController, animated: true)
            })
        }
        else {
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
    
   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
