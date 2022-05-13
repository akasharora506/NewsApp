import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Apple News"
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.backgroundColor = .systemGray6
        tableView.rowHeight = 120
        tableView.estimatedRowHeight = 120
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        addConstraints()
    }
    
    func addConstraints(){
        var constraints = [NSLayoutConstraint]()

        
        constraints.append(tableView.topAnchor.constraint(equalTo: view.topAnchor))
        constraints.append(tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        constraints.append(tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        
        NSLayoutConstraint.activate(constraints)
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}

extension ViewController: UITableViewDataSource, ButtonDelegate{
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
        cell.selectionStyle = .none
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }

    func onButtonTap(at index: IndexPath) {
        let thvc = TopHeadlinesViewController()
        let mvc = MapViewController()
        let csvc = CategorySourceViewController()
        if(index.row == 0){
            let cell = tableView.cellForRow(at: index as IndexPath) as! TableViewCell
            if cell.searchBar.text! == "" {
                let alert = UIAlertController(title: "No Input", message: "Please input query text in the searchbar or visit top headlines", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                csvc.searchText = cell.searchBar.text!
                csvc.configureHeader(queryText: cell.searchBar.text!)
                navigationController?.pushViewController(csvc, animated: true)
            }
        }else if(index.row == 1){
            navigationController?.pushViewController(mvc, animated: true)
        }else if(index.row == 2){
            navigationController?.pushViewController(thvc, animated: true)
        }
    }
  
    
}
