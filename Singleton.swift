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
    
  //  var serverData = serverCommunications()
    var teamSelectId = Int()
    
    var coatch = CoachInfo()
    var loadingInfo = loginResponse()
    var coatchTeams = [Team]()
    var settings = SettingsData()
    var playerOnTeam = [Players]()
    var Sesion = [traningSesion]()
    var idSesion = Int()
    
    var BL = BLEController()
    var playerConnected = [Bool]()
    var indexOfSelectedTeam = Int()
    
    var a = [Float]()
    var b = [Float]()
}
