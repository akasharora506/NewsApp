//
//  ViewController.swift
//  NewsApp
//
//  Created by Akash Arora on 11/04/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    
    let tableView = UITableView()
    let header: UILabel = {
        let header = UILabel()
        header.backgroundColor = .purple
        header.text = "Apple News"
        header.textColor = .white
        header.textAlignment = .center
        return header
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.backgroundColor = .systemGray6
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        view.addSubview(header)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        header.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        
        tableView.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: view.frame.height - 100)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        if(indexPath.row == 0){
            cell.configureButton(labelName: "Term Search", buttonName: "Search")
        }else if(indexPath.row == 1){
            cell.configureButton(labelName: "News by Location", buttonName: "View Map")
            cell.searchBar.isHidden = true
        }else{
            cell.configureButton(labelName: "Top Headlines", buttonName: "View Top Headlines")
            cell.searchBar.isHidden = true
        };
        return cell
    }
    
}

