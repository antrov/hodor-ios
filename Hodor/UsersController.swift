//
//  UsersController.swift
//  Hodor
//
//  Created by Antrov on 21.09.2017.
//  Copyright © 2017 Antrov. All rights reserved.
//

import UIKit
import PromiseKit

struct User {
    let name: String
    let avatar: UIImage
    
    init() {
        name =  ["Hubert", "Lena"][Int(arc4random() % 2)]
        avatar =  [#imageLiteral(resourceName: "avatar_lena.jpg"), #imageLiteral(resourceName: "avatar_hubert.jpg")][Int(arc4random() % 2)]
    }
}

class UsersController: UICollectionViewController, UIActionSheetDelegate {
    
    @IBOutlet var modalNavigationItem: UINavigationItem!
    @IBOutlet var longPressRecognizer: UILongPressGestureRecognizer!
    
    private var users: [User] = []
    
    let p = Promise<Void>.pending()
    
    override func viewDidLoad() {
        p.promise.then {
            print("dziala")
        }
        
        users.append(User())
        users.append(User())
        users.append(User())
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? UserCell else { return }
        let user = users[indexPath.item]
        
        cell.avatarImgView.image = user.avatar
        cell.titleLabel.text = user.name
    }
    
    // MARK: Actions
    
    @IBAction func addBtnAction(_ sender: Any) {
        p.fulfill()
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
    }
    
    @IBAction func doneBtnAction(_ sender: Any) {
    }
    
    @IBAction func longPressAction(_ sender: UILongPressGestureRecognizer) {
        guard case .ended = sender.state else { return }
        let location = sender.location(in: collectionView)
        guard let indexPath = collectionView?.indexPathForItem(at: location) else { return }

        collectionView?.selectItem(at: indexPath, animated: true, scrollPosition: .top)
        UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Delete").show(in: view)
    }
    
    // MARK: UIActionSheetDelegate
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == actionSheet.destructiveButtonIndex, let indexPath = collectionView?.indexPathsForSelectedItems?.first {
            users.remove(at: indexPath.item)
            collectionView?.deleteItems(at: [indexPath])
        }
    }
}
