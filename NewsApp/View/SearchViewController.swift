import UIKit

class SearchViewController: UIViewController, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate {
    var searchText = ""
    var selectedSource = ""
    var currentPage = 1
    private var searchViewModels = [NewsTableViewCellViewModel]()
    private var articles = [Article]()
    var viewModel = SearchViewModel()
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
        viewModel.articles.bind { [weak self] articles in
            self?.articles = articles
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.tableView.tableFooterView = nil
            }
          }
        viewModel.searchViewModels.bind { [weak self] searchViewModels in
            self?.searchViewModels = searchViewModels
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.tableView.tableFooterView = nil
            }
          }
        viewModel.onErrorHandling = { error in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Dismiss"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        viewModel.fetchData(searchText: searchText, currentPage: currentPage, selectedSource: selectedSource)
        addConstraints()
    }
    func addConstraints() {
        var constraints = [NSLayoutConstraint]()
        constraints.append(tableView.topAnchor.constraint(equalTo: view.topAnchor))
        constraints.append(tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        constraints.append(tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        NSLayoutConstraint.activate(constraints)
    }

    func configureHeader(queryText: String, sourceName: String) {
        searchText = queryText
        title = "\(sourceName) Results for \(queryText)"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModels.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier) as? NewsTableViewCell else {
            fatalError()
        }
        cell.configure(with: searchViewModels[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let articleURL = URL(string: articles[indexPath.row].url ?? "" ) else {
            return
        }
        let webVC = WebViewController(url: articleURL, title: articles[indexPath.row].source.name)
        navigationController?.pushViewController(webVC, animated: true)
    }
    func createSpinner() -> UIView {
        let layerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        let spinner = UIActivityIndicatorView()
        spinner.center = layerView.center
        spinner.style = .large
        layerView.addSubview(spinner)
        spinner.startAnimating()
        return layerView
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if(scrollView.contentOffset.y > 0.8*tableView.contentSize.height - scrollView.frame.height) {
            currentPage+=1
            self.tableView.tableFooterView = createSpinnerFooter()
            self.viewModel.fetchData(searchText: self.searchText, currentPage: self.currentPage, selectedSource: self.selectedSource)
        }
    }
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
}
