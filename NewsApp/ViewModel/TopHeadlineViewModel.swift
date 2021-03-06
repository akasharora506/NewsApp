import UIKit.UIImage
import CoreData

public class TopHeadlineViewModel {
    var topHeadlineViewModels = Box([NewsTableViewCellViewModel]())
    var articles = Box([Article]())
    var totalArticles = Box(0)
    var onErrorHandling : ((Error) -> Void)?
    let context = (UIApplication.shared.delegate as? AppDelegate ?? AppDelegate()).persistentContainer.viewContext
    func fetchData(currentPage: Int, selectedSource: String,completion: ((Result<Bool, Error>) -> Void)? = nil) {
        APIservices.shared.getTopHeadlines(pageNumber: currentPage, sources: selectedSource ) { [weak self] result, countArticles in
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
                do {
                    guard let articleItems = try self?.context.fetch(ArticleItem.fetchRequest()) else {
                        return
                    }
                    for item in articleItems {
                        self?.context.delete(item)
                        do {
                            try self?.context.save()
                        } catch {
                        }
                    }
                } catch {
                }
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
                    newArticle.queryText = "TopHeadlines"
                    do {
                        try self?.context.save()
                    } catch {
                    }
                }
            case .failure(let error):
                do {
                    let request = ArticleItem.fetchRequest() as NSFetchRequest<ArticleItem>
                    let pred = NSPredicate(format: "queryText == 'TopHeadlines'")
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
                    self?.totalArticles.value = 10
                    self?.topHeadlineViewModels.value = (articleItems?.compactMap({
                        NewsTableViewCellViewModel(
                            title: $0.title ?? "",
                            subTitle: $0.articleDescription ?? "No Description",
                            imageURL: URL(string: $0.urlToImage ?? "")
                        )
                    })) ?? []
                    print(error)
                } catch {
                    self?.onErrorHandling?(error)
                }
            }
        }
    }
}
