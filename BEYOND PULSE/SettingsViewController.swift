//
//  SettingsViewController.swift
//  BEYOND PULSE
//
//  Created by Milos Stosic on 6/28/17.
//  Copyright © 2017 Milos Stosic. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var settingsTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
  //  settingsTable.isScrollEnabled = false
        settingsTable.tableFooterView = UIView()
        settingsTable.backgroundColor = nil
        
        menuButton.target=revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
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
        let cell = self.settingsTable.dequeueReusableCell(withIdentifier: iden)!
        cell.selectionStyle = .none
      return cell
        

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 8
        {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
          
            
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "login") as! LoginViewController
           self.present(newViewController, animated: true, completion: nil)
            
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
