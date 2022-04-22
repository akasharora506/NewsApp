import UIKit
import SafariServices

class SearchViewController: UIViewController {
    private var searchText = ""
    private var currentPage = 1
    private var viewModels = [NewsTableViewCellViewModel]()
    private var articles = [Article]()
    let tableView = UITableView()
    let header :UILabel = {
       let header = UILabel()
        header.font = .systemFont(ofSize: 24, weight: .bold)
        header.backgroundColor = .purple
        header.textAlignment = .center
        header.textColor = .white
        return header
    }()
//    let sourcesLabel :UILabel = {
//       let header = UILabel()
//        header.text = "Sources"
//        header.textColor = .darkGray
//        header.textAlignment = .center
//        return header
//    }()
//
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemGray6
        view.addSubview(header)
//        view.addSubview(sourcesLabel)
        view.addSubview(tableView)
        fetchData()
        
    }
    override func viewDidLayoutSubviews() {
        header.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
//        sourcesLabel.frame = CGRect(x: 0, y: header.frame.height, width: view.frame.width, height: 100)
        tableView.frame = CGRect(x: 0, y: header.frame.height, width: view.frame.width, height: view.frame.height - header.frame.height)
    }
    func configureHeader(queryText: String){
        searchText = queryText
        header.text = "Search Results for \(queryText)"
    }
}
extension SearchViewController : UITableViewDataSource, UITableViewDelegate {
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
        guard let url = URL(string: articles[indexPath.row].url ?? "" ) else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    func fetchData(){
        APIservices.shared.getQueryHeadlines(queryText: searchText,pageNumber: currentPage){ [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles.append(contentsOf: articles)
                self?.viewModels.append(contentsOf: articles.compactMap({
                    NewsTableViewCellViewModel(
                        title: $0.title,
                        subTitle: $0.description ?? "No Description",
                        imageURL: URL(string: $0.urlToImage ?? "")
                    )
                }))
                DispatchQueue.main.async {
                    self?.tableView.tableFooterView = nil
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
                
            }
        }
    }
}

extension SearchViewController: UIScrollViewDelegate{
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if(scrollView.contentOffset.y > tableView.contentSize.height - 100 - scrollView.frame.height){
            currentPage+=1
            self.tableView.tableFooterView = createSpinnerFooter()
            fetchData()
        }
    }
    private func createSpinnerFooter()->UIView{
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
}
