import UIKit
import DropDown
class Component: UIView {

    let label = UILabel(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .purple
    }

    func configure(text: String) {
        label.text = text
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class HomeScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, ButtonDelegate {
    let headerName = [
    NSLocalizedString("Term Search", comment: "Term Search"),
    NSLocalizedString("News by Location", comment: "News by Location"),
    NSLocalizedString("Top Headlines", comment: "Top Headlines")
    ]
    private var searchText = "" {
        didSet {
            debouncer.call()
        }
    }
    private var debouncer: Debouncer!

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = .systemGray6
        tableView.register(HomeScreenTableViewCell.self, forCellReuseIdentifier: HomeScreenTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGray6
        tableView.rowHeight = 120
        let headerView = Component(frame: .zero)
        headerView.configure(text: NSLocalizedString("Apple News", comment: "Apple News"))
        view.addSubview(tableView)
        tableView.tableHeaderView = headerView
        debouncer = Debouncer.init(delay: 1, callback: debouncerApiCall)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        addConstraints()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateHeaderViewHeight(for: tableView.tableHeaderView)
    }

    func updateHeaderViewHeight(for header: UIView?) {
        guard let header = header else { return }
        header.frame.size.height = header.systemLayoutSizeFitting(CGSize(width: view.bounds.width - 32.0, height: 0)).height
    }
    private func debouncerApiCall() {
        SearchViewController().viewModel.fetchData(searchText: searchText, currentPage: 1, selectedSource: "")
    }
    func addConstraints() {
        var constraints = [NSLayoutConstraint]()
        constraints.append(tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
        constraints.append(tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor))
        constraints.append(tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        NSLayoutConstraint.activate(constraints)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerName.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
                let label = UILabel()
                label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
                label.text = headerName[section]
                label.font = .systemFont(ofSize: 24, weight: .bold)
                label.textAlignment = .center
                headerView.addSubview(label)
                return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeScreenTableViewCell.identifier, for: indexPath) as? HomeScreenTableViewCell else {
            return UITableViewCell()
        }
        if(indexPath.section == 0) {
            cell.configureButton(labelName: NSLocalizedString("Term Search", comment: "Term Search"), buttonName: NSLocalizedString("Search", comment: "Search"))
        } else if(indexPath.section == 1) {
            cell.configureButton(labelName: NSLocalizedString("News by Location", comment: "News by Location"), buttonName: NSLocalizedString("View Map", comment: "View Map"))
            cell.searchBar.isHidden = true
        } else {
            cell.configureButton(labelName: NSLocalizedString("Top Headlines", comment: "Top Headlines"), buttonName: NSLocalizedString("View Top Headlines", comment: "View Top Headlines"))
            cell.searchBar.isHidden = true
        }
        cell.selectionStyle = .none
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }

    func onButtonTap(at index: IndexPath) {
        let thvc = TopHeadlinesViewController()
        let mvc = MapViewController()
        let csvc = CategorySourceViewController()
        if(index.section == 0) {
            guard let cell = tableView.cellForRow(at: index as IndexPath) as? HomeScreenTableViewCell else {
                return
            }
            if cell.searchBar.text == "" {
                let alert = UIAlertController(title: "No Input", message: "Please input query text in the searchbar or visit top headlines", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Dismiss"), style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                csvc.searchText = cell.searchBar.text ?? ""
                csvc.configureHeader(queryText: cell.searchBar.text ?? "")
                navigationController?.pushViewController(csvc, animated: true)
            }
        } else if(index.section == 1) {
            navigationController?.pushViewController(mvc, animated: true)
        } else if(index.section == 2) {
            navigationController?.pushViewController(thvc, animated: true)
        }
    }
    func onSearchTextChange(newText: String) {
        searchText = newText
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
              if self.view.frame.origin.y == 0 {
                  self.view.frame.origin.y -= keyboardSize.height
              }
         }
     }

    @objc func keyboardWillHide(notification: NSNotification) {
              if self.view.frame.origin.y != 0 {
                  self.view.frame.origin.y = .zero
              }
     }
}
