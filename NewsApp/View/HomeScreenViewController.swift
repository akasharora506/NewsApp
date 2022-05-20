import UIKit

class HomeScreenViewController: UIViewController, UITableViewDelegate {
    let headerName = [
    "Term Search",
    "News by Location",
    "Top Headlines"
    ]
    private var searchText = "" {
        didSet {
            debouncer.call()
        }
    }
    private var debouncer: Debouncer!
    
    let headerView: UILabel = {
        let label = UILabel()
        label.text = "Apple News"
        label.textColor = .purple
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        
        view.backgroundColor = .systemGray6
        
        tableView.register(HomeScreenTableViewCell.self, forCellReuseIdentifier: HomeScreenTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGray6
        tableView.rowHeight = 120
        
        view.addSubview(headerView)
        view.addSubview(tableView)
        
        debouncer = Debouncer.init(delay: 1, callback: debouncerApiCall)
        
        addConstraints()
    }
    private func debouncerApiCall() {
        SearchViewController().viewModel.fetchData(searchText: searchText, currentPage: 1, selectedSource: "")
    }
    
    func addConstraints(){
        var constraints = [NSLayoutConstraint]()

        constraints.append(headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
        constraints.append(headerView.heightAnchor.constraint(equalToConstant: 50))
        constraints.append(headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        
        constraints.append(tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor))
        constraints.append(tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor))
        constraints.append(tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        
        NSLayoutConstraint.activate(constraints)
    }
    
}

extension HomeScreenViewController: UITableViewDataSource, ButtonDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
                
                let label = UILabel()
                label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
                label.text = headerName[section]
                label.font = .systemFont(ofSize: 24, weight: .bold)
                label.textAlignment = .center
                headerView.addSubview(label)
                
                return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeScreenTableViewCell.identifier, for: indexPath) as? HomeScreenTableViewCell else {
            return UITableViewCell()
        }
        if(indexPath.section == 0){
            cell.configureButton(labelName: "Term Search", buttonName: "Search")
        }else if(indexPath.section == 1){
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
        if(index.section == 0){
            let cell = tableView.cellForRow(at: index as IndexPath) as! HomeScreenTableViewCell
            if cell.searchBar.text! == "" {
                let alert = UIAlertController(title: "No Input", message: "Please input query text in the searchbar or visit top headlines", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                csvc.searchText = cell.searchBar.text!
                csvc.configureHeader(queryText: cell.searchBar.text!)
                navigationController?.pushViewController(csvc, animated: true)
            }
        }else if(index.section == 1){
            navigationController?.pushViewController(mvc, animated: true)
        }else if(index.section == 2){
            navigationController?.pushViewController(thvc, animated: true)
        }
    }
    func onSearchTextChange(newText: String){
        searchText = newText
    }
    
}

