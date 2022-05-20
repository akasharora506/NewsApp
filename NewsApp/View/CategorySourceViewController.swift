import UIKit
import DropDown

class CategorySourceViewController: UIViewController {
    
    var sourceViewModels = [SourceTableViewCellViewModel]()
    var searchText = ""
    var viewModel = CategorySourceViewModel()
    let categoryMenu :DropDown = {
        let menu = DropDown()
        menu.dataSource = [
        "business",
        "entertainment",
        "general",
        "health",
        "science",
        "sports",
        "technology",
        ]
        return menu
    }()
    
    let tableView: UITableView={
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    let textBox: UIView={
        let textBox = UIView()
        textBox.translatesAutoresizingMaskIntoConstraints = false
        return textBox
    }()
    let currView :UILabel = {
        let currView = UILabel()
        currView.text = "business"
        currView.textAlignment = .center
        currView.translatesAutoresizingMaskIntoConstraints = false
        return currView
    }()
    let skipButton :UIButton = {
       let button = UIButton()
        button.setTitle("SKIP (SEARCH ALL SOURCE)", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        tableView.register(SourceTableViewCell.self, forCellReuseIdentifier: SourceTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        view.addSubview(textBox)
        view.addSubview(categoryMenu)
        textBox.addSubview(currView)
        viewModel.sources.bind { [weak self] sources in
            self?.sourceViewModels = sources
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
          }
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didOpenMenu))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        textBox.addGestureRecognizer(gesture)
        categoryMenu.selectionAction = { index, title in
            self.onSelectCategory(index: index, title: title)
        }
        view.addSubview(skipButton)
        skipButton.addTarget(self, action: #selector(didSkipSources(sender:)), for: .touchUpInside)
        addConstraints()
    }
    
    @objc func didOpenMenu(){
        categoryMenu.show()
    }
    
    @objc func didSkipSources(sender: UIButton){
        let svc = SearchViewController()
        svc.configureHeader(queryText: searchText,sourceName: "")
        navigationController?.pushViewController(svc, animated: true)
    }
    
  
    func addConstraints(){
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(textBox.topAnchor.constraint(equalTo: view.topAnchor,constant: 100))
        constraints.append(textBox.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(textBox.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        constraints.append(textBox.heightAnchor.constraint(equalToConstant: 100))
        
        categoryMenu.anchorView = textBox
        
        constraints.append(currView.topAnchor.constraint(equalTo: textBox.topAnchor))
        constraints.append(currView.leadingAnchor.constraint(equalTo: textBox.leadingAnchor))
        constraints.append(currView.trailingAnchor.constraint(equalTo: textBox.trailingAnchor))
        constraints.append(currView.bottomAnchor.constraint(equalTo: textBox.bottomAnchor))
        
        constraints.append(tableView.topAnchor.constraint(equalTo: textBox.bottomAnchor))
        constraints.append(tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        constraints.append(tableView.heightAnchor.constraint(equalTo: view.heightAnchor,constant: -300))
        
        constraints.append(skipButton.topAnchor.constraint(equalTo: tableView.bottomAnchor))
        constraints.append(skipButton.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        constraints.append(skipButton.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func onSelectCategory(index: Int, title: String){
        currView.text = title
        self.viewModel.fetchSources(title: title)
    }
    func configureHeader(queryText: String){
        title = "Search for \(queryText)"
    }
    
    func configureSearchText(queryText: String){
        searchText = queryText
        title = "Search for \(queryText)"
    }
}


extension CategorySourceViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sourceViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SourceTableViewCell.identifier) as? SourceTableViewCell else {
            fatalError()
        }
        cell.configure(with: sourceViewModels[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let svc = SearchViewController()
        svc.configureHeader(queryText: searchText,sourceName: sourceViewModels[indexPath.row].title)
        svc.selectedSource = sourceViewModels[indexPath.row].id
        navigationController?.pushViewController(svc, animated: true)
        
    }
}
