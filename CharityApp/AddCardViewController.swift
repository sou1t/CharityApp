//
//  AddCardViewController.swift
//  CharityApp
//
//  Created by Виталий Волков on 07.06.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import UIKit
import CryptoSwift

class AddCardViewController: UIViewController, UITextFieldDelegate {
    
    let def = NSUserDefaults.standardUserDefaults()
    @IBOutlet weak var CVC: UITextField!
    @IBOutlet weak var HolderName: UITextField!
    @IBOutlet weak var ValidDate: UITextField!
    @IBOutlet weak var CardNo: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.CVC.delegate = self;
        self.HolderName.delegate = self;
        self.ValidDate.delegate = self;
        self.CardNo.delegate = self;

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func AddButtonClick(sender: AnyObject) {
        if (HolderName.text == "" || CVC.text=="" || ValidDate.text == "" || CardNo.text == "")
        {
            SweetAlert().showAlert("Ошибка!", subTitle: "Проверьте введенные данные", style: AlertStyle.Error)
        }
        else
        {
            let outputName: [UInt8] = Array(HolderName.text!.utf8)
            let outputCVC: [UInt8] = Array(CVC.text!.utf8)
            let outputValidDate: [UInt8] = Array(ValidDate.text!.utf8)
            let outputCardNo: [UInt8] = Array(CardNo.text!.utf8)
            
            let key: [UInt8] = [0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00]
            let iv: [UInt8] = [1, 5, 8, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18]
            do {
                //codding block
                let encryptedName = try AES(key: key, iv: iv, blockMode: .CBC, padding: PKCS7()).encrypt(outputName)
                let encryptedCVC = try AES(key: key, iv: iv, blockMode: .CBC, padding: PKCS7()).encrypt(outputCVC)
                let encryptedValidDate = try AES(key: key, iv: iv, blockMode: .CBC, padding: PKCS7()).encrypt(outputValidDate)
                let encryptedCardNo = try AES(key: key, iv: iv, blockMode: .CBC, padding: PKCS7()).encrypt(outputCardNo)
                
                let encryptedNSDataName = NSData(bytes: encryptedName, length: encryptedName.count)
                let encryptedNSDataCVC = NSData(bytes: encryptedCVC, length: encryptedCVC.count)
                let encryptedNSDataValidDate = NSData(bytes: encryptedValidDate, length: encryptedValidDate.count)
                let encryptedNSDataCardNo = NSData(bytes: encryptedCardNo, length: encryptedCardNo.count)
                
                
                let encryptedbase64Name = encryptedNSDataName.base64EncodedStringWithOptions([])
                let encryptedbase64ValidDate = encryptedNSDataValidDate.base64EncodedStringWithOptions([])
                let encryptedbase64CVC = encryptedNSDataCVC.base64EncodedStringWithOptions([])
                let encryptedbase64CardNo = encryptedNSDataCardNo.base64EncodedStringWithOptions([])
                
                def.setValue(encryptedbase64Name, forKeyPath: "holdername")
                def.setValue(encryptedbase64CVC, forKeyPath: "cvc")
                def.setValue(encryptedbase64ValidDate, forKeyPath: "validdate")
                def.setValue(encryptedbase64CardNo, forKeyPath: "cardno")
                
                //block for decoding
                let encryptedtoName = NSData(base64EncodedString: encryptedbase64Name, options:[])!
                let encryptedtoCVC = NSData(base64EncodedString: encryptedbase64CVC, options:[])!
                let encryptedtoValidDate = NSData(base64EncodedString: encryptedbase64ValidDate, options:[])!
                let encryptedtoCardNo = NSData(base64EncodedString: encryptedbase64CardNo, options:[])!
                
                
                let encryptedName1 = Array(UnsafeBufferPointer(start: UnsafePointer<UInt8>(encryptedtoName.bytes), count: encryptedtoName.length))
                let encryptedCVC1 = Array(UnsafeBufferPointer(start: UnsafePointer<UInt8>(encryptedtoCVC.bytes), count: encryptedtoCVC.length))
                let encryptedValidDate1 = Array(UnsafeBufferPointer(start: UnsafePointer<UInt8>(encryptedtoValidDate.bytes), count: encryptedtoValidDate.length))
                let encryptedCardNo1 = Array(UnsafeBufferPointer(start: UnsafePointer<UInt8>(encryptedtoCardNo.bytes), count: encryptedtoCardNo.length))

                
                let decryptedName = try AES(key: key, iv: iv, blockMode: .CBC, padding: PKCS7()).decrypt(encryptedName1)
                let decryptedCVC = try AES(key: key, iv: iv, blockMode: .CBC, padding: PKCS7()).decrypt(encryptedCVC1)
                let decryptedValidDate = try AES(key: key, iv: iv, blockMode: .CBC, padding: PKCS7()).decrypt(encryptedValidDate1)
                let decryptedCardNo = try AES(key: key, iv: iv, blockMode: .CBC, padding: PKCS7()).decrypt(encryptedCardNo1)
                
                let strName = String(bytes: decryptedName, encoding: NSUTF8StringEncoding)
                let strCVC = String(bytes: decryptedCVC, encoding: NSUTF8StringEncoding)
                let strValidDate = String(bytes: decryptedValidDate, encoding: NSUTF8StringEncoding)
                let strCardNo = String(bytes: decryptedCardNo, encoding: NSUTF8StringEncoding)
                
                
                
                
                

                
                
                print("Input:\n Number:\(outputCardNo)\n  CVC:\(outputCVC)\n Date:\(outputValidDate)\n Name:\(outputName)")
                
                print("Crypted:\n Number:\(encryptedCardNo)\n  CVC:\(encryptedCVC)\n Date:\(encryptedValidDate)\n Name:\(encryptedName)")
                print("Decrypted:\n Number:\(strCardNo)\n  CVC:\(strCVC)\n Date:\(strValidDate)\n Name:\(strName)")
                print("Base64:\n Number:\(encryptedCardNo.toBase64())\n  CVC:\(encryptedCVC.toBase64())\n Date:\(encryptedValidDate.toBase64())\n Name:\(encryptedName.toBase64())")
                print("Base64ToString:\n Number:\(encryptedtoCardNo))\n  CVC:\(encryptedtoCVC)\n Date:\(encryptedtoValidDate)\n Name:\(encryptedtoName)")
            } catch {
                print(error)
            }
           
            server().addCard{(result) in
                if (result==true)
                {
                    SweetAlert().showAlert("Готово!", subTitle: "Ваша карта успешно добавлена!", style: AlertStyle.Success)
                    self.performSegueWithIdentifier("AddToSettings", sender: self)
                }
                else
                {
                    SweetAlert().showAlert("Ошибка!", subTitle: "Такая карта уже существует", style: AlertStyle.Error)
                }
                
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

}
