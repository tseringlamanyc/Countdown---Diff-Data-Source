//
//  ViewController.swift
//  Countdown - Diff Data Source
//
//  Created by Tsering Lama on 11/2/20.
//

import UIKit

class ViewController: UIViewController {
    
    // 2)
    enum Section {
        case main // one section for table view
    }
    
    private var tableView: UITableView!
    
    // 1) define the UITableViewDiffableDataSource instance
    private var dataSource: UITableViewDiffableDataSource<Section, Int>!
    
    // timer
    private var timer: Timer!
    
    private var startInterval = 10 // 10 seconds
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        configureTableView()
        configureDataSource()
    }

    private func configureTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // takes up the whole view
        tableView.backgroundColor = .systemRed
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
    
    // 3) Configure data source
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Int>(tableView: tableView, cellProvider: { (tableView, indexPath, value) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "\(value)"  // value is Int (Section, Int)
            return cell
        })
        
        // set type of animation
        dataSource.defaultRowAnimation = .fade // automatic is default
        
        // setup snapshot
        var snapshot = NSDiffableDataSourceSnapshot<ViewController.Section, Int>()
        // add sections
        snapshot.appendSections([.main])
        // add items
        snapshot.appendItems([1,2,3,4,5,6,7,8,9,10])
        // apply changes to the dataSource 
        dataSource.apply(snapshot, animatingDifferences: true)
    }

}

