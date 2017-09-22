//
//  UsersController.swift
//  Hodor
//
//  Created by Antrov on 21.09.2017.
//  Copyright © 2017 Antrov. All rights reserved.
//

import UIKit
import PromiseKit

class UsersController: UICollectionViewController {
    
    @IBOutlet var modalNavigationItem: UINavigationItem!
    
    let p = Promise<Void>.pending()
    
    override func viewDidLoad() {
        p.promise.then {
            print("dziala")
        }
    }
    
    // MARK: Actions
    
    @IBAction func addBtnAction(_ sender: Any) {
        p.fulfill()
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
    }
    
    @IBAction func doneBtnAction(_ sender: Any) {
    }
    
}
