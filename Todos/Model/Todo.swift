//
//  Todo.swift
//  Todos
//
//  Created by Ahmed Khaled on 2/1/18.
//  Copyright © 2018 Ahmed Khaled. All rights reserved.
//


import UIKit
import SwiftyJSON

class Todo: NSObject {
    var id : Int
    var title : String
    
    init(json : JSON) {
        self.id = json["id"].intValue
        self.title = json["title"].stringValue
    }
}
