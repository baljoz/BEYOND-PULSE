//
//  LoginViewController.swift
//  BEYOND PULSE
//
//  Created by Milos Stosic on 6/8/17.
//  Copyright © 2017 Milos Stosic. All rights reserved.
//

import UIKit
import JWTDecode

class LoginViewController: UIViewController {

    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var textfieldView: UIView!
    @IBOutlet weak var passwordTextfild: UITextField!
    @IBOutlet weak var eMailTextfild: UITextField!
    
    var JSON = serverCommunications()
    
    override func viewDidLoad() {
        
        
          dek()
        super.viewDidLoad()
        eMailTextfild.leftViewMode = UITextFieldViewMode.always
        let img = UIImageView(image: UIImage(named: "mesage"))
        img.frame=CGRect(x:0.0, y:0.0, width:(img.image?.size.width)!+10.0, height:(img.image?.size.height)!)
        img.contentMode = .left
        eMailTextfild.leftView = img
        eMailTextfild.leftViewMode = .always
            //UIImageView(image: UIImage(named: "mesage"))//mesage
        passwordTextfild.leftViewMode = UITextFieldViewMode.always
        let img2 = UIImageView(image: UIImage(named: "lock"))
        img2.frame=CGRect(x:0.0, y:0.0, width:(img.image?.size.width)!+10.0, height:(img.image?.size.height)!)
        img2.contentMode = .left
        passwordTextfild.leftView = img2
        passwordTextfild.leftViewMode = .always
      //  passwordTextfild.leftView = UIImageView(image: UIImage(named: "lock"))
        //textfieldView.frame.
        textfieldView.layer.cornerRadius = 2;
        textfieldView.layer.borderWidth = 1;
        //textfieldView.layer.borderColor = UIColor(red: 128, green: 128, blue: 128, alpha: 1).cgColor
        //   login.layer.cornerRadius=10
        textfieldView.layer.cornerRadius=10

        continueButton.layer.cornerRadius = 1;
        //continueButton.layer.borderWidth = 1;
        //textfieldView.layer.borderColor = UIColor(red: 128, green: 128, blue: 128, alpha: 1).cgColor
        //   login.layer.cornerRadius=10
        continueButton.layer.cornerRadius=10
        
        // Do any additional setup after loading the view.
               }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onClickContinue(_ sender: Any) {
        
 
        
        JSON.loginGetToken(username: eMailTextfild.text!,password: passwordTextfild.text!) { (ress:response) -> Void in
        
            
            if ress.statusCode == "BP_200"
             {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "team") as! SWRevealViewController
            
            newViewController.sirnaslajdera = (self.view.frame.size.width / 3) * 2
            let next = newViewController
            self.present(next, animated: true, completion: nil)
            }

            else{
                let alert = UIAlertController(title: "Alert", message:ress.statusDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)

            }
        }
      
   //   let res = JSON.Login(username: eMailTextfild.text!,password: passwordTextfild.text!)
        
       // if res.statusCode == "BP_200"
       // {
         /*   let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "team") as! SWRevealViewController
           
            newViewController.sirnaslajdera = (self.view.frame.size.width / 3) * 2
            let next = newViewController
            self.present(next, animated: true, completion: nil)
            */
 
       /* }
        else
        {
            let alert = UIAlertController(title: "Alert", message:res.statusDescription, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    */
   
    }

    func dek()
    {
        
        do {
            // the token that will be decoded
            let token = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI2IiwiaWF0IjoxNDk5MDY1OTk0LCJleHAiOjE0OTkwNjk1OTQsInR5cGUiOiJhY2Nlc3MifQ.2wbgOdL6yYxXQsS8YeyiaPwjBQ5XHC4IzWIbyT1NnzqghpBB2VZBTOZjrRcidLXEnAYP0JPxkaJOMMELnCRH0A"
           
          //  let payload = try JWT.decode(jwt: token,algorithm: .hs256("secret".data(using: .utf8)!))
        //    print(payload)
      //  } catch {
      //      print("Failed to decode JWT: \(error)")
     //   }
    do {
            let claims = try decode(jwt: token)
        //;JWT.decode("eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI2IiwiaWF0IjoxNDk5MDY1OTk0LCJleHAiOjE0OTkwNjk1OTQsInR5cGUiOiJyZWZyZXNoIiwidmVyc2lvbiI6MX0.ykKj6iIsN09cU6fS74dDEL4InwbTt4GJn9LgYgkkrKuzm9XeQk7zXQfZvNRJrX3vQ0XnQynf0mjurDW2GgMYuw", algorithm: .hs512("encoded".data(using: .utf8)!))
       var g = claims.body  as? [String: Any]
        print(claims.body)
            print(g?["iat"])
        } catch {
            print("Failed to decode JWT: \(error)")
        }
    }
}
}
