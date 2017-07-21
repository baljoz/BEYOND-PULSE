//
//  SettingsViewController.swift
//  BEYOND PULSE
//
//  Created by Milos Stosic on 6/28/17.
//  Copyright © 2017 Milos Stosic. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
 
   var JSON = serverCommunications()
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var settingsTable: UITableView!
    var sing = MySingleton.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
  //  settingsTable.isScrollEnabled = false
        settingsTable.tableFooterView = UIView()
        settingsTable.backgroundColor = nil
        
        menuButton.target=revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        let button = UIButton(type: .system)
        button.titleLabel!.lineBreakMode = .byWordWrapping
        button.setTitle("Coaches \nWebsite", for: .normal)
        button.titleLabel?.textColor = UIColor.white
        
        button.sizeToFit()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return 13
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let iden = String(indexPath.row)
        
        if indexPath.row == 1
        {
            let cell = self.settingsTable.dequeueReusableCell(withIdentifier:iden) as! SettingsTableViewCell
            cell.dataSyncAndNotification.isOn = sing.coatch.settings.autoDataSync
            return cell
        }
        else if indexPath.row == 2
        {
            let cell = self.settingsTable.dequeueReusableCell(withIdentifier:iden) as! SettingsTableViewCell
            cell.dataSyncAndNotification.isOn = sing.coatch.settings.notificationsEnabled
            return cell
        }
        else if indexPath.row == 4
        {
             let cell = self.settingsTable.dequeueReusableCell(withIdentifier:iden) as! SettingsTableViewCell
            cell.launge.text = sing.coatch.settings.language
            return cell
        }
        
        let cell = self.settingsTable.dequeueReusableCell(withIdentifier: iden)!
        cell.selectionStyle = .none
      return cell
        

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 8
        {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
          JSON.sendSettings(dataSync: sing.coatch.settings.autoDataSync, notification: sing.coatch.settings.notificationsEnabled, language: sing.coatch.settings.language, token: sing.loadingInfo.token,id: sing.coatch.info.id)
            
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "login") as! LoginViewController
           self.present(newViewController, animated: true, completion: nil)
            
              }
    }
    
    @IBAction func automaticDataSyncUpdateState(_ sender: Any) {
       
        if self.sing.coatch.settings.autoDataSync
        {
            self.sing.coatch.settings.autoDataSync = false
        }
        else
        {
            self.sing.coatch.settings.autoDataSync = true
        }
    }
    
    @IBAction func notificationUpdatState(_ sender: Any) {
        if self.sing.coatch.settings.notificationsEnabled
        {
            self.sing.coatch.settings.notificationsEnabled = false
        }
        else
        {
            self.sing.coatch.settings.notificationsEnabled = true
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
