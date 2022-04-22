import Foundation

final class APIservices {
    
    static let shared = APIservices()
    struct Constants {
        static let topHeadlinesURL = "https://newsapi.org/v2/top-headlines?country=in&apiKey=c0116bfb153f43298374663b7e1379d2&pageSize=10"
    }
    private init(){}
    
    public func getTopHeadlines(pageNumber: Int,completion: @escaping (Result<[Article], Error>,Int)->Void){
        guard let url = URL(string: Constants.topHeadlinesURL+"&page=\(pageNumber)") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url){data, _, error in
            if let error = error {
                completion(.failure(error), 0)
            }
            else if let data = data {
                do{
                    let result = try JSONDecoder().decode(APIrespones.self, from: data)
                    completion(.success(result.articles), result.totalResults)
                }catch{
                    completion(.failure(error), 0)
                }
            }
        }
        task.resume()
        
    }
    public func getQueryHeadlines(queryText: String,pageNumber: Int,completion: @escaping(Result<[Article],Error>)->Void){
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=\(queryText)&pageSize=10&page=\(pageNumber)&apiKey=c0116bfb153f43298374663b7e1379d2") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url){data, _, error in
            if let error = error {
                completion(.failure(error))
            }else if let data = data {
                do{
                    let result = try JSONDecoder().decode(APIrespones.self, from: data)
                    completion(.success(result.articles))
                }catch{
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

//Models

struct APIrespones: Codable {
    let totalResults: Int
    let articles: Array<Article>
}

struct Article: Codable{
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
}

struct Source: Codable{
    let name: String
}
