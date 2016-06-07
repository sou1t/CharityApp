//
//  ServerMethods.swift
//  CharityApp
//
//  Created by Виталий Волков on 06.06.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


let ServerAdress = "http://api.chumanity.ru"
let def = NSUserDefaults.standardUserDefaults()


class server {
    
    func auth(completionHandler: ((result: JSON)->())) {
        
        let user = def.valueForKey("user") as? String ?? "u"
        let pass = def.valueForKey("pass") as? String ?? "p"
        
        Alamofire.request(.GET, "\(ServerAdress)/auth?login=\(user)&pass=\(pass)")
            .validate()
            .responseJSON {
                (response) in
                let Json = JSON(response.result.value!)
                print(Json)
                                    completionHandler(result: Json)

            }
        
    }
    
    func getHelpRequests(completionHandler: ((result: [JSON])->())) {
        
        Alamofire.request(.GET, "\(ServerAdress)/getrequests")
            .validate()
            .responseJSON {
                (response) in
                let Json = JSON(response.result.value!)
                if let data = Json["response"].arrayValue as [JSON]?{
                    completionHandler(result: data)
                }
        }

    }
    
    func getCardsOfUser(completionHandler: ((result: [JSON])->())) {
        
        let uid = def.valueForKey("uid") as? String ?? ""
        
        Alamofire.request(.GET, "\(ServerAdress)/getcards?uid=\(uid)")
            .validate()
            .responseJSON {
                (response) in
                let Json = JSON(response.result.value!)
                if let data = Json["response"].arrayValue as [JSON]?{
                    completionHandler(result: data)
                }
        }
        
    }

    
    
}