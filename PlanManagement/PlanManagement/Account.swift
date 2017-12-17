//
//  Account.swift
//  PlanManagement
//
//  Created by CNTT-MAC on 12/16/17.
//  Copyright © 2017 CNTT-MAC. All rights reserved.
//

import Foundation
import UIKit

public class Account
{
    var username : String
    var password : String
    var person : User?
    
    
    init?(user: String, pass: String, per: User?) {
        if user.isEmpty || pass.isEmpty || per == nil
        {
            return nil
        }
        
        self.username = user
        self.password = pass
        self.person = per
    }
    
    func getUsername() -> String {
        return username
    }
    
    func setUsername(user : String) {
        self.username = user
    }
    
    func getPass() -> String {
        return password
    }
    
    func setPass(pass : String){
        self.password = pass
    }
    
    func getPerson() -> User? {
        return person
    }
    
    func setPerson(user : User?) {
        self.person = user
    }
}

