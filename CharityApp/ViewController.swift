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
import VK_ios_sdk




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
        self.def.setValue("", forKey: "Uname")
        self.def.setValue("http://chumanity.ru/noavatar.png", forKey: "photo")
        self.performSegueWithIdentifier("mainToRegister", sender: self)
    }
    
    
    @IBAction func login_click(sender: AnyObject) {
        def.setValue(login.text, forKey: "user")
        def.setValue(password.text?.md5(), forKey: "pass")
        

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
    
    
    
    @IBAction func noSocialClick(sender: AnyObject) {
        self.def.setValue("", forKey: "Uname")
        self.def.setValue("http://chumanity.ru/noavatar.png", forKey: "photo")
        self.performSegueWithIdentifier("mainToRegister", sender: self)
    }
    

    @IBAction func ok_click(sender: AnyObject) {
        self.def.setValue("", forKey: "Uname")
        self.def.setValue("http://chumanity.ru/noavatar.png", forKey: "photo")
        self.performSegueWithIdentifier("mainToRegister", sender: self)}
    
    @IBAction func vk_click(sender: AnyObject) {
    
        print("VK auth")
        VKSdk.instance().registerDelegate(self)
        VKSdk.instance().uiDelegate = self
        
        let scope = [VK_PER_FRIENDS, VK_PER_WALL, VK_PER_AUDIO, VK_PER_PHOTOS, VK_PER_NOHTTPS, VK_PER_STATUS]
        
        VKSdk.wakeUpSession(scope) { (state, error) -> Void in
            
            if state == .Authorized {
                VKSdk.forceLogout()
            }
            VKAuthorizeController.presentForAuthorizeWithAppId("5506160", andPermissions: scope, revokeAccess: true, displayType: "")
            
            
        }

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }


}

extension ViewController: VKSdkDelegate, VKSdkUIDelegate{
    
    
    // MARK: - VKSdkDelegate
    
    func vkSdkAccessAuthorizationFinishedWithResult(result: VKAuthorizationResult!) {
        
        let token = result.token
        //let accessToken = token.accessToken
        let userId = token.userId
        //let email = token.email
        
        let request = VKApi.users().get([VK_API_FIELDS : "first_name, last_name, uid, photo_200"])
        
        request.waitUntilDone = true
        request.executeWithResultBlock({
            (res) in
            let json = res.json
            let parsed = JSON(json)
            print(parsed)
            let name = parsed[0]["first_name"].string
            let photo = parsed[0]["photo_200"].string
            print(name)
            print(photo)
            
            self.def.setValue(userId, forKey: "vk")
            self.def.setValue(name, forKey: "Uname")
            self.def.setValue(photo, forKey: "photo")
            self.performSegueWithIdentifier("mainToRegister", sender: self)
            },
                                       errorBlock:
            {
                                        (err) in
                SweetAlert().showAlert("Ошибка входа!", subTitle: "Проверьте введенные данные", style: AlertStyle.Error)
                print(err)
        
            })
        
    }
    
    func vkSdkUserAuthorizationFailed() {
        SweetAlert().showAlert("Ошибка входа!", subTitle: "Проверьте введенные данные", style: AlertStyle.Error)
        
    }
    
    // MARK: - VKSdkUIDelegate
    
    func vkSdkShouldPresentViewController(controller: UIViewController!) {
        presentViewController(controller, animated: true, completion: nil)
    }
    
    func vkSdkNeedCaptchaEnter(captchaError: VKError!) {
        let vc = VKCaptchaViewController.captchaControllerWithError(captchaError)
        vc.presentIn(self)
    }
}



