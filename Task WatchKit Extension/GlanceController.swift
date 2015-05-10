//
//  GlanceController.swift
//  Task WatchKit Extension
//
//  Created by Yuta Chiba on 2015/05/10.
//  Copyright (c) 2015年 yuinchirn. All rights reserved.
//

import WatchKit
import Foundation
import Parse
import Bolts


class GlanceController: WKInterfaceController {
    
    @IBOutlet weak var table: WKInterfaceTable!
    var tableItems = ["ビール", "焼酎", "ワイン", "ドラゲナイ"]
    var taskList:AnyObject?
    
    let parseApplicationId: String = "Cw4ebzunmIPm2MuWUfmGx3x1vPQhdooJjanelodC"
    let parseClientKey: String = "kPfQJCxt3y3TZdcKviavNpsLhhQL2msK4W6OXIJw"

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // tableの設定
        table.setNumberOfRows(tableItems.count, withRowType: "tableRow")  // withRowTypeにはTableRowControllerに設定したidentifierを入力
        
        // tableRowのラベルにtableItemsの要素を表示
        
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId(parseApplicationId,
            clientKey: parseClientKey)
        
        
        // データを取得
        var query: PFQuery = PFQuery(className: "Task")
        query.orderByAscending("createdAt")
        taskList = query.findObjects()
        
        if taskList != nil {
            
            println(taskList!.count)
            
            
            
            for num in 0...8 {
                let controller = table.rowControllerAtIndex(num) as? TaskTableRowController
                controller!.taskName.setText(taskList?.objectAtIndex(num).objectForKey("taskName") as? String)
            }
        }
        
        
        /*
        for (index, item) in enumerate(tableItems){
            let controller = table.rowControllerAtIndex(index) as? TaskTableRowController
            controller!.taskName.setText(item)
        }
        */
        
        // Configure interface objects here.
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
