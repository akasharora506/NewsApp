import UIKit
import SafariServices

class TopHeadlinesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    private var currentPage = 1
    private var viewModels = [NewsTableViewCellViewModel]()
    private var pages = 0
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
        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.blue, for: .normal)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        return nextButton
    }()
    let prevButton :UIButton={
        let prevButton = UIButton()
        prevButton.setTitle("Prev", for: .normal)
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
        title = "Top Headlines"
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        view.backgroundColor = .white
//        tableView.estimatedRowHeight = 150
        view.addSubview(tableView)
        updateTableData()
        nextButton.addTarget(self, action: #selector(onNextClick(sender:)), for: .touchUpInside)
        prevButton.addTarget(self, action: #selector(onPrevClick(sender:)), for: .touchUpInside)
        addConstraints()
    }

    @objc func onNextClick(sender: UIButton!){
        if(currentPage == pages){
            return
        }
        currentPage+=1
        updateTableData()
    }
    @objc func onPrevClick(sender: UIButton!){
        if(currentPage == 1){
            return
        }
        currentPage-=1
        updateTableData()
    }
    func addConstraints(){
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(tableView.topAnchor.constraint(equalTo: view.topAnchor))
        constraints.append(tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -100))
        constraints.append(tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        
        let stackView = UIStackView(arrangedSubviews: [prevButton,bottomPagination,nextButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        constraints.append(stackView.topAnchor.constraint(equalTo: tableView.bottomAnchor))
        constraints.append(stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        constraints.append(stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10))
        constraints.append(stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10))
        
        NSLayoutConstraint.activate(constraints)
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
        guard let url = URL(string: articles[indexPath.row].url ?? "" ) else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    func updateTableData(){
        APIservices.shared.getTopHeadlines(pageNumber: currentPage, sources: selectedSource ){
            [weak self] result, countArticles in
            self?.totalArticles = countArticles
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(
                        title: $0.title,
                        subTitle: $0.description ?? "No Description",
                        imageURL: URL(string: $0.urlToImage ?? "")
                    )
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    var totalPages = (self?.totalArticles ?? 0) / 10
                    if((self?.totalArticles ?? 0) % 10 != 0) {totalPages+=1}
                    self?.pages = totalPages
                    self?.bottomPagination.text = "\(self?.currentPage ?? 0)/\(self?.pages ?? 0)"
                }
            case .failure(let error):
                print(error)
            }
           
        }
    }
}