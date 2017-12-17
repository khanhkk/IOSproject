//
//  User.swift
//  PlanManagement
//
//  Created by CNTT-MAC on 12/16/17.
//  Copyright © 2017 CNTT-MAC. All rights reserved.
//

import Foundation
import UIKit

public class User
{
    var id : String
    var name : String
    var dob : Date?
    var address : String
    var email : String
    var image : UIImage?
    
    init?(code : String, name : String, dob : Date?, add : String, email : String, photo : UIImage?) {
        if code.isEmpty || name.isEmpty || dob == nil || add.isEmpty || email.isEmpty 
        {
            return nil
        }
        self.id = code
        self.name = name
        self.dob = dob
        self.address = add
        self.email = email
        self.image = photo
    }
    
//    init?(){
//    }
    
    func getId() -> String {
        return id
    }
    
    func setId(id : String) {
        self.id = id
    }
    
    func getName() -> String {
        return name
    }
    
    func setName(name : String){
        self.name = name
    }
    
    func getDOB() -> Date? {
        return dob
    }
    
    func setDOB(dob : Date?){
        self.dob = dob
    }
    
    func getAdd() -> String {
        return address
    }
    
    func setAdd(add : String){
        self.address = add
    }
    
    func getEmail() -> String {
        return email
    }
    
    func setEmail(mail : String) {
        self.email = mail
    }
}
