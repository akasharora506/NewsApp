import UIKit.UIImage
import CoreData

public class SearchViewModel {
    var searchViewModels = Box([NewsTableViewCellViewModel]())
    var articles = Box([Article]())
    var onErrorHandling : ((Error) -> Void)?
    // swiftlint: disable force_cast
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    func fetchData(searchText: String, currentPage: Int, selectedSource: String,completion: ((Result<Bool, Error>) -> Void)? = nil) {
        print(searchText,selectedSource,currentPage)
        let formattedSearchText = searchText.trimmingCharacters(in: NSCharacterSet.whitespaces).replacingOccurrences(of: " ", with: "-")
        APIservices.shared.getQueryHeadlines(queryText: formattedSearchText,pageNumber: currentPage, selectedSource: selectedSource) { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles.value.append(contentsOf: articles)
                self?.searchViewModels.value.append(contentsOf: articles.compactMap({
                    NewsTableViewCellViewModel(
                        title: $0.title,
                        subTitle: $0.description ?? NSLocalizedString("No Description", comment: "No Description"),
                        imageURL: URL(string: $0.urlToImage ?? "")
                    )
                }))
                for article in articles {
                    guard let currContext = self?.context else {
                        return
                    }
                    let newArticle = ArticleItem(context: currContext)
                    newArticle.title = article.title
                    newArticle.publishedAt = article.publishedAt
                    newArticle.url = article.url
                    newArticle.urlToImage = article.urlToImage
                    newArticle.sourceName = article.source.name
                    newArticle.articleDescription = article.description
                    newArticle.queryText = formattedSearchText
                    do {
                        try self?.context.save()
                        print("YAYY, Added to DB")
                    } catch {
                        print("Couldn't add to DB!!")
                    }
                }
            case .failure(let _):
                do {
                    let request = ArticleItem.fetchRequest() as NSFetchRequest<ArticleItem>
                    let pred = NSPredicate(format: "queryText == %@", formattedSearchText)
                    request.predicate = pred
                    let articleItems = try self?.context.fetch(request)
                    self?.articles.value = (articleItems?.compactMap({
                        Article(
                            source: Source(name: $0.sourceName ?? ""),
                            title: $0.title ?? "",
                            description: $0.articleDescription,
                            url: $0.url,
                            urlToImage: $0.urlToImage,
                            publishedAt: $0.publishedAt
                        )
                    })) ?? []
                    self?.searchViewModels.value = (articleItems?.compactMap({
                        NewsTableViewCellViewModel(
                            title: $0.title ?? "",
                            subTitle: $0.articleDescription ?? "No Description",
                            imageURL: URL(string: $0.urlToImage ?? "")
                        )
                    })) ?? []
                } catch {
                    print(error)
                    self?.onErrorHandling?(error)
                }
            }
        }
    }
}
