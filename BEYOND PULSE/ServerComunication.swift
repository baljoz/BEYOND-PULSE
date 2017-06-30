//
//  ServerComunication.swift
//  BEYOND PULSE
//
//  Created by Milos Stosic on 6/27/17.
//  Copyright © 2017 Milos Stosic. All rights reserved.
//

import Foundation

struct response {

    var statusCode = "404"
    var statusDescription =  "Server not responding"
    var token = String()
    var refreshToken = String()
    var data = String()
}
class serverCommunications
{
    
    var   res = response()
    var isLoad = false
    init() {
    }
    
   // func loginGetToken(username: String,password : String)
    func loginGetToken(username: String,password : String, handler:@escaping (_ re:response)-> Void)
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
                handler(self.res)
               //  self.isLoad = true
            }
            
            }
            

        task.resume()
      //  while (!isLoad) {}
       
        
    }
   // func Login(username:String,password:String) -> response
   // {
     //   loginGetToken(username:username,password: password)
      //  return res
    //}
    
  /*  func resetPassword (email : String) -> response
    {
        ForgootPassword( email : email)
        return res
    }*/
    
    func ForgootPassword( email : String,handler:@escaping (_ re:response)-> Void)
    {
    let json: [String: Any] = ["email": email]
                               
    
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    
    // create post request
    let url = URL(string: "http://bp.dev.ingsoftware.com:9092/password_reset")!
    var request = URLRequest(url: url)
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    
        
        /*
 
         "data": "Sent mail with reset password instructions",
         "status": {
         "code": "BP_200",
         "desc": "Success"
         }
 */
    // insert json data to the request
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
             //self.isLoad = true
            handler(self.res)
            }
        
        }
        
    task.resume()
   // while (!isLoad) {}
    
    
}

    
    func ForgootPassword( token : String)
    {
        let json: [String: Any] = ["refresh": token]
        
        
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
                self.isLoad = true
            }
            
        }
        
        task.resume()
        while (!isLoad) {}
        
        
    }

    
    


}
