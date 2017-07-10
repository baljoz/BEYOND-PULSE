//
//  StartTraningViewController.swift
//  BEYOND PULSE
//
//  Created by Milos Stosic on 7/10/17.
//  Copyright © 2017 Milos Stosic. All rights reserved.
//

import UIKit

class StartTraningViewController: UIViewController {
    
    @IBOutlet weak var stratButton: UIButton!

    @IBOutlet weak var tileLabel: UILabel!
    
    @IBOutlet weak var lockView: UIView!
    
 
    
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
                
        tileLabel.text = DateFormatter.localizedString(from: NSDate() as Date,dateStyle:.medium,timeStyle: .medium)
        lockView.isHidden = true
       
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func startSession(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 1.0,target: self,selector:#selector(incrementTimer),userInfo: nil,repeats: true)
        lockView.isHidden = false
        stratButton.isEnabled = false

    }

    @IBAction func swipeUnlock(_ sender: UISwipeGestureRecognizer) {
        lockView.transform.translatedBy(x: 10, y: 0)
  
            }
    
    func incrementTimer() {
        tileLabel.text = DateFormatter.localizedString(from: NSDate() as Date,dateStyle:.medium,timeStyle: .medium)
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
