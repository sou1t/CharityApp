//
//  ListViewController.swift
//  CharityApp
//
//  Created by Виталий Волков on 06.06.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
import ESPullToRefresh

class ListViewController: UIViewController {

    @IBOutlet weak var table: UITableView!

    
    var datas: [JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        server().getHelpRequests {(result) -> () in
            self.datas = result
            self.table.reloadData()
        }
        self.table.es_addPullToRefresh {
            
            [weak self] in
            server().getHelpRequests {(result) -> () in
                self!.datas = result
                self!.table.reloadData()
                self?.table.es_stopPullToRefresh(completion: true)
                self?.table.es_stopPullToRefresh(completion: true, ignoreFooter: false)
            }
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
    
    var tField: UITextField!
    
    func configurationTextField(textField: UITextField!)
    {
        print("generating the TextField")
        textField.placeholder = "Сумма в рублях"
        
        tField = textField
    }
    
    
    func handleCancel(alertView: UIAlertAction!)
    {
        print("Cancelled !!")
    }
    

    
    
    func Clicked(sender: UIButton) {
        let index = sender.tag
            let alert = UIAlertController(title: "Введите сумму пожертвования", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addTextFieldWithConfigurationHandler(configurationTextField)
            alert.addAction(UIAlertAction(title: "Отмена", style: UIAlertActionStyle.Cancel, handler:handleCancel))
            alert.addAction(UIAlertAction(title: "Готово", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
                print("Done !!")
                if Int(self.tField.text!) != nil
                {
                    def.setObject(self.tField.text, forKey: "aid")
                    let data = self.datas[index]
                    let id = data["requestid"].string
                    def.setObject(id, forKey: "requestid")
                    server().help{(result) in
                        if (result == true){
                            
                            let name = data["cardname"].string!
                            let aidsum = self.tField.text!
                            SweetAlert().showAlert("\(name)", subTitle: "Вы пожертвовали \(aidsum)руб", style: AlertStyle.Success)
                            server().getHelpRequests {(result) -> () in
                                self.datas = result
                                self.table.reloadData()
                            }
                        }
                        else
                        {
                            SweetAlert().showAlert("Ошибка", subTitle: "Повторите попытку", style: AlertStyle.Error)
                        }
                        
                    }

                }
                else
                {
                    SweetAlert().showAlert("Ошибка", subTitle: "Повторите попытку", style: AlertStyle.Error)
                }
                

                print("Item : \(self.tField.text) index: \(index+1)")
            }))
            self.presentViewController(alert, animated: true, completion: {
                print("completion block")
            })

    }
    

   
}

extension ListViewController:UITableViewDelegate, UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? CharityTableViewCell
        let data = datas[indexPath.row]
        if let CharityName = data["cardname"].string{
            cell?.CharityName.text = CharityName
        }
        if let photo = data["photo"].string{
            let url = NSURL(string: photo)
            cell?.CharityImage.sd_setImageWithURL(url)
        }
        if let sum = data["sum"].string{
            if let get = data["alredyHave"].string
            {
            cell?.NumberOfGet.text = "\(get)"
                let percente = Double(get)!/Double(sum)!
            cell?.Percentage.text = String(format: "\(round(percente*1000)/10)%%")
            cell?.CharityProgress.progress = Float(percente)
            }
        }
        if let city = data["city"].string{
            cell?.City.text = city
        }

        if let description = data["description"].string{
            cell?.CharityDescription.text = description
        }
        if let personName = data["human_name"].string{
            cell?.PersonName.text = personName
        }

        cell?.DaysToEnd.text = "20"
        cell?.HelpButton.tag = indexPath.row
        cell?.HelpButton.addTarget(self, action: #selector(self.Clicked(_:)), forControlEvents: .TouchUpInside)

        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 210
    }
    
    
    @IBAction func logoutClick(sender: AnyObject) {
        def.setValue("", forKeyPath: "uid")
        self.performSegueWithIdentifier("logout", sender: self)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
     
}
