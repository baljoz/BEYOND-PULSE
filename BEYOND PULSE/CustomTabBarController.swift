//
//  CustomTabBarController.swift
//  BEYOND PULSE
//
//  Created by Milos Stosic on 6/20/17.
//  Copyright © 2017 Milos Stosic. All rights reserved.
//

import Foundation


class CustomTabBarController: UITabBarController {
    
    @IBOutlet weak var financialTabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // I've added this line to viewDidLoad
        
       // UIApplication.shared.statusBarFrame.size.height
            financialTabBar.frame = CGRect(x: 10, y:  self.view.frame.size.height/8, width: financialTabBar.frame.size.width-20, height: 0)
        
       financialTabBar.backgroundColor = UIColor.black
        if #available(iOS 10.0, *) {
            financialTabBar.selectedItem?.badgeColor? = UIColor.brown
        } else {
            // Fallback on earlier versions
        }
}
}
