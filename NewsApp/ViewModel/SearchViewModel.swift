import UIKit.UIImage

public class SearchViewModel {
    
    var searchViewModels = Box([NewsTableViewCellViewModel]())
    var articles = Box([Article]())
    
    func fetchData(searchText: String, currentPage: Int, selectedSource: String){
        print(searchText,selectedSource,currentPage)
        let formattedSearchText = searchText.trimmingCharacters(in: NSCharacterSet.whitespaces).replacingOccurrences(of: " ", with: "-")
        APIservices.shared.getQueryHeadlines(queryText: formattedSearchText,pageNumber: currentPage, selectedSource: selectedSource){ [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles.value.append(contentsOf: articles)
                self?.searchViewModels.value.append(contentsOf: articles.compactMap({
                    NewsTableViewCellViewModel(
                        title: $0.title,
                        subTitle: $0.description ?? "No Description",
                        imageURL: URL(string: $0.urlToImage ?? "")
                    )
                }))
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
}
