//
//  ActionSheetViewController.swift
//  BEYOND PULSE
//
//  Created by Milos Stosic on 7/25/17.
//  Copyright © 2017 Milos Stosic. All rights reserved.
//

import UIKit

class ActionSheetViewController: UIViewController {
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!

    @IBOutlet weak var startTranningSessions: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let col = UIColor(red: 11/255.0, green: 18/255.0, blue: 20/255.0, alpha: 1)
    popUpView.backgroundColor = col.withAlphaComponent(0.9)
        popUpView.layer.cornerRadius = 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ClosePopUP(_ sender: Any) {
        self.view.removeFromSuperview()
    }

   /* @IBAction func clickOnStart(_ sender: Any) {
       
        
    }
  */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
