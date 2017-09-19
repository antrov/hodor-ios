//
//  MonitorController.swift
//  Hodor
//
//  Created by Antrov on 19.09.2017.
//  Copyright © 2017 Antrov. All rights reserved.
//

import UIKit

class MonitorController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }
    
    func setup() {
        //navigationController?.navigationBar.frame = navigationController?.navigationBar.frame.insetBy(dx: 0, dy: -50) ?? CGRect.zero
    }
}
