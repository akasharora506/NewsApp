import UIKit

class MapTableViewCell: UITableViewCell {
    
    static let identifier = "mapCell"
    let image :UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "bell")
        return image
    }()
    let newsHeadline :UILabel = {
        let headline = UILabel()
        headline.text = "Is New York City 'Over'?"
        headline.font = .systemFont(ofSize: 16, weight: .semibold)
        return headline
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let stackView = UIStackView(arrangedSubviews: [image,newsHeadline])
        stackView.axis = .horizontal
        stackView.frame = contentView.bounds
        stackView.backgroundColor = .lightGray
        stackView.distribution = .equalSpacing
        contentView.addSubview(stackView)
       
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
