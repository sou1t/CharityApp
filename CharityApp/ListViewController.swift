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
            cell?.Percentage.text = String(format: "\(percente*100)%")
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

        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 210
    }
}
