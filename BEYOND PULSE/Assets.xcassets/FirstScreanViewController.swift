//
//  FirstScreanViewController.swift
//  BEYOND PULSE
//
//  Created by Milos Stosic on 6/29/17.
//  Copyright © 2017 Milos Stosic. All rights reserved.
//

import UIKit

class FirstScreanViewController: UIViewController {

    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       let jeremyGif = UIImage.gifImageWithName("heartbeat")
        let imageView = UIImageView(image: jeremyGif)
        imageView.frame = CGRect(x: 20.0, y: view.frame.size.height - 300 , width: self.view.frame.size.width - 40, height: 150.0)
        view.addSubview(imageView)
        
        
        
        self.timer = Timer.scheduledTimer(timeInterval: 5, target: self,
                                          selector: #selector(self.timerDidFire(timer:)), userInfo: nil, repeats: false)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
   

    



 func timerDidFire(timer: Timer) {
    print(timer)
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let newViewController = storyBoard.instantiateViewController(withIdentifier: "login")
    self.present(newViewController, animated: true, completion: nil)
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
