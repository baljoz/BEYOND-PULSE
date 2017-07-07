//
//  ServerComunication.swift
//  BEYOND PULSE
//
//  Created by Milos Stosic on 6/27/17.
//  Copyright © 2017 Milos Stosic. All rights reserved.
//

import Foundation

class serverCommunications
{
    var coatchRes = coachResponese()
    var   res = loginResponse()
    var isLoad = false
    var teams = [Team]()
    var settings = SettingsData()
    var playerOnTeam = [Players]()
    var sesion = [traningSesion]()
    init() {
        
    }
    
    
    func loginGetToken(username: String,password : String, handler:@escaping (_ re:loginResponse)-> Void)
    {
        let json: [String: Any] = ["email": username,
                                   "password": password]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "http://bp.dev.ingsoftware.com:9092/login")!
        var request = URLRequest(url: url)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request)  { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return    handler(self.res)
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                let status = responseJSON["status"] as? [String: Any]
                
                self.res.statusCode = status?["code"] as! String
                self.res.statusDescription = status?["desc"] as! String
                if status?["code"] as? String == "BP_200"{
                    var data = responseJSON["data"] as? [String: Any]
                    
                    self.res.token = (data?["accessToken"] as? String)!
                    self.res.refreshToken = (data?["refreshToken"] as? String)!
                    
                    
                }
                
            }
            handler(self.res)
            
        }
        
        
        task.resume()
        
        
        
    }
    
    func ForgootPassword( email : String,handler:@escaping (_ re:loginResponse)-> Void)
    {
        let json: [String: Any] = ["email": email]
        
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "http://bp.dev.ingsoftware.com:9092/password_reset")!
        var request = URLRequest(url: url)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return handler(self.res)
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                let status = responseJSON["status"] as? [String: Any]
                
                self.res.statusCode = status?["code"] as! String
                self.res.statusDescription = status?["desc"] as! String
                if self.res.statusCode == "BP_200"
                {
                    self.res.data = responseJSON["data"] as! String
                }
                handler(self.res)
            }
            
        }
        
        task.resume()
        
        
        
    }
    
    //get new token
    func refreshToken( token : String)
    {
        let json: [String: Any] = ["refresh": token]
        
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "http://bp.dev.ingsoftware.com:9092/refres")!
        var request = URLRequest(url: url)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                self.isLoad = true
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                let status = responseJSON["status"] as? [String: Any]
                
                self.res.statusCode = status?["code"] as! String
                self.res.statusDescription = status?["desc"] as! String
                if self.res.statusCode == "BP_200"
                {
                    var data = responseJSON["data"] as! [String: Any]
                    self.res.refreshToken = data["refreshToken"] as! String
                    self.res.token = data["accessToken"] as! String
                    
                }
                
            }
            self.isLoad = true
        }
        
        task.resume()
        while(isLoad){}
        
    }
    
    func getCoachInfo(id: Int,token:String,handler:@escaping (_ re:coachResponese)-> Void)
    {
        // create post request
        let url = URL(string: "http://bp.dev.ingsoftware.com:9092/coaches/"+String(id))!
        
        var request = URLRequest(url: url)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer "+token ,forHTTPHeaderField:"Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request)  { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return    handler(self.coatchRes)
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            
            if let responseJSON = responseJSON as? [String: Any] {
                let status = responseJSON["status"] as? [String: Any]
                
                self.res.statusCode = status?["code"] as! String
                self.res.statusDescription = status?["desc"] as! String
                if status?["code"] as? String == "BP_200"{
                    var data = responseJSON["data"] as? [String: Any]
                    
                    
                    self.coatchRes.id = data!["id"] as? Int ?? -1
                    self.coatchRes.firstName = data?["firstName"] as? String! ?? ""
                    self.coatchRes.middleName = data?["middleName"] as? String! ?? ""
                    self.coatchRes.lastName = data?["lastName"] as? String! ?? ""
                    self.coatchRes.imageUrl = data?["photo"] as? String! ?? ""
                    
                    let str = NSURL(string :  self.coatchRes.imageUrl)
                    let dst = NSData(contentsOf: str! as URL)!
                    if dst != nil
                    {
                        self.coatchRes.image = (UIImage(data: dst as Data)!)
                    }
                    
                    let      team = data?["teams"] as? [[String : Any]]
                    for te in team!
                    {
                        var t = Team()
                        t.id = te["id"] as? Int ?? -1
                        
                        t.ageGrup = te["ageGrup"] as? String ?? ""
                        t.name = te["name"] as? String ?? ""
                        t.gender = te["gender"] as? String ?? ""
                        self.teams.append(t)
                    }
                    let setings = data?["mobileAppSettings"] as? [String: Any]
                    self.settings.autoDataSync = setings?["autoDataSync"] as? Bool ?? false
                    self.settings.language = setings?["language"] as? String ?? "EU"
                    self.settings.notificationsEnabled = setings?["notificationsEnabled"] as? Bool ?? false
                    
                }
                handler(self.coatchRes)
                
            }
            
        }
        task.resume()
        
    }
    
    func sendSettings(dataSync : Bool , notification : Bool , language : String,token:String,id:Int)
     {
     // vraca BP_500 ????
     let json: [String: Any] = ["autoDataSync": dataSync,
     "notificationsEnabled": notification,"language": language]
     let jsonData = try? JSONSerialization.data(withJSONObject: json)
     
     // create post request
     let url = URL(string: "http://bp.dev.ingsoftware.com:9092/coaches/"+String(id)+"/app_settings")!
     var request = URLRequest(url: url)
     request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
     request.setValue("Bearer "+token ,forHTTPHeaderField:"Authorization")
     request.httpMethod = "PUT"
     
     request.httpBody = jsonData
     
     let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            print(error?.localizedDescription ?? "No data")
            return
     }
        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
        if let responseJSON = responseJSON as? [String: Any] {
     
            if let status = responseJSON["status"] as? [String : Any]
            {
                    var code = status["code"] as? String ?? " "
                    if code == "BP_200"
                    {
                        return
                    }
                    else if code == "BP_403"
                    {
                        self.refreshToken(token: self.res.refreshToken)
                        self.sendSettings(dataSync: dataSync, notification: notification, language: language, token: self.res.token,id:id)
                    }
            }
     
     
        }
     
     }
     task.resume()
     }
     
     //func getCoachInfo(id: Int,token:String,handler:@escaping (_ re:coachResponese)-> Void)
    func getPlayersOfTeam(token:String , id: Int,handler:@escaping (_ player:[Players])-> Void)  {
    
        
        let url = URL(string: "http://bp.dev.ingsoftware.com:9092/teams/"+String(id)+"/players")
        
        var request = URLRequest(url: url!)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer "+token ,forHTTPHeaderField:"Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request)  { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return    handler(self.playerOnTeam)
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            
            if let responseJSON = responseJSON as? [String: Any] {
                var status = responseJSON["status"] as? [String : Any]
                if status?["code"] as? String == "BP_200"
                {
                let data = responseJSON["data"] as? [[String: Any]]
                    var i = 0
                    for player in data!
                    {
                        var pl = Players()
                        pl.id = player["id"] as? Int ?? -1
                        pl.firstName = player["firstName"] as? String ?? ""
                        pl.lastName = player["lastName"] as? String ?? ""
                        pl.middleName = player["middleName"] as? String ?? ""
                        pl.photoUrl = player["photo"] as? String ?? ""
                        if pl.photoUrl != ""
                        {
                            do{
                        try    self.getImage(urlImage:pl.photoUrl,index:i)
                            }
                            catch {
                                
                            }
                        
                        }
                        pl.postition = player["position"] as? String ?? ""
                        pl.beltName = player["beltNumber"] as? String ?? ""
                        self.playerOnTeam.append(pl)
                        i = i + 1
                    }
                
                }
                    
                    handler(self.playerOnTeam)
                    
                }
            
            }
        task.resume()

        }
    
        
  
    func getImage(urlImage : String,index : Int) throws
{
    let url = URL(string:urlImage)
    
    let task = URLSession.shared.dataTask(with: url!) { data, response, error in
        guard let data = data, error == nil else { return }
        if data.isEmpty
        {
            return
        }
     
        
       // DispatchQueue.main.sync() {
            if let image = UIImage(data: data){
             self.playerOnTeam[index].playerImage =  image
          //  }
        }
        
    
    }
    task.resume()
    }

    func getTraningSesionOfTeam(token:String , id: Int,handler:@escaping (_ ses :[traningSesion])-> Void)  {
        
        
        let url = URL(string: "http://bp.dev.ingsoftware.com:9092/teams/"+String(id)+"/sessions")
        
        var request = URLRequest(url: url!)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer "+token ,forHTTPHeaderField:"Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request)  { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return handler(self.sesion)

            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                     if let responseJSON = responseJSON as? [String: Any] {
                var status = responseJSON["status"] as? [String : Any]
                if status?["code"] as? String == "BP_200"
                {
                    let data = responseJSON["data"] as? [[String: Any]]
                 
                    for sesion in data!
                    {
                        var ses = traningSesion()
                        ses.id = sesion["id"] as? Int ?? -1
                        ses.teamId = sesion["teamId"] as? Int ?? -1
                        ses.started = sesion["started"] as? String ?? ""
                        ses.ended = sesion["ended"] as? String ?? ""
                       ses.uploadStatus = sesion["uploadStatus"] as? String ?? ""
                       
                       self.sesion.append(ses)
                    }
                    
                }
                        handler(self.sesion)

                
                
            }
            
        }
        task.resume()
        
    }

    
    func getPlayersOfSesionTranning(token:String , idTeam: Int,idSesion:Int,handler:@escaping (_ player:[Players])-> Void)  {
        
        
        let url = URL(string: "http://bp.dev.ingsoftware.com:9092/teams/"+String(idTeam)+"/sessions/"+String(idSesion))
        
        var request = URLRequest(url: url!)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer "+token ,forHTTPHeaderField:"Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request)  { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return    handler(self.playerOnTeam)
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            
            if let responseJSON = responseJSON as? [String: Any] {
                var status = responseJSON["status"] as? [String : Any]
                if status?["code"] as? String == "BP_200"
                {
                    let data = responseJSON["data"] as? [String: Any]
                  
                    var ses = traningSesion()
                    ses.id = data?["id"] as? Int ?? -1
                    ses.teamId = data?["teamId"] as? Int ?? -1
                    ses.ended = data?["ended"] as? String ?? ""
                    ses.started = data?["started"] as? String ?? ""
                    ses.uploadStatus = data?["uploadStatus"] as? String ?? ""
                    print(responseJSON["data"])
                    print( data?["playerActivities"])
                    let palyers = data?["playerActivities"] as? [[String : Any ]]
                    var i = 0
                    for play in palyers!
                    {
                        let pl = Players()
                        pl.id = play["playerId"] as? Int ?? -1
                        pl.firstName = play["playerName"] as? String ?? ""
                        pl.lastName = play["playerLastName"] as? String ?? ""
                        pl.middleName = play["playerMiddleName"] as? String ?? ""
                        pl.photoUrl = play["playerPhoto"] as? String ?? ""
                        if pl.photoUrl != ""
                        {
                            do{
                                try    self.getImage(urlImage:pl.photoUrl,index:i)
                            }
                            catch {
                                
                            }
                            
                        }
                      
                        pl.postition = play["playerPosition"] as? String ?? ""
                        pl.beltName = play["beltNum"] as? String ?? ""
                        pl.playerIdinSesion = play["playerIdinSesion"] as? Int ?? -1
                        
                         pl.teamActivityId=play["teamActivityId"] as? Int ?? -1
                         pl.dataUploaded = play["dataUploaded"] as? String ?? ""
                        pl.created = play["created"] as? String ?? ""
                      
                        i = i+1
                        
                        
                        self.playerOnTeam.append(pl)
                       
                    }
                    
                }
                
                handler(self.playerOnTeam)
                
            }
            
        }
        task.resume()
        
    }
    
    func getTraningSesionOnPlayer(token:String , idTeam: Int,idPlayer:Int,handler:@escaping (_ ses:[traningSesion])-> Void)  {
        
        ///teams/4/players/2/sessions
        let url = URL(string: "http://bp.dev.ingsoftware.com:9092/teams/"+String(idTeam)+"/players/"+String(idPlayer)+"/sessions")
        
        var request = URLRequest(url: url!)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer "+token ,forHTTPHeaderField:"Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request)  { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return    handler(self.sesion)
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            
            if let responseJSON = responseJSON as? [String: Any] {
                var status = responseJSON["status"] as? [String : Any]
                
                var g = status?["code"]
                print(g)
                if status?["code"] as? String == "BP_200"
                {
                    let data = responseJSON["data"] as? [[String: Any]]
                    for da in data!
                    {
                    var ses = traningSesion()
                    ses.id = da["id"] as? Int ?? -1
                    ses.teamId = da["teamId"] as? Int ?? -1
                    ses.ended = da["ended"] as? String ?? ""
                    ses.started = da["started"] as? String ?? ""
                    ses.uploadStatus = da["uploadStatus"] as? String ?? ""
                    
                    self.sesion.append(ses)
                    }
                }
                
                handler(self.sesion)
                
            }
            
        }
        task.resume()
        
    }

     
}


struct loginResponse {
    
    var statusCode = "404"
    var statusDescription =  "Server not responding"
    var token = String()
    var refreshToken = String()
    var data = String()
}

struct coachResponese
{
    var id = Int()
    var   firstName = String()
    var middleName = String()
    var lastName = String()
    var imageUrl = String()
    var image = UIImage()
    
}
struct Team
{
    var id = Int()
    var name = String()
    var gender = String()
    var ageGrup = String()
}
struct SettingsData
{
    var autoDataSync = Bool()
    var notificationsEnabled = Bool()
    var language = String()
}

struct traningSesion{
 var id = Int()
 var teamId = Int()
 var started = String()
 var ended = String()
 var uploadStatus = String()
}

