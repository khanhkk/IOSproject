//
//  Plan.swift
//  PlanManagement
//
//  Created by CNTT-MAC on 12/16/17.
//  Copyright © 2017 CNTT-MAC. All rights reserved.
//

import Foundation
import UIKit

public class Plan{
    var code : String
    
    var title : String
    var timeStart : Date?
    var timeFinish : Date?
    var comment : String
    
    init?(code : String, title : String,timeStart: Date?, timeFinish: Date?, note : String) {
        if code.isEmpty || title .isEmpty || timeFinish == nil || timeStart == nil
        {
            return nil
        }
        
        self.code = code
        
        self.title = title
        self.comment = note
        self.timeStart = timeStart
        self.timeFinish = timeFinish
    }
    
    func getCode() -> String {
        return code
    }
    
    func setCode(code : String) {
        self.code = code
    }
    
    
    
    func getTitle() -> String {
        return title
    }
    
    func setTitle(title : String) {
        self.title = title
    }
    
    func getTimeStart() -> Date? {
        return timeStart
    }
    
    func setTimeStart(start : Date?) {
        self.timeStart = start
    }
    
    func getTimeFinish() -> Date? {
        return timeFinish
    }
    
    func setTimeFinish(finish : Date?) {
        self.timeFinish = finish
    }

    
    func getComment() -> String {
        return comment
    }
    
    func setComment(com : String) {
        self.comment = com
    }
}
