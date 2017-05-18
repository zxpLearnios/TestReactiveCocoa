//
//  TestViewModel.swift
//  TestReactiveCocoa
//
//  Created by Jingnan Zhang on 2017/5/17.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//

import UIKit

import ReactiveCocoa
import ReactiveSwift
import Result

class TestViewModel: NSObject {
    
    weak var model:TestModel!
    
    
    var userName: MutableProperty<String?>!
    var userPwd : MutableProperty<String?>!
    
    var logAction = Action<Void, Void, NoError> { (input: Void) -> SignalProducer<Void , NoError> in
        
        return SignalProducer.init({ (observer, compositeDisposable) in
            
            observer.send(value: ())
            observer.sendCompleted()
        })
        
    }
    
    
    
}
