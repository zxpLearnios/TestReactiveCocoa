//
//  ViewController.swift
//  TestReactiveCocoa
//
//  Created by Jingnan Zhang on 2017/5/17.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let vc = TestViewController()
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}

