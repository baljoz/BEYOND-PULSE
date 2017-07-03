//
//  Singleton.swift
//  BEYOND PULSE
//
//  Created by Milos Stosic on 7/3/17.
//  Copyright © 2017 Milos Stosic. All rights reserved.
//

import Foundation



class MySingleton {
    
    static let sharedInstance = MySingleton()
    
   var serverData = serverCommunications()

}
