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
    @IBOutlet weak var viewe: UIView!
    
    var sing = MySingleton.sharedInstance
    
    var JSON = serverCommunications()
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        eMailTextfild.leftViewMode = UITextFieldViewMode.always
        let img = UIImageView(image: UIImage(named: "mesage"))
        img.frame=CGRect(x:0.0, y:0.0, width:(img.image?.size.width)!+10.0, height:(img.image?.size.height)!)
        img.contentMode = .left
        eMailTextfild.leftView = img
        eMailTextfild.leftViewMode = .always
        passwordTextfild.leftViewMode = UITextFieldViewMode.always
        let img2 = UIImageView(image: UIImage(named: "lock"))
        img2.frame=CGRect(x:0.0, y:0.0, width:(img.image?.size.width)!+10.0, height:(img.image?.size.height)!)
        img2.contentMode = .left
        passwordTextfild.leftView = img2
        passwordTextfild.leftViewMode = .always
        textfieldView.layer.cornerRadius = 2;
        textfieldView.layer.borderWidth = 1;
        textfieldView.layer.cornerRadius=10

        continueButton.layer.cornerRadius = 1;
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
        
 
        
        JSON.loginGetToken(username: eMailTextfild.text!,password: passwordTextfild.text!) { (ress:loginResponse) -> Void in
        
            
            if ress.stat.statusCode == "BP_200"
             {
                self.sing.loadingInfo = ress
                let id  = self.getTokenIdCoach(token: ress.token)
                self.JSON.getCoachInfo(id: id, token: ress.token) { (coa:CoachInfo) -> Void in
                 
                    self.sing.coatch = coa
                    //self.sing.settings = coa.settings
                    
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "team") as! SWRevealViewController
                    
                    newViewController.sirnaslajdera = (self.view.frame.size.width / 3) * 2
                
                    let next = newViewController
                    DispatchQueue.main.async {
                        
                    self.present(next, animated: true, completion: nil)
                 
                    }
                }
            }
            else{
                let alert = UIAlertController(title: "Alert", message:ress.stat.statusDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)

            }
        }
      
    }
    //
    //on token get id
    func getTokenIdCoach(token : String) -> Int
    {
         var id = -1
        do {
                let claims = try decode(jwt: token)
                var body = claims.body  as? [String: Any]
            
                 id = Int((body?["sub"] as? String)!)!
            } catch {
                print("Failed to decode JWT: \(error)")
        }
        return id
        }
    

}
