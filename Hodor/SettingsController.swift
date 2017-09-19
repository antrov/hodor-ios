//
//  SettingsController.swift
//  Hodor
//
//  Created by Antrov on 19.09.2017.
//  Copyright © 2017 Antrov. All rights reserved.
//

import UIKit

class SettingsController: UITableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
