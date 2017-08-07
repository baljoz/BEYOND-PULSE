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
    var sing = MySingleton.sharedInstance
    var idSesion = Int()
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
                return    handler(loginResponse())
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            var response = loginResponse()

            if let responseJSON = responseJSON as? [String: Any] {
                let status = responseJSON["status"] as? [String: Any]
              
                response.stat.statusCode = status?["code"] as! String
                response.stat.statusDescription = status?["desc"] as! String
                if status?["code"] as? String == "BP_200"{
                    var data = responseJSON["data"] as? [String: Any]
                    
                    response.token = (data?["accessToken"] as? String)!
                    response.refreshToken = (data?["refreshToken"] as? String)!
                    
                    
                }
                
             
            }
            handler(response)
            
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
                
                self.res.stat.statusCode = status?["code"] as! String
                self.res.stat.statusDescription = status?["desc"] as! String
                if self.res.stat.statusCode == "BP_200"
                {
                    self.res.data = responseJSON["data"] as! String
                }
                handler(self.res)
            }
            
        }
        
        task.resume()
        
        
        
    }
    
    //get new token
    func refreshToken( token : String,handler:@escaping (_ info:loginResponse)-> Void)
    {
        var loginRes = loginResponse()
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
                handler(loginRes)
                print(error?.localizedDescription ?? "No data")
                return handler(loginRes)
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                let status = responseJSON["status"] as? [String: Any]
                
                loginRes.stat.statusCode = status?["code"] as! String
                loginRes.stat.statusDescription = status?["desc"] as! String
                if loginRes.stat.statusCode == "BP_200"
                {
                    var data = responseJSON["data"] as! [String: Any]
                    loginRes.refreshToken = data["refreshToken"] as! String
                    loginRes.token = data["accessToken"] as! String
                    
                }
                
            }
            handler(loginRes)
          
        }
        
        task.resume()
        
        
    }
    
    func getCoachInfo(id: Int,token:String,handler:@escaping (_ coa:CoachInfo)-> Void)
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
                
                self.sing.loadingInfo.stat.statusCode = "Erorr"
                self.sing.loadingInfo.stat.statusDescription = (error?.localizedDescription as? String)!
                
                return    handler(CoachInfo())
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            
            if let responseJSON = responseJSON as? [String: Any] {
                let statuss = responseJSON["status"] as? [String: Any]
                var checkStatus = status()
                
                checkStatus.statusCode = statuss?["code"] as! String
                checkStatus.statusDescription = statuss?["desc"] as! String
                var couch = coachResponese()
                var teams = [Team]()
                var sett = SettingsData()
                var clu = club()
                if statuss?["code"] as? String == "BP_200"{
                    
                    var data = responseJSON["data"] as? [String: Any]
                    
                    
                    couch.id = data!["id"] as? Int ?? -1
                   couch.firstName = data?["firstName"] as? String! ?? ""
                    couch.middleName = data?["middleName"] as? String! ?? ""
                    couch.lastName = data?["lastName"] as? String! ?? ""
                    couch.imageUrl = data?["photo"] as? String! ?? ""
                    
                    let str = NSURL(string :couch.imageUrl)
                    let dst = NSData(contentsOf: str! as URL)!
                    if dst != nil
                    {
                        couch.image = (UIImage(data: dst as Data)!)
                    }
                    
                    let cl = data?["club"] as? [String:Any]
                    clu.id = cl?["id"] as? Int ?? -1
                    clu.name = cl?["name"] as? String ?? " "
                    clu.imageUrl = cl?["logo"] as? String ?? ""
                    let logoUrl = NSURL(string : clu.imageUrl)
                    let logoData = NSData(contentsOf: logoUrl! as URL)!
                    if logoData != nil
                    {
                        clu.image = (UIImage(data: logoData as Data)!)
                    }

                    
                    let      team = data?["teams"] as? [[String : Any]]
                    for te in team!
                    {
                        var t = Team()
                        t.id = te["id"] as? Int ?? -1
                        
                        t.ageGrup = te["ageGrup"] as? String ?? ""
                        var cName = data?["club"] as! [String : Any]
                        t.name = cName["name"] as? String ?? ""
                        t.name.append(" ")
                        t.name.append(te["name"] as? String ?? "")
                        t.urlImage = cName["logo"] as? String ?? ""
                        let str = NSURL(string : t.urlImage)
                        if let dstt = NSData(contentsOf: str! as URL)
                        {
                       
                            t.img = (UIImage(data: dstt as Data)!)
                        
                        }
                        t.gender = te["gender"] as? String ?? ""
                        teams.append(t)
                    }
                    let setings = data?["mobileAppSettings"] as? [String: Any]
                    sett.autoDataSync = setings?["autoDataSync"] as? Bool ?? false
                    sett.language = setings?["language"] as? String ?? "EU"
                    sett.notificationsEnabled = setings?["notificationsEnabled"] as? Bool ?? false
                    
                    var coa = CoachInfo()
                    coa.info = couch
                    coa.settings = sett
                    coa.coutchClub = clu
                    coa.team = teams
                    coa.stat = checkStatus
                    handler(coa)
                }
              else if statuss?["code"] as? String == "BP_403"
                {
                    self.refreshToken(token: self.sing.loadingInfo.refreshToken) { (ress:loginResponse) -> Void in
                        self.sing.loadingInfo = self.res
                        self.getCoachInfo(id: id, token: ress.token) { (coac:CoachInfo) -> Void in
                            
                            
                     handler(coac)
                        
                        
                }
                
            }
                }
        
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
            
            self.sing.loadingInfo.stat.statusCode = "Erorr"
            self.sing.loadingInfo.stat.statusDescription = (error?.localizedDescription)!
            
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
                        self.refreshToken(token: self.res.refreshToken){  ( res:loginResponse)-> Void in
                            
                            self.sendSettings(dataSync: dataSync, notification: notification, language: language, token: res.token,id:id) }
                    }
            }
     
     
        }
     
     }
     task.resume()
     }
     

    func getPlayersOfTeam(token:String , id: Int,handler:@escaping (_ player:[Players])-> Void)  {
    
        
        let url = URL(string: "http://bp.dev.ingsoftware.com:9092/teams/"+String(id)+"/players")
        
        var request = URLRequest(url: url!)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer "+token ,forHTTPHeaderField:"Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request)  { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                
                self.sing.loadingInfo.stat.statusCode = "Erorr"
                self.sing.loadingInfo.stat.statusDescription = (error?.localizedDescription)!
                return    handler([Players]())
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            
            if let responseJSON = responseJSON as? [String: Any] {
                var status = responseJSON["status"] as? [String : Any]
                var play = [Players]()
                self.sing.loadingInfo.stat.statusCode = (status?["code"] as? String)!
                self.sing.loadingInfo.stat.statusDescription = (status?["desc"] as? String)!
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
                                try    self.getImage(urlImage:pl.photoUrl,index:i) { ( img:UIImage)-> Void in

                                    pl.playerImage = img
                                }
                            }
                            catch {
                                
                            }
                        
                        }
                        pl.postition = player["position"] as? String ?? ""
                        pl.beltName = player["beltNumber"] as? String ?? ""
                        pl.weight = player["weight"] as? Float ??  -1
                        pl.height = player["height"] as? Float ?? -1
                        pl.gender = player["gender"] as? String ?? ""
                        pl.maxHeartRate = player["maxHeartRate"] as? Int ?? -1
                        pl.age = player["age"] as? Int ?? -1
                        play.append(pl)
                        i = i + 1
                    }
                    handler(play)

                }
                    
                else if status?["code"] as? String == "BP_403"
                {
                    self.refreshToken(token: self.res.refreshToken){  ( res:loginResponse)-> Void in
                        self.sing.loadingInfo = res
                       self.getPlayersOfTeam(token:res.token , id: id) { ( player:[Players])-> Void in
                        
                        handler(play)
                        
                }

                }
            
            }
        }
    }
        task.resume()

        }
    
        
  
    func getImage(urlImage : String,index : Int,handler:@escaping (_ img:UIImage)-> Void) throws
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
             handler(image)          //  }
        }
        
    
    }
    task.resume()
    }

    func getTraningSesionOfTeam(token:String , id: Int,page:Int,handler:@escaping (_ session  :[traningSesion])-> Void)  {
        
        var sesions = [traningSesion]()
        let url = URL(string: "http://bp.dev.ingsoftware.com:9092/teams/"+String(id)+"/sessions?page="+String(page)+"&size=5")
        
        var request = URLRequest(url: url!)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer "+token ,forHTTPHeaderField:"Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request)  { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                self.sing.loadingInfo.stat.statusCode = "Erorr"
                self.sing.loadingInfo.stat.statusDescription = (error?.localizedDescription)!
                return handler(sesions)

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
                       
                       sesions.append(ses)
                    }
                    
                }
                        handler(sesions)

                
                
            }
            
        }
        task.resume()
        
    }

    
    func getPlayersOfSesionTranning(token:String , idTeam: Int,idSesion:Int,handler:@escaping (_ player:playerOfSessions)-> Void)  {
        
        var pos = playerOfSessions()
        
        let url = URL(string: "http://bp.dev.ingsoftware.com:9092/teams/"+String(idTeam)+"/sessions/"+String(idSesion))
        
        var request = URLRequest(url: url!)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer "+token ,forHTTPHeaderField:"Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request)  { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                
                self.sing.loadingInfo.stat.statusCode = "Erorr"
                self.sing.loadingInfo.stat.statusDescription = (error?.localizedDescription)!
                
                return    handler(pos)
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
               
                    pos.sesion = ses
                
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
                                try    self.getImage(urlImage:pl.photoUrl,index:i) { ( img:UIImage)-> Void in
                                    pl.playerImage = img
                                }
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
                        
                        
                        pos.player.append(pl)
                       
                    }
                    
                }
                
                handler(pos)
                
            }
            
        }
        task.resume()
        
    }
    
    func getTraningSesionOnPlayer(token:String , idTeam: Int,idPlayer:Int,handler:@escaping (_ ses:[traningSesion])-> Void)  {
        
        var sesion = [traningSesion]()
        // treba pejdzing da se implementira
        let url = URL(string: "http://bp.dev.ingsoftware.com:9092/teams/"+String(idTeam)+"/players/"+String(idPlayer)+"/sessions")
        
        var request = URLRequest(url: url!)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer "+token ,forHTTPHeaderField:"Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request)  { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                
                self.sing.loadingInfo.stat.statusCode = "Erorr"
                self.sing.loadingInfo.stat.statusDescription = (error?.localizedDescription)!
                
                return    handler(sesion)
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            
            if let responseJSON = responseJSON as? [String: Any] {
                var status = responseJSON["status"] as? [String : Any]
                
          
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
                    
                    sesion.append(ses)
                    }
                }
                
                handler(sesion)
                
            }
            
        }
        task.resume()
        
    }
    func getPlayerDetails(token:String , idTeam: Int,idPlayer:Int,handler:@escaping (_ player:Players)-> Void)  {
        
       var playe = Players()
        
        let url = URL(string: "http://bp.dev.ingsoftware.com:9092/teams/"+String(idTeam)+"/players/"+String(idPlayer))
        
        var request = URLRequest(url: url!)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer "+token ,forHTTPHeaderField:"Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request)  { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                
                self.sing.loadingInfo.stat.statusCode = "Erorr"
                self.sing.loadingInfo.stat.statusDescription = (error?.localizedDescription)!
                
                return    handler(playe)
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            
            if let responseJSON = responseJSON as? [String: Any] {
                var status = responseJSON["status"] as? [String : Any]
                if status?["code"] as? String == "BP_200"
                {
                    let data = responseJSON["data"] as? [String: Any]
                    
                    var i = 0
                    
                        let pl = Players()
                        pl.id = data?["id"] as? Int ?? -1
                        pl.firstName = data?["firstName"] as? String ?? ""
                        pl.lastName = data?["lastName"] as? String ?? ""
                        pl.middleName = data?["middleName"] as? String ?? ""
                        pl.photoUrl = data?["photo"] as? String ?? ""
                        if pl.photoUrl != ""
                        {
                            do{
                                try    self.getImage(urlImage:pl.photoUrl,index:i) { ( img:UIImage)-> Void in
                                    
                                        pl.playerImage = img
                                
                                }
                            }
                            catch {
                                
                            }
                            
                        }
                        
                        pl.postition = data?["position"] as? String ?? ""
                        pl.beltName = data?["beltNumber"] as? String ?? ""
                        pl.dob = data?["dob"] as? String ?? ""
                        i = i+1
                        pl.height = (data?["height"] as? Float)!
                    pl.weight = (data?["weight"] as? Float)!
                    pl.gender = (data?["gender"] as? String)!
                    pl.maxHeartRate = (data?["maxHeartRate"] as? Int)!
                    pl.age = (data?["age"] as? Int)!
                        playe = pl
                        
                    
                    
                }
                
                handler(playe)
                
            }
            
        }
        task.resume()
        
    }
   //TESTIRANAAA RADI SAMO JE SOTALO DA SE UKLOPI TAMO GDE TREA!!!!
    func updatePlayerBelt(token:String , idTeam: Int,idPlayer:Int,beltNumber:String)

    {
        // vraca BP_500 ????
        let json: [String: Any] = ["beltNumber": beltNumber]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // /teams/4/players/2
        let url = URL(string: "http://bp.dev.ingsoftware.com:9092/teams/"+String(idTeam)+"/players/"+String(idPlayer))!
        var request = URLRequest(url: url)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer "+token ,forHTTPHeaderField:"Authorization")
        request.httpMethod = "PUT"
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                
                self.sing.loadingInfo.stat.statusCode = "Erorr"
                self.sing.loadingInfo.stat.statusDescription = (error?.localizedDescription)!
                
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
                        self.refreshToken(token: self.res.refreshToken){  ( res:loginResponse)-> Void in
                        self.updatePlayerBelt(token:res.token,idTeam: idTeam,idPlayer: idPlayer,beltNumber: beltNumber)
                        }}
                }
                
                
            }
            
        }
        task.resume()
    }
    
    
