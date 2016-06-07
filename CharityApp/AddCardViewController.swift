//
//  AddCardViewController.swift
//  CharityApp
//
//  Created by Виталий Волков on 07.06.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import UIKit

class AddCardViewController: UIViewController {
    
    let def = NSUserDefaults.standardUserDefaults()
    @IBOutlet weak var CVC: UITextField!
    @IBOutlet weak var HolderName: UITextField!
    @IBOutlet weak var ValidDate: UITextField!
    @IBOutlet weak var CardNo: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func AddButtonClick(sender: AnyObject) {
        if (HolderName.text == nil || CVC.text==nil || ValidDate.text == nil || CardNo.text == nil)
        {
            SweetAlert().showAlert("Ошибка!", subTitle: "Проверьте введенные данные", style: AlertStyle.Error)
        }
        else
        {
            def.setValue(HolderName.text, forKeyPath: "holdername")
            def.setValue(CVC.text, forKeyPath: "cvc")
            def.setValue(ValidDate.text, forKeyPath: "validdate")
            def.setValue(CardNo.text, forKeyPath: "cardno")
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

}
