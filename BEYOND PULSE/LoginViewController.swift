//
//  LoginViewController.swift
//  BEYOND PULSE
//
//  Created by Milos Stosic on 6/8/17.
//  Copyright © 2017 Milos Stosic. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var textfieldView: UIView!
    @IBOutlet weak var passwordTextfild: UITextField!
    @IBOutlet weak var eMailTextfild: UITextField!
    
    var JSON = serverCommunications()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eMailTextfild.leftViewMode = UITextFieldViewMode.always
        eMailTextfild.leftView = UIImageView(image: UIImage(named: "mesage"))//mesage
        passwordTextfild.leftViewMode = UITextFieldViewMode.always
        passwordTextfild.leftView = UIImageView(image: UIImage(named: "lock"))
        //textfieldView.frame.
        textfieldView.layer.cornerRadius = 2;
        textfieldView.layer.borderWidth = 1;
        //textfieldView.layer.borderColor = UIColor(red: 128, green: 128, blue: 128, alpha: 1).cgColor
        //   login.layer.cornerRadius=10
        textfieldView.layer.cornerRadius=10

        continueButton.layer.cornerRadius = 1;
        continueButton.layer.borderWidth = 1;
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
   
}
