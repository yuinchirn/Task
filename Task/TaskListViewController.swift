//
//  TaskListViewController.swift
//  Task
//
//  Created by Yuta Chiba on 2015/05/10.
//  Copyright (c) 2015年 yuinchirn. All rights reserved.
//

import UIKit
import Parse
import Bolts

class TaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var undoBtn: UIButton?
    @IBOutlet weak var doingBtn: UIButton?
    @IBOutlet weak var doneBtn: UIButton?
    @IBOutlet weak var addBtn: UIButton!
    
    var isShowChangeBtns = false
    
    let showHeight = UIScreen.mainScreen().bounds.size.height - 170
    let hideHeight = UIScreen.mainScreen().bounds.size.height + 170
    
    @IBOutlet weak var tableView: UITableView!
    
    var taskList:AnyObject?
    
    var taskName:String = "taskName"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // データを取得
        var query: PFQuery = PFQuery(className: "Task")
        query.orderByAscending("createdAt")
        taskList = query.findObjects()

        
    }
    
    override func viewWillAppear(animated: Bool) {
        println(__FUNCTION__)
        
        // データを取得
        // TODO ネットワークが繋がっていない場合は取りに行かない。
        // TODO 基本的に書き込み、取得するDBはローカルのDBにする。
        // 適当なタイミングでリモートと同期
        var query: PFQuery = PFQuery(className: "Task")
        query.orderByAscending("createdAt")
        query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            for object in (objects as! [PFObject]) {
                
                if(error == nil){
                    self.taskList = objects
                    self.tableView.reloadData()
                }
            }
        }
        
        
        if let undo = undoBtn, doing = doingBtn, done = doneBtn, add = addBtn {
            UIView.animateWithDuration(0.8, // アニメーションの時間
                animations: {() -> Void  in
                    // アニメーションする処理
                    add.frame.origin.y = self.showHeight
                    add.hidden = false
                    
            })
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        // TODO 
        // 透明にアニメーション
        
        
        if let undo = undoBtn, doing = doingBtn, done = doneBtn, add = addBtn {
            UIView.animateWithDuration(1, // アニメーションの時間
                animations: {() -> Void  in
                    // アニメーションする処理
                    add.frame.origin.y = self.hideHeight
            })
            
           
        }
        
    }
    
    // セルの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // println(__FUNCTION__)
        return taskList!.count
    }
    
    // セルの内容を変更
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // println(__FUNCTION__)
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = taskList?.objectAtIndex(indexPath.row).objectForKey("taskName") as? String
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("せるたっぷ")
        
        if isShowChangeBtns {
            if let undo = undoBtn, doing = doingBtn, done = doneBtn, add = addBtn {
                UIView.animateWithDuration(0.8, // アニメーションの時間
                    animations: {() -> Void  in
                        // アニメーションする処理
                        undo.frame.origin.y = self.hideHeight
                        undo.hidden = false
                        doing.frame.origin.y = self.hideHeight
                        doing.hidden = false
                        done.frame.origin.y = self.hideHeight
                        done.hidden = false
                        add.frame.origin.y = self.showHeight
                        add.hidden = false
                        
                })
            }
        } else {
            if let undo = undoBtn, doing = doingBtn, done = doneBtn, add = addBtn {
                UIView.animateWithDuration(0.8, // アニメーションの時間
                    animations: {() -> Void  in
                        // アニメーションする処理
                        undo.frame.origin.y = self.showHeight
                        undo.hidden = false
                        doing.frame.origin.y = self.showHeight
                        doing.hidden = false
                        done.frame.origin.y = self.showHeight
                        done.hidden = false
                        add.frame.origin.y = self.hideHeight
                        
                })
            }
        }
        self.isShowChangeBtns = !self.isShowChangeBtns
    }

    override func didReceiveMemoryWarning() {
        println(__FUNCTION__)
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dragGesture(sender: UIPanGestureRecognizer) {
        
        let point = sender.translationInView(self.view)
        let movedPoint = CGPointMake(sender.view!.center.x + point.x, sender.view!.center.y + point.y)
        
        sender.view?.center = movedPoint
        
        sender.setTranslation(CGPointZero, inView: self.view)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
