//Models
struct APIrespones: Codable {
    let totalResults: Int
    let articles: Array<Article>
}
// Article Model
struct Article: Codable{
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
}
// Source Model
struct Source: Codable{
    let name: String
}


