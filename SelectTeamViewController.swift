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
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var teamTable: UITableView!
    var teamName = [String]()
    var teamImg = [UIImage]()
    var JSON = serverCommunications()
    var team = [Team]()
    var coatch = [coachResponese]()
    
    var sing = MySingleton.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        /*teamName.append("FC Munchester United")
        teamName.append("FC Real Madrid")
        teamName.append("FC Barcelona")
        */
        teamImg.append(UIImage(named: "mancester")!)
        teamImg.append(UIImage(named: "real")!)
        teamImg.append(UIImage(named: "barca")!)
        
        menuButton.target=revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
       teamTable.separatorStyle = .none
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "top"), for: .normal)
        button.imageView?.tintColor = UIColor.orange
        button.setTitle("Coaches Website", for: .normal)
       // button.addTarget(self, action: #selector(showCategories), for: .touchUpInside)
        button.sizeToFit()
    
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sing.serverData.teams.count
    }
  
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.teamTable.dequeueReusableCell(withIdentifier: "teamCell") as! TeamTableViewCell
        cell.imageTeam.image = teamImg[indexPath.row]
        cell.nameTeam.text = sing.serverData.teams[indexPath.row].name
        
        cell.imageTeam.contentMode = .scaleAspectFit
        cell.backgroundColor = nil
        return cell
    }
  
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
    
   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
