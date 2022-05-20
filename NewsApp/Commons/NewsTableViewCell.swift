import UIKit
import SDWebImage

class NewsTableViewCellViewModel {
    let title: String
    let subTitle: String
    let imageURL: URL?
    var imageData: Data? = nil
    
    init(
        title: String,
        subTitle: String,
        imageURL: URL?
    ){
        self.title = title
        self.subTitle = subTitle
        self.imageURL = imageURL
    }
}

class NewsTableViewCell: UITableViewCell {
    
    static let identifier = "NewsTableViewCell"
    
    private let newsHeadline: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let newsSubline: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let newsImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .white
        image.layer.cornerRadius = 6
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsHeadline)
        contentView.addSubview(newsSubline)
        contentView.addSubview(newsImage)
        addConstraints()
    }
    
    func addConstraints(){
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(newsHeadline.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5))
        constraints.append(newsHeadline.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10))
        constraints.append(newsHeadline.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6,constant: -10))
        constraints.append(newsHeadline.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5,constant: -5))
        
        constraints.append(newsSubline.topAnchor.constraint(equalTo: newsHeadline.bottomAnchor, constant: 5))
        constraints.append(newsSubline.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10))
        constraints.append(newsSubline.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6))
        constraints.append(newsSubline.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5,constant: -5))

        constraints.append(newsImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1,constant: -10))
        constraints.append(newsImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4,constant: -10))
        constraints.append(newsImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5))
        constraints.append(newsImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5))
        constraints.append(newsImage.leadingAnchor.constraint(equalTo: newsHeadline.trailingAnchor, constant: 5))
        

        NSLayoutConstraint.activate(constraints)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        newsImage.image = nil
        newsSubline.text = nil
        newsHeadline.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: NewsTableViewCellViewModel){
        newsHeadline.text = viewModel.title
        newsSubline.text = viewModel.subTitle
        newsImage.sd_setImage(with: viewModel.imageURL)
    }
}
