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
        
    
        coachImage.layer.borderWidth = 1.5
        coachImage.layer.borderColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1).cgColor
        coachImage.layer.cornerRadius=10
        coachImage.contentMode = .scaleAspectFit
        coachImage.image = sing.coatch.info.image
        coachImage.layer.masksToBounds = true

        
        tableView.separatorStyle = .none
        coachName.text = sing.coatch.info.firstName+" "+sing.coatch.info.middleName+" "+sing.coatch.info.lastName
        
        
        var gradient:CAGradientLayer = CAGradientLayer()
        let colorBottom = UIColor(red: 48.0/255.0, green: 48.0/255.0, blue: 48.0/255.0, alpha: 1.0).cgColor
        let colorTop = UIColor(red: 61.0/255.0, green: 62.0/255.0, blue: 64.0/255.0, alpha: 1.0).cgColor
        //colorBottom
        gradient.colors = [colorTop, colorBottom]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        //gradient.frame = self.view.bounds
        
        self.view.layer.addSublayer(gradient)

        tableView.backgroundColor = UIColor.clear
           }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sing.coatch.team.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "coatchcell") as! TeamTableViewCell
        cell.imageTeam.image = sing.coatch.team[indexPath.row].img
        cell.nameTeam.text = sing.coatch.team[indexPath.row].name
        cell.imageTeam.contentMode = .scaleAspectFit
       
        cell.backgroundColor = UIColor.clear
        
        var selectionView = UIView()
        selectionView.backgroundColor = UIColor(red: 61.0/255.0, green:61.0/255.0 , blue: 61.0/255.0, alpha: 1.0)
        
        cell.selectedBackgroundView = selectionView
    
        

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        self.JSON.playerOnTeam.removeAll()
        let revealviewcontroller:SWRevealViewController = self.revealViewController()
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        JSON.getPlayersOfTeam(token:sing.loadingInfo.token , id: sing.coatch.team[indexPath.row].id) { ( player:[Players])-> Void in
            if self.sing.loadingInfo.stat.statusCode == "BP_200"
            {
            self.sing.Sesion.removeAll()
            self.sing.playerOnTeam = player
            self.sing.teamSelectId = self.sing.coatch.team[indexPath.row].id
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "selP") as! PlayerViewController
            newViewController.indexTeam = self.sing.coatch.team[indexPath.row].id
            newViewController.navTitleName = self.sing.coatch.team[indexPath.row].name
            newViewController.navigationItem.title = self.sing.coatch.team[indexPath.row].name
            newViewController.players = player
                for _ in 0...player.count
                {
                    self.sing.playerConnected.append(false)
                }
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

