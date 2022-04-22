import UIKit
import SafariServices

class TopHeadlinesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let tableView = UITableView()
    private var currentPage = 1
    private var viewModels = [NewsTableViewCellViewModel]()
    private var pages = 0
    var articles = [Article]()
    var totalArticles = 0
    let header: UILabel = {
        let header = UILabel()
        header.text = "Top Headlines"
        header.font = .systemFont(ofSize: 24, weight: .bold)
        header.backgroundColor = .purple
        header.textAlignment = .center
        header.textColor = .white
        return header
        
    }()
    let nextButton :UIButton = {
        let nextButton = UIButton()
        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.blue, for: .normal)
        return nextButton
    }()
    let prevButton :UIButton={
        let prevButton = UIButton()
        prevButton.setTitle("Prev", for: .normal)
        prevButton.setTitleColor(.blue, for: .normal)
        return prevButton
    }()
    
    let bottomPagination: UILabel = {
        let paginatedIndex = UILabel()
        paginatedIndex.text = "0/0"
        return paginatedIndex
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        view.backgroundColor = .white
        view.addSubview(header)
        view.addSubview(tableView)
        updateTableData()
        nextButton.addTarget(self, action: #selector(onNextClick(sender:)), for: .touchUpInside)
        prevButton.addTarget(self, action: #selector(onPrevClick(sender:)), for: .touchUpInside)
        
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
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        header.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        tableView.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: view.frame.height - 200)
        let stackView = UIStackView(arrangedSubviews: [prevButton,bottomPagination,nextButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.frame = CGRect(x: 10, y: view.frame.height - 100, width: view.frame.width - 20, height: 100)
        view.addSubview(stackView)
        
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
        APIservices.shared.getTopHeadlines(pageNumber: currentPage){
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
