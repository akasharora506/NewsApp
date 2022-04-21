import UIKit

class SearchViewController: UIViewController {
    
    let tableView = UITableView()
    let header :UILabel = {
       let header = UILabel()
        header.font = .systemFont(ofSize: 24, weight: .bold)
        header.backgroundColor = .purple
        header.textAlignment = .center
        header.textColor = .white
        return header
    }()
    let sourcesLabel :UILabel = {
       let header = UILabel()
        header.text = "Sources"
        header.textColor = .darkGray
        header.textAlignment = .center
        return header
    }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemGray6
        view.addSubview(header)
        view.addSubview(sourcesLabel)
        view.addSubview(tableView)
        
    }
    override func viewDidLayoutSubviews() {
        header.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        sourcesLabel.frame = CGRect(x: 0, y: header.frame.height, width: view.frame.width, height: 100)
        tableView.frame = CGRect(x: 0, y: header.frame.height + sourcesLabel.frame.height, width: view.frame.width, height: view.frame.height - header.frame.height - sourcesLabel.frame.height)
    }
    func configureHeader(queryText: String){
        header.text = "Search Results for \(queryText)"
    }
}
extension SearchViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        return cell
    }
}

