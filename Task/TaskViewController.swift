//
//  TaskViewController.swift
//  Task
//
//  Created by Yuta Chiba on 2015/05/10.
//  Copyright (c) 2015年 yuinchirn. All rights reserved.
//

import UIKit
import Parse
import Bolts

class TaskViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var taskNameTextField: UITextField!
    
    var objectId:String?
    var editingTask:PFObject?
    var taskStatus:TaskStatus?
    
    var createMode:Bool {
        get{
            return objectId == nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO Listビュー下スワイプで表示したい。
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if let id = objectId {
            // データを取得
            var query: PFQuery = PFQuery(className: "Task")
            query.whereKey("objectId", equalTo: id)
            query.orderByAscending("createdAt")
            
            editingTask = query.findObjects()?.first as? PFObject
            if let task = editingTask {
                taskNameTextField.text = task.valueForKey("taskName") as! String
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        objectId = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
    
    /* checkボタン押下時のイベント */
    @IBAction func checkBtn(sender: AnyObject) {
        
        if taskNameTextField.text.isEmpty {
            self.dismissViewControllerAnimated(true, completion:nil)
            return
        }
        
        if createMode {
            saveTask()
        } else {
            updateTask()
        }
        self.dismissViewControllerAnimated(true, completion:nil)
    }
    
    /* タスクを保存 */
    func saveTask(){
        let task = PFObject(className: taskTable)
        task.setValue(taskNameTextField.text, forKey: taskNameKey)
        task.setValue(taskStatus?.rawValue, forKey: taskStatusKey)
        task.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if let err = error {
                println("error：\(err.description)")
            } else {
                println("Object has been saved.")
            }
        }
        task.pinInBackground()
    }
    
    /* タスクを更新 */
    func updateTask(){
        editingTask?.setValue(taskNameTextField.text, forKey: taskNameKey)
        editingTask?.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if let err = error {
                println("error：\(err.description)")
            } else {
                println("Object has been updated.")
            }
        }
        editingTask?.pinInBackground()
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
