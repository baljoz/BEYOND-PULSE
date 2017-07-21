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
 
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    @IBOutlet weak var unlockLabelCentar: NSLayoutConstraint!
     var tim = Timer()
    var timer = Timer()
        var leftSideView = CGFloat()
        var labCentar = CGFloat()
    var sing = MySingleton.sharedInstance
    var start = false
    var minuts=0
    var hour = 0
    var secund = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
                
        tileLabel.text = DateFormatter.localizedString(from: NSDate() as Date,dateStyle:.none,timeStyle: .medium)
        lockView.isHidden = true
        leftSideView = self.lockViewLeftSide.constant
      //  labCentar =  self.unlockLabelCentar.constant
        self.swipeToUnlock.isHidden = true
        let colorback = UIColor(red: 33.0/255.0, green: 33.0/255.0, blue: 33.0/255.0, alpha: 1.0)
        lockView.backgroundColor = colorback.withAlphaComponent(0.1)
        
        
        stratButton.frame = CGRect(x:0,y:0, width:149.5,height:149.5)
        
       
        stratButton.clipsToBounds = true
        
        
        stratButton.layer.cornerRadius = 145.5/2.0
        
        stratButton.backgroundColor = UIColor.red
        
        let gradient:CAGradientLayer = CAGradientLayer()
        let colorBottom = UIColor(red: 254.0/255.0, green: 92.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        let  colorTop = UIColor(red: 255.0/255.0, green: 186.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        
        gradient.colors = [colorTop, colorBottom]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.frame = stratButton.bounds
        gradient.cornerRadius = 10
        
       
        stratButton.layer.addSublayer(gradient)
        var x = (stratButton.frame.maxX+stratButton.frame.minX)/2
        var y = (stratButton.frame.minY+stratButton.frame.maxY)/2
        x = x - 26.5
        y = y - 26.5
        let uiimg = UIImage(named:"stopIco")
        let img = UIImageView()
        img.image = uiimg
        img.frame = CGRect(x:x,y:y,width:53.0,height:53.0)
        stratButton.layer.addSublayer(img.layer)
        
        let button = UIButton(type: .system)
        button.titleLabel!.lineBreakMode = .byWordWrapping
        button.setTitle("Coaches\nWebsite", for: .normal)
        button.titleLabel?.textColor = UIColor.white
        
        button.sizeToFit()

        
         navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func startSession(_ sender: Any) {
        if start
        {
            let revealviewcontroller:SWRevealViewController = self.revealViewController()
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "selP") as! PlayerViewController
           
      
            revealviewcontroller.pushFrontViewController(newViewController, animated: true)

        }
        else
        {
            timer = Timer.scheduledTimer(timeInterval: 1.0,target: self,selector:#selector(incrementTimer),userInfo: nil,repeats: true)
            lockView.isHidden = false
            stratButton.isEnabled = false
            self.swipeToUnlock.isHidden = false
            stratButton.alpha = 0.5
            start = true
        }

    }

    @IBAction func swipeUnlock(_ sender: UISwipeGestureRecognizer) {
       
        
        
        UIView.animate(withDuration: 0.5) {
            self.lockViewLeftSide.constant = self.lockViewLeftSide.constant  + self.view.frame.maxX
            self.view.layoutIfNeeded()
       //     self.unlockLabelCentar.constant = self.unlockLabelCentar.constant + self.view.frame.maxX
        self.stratButton.alpha = 1.0
       
        self.tim = Timer.scheduledTimer(timeInterval: 1.0,target: self,selector:#selector(self.updateFrame),userInfo: nil,repeats: true)
            
            
       
    }
}
    func updateFrame()
    {
        self.stratButton.isEnabled = true
        self.lockView.isHidden = true
        self.swipeToUnlock.isHidden = true
        self.lockViewLeftSide.constant = leftSideView
       // self.unlockLabelCentar.constant = labCentar
        tim.invalidate()

    }
    
    func incrementTimer() {
        secund = secund + 1
        if secund == 60
        {
            minuts = minuts + 1
            secund = 0
        }
        
        if minuts == 60
        {
            hour = hour + 1
            minuts = 0
            secund = 0
        }
        tileLabel.text = String(hour)+":"+String(minuts)+":"+String(secund)
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
