import UIKit

class TableViewCell: UITableViewCell {
    static let identifier = "customCell"
    internal let searchBar: UISearchTextField = {
       let searchBar = UISearchTextField()
        searchBar.textColor = .darkGray
        searchBar.placeholder = "Search"
        return searchBar
    }()
    internal let termSearch: UILabel = {
        let termSearch = UILabel()
        termSearch.textColor = .darkGray
        return termSearch
    }()
    internal let button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(termSearch)
        contentView.addSubview(searchBar)
        contentView.addSubview(button)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        button.setTitle(nil, for: .normal)
        termSearch.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        termSearch.frame = CGRect(x: 10, y: 10, width: contentView.frame.width - 20, height: 20)
        termSearch.textAlignment = .center
        searchBar.frame = CGRect(x: 10, y: 20 + termSearch.frame.height, width: contentView.frame.width - 20, height: 30)
        
        button.frame = CGRect(x: 10, y: 40 + termSearch.frame.height + searchBar.frame.height, width: contentView.frame.width - 20, height: 20)
    }
    
    public func configureButton(labelName: String, buttonName: String){
        button.setTitle(buttonName, for: .normal)
        termSearch.text = labelName
    }
}
