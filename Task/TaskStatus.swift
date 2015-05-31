//
//  TaskStatus.swift
//  Task
//
//  Created by Yuta Chiba on 2015/05/30.
//  Copyright (c) 2015年 yuinchirn. All rights reserved.
//

import Foundation

enum TaskStatus: Int {
    case Undo = 1
    case Doing
    case Done
    
    func getName() -> String {
        switch self {
        case .Undo:
            return "Undo"
        case .Doing:
            return "Doing"
        case .Done:
            return "Done"
        }
    }
}


