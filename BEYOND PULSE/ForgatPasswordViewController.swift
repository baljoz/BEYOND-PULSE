//
//  ForgatPasswordViewController.swift
//  BEYOND PULSE
//
//  Created by Milos Stosic on 6/8/17.
//  Copyright © 2017 Milos Stosic. All rights reserved.
//

import UIKit

class ForgatPasswordViewController: UIViewController {

    @IBOutlet weak var mailView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    var JOSN = serverCommunications()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        emailTextField.leftViewMode = UITextFieldViewMode.always
        emailTextField.leftView = UIImageView(image: UIImage(named: "mesage"))
        
        submitButton.layer.cornerRadius = 1;
        //submitButton.layer.borderWidth = 1;
        submitButton.layer.cornerRadius=10
        
        let img = UIImageView(image: UIImage(named: "mesage"))
        img.frame=CGRect(x:0.0, y:0.0, width:(img.image?.size.width)!+10.0, height:(img.image?.size.height)!)
        img.contentMode = .left
        emailTextField.leftView = img
        emailTextField.leftViewMode = .always
        
        mailView.layer.cornerRadius = 2;
       // mailView.layer.borderWidth = 1;
        //textfieldView.layer.borderColor = UIColor(red: 128, green: 128, blue: 128, alpha: 1).cgColor
        //   login.layer.cornerRadius=10
       mailView.layer.cornerRadius=10


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func resetPassword(_ sender: Any)
    {
        
    JOSN.ForgootPassword(email: emailTextField.text!){ (ress:loginResponse) -> Void in
        
        if ress.statusCode == "BP_200"
        {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "resetPassword")
            self.present(newViewController, animated: true, completion: nil)
        }
        else
        {
            let alert = UIAlertController(title: "Alert", message:ress.statusDescription, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }

}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
