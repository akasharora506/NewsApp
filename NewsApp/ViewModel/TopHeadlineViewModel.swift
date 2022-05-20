import UIKit.UIImage
import CoreData

public class TopHeadlineViewModel {
    
    var topHeadlineViewModels = Box([NewsTableViewCellViewModel]())
    var articles = Box([Article]())
    var totalArticles = Box(0)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
                do{
                    let articleItems = try self?.context.fetch(ArticleItem.fetchRequest()) as! [NSManagedObject]
                    
                    for item in articleItems{
                        self?.context.delete(item)
                        do{
                            try self?.context.save()
                        }catch {
                            
                        }
        
                    }
                }catch{
                    
                }
                
                for article in articles{
                    let newArticle = ArticleItem(context: self!.context)
                    newArticle.title = article.title
                    newArticle.publishedAt = article.publishedAt
                    newArticle.url = article.url
                    newArticle.urlToImage = article.urlToImage
                    newArticle.sourceName = article.source.name
                    newArticle.articleDescription = article.description
                    do {
                        try self?.context.save()
                    }catch {
                        
                    }
                }
            case .failure(_):
                do {
                    let articleItems = try self?.context.fetch(ArticleItem.fetchRequest())
                    self?.articles.value = (articleItems?.compactMap({
                        Article(
                            source: Source(name: $0.sourceName ?? ""),
                            title: $0.title ?? "",
                            description: $0.articleDescription,
                            url: $0.url,
                            urlToImage: $0.urlToImage,
                            publishedAt: $0.publishedAt
                        )
                    }))!
                    self?.totalArticles.value = 10
                    self?.topHeadlineViewModels.value = (articleItems?.compactMap({
                        NewsTableViewCellViewModel(
                            title: $0.title ?? "",
                            subTitle: $0.articleDescription ?? "No Description",
                            imageURL: URL(string: $0.urlToImage ?? "")
                        )
                    }))!
                    
                }catch {
                    print(error)
                }
            }
        }
    }
    
}
