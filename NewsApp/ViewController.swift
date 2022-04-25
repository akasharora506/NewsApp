import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    
    let tableView = UITableView()
    let header: UILabel = {
        let header = UILabel()
        header.backgroundColor = .purple
        header.text = "Apple News"
        header.textColor = .white
        header.textAlignment = .center
        header.font = .systemFont(ofSize: 24, weight: .bold)
        return header
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.backgroundColor = .systemGray6
        tableView.delegate = self
        tableView.dataSource = self
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
        cell.selectionStyle = .none
        cell.button.tag = indexPath.row
        cell.button.addTarget(self, action: #selector(onClick(sender:)), for: .touchUpInside)
        return cell
    }
    @objc func onClick(sender: UIButton!){
        let svc = SearchViewController()
        let mvc = MapViewController()
            let section = sender.tag / 100
            let row = sender.tag % 100
        let indexPath = NSIndexPath(row: row, section: section)
        let csvc = CategorySourceViewController()
        if(sender.tag == 0){
            let cell = tableView.cellForRow(at: indexPath as IndexPath) as! TableViewCell
            if cell.searchBar.text! == "" {
                let alert = UIAlertController(title: "No Input", message: "Please input query text in the searchbar or visit top headlines", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                svc.configureHeader(queryText: cell.searchBar.text!)
                present(svc, animated: true)
            }
        }
        else if(sender.tag == 1){ present(mvc, animated: true) }
        else if(sender.tag == 2){
            present(csvc, animated: true)
        }
    }
    
}

