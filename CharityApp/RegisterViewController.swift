//
//  RegisterViewController.swift
//  CharityApp
//
//  Created by Виталий Волков on 13.06.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import UIKit
import CryptoSwift

class RegisterViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var NameField: UITextField!

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var LoginField: UITextField!
    
    @IBOutlet weak var PasswordField: UITextField!
    let def = NSUserDefaults.standardUserDefaults()
    override func viewDidLoad() {
        super.viewDidLoad()
        NameField.delegate = self
        LoginField.delegate = self
        PasswordField.delegate = self
        NameField.text = def.valueForKey("Uname") as? String ?? ""
        //LoginField.text = def.valueForKey("email") as? String ?? ""
        let photoURL = def.valueForKey("photo") as? String ?? "http://chumanity.ru/noavatar.png"
        let url = NSURL(string: photoURL)
        photo.sd_setImageWithURL(url)
        // Do any additional setup after loading the view.
    }

    @IBAction func RegisterClicked(sender: AnyObject) {
        
        def.setValue(NameField.text, forKey: "Uname")
        def.setValue(PasswordField.text?.md5(), forKey: "pass")
        def.setValue(LoginField.text, forKey: "user")
        
        server().Registration{(result) in
            if (result==true)
            {
                SweetAlert().showAlert("Готово!", subTitle: "Вы зарегистрированы!", style: AlertStyle.Success)
                server().auth{(result) -> () in
                    
                    print(result)
                    if(result["response"].string! == "error")
                    {
                        SweetAlert().showAlert("Ошибка входа!", subTitle: "Проверьте введенные данные", style: AlertStyle.Error)
                    }
                        
                    else
                    {
                        let uid = result["response"].string
                        self.def.setValue(uid, forKey: "uid")
                        self.performSegueWithIdentifier("registerToMain", sender: self)
                    }          }

            }
            else
            {
                SweetAlert().showAlert("Ошибка!", subTitle: "Такое имя уже занято", style: AlertStyle.Error)
            }}
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
