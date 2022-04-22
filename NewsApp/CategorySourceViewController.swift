import UIKit
import DropDown

class CategorySourceViewController: UIViewController {
    
    var viewModels = [SourceTableViewCellViewModel]()
    
    let header :UILabel = {
        let header = UILabel()
        header.text = "Choose source"
        header.textColor = .white
        header.backgroundColor = .purple
        header.font = .systemFont(ofSize: 24, weight: .bold)
        header.textAlignment = .center
        return header
    }()
    
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
    
    let tableView = UITableView()
    let textBox = UIView()
    let currView :UILabel = {
        let currView = UILabel()
        currView.text = "business"
        return currView
    }()
    let skipButton :UIButton = {
       let button = UIButton()
        button.setTitle("SKIP (SEARCH ALL SOURCE)", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        view.addSubview(header)
        tableView.register(SourceTableViewCell.self, forCellReuseIdentifier: SourceTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        view.addSubview(textBox)
        view.addSubview(categoryMenu)
        textBox.addSubview(currView)
        fetchSources(title: currView.text ?? "")
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didOpenMenu))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        textBox.addGestureRecognizer(gesture)
        categoryMenu.selectionAction = { index, title in
            self.onSelectCategory(index: index, title: title)
        }
        view.addSubview(skipButton)
        skipButton.addTarget(self, action: #selector(didSkipSources(sender:)), for: .touchUpInside)
    }
    @objc func didOpenMenu(){
        categoryMenu.show()
    }
    
    @objc func didSkipSources(sender: UIButton){
        let thvc = TopHeadlinesViewController()
        show(thvc, sender: self)
    }
    
    override func viewDidLayoutSubviews() {
        header.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        textBox.frame = CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 100)
        categoryMenu.anchorView = header
        tableView.frame = CGRect(x: 0, y: 200, width: view.frame.width, height: view.frame.height - 300)
        currView.frame = textBox.bounds
        skipButton.frame = CGRect(x: 0, y: view.frame.height - 100, width: view.frame.width, height: 100)
    }
    func onSelectCategory(index: Int, title: String){
        currView.text = title
        fetchSources(title: title)
        
    }
    func fetchSources(title: String){
        APIservices.shared.getSources(for: title){
            [weak self] result in
            switch result {
            case .success(let sources):
                self?.viewModels = sources.compactMap({
                    SourceTableViewCellViewModel(
                        id: $0.id,
                        title: $0.name,
                        description:  $0.description ?? "No Description"
                    )
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
           
        }
    }
}


extension CategorySourceViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SourceTableViewCell.identifier) as? SourceTableViewCell else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let thvc = TopHeadlinesViewController()
        thvc.selectedSource = viewModels[indexPath.row].id
        show(thvc, sender: self)
        
    }
}
