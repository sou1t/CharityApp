//
//  TestData.swift
//  CharityApp
//
//  Created by Виталий Волков on 06.06.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import Foundation

class HelpMe{
    var charityName = ""
    var personName = ""
    var image = ""
    var location = ""
    var charDisc = ""
    var pecentage = ""
    var numOfGet = ""
    var dayToEnd = ""
    var numOfPeople = ""
    
    
    init(charityName: String , personName: String , image: String ,location: String, charDisc: String , pecentage: String, numOfGet: String,dayToEnd: String , numOfPeople: String ){
        
        self.charityName = charityName
        self.personName = personName
        self.image = image
        self.location = location
        self.charDisc = charDisc
        self.pecentage = pecentage
        self.numOfGet = numOfGet
        self.dayToEnd = dayToEnd
        self.numOfPeople = numOfPeople
    }
    
}