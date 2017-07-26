//
//  AlterViewController.swift
//  BEYOND PULSE
//
//  Created by Milos Stosic on 7/25/17.
//  Copyright © 2017 Milos Stosic. All rights reserved.
//

import UIKit

class AlterViewController: UIViewController {

    @IBOutlet weak var horisontalVIew: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var comitButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    var titles = String()
    var message = String()
    var custom = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        popUpView.layer.cornerRadius = 10
        let col = UIColor(red: 12/255.0, green: 12/255.0, blue: 22/255.0, alpha: 1)

          self.view.backgroundColor = col.withAlphaComponent(0.6)
        closeButton.isHidden = true
        if custom{
       titleLabel.text = titles
        messageLabel.text = message
        comitButton.isHidden = true
            cancelButton.isHidden = true
        closeButton.isHidden = false
            horisontalVIew.isHidden=true
        }
    }

    @IBAction func ClosePopUP(_ sender: Any) {
        self.view.removeFromSuperview()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonOnClick(_ sender: Any) {
        
        self.view.removeFromSuperview()

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
