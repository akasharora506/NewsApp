import CoreLocation

public class MapTableCellViewModel {
    var newsViewModels = Box([MapCollectionViewModel]())
    var articles = Box([Article]())
    var onErrorHandling : ((Error) -> Void)?
    func fetchData(cityName: String,completion: ((Result<Bool, Error>) -> Void)? = nil) {
        let formattedCityName = cityName.trimmingCharacters(in: NSCharacterSet.whitespaces).replacingOccurrences(of: " ", with: "-")
        if(formattedCityName == "") {
            self.newsViewModels.value.removeAll()
            self.articles.value.removeAll()
            return
        }
        APIservices.shared.getQueryHeadlines(queryText: formattedCityName) { [weak self] result in
            switch result {
            case .success(let articles):
                print(articles)
                self?.articles.value = articles
                self?.newsViewModels.value = articles.compactMap({
                    MapCollectionViewModel(
                        title: $0.title,
                        subTitle: $0.description ?? "No Description",
                        imageURL: URL(string: $0.urlToImage ?? "")
                    )
                })
            case .failure(let error):
                print(error)
                self?.onErrorHandling?(error)
            }
        }
    }
}
