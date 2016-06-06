//
//  ListViewController.swift
//  CharityApp
//
//  Created by Виталий Волков on 06.06.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    var array : [HelpMe] = [HelpMe(charityName: "хочу собрать", personName: "by Anar", image: "logo", location: "Moscow", charDisc: "Коплю на ноут", pecentage: "49%", numOfGet: "3 из 6", dayToEnd: "10", numOfPeople: "250")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        return array.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? CharityTableViewCell
        
        cell?.CharityDescription.text = array[indexPath.row].charDisc
        cell?.CharityName.text = array[indexPath.row].charityName
        cell?.City.text = array[indexPath.row].location
        cell?.NumberOfGet.text = array[indexPath.row].numOfGet
        cell?.NumberOfPeople.text = array[indexPath.row].numOfPeople
        cell?.DaysToEnd.text = array[indexPath.row].dayToEnd
        cell?.Percentage.text = array[indexPath.row].pecentage
        cell?.CharityImage.image =  UIImage(named : array[indexPath.row].image)
        cell?.PersonName.text = array[indexPath.row].personName
        return cell!
    }
}
