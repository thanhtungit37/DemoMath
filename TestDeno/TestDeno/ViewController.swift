//
//  ViewController.swift
//  TestDeno
//
//  Created by ThanhTung on 2/8/19.
//  Copyright © 2019 thanh tung. All rights reserved.
//

import UIKit

enum typeTest: String {
    case abc
    case xyz
    case yk
    
    func string() -> String {
        return self.rawValue
    }
}


class ViewController: UIViewController {
    
    var block: (()-> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        testDisPathGroup()
        //        syncWork()
        self.block = {
            print("block1")
        }
        testDisPathWorkItem()
        let xy = typeTest.abc
        print("xy: \(xy)")
    }
    
    func syncWork() {
        let northWord = DispatchQueue.init(label: "test_sync_1")
        let southWord = DispatchQueue.init(label: "test_sync_1")
        northWord.async {
            for i in 0..<100 {
                print("LOGGG----1: \(i)")
            }
        }
        print("LOGGG3")
        
        southWord.async {
            for i in 0..<50 {
                print("LOGGG----2: \(i)")
            }
        }
        
    }
    
    func taskOne(completion: @escaping (()-> Void)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            completion()
        }
        //        completion()
    }
    
    func taskTow(completion: @escaping (()-> Void)) {
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        completion()
        //        }
    }
    
    func workItem2() {
        
    }
    
    
    func testDisPathWorkItem() {
        let dg = DispatchGroup.init()
        
        let workItem = DispatchWorkItem.init(block: self.block)
        let queue_1 = DispatchQueue.init(label: "work_item_1")
        
        print("work item wait---- 2s")
        queue_1.async(group: dg, execute: workItem)
        
        let workItem2 = DispatchWorkItem.init {
            print("block2")
        }
        
        queue_1.async(group: dg, execute: workItem2)
        dg.notify(queue: .main) {
            print("notify")
        }
    }
    
    fileprivate func extractedFunc(_ dg: DispatchGroup) {
        taskOne {
            print("task one")
            dg.leave()
            
        }
        dg.enter()
        taskTow {
            print("task tow")
            dg.leave()
            
        }
    }
    
    fileprivate func extractedFunc1() {
        let dg = DispatchGroup.init()
        dg.enter()
        extractedFunc(dg)
        
        //        dg.wait(timeout: .now() + 5)
        print("LOB wait")
        dg.notify(queue: .main) {
            print("ALL DG success")
        }
    }
    
    func testDisPathGroup() {
        extractedFunc1()
    }
    
    
    
}

