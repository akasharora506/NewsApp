import UIKit
import SafariServices

class MapTableViewCell: UITableViewCell {
    
    static let identifier = "mapCell"
    var parent: UIViewController?
    
    var viewModel = MapTableCellViewModel()
    
    var newsViewModels = [MapCollectionViewModel]()
    var articles = [Article]()
    var cityName = ""
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MapCollectionCell.self, forCellWithReuseIdentifier: MapCollectionCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        viewModel.articles.bind { [weak self] articles in
            self?.articles = articles
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
          }
        viewModel.newsViewModels.bind { [weak self] newsViewModels in
            self?.newsViewModels = newsViewModels
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
          }
        addConstraints()
    }
    
    func addConstraints(){
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(collectionView.topAnchor.constraint(equalTo: contentView.topAnchor))
        constraints.append(collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -25))
        constraints.append(collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor))
        constraints.append(collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor))
        
        NSLayoutConstraint.activate(constraints)
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
extension MapTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapCollectionCell.identifier, for: indexPath) as! MapCollectionCell
        cell.configureTile(with: newsViewModels[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsViewModels.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: contentView.frame.width, height: contentView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let url = URL(string: articles[indexPath.row].url ?? "" ) else {
            return
        }
        let vc = SFSafariViewController(url: url)
        parent?.navigationController?.pushViewController(vc, animated: true)
    }
}
