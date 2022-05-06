import UIKit

class SourceTableViewCellViewModel {
    let title: String
    let description: String
    let id: String
  
    init(
        id: String,
        title: String,
        description: String
    ){
        self.title = title
        self.description = description
        self.id = id
    }
}

class SourceTableViewCell: UITableViewCell {
    
    static let identifier = "SourceTableViewCell"
    
    private let SourceName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let SourceDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(SourceName)
        contentView.addSubview(SourceDescription)
        addConstraints()
        
    }
    func addConstraints(){
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(SourceName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5))
        constraints.append(SourceName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10))
        constraints.append(SourceName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10))
        constraints.append(SourceName.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5, constant: -10))
        
        constraints.append(SourceDescription.topAnchor.constraint(equalTo: SourceName.bottomAnchor, constant: 5))
        constraints.append(SourceDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10))
        constraints.append(SourceDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10))
        constraints.append(SourceDescription.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5, constant: -10))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        SourceName.text = nil
        SourceDescription.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: SourceTableViewCellViewModel){
        SourceName.text = viewModel.title
        SourceDescription.text = viewModel.description
       
    }
}
