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

class ListViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    var array : [HelpMe] = [HelpMe(charityName: "хочу собрать", personName: "by Anar", image: "logo", location: "Moscow", charDisc: "Коплю на ноут", pecentage: "49%", numOfGet: "3 из 6", dayToEnd: "10", numOfPeople: "250")]
    
    var datas: [JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        server().getHelpRequests {(result) -> () in
            self.datas = result
            self.table.reloadData()
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
            cell?.NumberOfGet.text = "\(get) из \(sum)"
                let percente = Double(get)!/Double(sum)!
            cell?.Percentage.text = String(format: "%02d", percente)
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
        

        
        
        
        
        
        
        
//        cell?.CharityDescription.text = array[indexPath.row].charDisc
//        cell?.CharityName.text = array[indexPath.row].charityName
//        cell?.City.text = array[indexPath.row].location
//        cell?.NumberOfGet.text = array[indexPath.row].numOfGet
//        cell?.NumberOfPeople.text = array[indexPath.row].numOfPeople
        cell?.DaysToEnd.text = array[indexPath.row].dayToEnd
//        cell?.Percentage.text = array[indexPath.row].pecentage
//        cell?.CharityImage.image =  UIImage(named : array[indexPath.row].image)
//        cell?.PersonName.text = array[indexPath.row].personName
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 210
    }
}
