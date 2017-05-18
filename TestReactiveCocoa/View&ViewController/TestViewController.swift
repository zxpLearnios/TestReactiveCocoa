//
//  TestViewController.swift
//  TestReactiveCocoa
//
//  Created by Jingnan Zhang on 2017/5/17.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//
//  reactive rac 的使用  http://www.jianshu.com/p/002da942d392
//  1. RAC能使注册监听和监听后的须做的处理放在一起，实现了高聚合、低耦合
//  2. 在viewDidLoad里，监听之后，只有textField或按钮被点击了就会触发回调，实现实时更新即热响应.
//  reactiveCocoa  3已结停止了。 现在网上的RAC资料大多是基于RAC2.5 基于oc的，但是官方RAC已经更新到了RAC5 基于Swift，不再维护OC了。

//  RAC：被称为函数响应式编程框架FRP，函数式编程和链式编程。 是一个已经有着3年历史的项目，从Objective-C时期开始，后来从3.0开始支持了swift(可以通过bridge在OC下使用)，接着就完全停止了在Objective-C上的维护。RxSwift项目的时间短一些只有几个月（作者写的时间是15年），但是社区似乎充满了动力。关于RxSwift有一件重要的事是项目是按照 ReactiveX这个组织的规定下开发的，并且所有其他语言的Rx项目也是一样。如果学会了如何使用RxSwift，再去学习Rx.Net, RxJava 或者 RxJS就是小菜一碟，只是语言语法上的差异。这真的就是learn once, apply everywhere.
//  3. 响应式编程思想：不需要考虑调用顺序，只需要知道考虑结果，类似于蝴蝶效应，产生一个事件，会影响很多东西，这些事件像流一样的传播出去，然后影响结果，借用面向对象的一句话，万物皆是流。 代表：KVO运用。

//  4. 函数式编程思想：是把操作尽量写成一系列嵌套的函数或者方法调用。函数式编程本质:就是往方法中传入Block,方法中嵌套Block调用，把代码聚合起来管理函数式编程特点：每个方法必须有返回值（本身对象）,把函数或者Block当做参数,block参数（需要操作的值）block返回值（操作结果）

import UIKit

import ReactiveCocoa
import ReactiveSwift
import Result


class TestViewController: UIViewController {

    
    @IBOutlet weak var accountField: UITextField!
    @IBOutlet weak var pwdField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var accountLab: UILabel!
    
    @IBOutlet weak var mvvmBtn: UIButton!
    @IBOutlet weak var strLab: UILabel!
    
    let viewModel = TestViewModel()
    
    
    /**signal：输出   obser：输入\发送信号*/
    let (signal, obser) = Signal<Any, NoError>.pipe() // 信号管道
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. 监听文本框
        // 监听输入时的文字
        weak var wself = self // 在closure外的弱引用
        //  { [weak self] in  Mylog("这是closure内的弱引用") }   { [weak self]  (str) in  Mylog("\(str)") }
        
        //   accountField.reactive就是把accountField变成可响应的     accountField.reactive.continuousTextValues.observeValues { (text) in
        //            wself?.accountLab.text = text
        //            MyLog("输入的账号为：%@", text ?? "")
        //        }
        //
        //        //
        //        pwdField.reactive.controlEvents(.editingChanged).observeValues { textField in
        //
        //            MyLog(textField.text)
        //        }
        //
        //        // 2. 监听按钮的点击
        loginBtn.reactive.controlEvents(.touchUpInside).observeValues { _  in
            wself?.view.endEditing(true)
            MyLog("按钮了登录点击")
            
            // 测试代理
            wself?.obser.send(value: "点击按钮后发送信息")
        }
        
        // 3. 监听label
        //        let nameStr = accountLab.reactive.signal(for: #selector(signalFromLabel))
        
        // 4.
        
