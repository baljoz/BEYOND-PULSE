//
//  AlterViewController.swift
//  BEYOND PULSE
//
//  Created by Milos Stosic on 7/25/17.
//  Copyright © 2017 Milos Stosic. All rights reserved.
//

import UIKit

class AlterViewController: UIViewController {

    @IBOutlet weak var popUpView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        popUpView.layer.cornerRadius = 10
        let col = UIColor(red: 12/255.0, green: 12/255.0, blue: 22/255.0, alpha: 1)

          self.view.backgroundColor = col.withAlphaComponent(0.2)
        
    }

    @IBAction func ClosePopUP(_ sender: Any) {
        self.view.removeFromSuperview()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
