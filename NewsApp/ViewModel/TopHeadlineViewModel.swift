import UIKit.UIImage

public class TopHeadlineViewModel {
    
    var topHeadlineViewModels = Box([NewsTableViewCellViewModel]())
    var articles = Box([Article]())
    var totalArticles = Box(0)
    
    func fetchData(currentPage: Int, selectedSource: String){
        APIservices.shared.getTopHeadlines(pageNumber: currentPage, sources: selectedSource ){
            [weak self] result, countArticles in
            self?.totalArticles.value = countArticles
            switch result {
            case .success(let articles):
                self?.articles.value = articles
                self?.topHeadlineViewModels.value = articles.compactMap({
                    NewsTableViewCellViewModel(
                        title: $0.title,
                        subTitle: $0.description ?? "No Description",
                        imageURL: URL(string: $0.urlToImage ?? "")
                    )
                })

            case .failure(let error):
                print(error)
            }
        }
    }
    
}
