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

extension String {
    func replace(string:String, replacement:String) -> String {
        return self.stringByReplacingOccurrencesOfString(string, withString: replacement, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(" ", replacement: "")
    }
}

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
    
    func getUserInfo(completionHandler: ((result: JSON)->())) {
        
        let uid = def.valueForKey("uid") as? String ?? ""
        
        Alamofire.request(.GET, "\(ServerAdress)/getuser?uid=\(uid)")
            .validate()
            .responseJSON {
                (response) in
                let Json = JSON(response.result.value!)
                completionHandler(result: Json["response"])
        }
        
    }
    
    func addCard(completionHandler: ((result: JSON)->())){
        
        let uid = def.valueForKey("uid") as? String ?? ""
        let cardno = def.valueForKey("cardno") as? String ?? ""
        let cvc = def.valueForKey("cvc") as? String ?? ""
        let validdate = def.valueForKey("validdate") as? String ?? ""
        let holdername = (def.valueForKey("holdername") as? String ?? "").removeWhitespace()
        
        let parameters = [
            "uid": uid,
            "cardno": cardno,
            "cvc": cvc,
            "validdate": validdate,
            "holdername": holdername,
            "type": "visa"
            ]
        
        Alamofire.request(.POST, "\(ServerAdress)/addNewCard", parameters: parameters, encoding: .URL).responseJSON{
            (response) in
            print(response.request?.URLString)
            let Json = JSON(response.result.value!)
            completionHandler(result: Json["result"])
            
        }
        }
    
    func deleteCard(completionHandler: ((result: JSON)->())){
        
        let uid = def.valueForKey("uid") as? String ?? ""
        let cardid = def.valueForKey("cardid") as? String ?? ""
        Alamofire.request(.GET, "\(ServerAdress)/deleteCards?uid=\(uid)&cardid=\(cardid)")
            .validate()
            .responseJSON {
                (response) in
                print(response.request?.URLString)
                let Json = JSON(response.result.value!)
                completionHandler(result: Json["result"])
        }
    }

    
    func help(completionHandler: ((result: JSON)->())){
        
        let uid = def.valueForKey("uid") as? String ?? ""
        let requestid = def.valueForKey("requestid") as? String ?? ""
        var aid = def.valueForKey("aid") as? String ?? "0"
        if (aid == "")
        {
            aid = "0"
        }
        
        Alamofire.request(.GET, "\(ServerAdress)/help?uid=\(uid)&requestid=\(requestid)&aid=\(aid)")
            .validate()
            .responseJSON {
                (response) in
                print(response.request?.URLString)
                let Json = JSON(response.result.value!)
                completionHandler(result: Json["result"])
        }
    }

    func Registration(completionHandler: ((result: JSON)->())){
        
        let login = def.valueForKey("user") as? String ?? ""
        let pass = def.valueForKey("pass") as? String ?? ""
        let name = def.valueForKey("Uname") as? String ?? ""
        let photo = def.valueForKey("photo") as? String ?? ""
        
        let parameters = [
            "login": login,
            "pass": pass,
            "name": name,
            "photo": photo,
        ]
        
        Alamofire.request(.POST, "\(ServerAdress)/register", parameters: parameters, encoding: .URL).responseJSON{
            (response) in
            print(response.request?.URLString)
            let Json = JSON(response.result.value!)
            completionHandler(result: Json["result"])
            
        }
    }

    

    
    
    

    
    
}