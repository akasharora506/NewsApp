import UIKit

protocol ButtonDelegate{
    func onButtonTap(at index:IndexPath)
}

class TableViewCell: UITableViewCell {
    
    static let identifier = "customCell"
    var delegate:ButtonDelegate!
    var indexPath:IndexPath!
    let searchBar: UISearchTextField = {
       let searchBar = UISearchTextField()
        searchBar.textColor = .darkGray
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search"
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
    }
    @objc func onButtonTap(sender: Any){
        self.delegate?.onButtonTap(at: indexPath)
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
    
    func addConstraints(){
        var constraints = [NSLayoutConstraint]()
        
        //constraints for labeltext
        constraints.append(labelText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor))
        constraints.append(labelText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor))
        constraints.append(labelText.topAnchor.constraint(equalTo: contentView.topAnchor))
        constraints.append(labelText.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.33))
        
        //constraints for searchbar
        constraints.append(searchBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10))
        constraints.append(searchBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10))
        constraints.append(searchBar.topAnchor.constraint(equalTo: labelText.bottomAnchor))
        constraints.append(searchBar.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.33))
        
        //constraints for action button
        constraints.append(button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor))
        constraints.append(button.topAnchor.constraint(equalTo: searchBar.bottomAnchor))
        constraints.append(button.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.33))
        constraints.append(button.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    public func configureButton(labelName: String, buttonName: String){
        button.setTitle(buttonName, for: .normal)
        labelText.text = labelName
    }
}
