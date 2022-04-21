import UIKit
import SafariServices

class TopHeadlinesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let tableView = UITableView()
    
    var viewModels = [NewsTableViewCellViewModel]()
    var articles = [Article]()
    
    let header: UILabel = {
        let header = UILabel()
        header.text = "Top Headlines"
        header.font = .systemFont(ofSize: 24, weight: .bold)
        header.backgroundColor = .purple
        header.textAlignment = .center
        header.textColor = .white
        return header
        
    }()
    
    let bottomPagination: UIStackView = {
        let nextButton = UIButton()
        let prevButton = UIButton()
        nextButton.setTitle("Next", for: .normal)
        prevButton.setTitle("Prev", for: .normal)
        let paginatedIndex = UILabel()
        paginatedIndex.text = "1/4"
        let stackButtons = UIStackView(arrangedSubviews: [prevButton,paginatedIndex,nextButton])
        stackButtons.axis = .horizontal
        stackButtons.distribution = .equalSpacing
        return stackButtons
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        view.backgroundColor = .white
        view.addSubview(header)
        view.addSubview(tableView)
        APIservices.shared.getTopHeadlines{
            [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(
                        title: $0.title,
                        subTitle: $0.description ,
                        imageURL: URL(string: $0.urlToImage )
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
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        header.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        tableView.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: view.frame.height - 100)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier) as? NewsTableViewCell else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string: articles[indexPath.row].url ) else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
}
