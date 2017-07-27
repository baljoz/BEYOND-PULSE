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
    @IBOutlet weak var passwordIcon: UIImageView!

    
    @IBOutlet weak var check: UISwitch!
    @IBOutlet weak var emailIcon: UIImageView!
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
     
        let colorback = UIColor(red: 31.0/255.0, green: 31.0/255.0, blue: 31.0/255.0, alpha: 1.0)
        textfieldView.backgroundColor = colorback.withAlphaComponent(0.8)
        textfieldView.layer.borderWidth = 1
        let color = UIColor(red: 61.0/255.0, green: 61.0/255.0, blue: 61.0/255.0, alpha: 0.6)
        
        textfieldView.layer.borderColor = color.cgColor
        textfieldView.layer.cornerRadius=5

        
       // let loginButton = UIButton(frame: CGRect(x: 10, y: 50, width: 300, height: 30))
       // self.view.addSubview(loginButton)
        
        let gradient:CAGradientLayer = CAGradientLayer()
        let colorBottom = UIColor(red: 158.0/255.0, green: 33.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        let colorTop = UIColor(red: 255.0/255.0, green: 156.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        //colorBottom
        gradient.colors = [colorTop, colorBottom]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.frame = continueButton.bounds
        gradient.cornerRadius = 2
        
        continueButton.layer.addSublayer(gradient)
        
        
        continueButton.layer.cornerRadius=10
          emailIcon.contentMode = .scaleAspectFit
        passwordIcon.contentMode = .scaleAspectFit // Do any additional setup after loading the view.
        check.transform = CGAffineTransform(scaleX: 0.6, y: 0.6);
        if let cek = UserDefaults.standard.object(forKey: "switch")  {
            if cek as! Bool == true {
            
            check.isOn = cek as! Bool
            eMailTextfild.text = UserDefaults.standard.object(forKey: "email") as? String
            passwordTextfild.text = UserDefaults.standard.object(forKey: "password") as? String
            }
        }
       
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
        
        let userDefaults = UserDefaults.standard
        if check.isOn{
            
            userDefaults.set(eMailTextfild.text, forKey: "email")
            userDefaults.set(passwordTextfild.text,forKey:"password")
        }
        userDefaults.set(check.isOn,forKey:"switch")
        userDefaults.synchronize()
        
        JSON.loginGetToken(username: eMailTextfild.text!,password: passwordTextfild.text!) { (ress:loginResponse) -> Void in
        
          
            if ress.stat.statusCode == "BP_200"
             {
                self.sing.loadingInfo = ress
                let id  = self.getTokenIdCoach(token: ress.token)
                self.JSON.getCoachInfo(id: id, token: ress.token) { (coa:CoachInfo) -> Void in
                 
                    if coa.stat.statusCode == "BP_200"
                    {
                    self.sing.coatch = coa
                    
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "team") as! SWRevealViewController
                    
                    newViewController.sirnaslajdera = (self.view.frame.size.width / 3) * 2
                
                    let next = newViewController
                    DispatchQueue.main.async {
                        
                    self.present(next, animated: true, completion: nil)
                        }
                    }
                    
                    else if coa.stat.statusCode == "BP_403"
                    {
                        self.JSON.refreshToken(token: ress.refreshToken) {(res:loginResponse)-> Void in
                            self.sing.loadingInfo = res
                            let id  = self.getTokenIdCoach(token: ress.token)
                            self.JSON.getCoachInfo(id: id, token: ress.token) { (coa:CoachInfo) -> Void in
                                
                                if coa.stat.statusCode == "BP_200"
                                {
                                    self.sing.coatch = coa
                                    
                                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "team") as! SWRevealViewController
                                    
                                    newViewController.sirnaslajdera = (self.view.frame.size.width / 3) * 2
                                    
                                    let next = newViewController
                                    DispatchQueue.main.async {
                                        
                                        self.present(next, animated: true, completion: nil)
                                        
                                    }

                            
                                }
                            }
                        }
                    }
                }
            }
            else{
               
                DispatchQueue.main.async {
               let popUp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "alterView") as! AlterViewController
                popUp.custom = true
                popUp.titles = "Erorr"
                popUp.message = ress.stat.statusDescription
                
                //popUp.comitButton.isHidden = true
                self.addChildViewController(popUp)
                popUp.view.frame = self.view.frame
                self.view.addSubview(popUp.view)
                
                popUp.didMove(toParentViewController: self)
                }}
        
      
    }
    }
    //
    //on token get id
    func getTokenIdCoach(token : String) -> Int
    {
         var id = -1
        do {
                let claims = try decode(jwt: token)
                var body = claims.body  as? [String : Any]
            
                 id = Int((body?["sub"] as? String)!)!
            } catch {
                print("Failed to decode JWT: \(error)")
        }
        return id
        }
    

}
