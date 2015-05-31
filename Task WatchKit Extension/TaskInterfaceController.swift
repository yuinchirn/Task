//
//  TaskInterfaceController.swift
//  Task
//
//  Created by Yuta Chiba on 2015/05/31.
//  Copyright (c) 2015年 yuinchirn. All rights reserved.
//

import WatchKit
import Foundation


class TaskInterfaceController: WKInterfaceController {

    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        if let name = context as? String {
            titleLabel.setText(name)
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