//Proverena .... radi ali msm da ce treba malo drugojacije da se implementira
    func createNewTraningSessins(token:String , idTeam: Int,sessionStart:String,sessionEnd:String,idPlayers:[Int])    {
    
        let json: [String: Any] = ["started": sessionStart,
                                   "ended": sessionEnd,"playerIds":idPlayers]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // /teams/4/sessions
        let url = URL(string: "http://bp.dev.ingsoftware.com:9092/teams/"+String(idTeam)+"/sessions")!
        var request = URLRequest(url: url)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer "+token ,forHTTPHeaderField:"Authorization")
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request)  { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                
                
                self.sing.loadingInfo.stat.statusCode = "Erorr"
                self.sing.loadingInfo.stat.statusDescription = (error?.localizedDescription)!
                
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                let status = responseJSON["status"] as? [String: Any]
                var code = status?["code"] as? String ?? ""
                if code == "BP_200"
                {
                    self.idSesion = responseJSON["data"] as? Int ?? 0
                }
                else {
                    //hvali za not found za token ..... treba da se izhendluje
                }
            }
        }
        task.resume()
    }
    // Testirana radi 
    
    func updatePlayerTraningSessionsData(token:String , idTeam: Int,idSession:Int,beltNumber:String,idPlayer:Int,strideRate: [Int],numberOfSteps:[Int],heartRate:[Int])
        
    {
        var nos = [Int]()
        nos.append(5)
        nos.append(5)
        nos.append(5)
        // vraca BP_500 ????
        let json: [String: Any] = ["beltNumber": beltNumber,"playerId":idPlayer,"strideRate":strideRate,"numberOfSteps":numberOfSteps,"heartRate":heartRate]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // }/teams/4/sessions/6
        let url = URL(string: "http://bp.dev.ingsoftware.com:9092/teams/"+String(idTeam)+"/sessions/"+String(idSession))!
        var request = URLRequest(url: url)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer "+token ,forHTTPHeaderField:"Authorization")
        request.httpMethod = "PUT"
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                
                self.sing.loadingInfo.stat.statusCode = "Erorr"
                self.sing.loadingInfo.stat.statusDescription = (error?.localizedDescription)!
                
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
                if let status = responseJSON["status"] as? [String : Any]
                {
                    var code = status["code"] as? String ?? " "
                    if code == "BP_200"
                    {
                        return
                    }
                 
                }
                
                
            }
            
        }
        task.resume()
    }

     
}
struct status{
    var statusCode = "404"
    var statusDescription =  "Server not responding"

}

struct loginResponse {
    var stat = status()
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
    var urlImage = String()
    var img = UIImage()
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
struct club{
    var id = Int()
    var name = String()
    var imageUrl = String()
    var image = UIImage()
}
struct CoachInfo
{
    var stat = status()
    var info = coachResponese()
    var settings = SettingsData()
    var team = [Team]()
    var coutchClub = club()
}
struct playerOfSessions
{
    var sesion = traningSesion()
    var player = [Players]()
}
