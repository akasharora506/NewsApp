import UIKit

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
        image.image = UIImage(systemName: "bell")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        return image
    }()
    let newsHeadline :UILabel = {
        let headline = UILabel()
        headline.text = "Is New York City 'Over'?"
        headline.font = .systemFont(ofSize: 21, weight: .semibold)
        headline.translatesAutoresizingMaskIntoConstraints = false
        headline.numberOfLines = 0
        return headline
    }()
    let newsSubline :UILabel = {
        let headline = UILabel()
        headline.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum nulla lectus, vehicula quis massa ac, pulvinar varius nibh. Nullam varius sollicitudin ligula, eu hendrerit mauris varius eget. Pellentesque sed ligula ante. Nulla auctor, odio ac ultrices scelerisque, sapien mi ornare nisl, eu fringilla augue metus vel neque. Praesent nisi elit, fermentum vitae orci fermentum, rhoncus convallis velit. Nulla bibendum lectus ac turpis congue viverra. Donec cursus ipsum ac maximus faucibus. Mauris sodales mauris eget urna accumsan sollicitudin. Suspendisse nec maximus justo. Proin non accumsan purus. Sed dignissim turpis et lectus lacinia, ut eleifend erat efficitur. Donec pulvinar quam et enim porttitor, vel posuere sem consectetur. Morbi a sapien ut enim suscipit lobortis."
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
    func addConstraints(){
        var constraints = [NSLayoutConstraint]()
        constraints.append(newsHeadline.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5))
        constraints.append(newsHeadline.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10))
        constraints.append(newsHeadline.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6,constant: -10))
        constraints.append(newsHeadline.heightAnchor.constraint(equalToConstant: 45))
        
        constraints.append(newsSubline.topAnchor.constraint(equalTo: newsHeadline.bottomAnchor, constant: 5))
        constraints.append(newsSubline.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10))
        constraints.append(newsSubline.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6,constant: -10))
        constraints.append(newsSubline.heightAnchor.constraint(equalTo: contentView.heightAnchor,constant: -50))

        constraints.append(newsImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1,constant: -10))
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
