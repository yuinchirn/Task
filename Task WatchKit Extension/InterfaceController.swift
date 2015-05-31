//
//  InterfaceController.swift
//  Task WatchKit Extension
//
//  Created by Yuta Chiba on 2015/05/10.
//  Copyright (c) 2015年 yuinchirn. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var tableView: WKInterfaceTable!
    
    let status = ["Undo","Doing","Done"]
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        setTableData()
    }
    
    func setTableData(){
        
        tableView.setNumberOfRows(status.count, withRowType: "TaskListRowController")
        
        for (index,value) in enumerate(status) {
            let row =   tableView.rowControllerAtIndex(index) as? TaskListRowController
            row?.titleLabel?.setText(value)
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
    
    
    /*
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        var row = table.rowControllerAtIndex(rowIndex) as? TaskListRowController
        println("タップ")
        pushControllerWithName("ListView", context: row)
    }
*/

    // 遷移先の画面にデータを受け渡す
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        println("あああ")
        return status[rowIndex]
    }
    
}
