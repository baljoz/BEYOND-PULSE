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
    @IBOutlet weak var lockViewLeftSide: NSLayoutConstraint!
    
    @IBOutlet weak var lockView: UIView!
    
    @IBOutlet weak var swipeToUnlock: UILabel!
    @IBOutlet weak var constraint: NSLayoutConstraint!
 
    @IBOutlet weak var unlockLabelCentar: NSLayoutConstraint!
     var tim = Timer()
    var timer = Timer()
        var leftSideView = CGFloat()
        var labCentar = CGFloat()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
                
        tileLabel.text = DateFormatter.localizedString(from: NSDate() as Date,dateStyle:.medium,timeStyle: .medium)
        lockView.isHidden = true
        leftSideView = self.lockViewLeftSide.constant
        labCentar =  self.unlockLabelCentar.constant
        self.swipeToUnlock.isHidden = true
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func startSession(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 1.0,target: self,selector:#selector(incrementTimer),userInfo: nil,repeats: true)
        lockView.isHidden = false
        stratButton.isEnabled = false
        self.swipeToUnlock.isHidden = false

    }

    @IBAction func swipeUnlock(_ sender: UISwipeGestureRecognizer) {
       
     
        UIView.animate(withDuration: 0.5) {
            self.lockViewLeftSide.constant = self.lockViewLeftSide.constant  + self.view.frame.maxX
            self.view.layoutIfNeeded()
            self.unlockLabelCentar.constant = self.unlockLabelCentar.constant + self.view.frame.maxX
        }
       
        tim = Timer.scheduledTimer(timeInterval: 1.0,target: self,selector:#selector(updateFrame),userInfo: nil,repeats: true)
       
            }
    
    func updateFrame()
    {
        self.stratButton.isEnabled = true
        self.lockView.isHidden = true
        self.swipeToUnlock.isHidden = true
        self.lockViewLeftSide.constant = leftSideView
        self.unlockLabelCentar.constant = labCentar
        tim.invalidate()

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
