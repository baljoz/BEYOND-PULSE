//
//  SessionViewController.swift
//  BEYOND PULSE
//
//  Created by Milos Stosic on 7/6/17.
//  Copyright © 2017 Milos Stosic. All rights reserved.
//

import UIKit

class SessionViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var sesionTable: UITableView!

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    
    var player = [Players]()
    var session = traningSesion()
    var pageOfSeeions = Int()
    var sing = MySingleton.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
    
       // backButton.action = #selector(SWRevealViewController.revealToggle(_:))
        // Do any additional setup after loading the view.
        sesionTable.backgroundColor = UIColor.clear
        sesionTable.separatorStyle = .none
        sesionTable.allowsSelection = false
        
      //  var time = String()
        var len = session.started.charOfString(start:0,end:9)
        print(len)
         len = len+" - "
        len  = len + session.started.charOfString(start:12,end:19)
        len = len+" - "
        len  = len+session.ended.charOfString(start:12,end:19)
        if let navView =  Bundle.main.loadNibNamed("navigationView", owner: self, options: nil)?.first as? NavigationView
        {
            navView.image.image = self.sing.coatch.team[0].img
            
            navView.image.contentMode = .scaleAspectFit
            
            navView.title.text = self.sing.coatch.team[0].name
            navView.sesionLength.text = len
            self.navigationBar.topItem?.titleView = navView
          navView.sizeToFit()
        }

        if let butView =  Bundle.main.loadNibNamed("buttonView", owner: self, options: nil)?.first as? CustomButton
        {
            butView.buttonImage.image = UIImage(named:"arrow")
            butView.buttonName.text = "Coutch \n Website"
            
          rightBarButton.customView?.addSubview(butView) 
            butView.sizeToFit()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
         let cell = self.sesionTable.dequeueReusableCell(withIdentifier: "sesionCell") as! SessionTableViewCell
        
        cell.playerName.text = player[indexPath.row].firstName+" "+player[indexPath.row].middleName+" "+player[indexPath.row].lastName
        cell.positionPlayer.text = player[indexPath.row].postition
        cell.connectionPlayer.text = session.uploadStatus
        cell.imagePlayer.image = player[indexPath.row].playerImage
        cell.imagePlayer.contentMode = .scaleAspectFit
        
        cell.connectionImage.contentMode = .scaleAspectFit
        cell.backgroundColor = UIColor.clear
        cell.viewCell.layer.cornerRadius = 10
        
        
        let gradient:CAGradientLayer = CAGradientLayer()
        var colorBottom : CGColor
        var colorTop : CGColor
        
      
        if  cell.connectionPlayer.text! == "PENDING"
        {
            colorBottom = UIColor(red: 158.0/255.0, green: 33.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
            colorTop = UIColor(red: 255.0/255.0, green: 156.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        }
        else if cell.connectionPlayer.text! == "COMPLETED"
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
        
        
        cell.sessionConnectionView.layer.addSublayer(cell.connectionPlayer.layer)
        cell.sessionConnectionView.layer.addSublayer(cell.connectionImage.layer)
        
        cell.sessionConnectionView.roundCorners(corners: [.bottomRight, .bottomLeft], radius: 10)
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
             print(player.count)
              return player.count
    }
    @IBAction func clickOnBack(_ sender: Any) {
        
        let revealviewcontroller:SWRevealViewController = self.revealViewController()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "selP") as! PlayerViewController
        newViewController.players = sing.playerOnTeam
        newViewController.ses = sing.Sesion
     
        
        newViewController.pageOfSesion = pageOfSeeions
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
