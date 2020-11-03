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
    private var dataSource: UITableViewDiffableDataSource<ViewController.Section, Int>!
    
    // timer
    private var timer: Timer!
    
    private var startInterval = 10 // 10 seconds
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        configureTableView()
        // DispatchQueue.main.asyncAfter(deadline: .now() + 1) {self.configureDataSource()}
        configureDataSource()
        configureNavBar()
    }
    
    private func configureNavBar() {
        navigationItem.title = "Countdown with diffable datasource"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startCountDown))
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
            
            if value == -1 {
                cell.textLabel?.text = "App launched 😅"  // value is Int (Section, Int)
                cell.textLabel?.numberOfLines = 0
            } else {
                cell.textLabel?.text = "\(value)"  // value is Int (Section, Int)
            }
        
            return cell
        })
        
        // set type of animation
        dataSource.defaultRowAnimation = .fade // automatic is default
//
//        // setup snapshot
//        var snapshot = NSDiffableDataSourceSnapshot<ViewController.Section, Int>()
//        // add sections
//        snapshot.appendSections([.main])
//        // add items
//        snapshot.appendItems([1,2,3,4,5,6,7,8,9,10])
//        // apply changes to the dataSource
//        dataSource.apply(snapshot, animatingDifferences: true)
        
        startCountDown()
    }

    @objc
    private func startCountDown() {
        if timer != nil {
            timer.invalidate()
        }
        
        // configure the timer , set interval for countdown
        // assign a method that gets called every second
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(decrementCounter), userInfo: nil, repeats: true)
        // reset our startingInterval
        startInterval = 10 // 10 seconds
        
        // set up snapshot
        // setup snapshot
        var snapshot = NSDiffableDataSourceSnapshot<ViewController.Section, Int>()
        // add sections
        snapshot.appendSections([.main])
        // add items
        snapshot.appendItems([startInterval]) // starts at 10
        // apply changes to the dataSource
        dataSource.apply(snapshot, animatingDifferences: false)
        
    }
    
    @objc
    private func decrementCounter() {
        // get access to the snapshot to manipulate the data
        // snapshot is the "source of truth"
        
        var snapshot = dataSource.snapshot()
        guard startInterval > 0 else {
            timer.invalidate()
            ship()
            return
        }
        startInterval -= 1
        snapshot.appendItems([startInterval])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func ship() {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems([-1])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

