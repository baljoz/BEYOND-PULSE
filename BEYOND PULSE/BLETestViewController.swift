//
//  BLETestViewController.swift
//  BEYOND PULSE
//
//  Created by Milos Stosic on 7/5/17.
//  Copyright © 2017 Milos Stosic. All rights reserved.
//

import UIKit

class BLETestViewController: UIViewController,BLEControllerDelegate{
    func newHeartRateValue(_ bpm: UnsafeMutablePointer<UInt8>!) {
        print(bpm)
    }

    var sing = MySingleton.sharedInstance
 var gg = String()
    @IBOutlet weak var lab: UILabel!
    
   
    @IBOutlet weak var v: UIView!
    var bl = BLEController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bl.delegate = self
        // Do any additional setup after loading the view.
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        }
    

    @IBAction func onClick(_ sender: Any) {
    
        if bl.isOK {
        
        
        bl.startScan()
        bl.perform(#selector(bl.stopScan), with: nil, afterDelay: 5)
            var timer = Timer()
            timer = Timer.scheduledTimer(timeInterval: 5, target: self,
                                         selector: #selector(abortPairing),userInfo: nil, repeats: false)
            var timer2 = Timer()
            timer2 = Timer.scheduledTimer(timeInterval: 5, target: self,
                                         selector: #selector(provera),userInfo: nil, repeats: false)
        }
       
        
        
     //   self.timer = Timer.scheduledTimer(timeInterval: 5, target: self,
                                         // selector: bl.startScan), userInfo: nil, repeats: false)
       
    }
    func provera()
    {
        print(bl.isDeviceConnected())
        lab.text = " povezno :D :D :D  na "+gg
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
      func abortPairing() {
    
    // avbryt parningen med ett pulsband
            bl.stopScan()
   bl.cancelConnectionSilent(true, byUser: true)
       

       
    if self.bl.listOfperipheral.count == 0
    {
          }
    else
    {
       
  
        var p : NSInteger = 0
        bl.tryToConnect(to: bl.listOfperipheral.object(at: p) as! CBPeripheral)
        let g = bl.listOfperipheral.object(at: p) as! CBPeripheral
        gg = g.name!
        print(self.bl.isDeviceConnected())

   
    
    //NSArray *colors = [NSArray arrayWithObjects:@"Red", @"Green", @"Blue", @"Orange", nil];
    
    }

}
}
