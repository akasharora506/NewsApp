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
        return label
    }()
    private let SourceDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(SourceName)
        contentView.addSubview(SourceDescription)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        SourceName.frame = CGRect(x: 10, y: 0, width: contentView.frame.width, height: contentView.frame.height/2 - 5)
        SourceDescription.frame = CGRect(x: 10, y: 70, width: contentView.frame.width, height: contentView.frame.height/2 - 5)
        
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
