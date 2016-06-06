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
    
    func auth(completionHandler: ((result: Bool)->())) {
        
        let user = def.valueForKey("user") as? String ?? "u"
        let pass = def.valueForKey("pass") as? String ?? "p"
        
        Alamofire.request(.GET, "\(ServerAdress)/auth?login=\(user)&pass=\(pass)")
            .validate()
            .responseJSON {
                (response) in
                let Json = JSON(response.result.value!)
                if (Json["result"] == true)
                {
                    completionHandler(result: true)
                }
                else
                {
                    completionHandler(result: false)
                }
        }
        
    }
    
    
}