//
//  Task.swift
//  Homefield
//
//  Created by Ugur Bastug on 08/05/16.
//  Copyright © 2016 Ugur Bastug. All rights reserved.
//

import Foundation
class Task {
    var description:String!
    var type:String!
    var username:String!
    var amount:Double!
    var doneBy:String!
    var createdAt:NSTimeInterval!
    var dueTo:NSTimeInterval!
    var ref:String!

    func checkIfTaskPastIsDueDate()->Bool{
        if(dueTo<=NSDate().timeIntervalSince1970){
            //due to is lesser than now. so it is past it is due date.
            return true
        }else{
            return false
        }
    }
}