//
//  ActionOfPlan.swift
//  PlanManagement
//
//  Created by CNTT-MAC on 12/16/17.
//  Copyright © 2017 CNTT-MAC. All rights reserved.
//

import Foundation
import UIKit

public class Action
{
    var id : String
     var name : String
    var plan : Plan?
    var actor : User?
    var content : String
    var time: Date?
    var comment : String
    
    init?(id : String, name: String, plan : Plan?, implementer : User?, content : String, time : Date?, comment : String) {
        if id.isEmpty || content.isEmpty || time == nil || name.isEmpty || implementer == nil
        {
            return nil
        }
        
        self.id = id
        self.plan = plan
        self.content = content
        self.actor = implementer
        self.time = time
        self.comment = comment
        self.name = name
    }
    
    func getActor() -> User? {
        return actor
    }
    
    func setActor(user : User?) {
        self.actor = user
    }
    
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

    
    func getPlan() -> Plan? {
        return plan
    }
    
    func setPlan(plan : Plan?) {
        self.plan = plan
    }
    
    func getContent() -> String {
        return content
    }
    
    func setContent(content : String) {
        self.content = content
    }
    
    func getTime() -> Date? {
        return time
    }
    
    func setTime(start : Date?) {
        self.time = start
    }
    
    
    func getComment() -> String {
        return comment
    }
    
    func setComment(com : String) {
        self.comment = com
    }

}
