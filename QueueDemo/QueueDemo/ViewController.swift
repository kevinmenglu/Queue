//
//  ViewController.swift
//  QueueDemo
//
//  Created by ChenHao on 12/10/15.
//  Copyright © 2015 HarriesChen. All rights reserved.
//

import UIKit
import Queue

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let queue = Queue(queueName: "NetWorking", maxConcurrency: 1, maxRetries: 5, serializationProvider: NSUserDefaultsSerializer(),logProvider: ConsoleLogger())
        queue.addTaskCallback("Create") { (task) -> Void in
            sleep(1)
            print("finish create task")
            task.complete(nil)
        }
        
        queue.addTaskCallback("Delete") { (task) -> Void in
            print("finish Delete task")
            task.complete(NSError(domain: "dsfs", code: 22, userInfo: nil))
        }
        var taskNUmber = 0
        if queue.hasUnfinishedTask() {
            print("存在未完成任务")
            queue.loadSerializeTaskToQueue()
        } else {
            print("不存在未完成任务")
            taskNUmber = 100
        }
        
        var i = 0
        for i = 0; i < taskNUmber; i++ {
            
            
            let task = QueueTask(queue: queue, type: "Create", userInfo: nil, retries: 0)
            let taskDelete = QueueTask(queue: queue, type: "Delete", userInfo: nil, retries: 0)
            queue.addOperation(taskDelete)
            queue.addOperation(task)
        }
        
        queue.pause()
        queue.start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

