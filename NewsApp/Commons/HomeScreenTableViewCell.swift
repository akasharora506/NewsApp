import UIKit

protocol ButtonDelegate: AnyObject {
    func onButtonTap(at index:IndexPath)
    func onSearchTextChange(newText: String)
}

class HomeScreenTableViewCell: UITableViewCell {
    static let identifier = "customCell"
    var delegate:ButtonDelegate!
    var indexPath:IndexPath!
    let searchBar: UISearchTextField = {
       let searchBar = UISearchTextField()
        searchBar.textColor = .darkGray
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = NSLocalizedString("Search", comment: "Search")
        return searchBar
    }()
    internal let labelText: UILabel = {
        let labelText = UILabel()
        labelText.translatesAutoresizingMaskIntoConstraints = false
        labelText.textAlignment = .center
        labelText.textColor = .darkGray
        return labelText
    }()
    internal let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(labelText)
        contentView.addSubview(searchBar)
        contentView.addSubview(button)
        button.addTarget(self, action: #selector(onButtonTap(sender:)), for: .touchUpInside)
        searchBar.addTarget(self, action: #selector(onSearchTextChange(sender:)), for: .editingChanged)
    }
    @objc func onButtonTap(sender: Any) {
        self.delegate?.onButtonTap(at: indexPath)
    }
    @objc func onSearchTextChange(sender: Any) {
        self.delegate?.onSearchTextChange(newText: searchBar.text ?? "")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        button.setTitle(nil, for: .normal)
        labelText.text = nil
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        addConstraints()
    }
    func addConstraints() {
        var constraints = [NSLayoutConstraint]()
        constraints.append(searchBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10))
        constraints.append(searchBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10))
        constraints.append(searchBar.bottomAnchor.constraint(equalTo: button.topAnchor))
        constraints.append(searchBar.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.33))
        constraints.append(button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor))
        constraints.append(button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor))
        constraints.append(button.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5))
        constraints.append(button.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5))
        NSLayoutConstraint.activate(constraints)
    }
    public func configureButton(labelName: String, buttonName: String) {
        button.setTitle(buttonName, for: .normal)
    }
}
