//
//  RLConfigViewController.swift
//  downloaderGifs
//
//  Created by User on 9/3/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

import UIKit

class RLConfigViewController: UIViewController {
    
    fileprivate let cellId = "configId"
    fileprivate var lastSelection: IndexPath!
    
    fileprivate let presenter: Presenter2 = {
        let p = (UIApplication.shared.delegate as! RLAppDelegate).presenter
        return p!
    }()
    
    var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: UITableViewStyle.plain)
        table.backgroundColor = .white
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.confugureTable(table: self.tableView)
        
        if let configArr = self.presenter.getConfigArr() {
            self.setLastSelectionOfConfigObj(configObjects: configArr)
        }
    }
    
    func confugureTable(table: UITableView) {
        table.register(RLConfigTableViewCell.self, forCellReuseIdentifier: self.cellId)
        table.delegate = self
        table.dataSource = self
        self.view.addSubview(table)
        self.setUpConstraints(to: table)
    }
    
    func setLastSelectionOfConfigObj(configObjects: Array<ConfigModel>) {
        
        let selectedConfigObj = configObjects.filter { $0.isSelected == true }.first
        guard let selected = selectedConfigObj, let configArr = self.presenter.getConfigArr(), let index = configArr.index(of: selected) else { return }
        self.lastSelection = IndexPath.init(row: index, section: 0)
    }
    
}

extension RLConfigViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.getConfigArrCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! RLConfigTableViewCell
        guard let config = self.presenter.getConfigObj(with: indexPath) else { return cell }
        if(config.isSelected == false) {
            cell.accessoryType = UITableViewCellAccessoryType.none
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        cell.textLabel?.text = config.rating
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(self.lastSelection != nil) {
            tableView.cellForRow(at: self.lastSelection)?.accessoryType = UITableViewCellAccessoryType.none
            self.presenter.getConfigObj(with: self.lastSelection)?.isSelected = false
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        self.presenter.getConfigObj(with: indexPath)?.isSelected = true
        self.lastSelection = indexPath
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}
