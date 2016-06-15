//
//  SettingsViewController.swift
//  CharityApp
//
//  Created by Виталий Волков on 07.06.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
import CryptoSwift

class SettingsViewController: UIViewController {
    var datas: [JSON] = []

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var LoginLabel: UILabel!
    @IBOutlet weak var NameLable: UILabel!
    @IBOutlet weak var table1: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        server().getCardsOfUser{(result) in
            self.datas = result
            self.table1.reloadData()
            
            
        }
        self.table1.es_addPullToRefresh {
            [weak self] in
            server().getCardsOfUser {(result) -> () in
                self!.datas = result
                self!.table1.reloadData()
                self?.table1.es_stopPullToRefresh(completion: true)
                self?.table1.es_stopPullToRefresh(completion: true, ignoreFooter: false)
            }
        }
        server().getUserInfo{(result) in
            if let photo = result[0]["photo"].string{
                print(photo)
                let url = NSURL(string: photo)
                self.photo.sd_setImageWithURL(url)
            }
            self.LoginLabel.text = result[0]["login"].string
            self.NameLable.text = result[0]["name"].string
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension SettingsViewController:UITableViewDelegate, UITableViewDataSource{
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath) as? CardTableViewCell
        let data = datas[indexPath.row]
        if let CardNo = data["cardno"].string{
            
            do
            {
            let key: [UInt8] = [0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00]
            let iv: [UInt8] = [1, 5, 8, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18]
            let encryptedtoName = NSData(base64EncodedString: CardNo, options:[])!
            let encryptedName1 = Array(UnsafeBufferPointer(start: UnsafePointer<UInt8>(encryptedtoName.bytes), count: encryptedtoName.length))
            let decryptedName = try AES(key: key, iv: iv, blockMode: .CBC, padding: PKCS7()).decrypt(encryptedName1)
            let strName = String(bytes: decryptedName, encoding: NSUTF8StringEncoding)
                cell?.CardNo.text = strName
            print(decryptedName)
            }
            catch {
                print(error)
            }
        
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 56
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
     func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
     func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let data = datas[indexPath.row]
            if let CardId = data["cardid"].string{
                def.setValue(CardId, forKeyPath: "cardid")
            }
            SweetAlert().showAlert("Are you sure?", subTitle: "You file will permanently delete!", style: AlertStyle.Warning, buttonTitle:"No, cancel plx!", buttonColor:UIColorFromRGB(0xD0D0D0) , otherButtonTitle:  "Yes, delete it!", otherButtonColor: UIColorFromRGB(0xDD6B55)) { (isOtherButton) -> Void in
                if isOtherButton == true {
                    
                    SweetAlert().showAlert("Cancelled!", subTitle: "Your imaginary file is safe", style: AlertStyle.Error)
                }
                else {
                    
                    server().deleteCard{(result) in
                        if (result==true){
                            SweetAlert().showAlert("Deleted!", subTitle: "Your imaginary file has been deleted!", style: AlertStyle.Success)
                            server().getCardsOfUser{(result) in
                                self.datas = result
                                self.table1.reloadData()
                                
                                
                            }

                            
                        }
                        else
                        {
                            SweetAlert().showAlert("Error!", subTitle: "Error", style: AlertStyle.Error)
                        }
                        
                    }

                }
            }
            
                        
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
    
}


