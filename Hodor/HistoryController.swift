//
//  MonitorController.swift
//  Hodor
//
//  Created by Antrov on 19.09.2017.
//  Copyright © 2017 Antrov. All rights reserved.
//

import UIKit

struct HistoryItem {
    let date: Date
    let user: String
    let status: Status
    
    enum Status {
        case uploading, processing, completed
    }
    
    init(date: Date) {
        self.date = date
        self.user = ["Hubert", "Lena"][Int(arc4random() % 2)]
        self.status = .completed
    }
}

class HistoryController: UITableViewController {
    
    private var history: [HistoryItem] = []
    
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        history.append(HistoryItem(date: Date()))
        history.append(HistoryItem(date: Date()))
        history.append(HistoryItem(date: Date()))
        history.append(HistoryItem(date: Date()))
        history.append(HistoryItem(date: Date()))
        history.append(HistoryItem(date: Date()))
        history.append(HistoryItem(date: Date()))
        history.append(HistoryItem(date: Date()))
        history.append(HistoryItem(date: Date()))
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? HistoryCell else { return }
        let item = history[indexPath.row]
        
        cell.dateLabel.text = formatter.string(from: item.date)
        cell.titleLabel.text = item.status != .completed ? "\(item.status)" : item.user
    }
}
