import UIKit
import SafariServices

class SearchViewController: UIViewController {
    private var searchText = ""
    var selectedSource = ""
    private var currentPage = 1
    private var viewModels = [NewsTableViewCellViewModel]()
    private var articles = [Article]()
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemGray6
        view.addSubview(tableView)
        fetchData()
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

    func configureHeader(queryText: String, sourceName: String){
        searchText = queryText
        title = "\(sourceName) Results for \(queryText)"
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
    func createSpinner()->UIView{
        let layerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        let spinner = UIActivityIndicatorView()
        spinner.center = layerView.center
        spinner.style = .large
        layerView.addSubview(spinner)
        spinner.startAnimating()
        return layerView
    }
    func fetchData(){
        let loadingView = createSpinner()
        if(articles.isEmpty){
            view.addSubview(loadingView)
        };
        let formattedSearchText = searchText.trimmingCharacters(in: NSCharacterSet.whitespaces).replacingOccurrences(of: " ", with: "-")
        APIservices.shared.getQueryHeadlines(queryText: formattedSearchText,pageNumber: currentPage, selectedSource: selectedSource){ [weak self] result in
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
                    loadingView.removeFromSuperview()
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
