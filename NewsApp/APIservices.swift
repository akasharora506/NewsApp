import Foundation

final class APIservices {
    
    static let shared = APIservices()
    struct Constants {
        static let topHeadlinesURL = "https://newsapi.org/v2/top-headlines?country=in&apiKey=c0116bfb153f43298374663b7e1379d2&pageSize=10"
        static let topHeadlinesURLwithSource = "https://newsapi.org/v2/top-headlines?apiKey=c0116bfb153f43298374663b7e1379d2&pageSize=10"
    }
    private init(){}
// API
    public func getTopHeadlines(pageNumber: Int,sources: String,completion: @escaping (Result<[Article], Error>,Int)->Void){
        var url = ""
        if(sources != ""){ url = Constants.topHeadlinesURLwithSource+"&page=\(pageNumber)" + "&sources=\(sources)" }else{
            url = Constants.topHeadlinesURL+"&page=\(pageNumber)"
        }
        print(url)
        guard let url = URL(string: url) else {
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
    public func getSources(for category: String,completion: @escaping(Result<[SourceDetail],Error>)->Void){
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines/sources?apiKey=c0116bfb153f43298374663b7e1379d2&category=\(category)") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url){data, _, error in
            if let error = error {
                completion(.failure(error))
            }else if let data = data {
                do{
                    let result = try JSONDecoder().decode(SourceAPIResponse.self, from: data)
                    completion(.success(result.sources))
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

//Model for Sources

struct SourceAPIResponse: Codable {
    let sources: Array<SourceDetail>
}

struct SourceDetail: Codable {
    let id: String
    let name: String
    let description: String?
}
