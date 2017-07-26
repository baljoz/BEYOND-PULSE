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
        
        
        let gradient:CAGradientLayer = CAGradientLayer()
        let colorBottom = UIColor(red: 158.0/255.0, green: 33.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        let colorTop = UIColor(red: 255.0/255.0, green: 156.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        //colorBottom
        gradient.colors = [colorTop, colorBottom]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.frame = submitButton.bounds
        gradient.cornerRadius = 2
        
        submitButton.layer.masksToBounds = true
        submitButton.layer.addSublayer(gradient)

        let col = UIColor(red: 31.0/255.0, green: 31.0/255.0, blue: 31.0/255.0, alpha: 1.0)
        mailView.backgroundColor = col.withAlphaComponent(0.6)
       mailView.layer.cornerRadius=5
    
        mailView.layer.borderWidth = 1
    mailView.layer.borderColor = UIColor(red: 61.0/255.0, green: 61.0/255.0, blue: 61.0/255.0, alpha: 1).cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func resetPassword(_ sender: Any)
    {
        
    JOSN.ForgootPassword(email: emailTextField.text!){ (ress:loginResponse) -> Void in
        
        if ress.stat.statusCode == "BP_200"
        {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "resetPassword")
            self.present(newViewController, animated: true, completion: nil)
        }
        else
        {
            
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
            }
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
