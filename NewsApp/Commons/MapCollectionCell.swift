import UIKit
import SDWebImage

class MapCollectionViewModel {
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

class MapCollectionCell: UICollectionViewCell {
    static let identifier = "MapCollectionCell"

    let newsImage :UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 6
        image.layer.masksToBounds = true
        return image
    }()
    let newsHeadline :UILabel = {
        let headline = UILabel()
        headline.font = .systemFont(ofSize: 21, weight: .semibold)
        headline.translatesAutoresizingMaskIntoConstraints = false
        headline.numberOfLines = 0
        return headline
    }()
    let newsSubline :UILabel = {
        let headline = UILabel()
        headline.font = .systemFont(ofSize: 16, weight: .medium)
        headline.textColor = .systemGray
        headline.numberOfLines = 0
        headline.translatesAutoresizingMaskIntoConstraints = false
        return headline
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(newsImage)
        contentView.addSubview(newsHeadline)
        contentView.addSubview(newsSubline)
        addConstraints()
    }
    func configureTile(with viewModel: MapCollectionViewModel){
        newsHeadline.text = viewModel.title
        newsSubline.text = viewModel.subTitle
        newsImage.sd_setImage(with: viewModel.imageURL)
    }
    func addConstraints(){
        var constraints = [NSLayoutConstraint]()
        constraints.append(newsHeadline.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5))
        constraints.append(newsHeadline.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10))
        constraints.append(newsHeadline.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6,constant: -10))
        constraints.append(newsHeadline.heightAnchor.constraint(equalToConstant: 45))
        
        constraints.append(newsSubline.topAnchor.constraint(equalTo: newsHeadline.bottomAnchor, constant: 5))
        constraints.append(newsSubline.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10))
        constraints.append(newsSubline.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6,constant: -10))
        constraints.append(newsSubline.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -5))

        constraints.append(newsImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -5))
        constraints.append(newsImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4,constant: -10))
        constraints.append(newsImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5))
        constraints.append(newsImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5))
        constraints.append(newsImage.leadingAnchor.constraint(equalTo: newsHeadline.trailingAnchor, constant: 5))
        NSLayoutConstraint.activate(constraints)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
