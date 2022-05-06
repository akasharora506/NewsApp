import UIKit
import SafariServices

class MapTableViewCell: UITableViewCell {
    
    static let identifier = "mapCell"
    var parent: UIViewController?
    
    var viewModels = [MapCollectionViewModel]()
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
//        print(viewModels)
        cell.configureTile(with: viewModels[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: contentView.frame.width, height: contentView.frame.height)
    }
    func fetchData(){
        let formattedCityName = cityName.trimmingCharacters(in: NSCharacterSet.whitespaces).replacingOccurrences(of: " ", with: "-")
        if(formattedCityName == ""){
            self.viewModels.removeAll()
            self.articles.removeAll()
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            return
        }
        APIservices.shared.getQueryHeadlines(queryText: formattedCityName){ [weak self] result in
            switch result {
            case .success(let articles):
                print(articles)
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    MapCollectionViewModel(
                        title: $0.title,
                        subTitle: $0.description ?? "No Description",
                        imageURL: URL(string: $0.urlToImage ?? "")
                    )
                })
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
                
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let url = URL(string: articles[indexPath.row].url ?? "" ) else {
            return
        }
        let vc = SFSafariViewController(url: url)
        parent?.navigationController?.pushViewController(vc, animated: true)
    }
}
