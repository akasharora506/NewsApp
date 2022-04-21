import UIKit

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
        return label
    }()
    private let newsSubline: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    private let newsImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .white
        image.layer.cornerRadius = 6
        image.layer.masksToBounds = true
        return image
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsHeadline)
        contentView.addSubview(newsSubline)
        contentView.addSubview(newsImage)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        newsHeadline.frame = CGRect(x: 10, y: 0, width: contentView.frame.width - 160, height: contentView.frame.height/2 - 5)
        newsSubline.frame = CGRect(x: 10, y: 70, width: contentView.frame.width - 160, height: contentView.frame.height/2 - 5)
        newsImage.frame = CGRect(x: contentView.frame.width - 150, y: 5, width: 140, height: contentView.frame.height - 10)
        
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
        if let data = viewModel.imageData {
            newsImage.image = UIImage(data: data)
        }else if let url = viewModel.imageURL {
            URLSession.shared.dataTask(with: url){data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self.newsImage.image = UIImage(data: data)
                }
                
            }.resume()
        }
    }
}
