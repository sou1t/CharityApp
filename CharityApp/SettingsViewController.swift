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

class SettingsViewController: UIViewController {
    var datas: [JSON] = []

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var table1: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        server().getCardsOfUser{(result) in
            self.datas = result
            self.table1.reloadData()
            
        }
        server().getUserInfo{(result) in
            if let photo = result[0]["photo"].string{
                print(photo)
                let url = NSURL(string: photo)
                self.photo.sd_setImageWithURL(url)
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

extension SettingsViewController:UITableViewDelegate, UITableViewDataSource{
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
            cell?.CardNo.text = CardNo
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 56
    }

    
    
}


