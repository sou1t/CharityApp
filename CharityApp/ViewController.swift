//
//  ViewController.swift
//  CharityApp
//
//  Created by Виталий Волков on 04.06.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITextFieldDelegate {
    var datas: JSON = []
    @IBOutlet weak var password: AwesomeTextField!
    @IBOutlet weak var login: AwesomeTextField!
    
    let def = NSUserDefaults.standardUserDefaults()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.login.delegate = self;
        self.password.delegate = self;
        let uid = def.valueForKey("uid") as? String ?? ""
        print(uid)
        if (def.valueForKey("uid") as? String ?? "" != "")
        {
            self.performSegueWithIdentifier("mainTonext", sender: self)
        }

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
                // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func fb_click(sender: AnyObject) {
    }
    
    
    @IBAction func login_click(sender: AnyObject) {
        def.setValue(login.text, forKey: "user")
        def.setValue(password.text, forKey: "pass")
        

            server().auth{(result) -> () in
                self.datas = result
                print(result)
                if(self.datas["response"].string! == "error")
                {
                    SweetAlert().showAlert("Ошибка входа!", subTitle: "Проверьте введенные данные", style: AlertStyle.Error)
                }
                
                else
                {
                    let uid = self.datas["response"].string
                    self.def.setValue(uid, forKey: "uid")
                    self.performSegueWithIdentifier("mainTonext", sender: self)
                }
        }




        


        
    }
    

    @IBAction func ok_click(sender: AnyObject) {
    }
    
    @IBAction func vk_click(sender: AnyObject) {
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}


