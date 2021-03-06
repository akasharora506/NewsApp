import UIKit

class TopHeadlinesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var currentPage = 1
    private var topHeadlineViewModels = [NewsTableViewCellViewModel]()
    private var pages = 0
    private var viewModel = TopHeadlineViewModel()
    var selectedSource = ""
    var articles = [Article]()
    var totalArticles = 0
    let tableView: UITableView={
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    let nextButton :UIButton = {
        let nextButton = UIButton()
        nextButton.setTitle(NSLocalizedString("Next", comment: "Next"), for: .normal)
        nextButton.setTitleColor(.blue, for: .normal)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        return nextButton
    }()
    let prevButton :UIButton={
        let prevButton = UIButton()
        prevButton.setTitle(NSLocalizedString("Prev", comment: "Prev"), for: .normal)
        prevButton.setTitleColor(.blue, for: .normal)
        prevButton.translatesAutoresizingMaskIntoConstraints = false
        return prevButton
    }()
    let bottomPagination: UILabel = {
        let paginatedIndex = UILabel()
        paginatedIndex.text = "0/0"
        paginatedIndex.translatesAutoresizingMaskIntoConstraints = false
        return paginatedIndex
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString(NSLocalizedString("Top Headlines", comment: "Top Headlines"), comment: NSLocalizedString("Top Headlines", comment: "Top Headlines"))
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        view.backgroundColor = .white
        view.addSubview(tableView)
        let stackView = UIStackView(arrangedSubviews: [prevButton,bottomPagination,nextButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        stackView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50)
        viewModel.articles.bind { [weak self] articles in
            self?.articles = articles
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                var totalPages = (self?.totalArticles ?? 0) / 10
                if((self?.totalArticles ?? 0) % 10 != 0) {totalPages+=1}
                self?.pages = totalPages
                self?.bottomPagination.text = "\(self?.currentPage ?? 0)/\(self?.pages ?? 0)"
                if(!(self?.topHeadlineViewModels.isEmpty ?? true)) {
                    self?.tableView.tableFooterView = stackView
                }
            }
          }
        viewModel.topHeadlineViewModels.bind { [weak self] topHeadlineViewModels in
            self?.topHeadlineViewModels = topHeadlineViewModels
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                var totalPages = (self?.totalArticles ?? 0) / 10
                if((self?.totalArticles ?? 0) % 10 != 0) {totalPages+=1}
                self?.pages = totalPages
                self?.bottomPagination.text = "\(self?.currentPage ?? 0)/\(self?.pages ?? 0)"
                if(!(self?.topHeadlineViewModels.isEmpty ?? true)) {
                    self?.tableView.tableFooterView = stackView
                }
            }
          }
        viewModel.totalArticles.bind { [weak self] totalArticles in
            self?.totalArticles = totalArticles
          }
        viewModel.onErrorHandling = { error in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Dismiss"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        viewModel.fetchData(currentPage: currentPage, selectedSource: selectedSource)
        nextButton.addTarget(self, action: #selector(onNextClick(sender:)), for: .touchUpInside)
        prevButton.addTarget(self, action: #selector(onPrevClick(sender:)), for: .touchUpInside)
        addConstraints()
    }

    @objc func onNextClick(sender: UIButton!) {
        if(currentPage == pages) {
            return
        }
        currentPage+=1
        self.viewModel.fetchData(currentPage: currentPage, selectedSource: selectedSource)
    }
    @objc func onPrevClick(sender: UIButton!) {
        if(currentPage == 1) {
            return
        }
        currentPage-=1
        self.viewModel.fetchData(currentPage: currentPage, selectedSource: selectedSource)
    }
    func addConstraints() {
        var constraints = [NSLayoutConstraint]()
        constraints.append(tableView.topAnchor.constraint(equalTo: view.topAnchor))
        constraints.append(tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        constraints.append(tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        NSLayoutConstraint.activate(constraints)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topHeadlineViewModels.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier) as? NewsTableViewCell else {
            fatalError()
        }
        cell.configure(with: topHeadlineViewModels[indexPath.row])
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
}