        let time = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: time) {
            
            //        wself?.createSignalMehods()
            //        wself?.signZip()
            //            wself?.testScheduler()
            
            // 测试代理
            //            wself?.testDelegate()
            //            wself?.testNoti()
            //            wself?.testKVO()
//            wself?.testIterator()
//            wself?.testOn()
            
//            wself?.testMap()
//            wself?.testFilter()
//            wself?.testMergin()
//            
//            wself?.testConcat()
//            wself?.testLatest()
//            wself?.testFlatMapError()
//            wself?.testRetry()
            
            wself?.testPropertyBind()
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - 0.创建信号的方法
    func createSignalMehods() {
        // 1.通过信号发生器创建(冷信号)
        //        let producer = SignalProducer<String, NoError>.init { (observer, _) in
        //            MyLog("新的订阅，启动操作")
        //            observer.send(value: "Hello")
        //            observer.send(value: "World")
        //        }
        //
        //        let subscriber1 = Observer<String, NoError>(value: { print("观察者1接收到值 \($0)") })
        //        let subscriber2 = Observer<String, NoError>(value: { print("观察者2接收到值 \($0)") })
        //
        //        MyLog("观察者1订阅信号发生器")
        //        producer.start(subscriber1)
        
        //        MyLog("观察者2订阅信号发生器")
        //        producer.start(subscriber2)
        
        
        //注意：发生器将再次启动工作
        
        // 2.通过管道创建（热信号）
        //        let (signalA, observerA) = Signal<String, NoError>.pipe()
        //        let (signalB, observerB) = Signal<String, NoError>.pipe()
        //
        //
        //        // 合并信号
        //        Signal.combineLatest(signalA, signalB).observeValues { (value) in
        //            MyLog( "收到的值\(value.0) + \(value.1)")
        //        }
        //
        //
        //        observerA.send(value: "1")
        //        observerA.sendCompleted()
        //
        //        observerB.send(value: "2")
        //        observerB.sendCompleted()
    }
    
    // MARK: - 1.信号联合
    func signZip() {
        let (signalA, observerA) = Signal<String, NoError>.pipe()
        let (signalB, observerB) = Signal<String, NoError>.pipe()
        
        Signal.zip(signalA, signalB).observeValues { (value) in
            MyLog( "收到的值\(value.0) + \(value.1)")
        }
        
        signalA.zip(with: signalB).observeValues { (value) in
            
        }
        observerA.send(value: "1")
        observerA.sendCompleted()
        observerB.send(value: "2")
        observerB.sendCompleted()
        
    }
    
    // MARK: - 2.Scheduler(调度器)
    func testScheduler() {
        // 主线程上延时0.3秒调用
        QueueScheduler.main.schedule(after: Date.init(timeIntervalSinceNow: 0.3)) {
            MyLog("主线程调用")
        }
        
        QueueScheduler.init().schedule(after: Date.init(timeIntervalSinceNow: 0.3)){
            MyLog("子线程调用")
        }
        
    }
    
    
    // MARK: - 3.Delegate
    func testDelegate() {
        signal.observeValues { (value) in
            MyLog("测试代理--\(value)")
        }
    }
    
    
    // MARK: - 4.通知
    func testNoti() {
        // 4.1 普通的通知方法
        //        NotificationCenter.default.reactive.notifications(forName: Notification.Name(rawValue: "home")).observeValues { (value) in
        //            debugPrint((value.object as? AnyObject) ?? "")
        //        }
        //
        //        let dicInfo = ["name": "测试通知", "value": "通知的内容"]
        //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "home"), object: dicInfo)
        
        // 4.2 键盘的通知
        //        NotificationCenter.default.reactive.notifications(forName: Notification.Name(rawValue: "UIKeyboardWillShowNotification" ), object: nil).observeValues { (value) in
        //            MyLog("键盘弹起")
        //        }
        //        NotificationCenter.default.reactive.notifications(forName: Notification.Name(rawValue: "UIKeyboardWillHideNotification"), object: nil).observeValues { (value) in
        //            MyLog("键盘收起")
        //        }
    }
    
    // MARK: - 5.KVO
    func testKVO() {
        
        let result = self.view.reactive.producer(forKeyPath: "bounds")
        result.start { [weak self](rect) in
            MyLog(self?.loginBtn)
            MyLog(rect)
        }
    }
    
    // MARK: - 6.迭代器
    func testIterator() {
        
        
        let array:[String] = ["name","name2"]
        var arrayIterator =  array.makeIterator()
        
        // 1. 数组的迭代器
        //        while let temp = arrayIterator.next() {
        //            MyLog(temp)
        //        }
        
        // 1.1. swift 系统自带的遍历
        //        array.forEach { (value) in
        //            MyLog(value)
        //        }
        
        //
        let dict:[String: String] = ["key":"name", "key1":"name1"]
        var dictIterator =  dict.makeIterator()
        
        // 3. 字典的迭代器
        while let temp = dictIterator.next() {
            MyLog(temp)
        }
        
        //        // 3.1 swift 系统自带的遍历
        dict.forEach { (key, value) in
            MyLog("\(key) + \(value)")
        }
        
        
    }

    // MARK:  7.  可以通过 on来观察signal，生成一个新的信号，即使没有订阅者也会被触发。和 observe相似，也可以只观察你关注的某个事件。
    func testOn() {
        
        let signal = SignalProducer<String , NoError>.init { (obsever, _) in
            
            obsever.send(value: "ddd")
            obsever.sendCompleted()
        }
        
        // 可以通过 on来观察signal，生成一个新的信号，即使没有订阅者（sp.start("传入订阅者")）也会被触发。
        let sp = signal.on(starting: {
            MyLog("开始")
        }, started: {
            MyLog("结束")
        }, event: { (event) in
            MyLog("Event: \(event)")
        }, failed: { (error) in
            MyLog("error: \(error)")
        }, completed: {
            MyLog("信号完成")
        }, interrupted: {
            MyLog("信号被中断")
        }, terminated: {
            MyLog("信号结束")
        }, disposed: {
            MyLog("信号清理")
        }) { (value) in
            MyLog("value: \(value)")
        }
        
        sp.start()
    }
    
    
    // MARK:  8. map 
    func testMap(){
        
        let (signal, observer) = Signal<String, NoError>.pipe()
        
        signal.map { (string) -> Int in
            return string.lengthOfBytes(using: .utf8)
            }.observeValues { (length) in
                MyLog("length: \(length)")
        }
        
        observer.send(value: "lemon")
        observer.send(value: "something")
    }
    
    // MARK:  9. filter  reduce
    func testFilter(){
        
        let (signal, observer) = Signal<Int, NoError>.pipe()
        
        // 1.
//        signal.filter { (value) -> Bool in
//            return value % 2 == 0
//            }.observeValues { (value) in
//                MyLog("\(value)能被2整除")
//        }
        
//        observer.send(value: 3)
//        observer.send(value: 4)
//        observer.send(value: 6)
//        observer.send(value: 7)

        // 2.  reduce将事件里的值聚集后组合成一个值，最终的结果为(a ? b) ? reduce
        signal.reduce(3) { (a, b) -> Int in
            return a + b
        }.observeValues { (result) in
            MyLog(result)
        }
        
        observer.send(value: 2)
        observer.send(value: 5)
        // 要注意的是最后算出来的值直到输入的流 完成后才会被发送出去。
        observer.sendCompleted()
    }
    
    // MARK: 10. Merge 策略将每个流的值立刻组合输出。无论内部还是外层的流如果收到失败就终止。 打印： a 1 b 2 c 3
    func testMergin(){
    
        let (producerA, lettersObserver) = Signal<String, NoError>.pipe()
        let (producerB, numbersObserver) = Signal<String, NoError>.pipe()
        let (signal, observer) = Signal<Signal<String, NoError>, NoError>.pipe()
        
        signal.flatten(.merge).observeValues { (value) in
            MyLog("value: \(value)")
        }
        
        observer.send(value: producerA)
        
//        observer.sendInterrupted() // 中断，
        
        observer.send(value:producerB)
        observer.sendCompleted()
        
        lettersObserver.send(value:"a") // prints "a"
        numbersObserver.send(value:"1") // prints "1"
        lettersObserver.send(value:"b") // prints "b"
        numbersObserver.send(value:"2") // prints "2"
        lettersObserver.send(value:"c") // prints "c"
        numbersObserver.send(value:"3") // prints "3"
    }
    
    
    // MARK:  10.1 Concat 策略是将内部的SignalProducer排序。外层的producer是马上被started。随后的producer直到前一个发送完成后才会start。一有失败立即传到外层。
    func testConcat(){
        
        let (signalA, lettersObserver) = Signal<Any, NoError>.pipe()
        let (signalB, numberObserver) = Signal<Any, NoError>.pipe()
        
        let (siganl, observer) = Signal<Signal<Any, NoError>, NoError>.pipe()
        
        siganl.flatten(.concat).observeValues { (value) in
            print("value: \(value)")
        }
        
        observer.send(value: signalA)
        observer.send(value: signalB)
        observer.sendCompleted()
        
        lettersObserver.send(value: "dddd")//dddd
        numberObserver.send(value: 33)    //不打印
        
        lettersObserver.send(value: "sss")//sss
        lettersObserver.send(value: "ffff")//ffff
        lettersObserver.sendCompleted()
        //要前一个信号执行完毕后，下一个信号才能被订阅
        numberObserver.send(value: 44)// 44
    }
    
    // MARK:  10.2 .latest只接收 在以后发送进来的那个流的值。
    func testLatest(){
        
        let (signalA, lettersObserver) = Signal<Any, NoError>.pipe()
        let (signalB, numberObserver) = Signal<Any, NoError>.pipe()
        
        let (siganl, observer) = Signal<Signal<Any, NoError>, NoError>.pipe()
        
        siganl.flatten(.latest).observeValues { (value) in
            MyLog("value: \(value)")
        }
        
        observer.send(value: signalA)
        // 1.
//        observer.send(value: signalB)
        
        lettersObserver.send(value: "dddd")
        numberObserver.send(value: 33)
        lettersObserver.send(value: "sss")
        
        // 2.
//        observer.send(value: signalB)
        
        // 只接受最近进来的信号
        numberObserver.send(value: 44)
        lettersObserver.send(value: "ffff")
    }
    

    // MARK:  11. flatMapError捕捉一个由SignalProducer产生的失败，然后产生一个新的SignalProducer代替。
    func testFlatMapError(){
        let (signal, observer) = Signal<Any, NSError>.pipe()
        let error = NSError.init(domain: "domian", code: 0, userInfo: nil)
        
        signal.flatMapError { (value) -> SignalProducer<Any, NoError> in
            return SignalProducer<Any, NoError>.init({ () -> String in
                return "sssss"
            })
            }.observeValues { (value) in
                MyLog(value)
        }
        
        observer.send(value: 3333)
        observer.send(value: 444)
        observer.send(error: error)
        observer.sendCompleted()
    }
   
    
    // MARK:  12.  retry用于按照指定次数，在失败时重启SignalProducer
    func testRetry(){
        var tries = 0
        let limit = 2
        let error = NSError.init(domain: "domian", code: 0, userInfo: nil)
        
        let signal = SignalProducer<String, NSError >.init { (observer, _) in
            tries += 1
            if tries < limit {
                observer.send(error: error)
            }else{
                observer.send(value: "Success")
                observer.sendCompleted()
            }
        }
        
        // retry用于按照指定次数，在失败时重启SignalProducer。
        signal.on(failed:{e in
            MyLog("Failure")
        }).retry(upTo:2).start { (event) in
            
            switch event {
            case .completed:
                MyLog("Complete")
            //判断输出值是否相等
            case .value("Success"):
                MyLog("ddd")
            case .interrupted:
                MyLog("interrupted")
            case .failed(error):
                MyLog(error)
            default:
                break
                
            }
            
        }
        
    }
    
    // MARK:  13. 属性的绑定: <~运算符是提供了几种不同的绑定属性的方式。注意这里绑定的属性必须是 MutablePropertyType类型的。 1. property <~ signal 将一个属性和信号绑定在一起，属性的值会根据信号送过来的值刷新。  2. property <~ producer 会启动这个producer，并且属性的值也会随着这个产生的信号送过来的值刷新。 3. property <~ otherProperty将一个属性和另一个属性绑定在一起，这样这个属性的值会随着源属性的值变化而变化。
    func testPropertyBind(){
         mvvmBtn.reactive.pressed = CocoaAction<UIButton>.init(viewModel.logAction)
    }
    
    

}



