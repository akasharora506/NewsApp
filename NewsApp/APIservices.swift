import Foundation

final class APIservices {
    
    static let shared = APIservices()
    struct Constants {
        static let topHeadlinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=0d8efc4eb1c44e22bbe93459486fdf57")
    }
    private init(){}
    
    public func getTopHeadlines(completion: @escaping (Result<[Article], Error>)->Void){
        
        guard let url = Constants.topHeadlinesURL else {
            return
        }
        let task = URLSession.shared.dataTask(with: url){data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
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
    public func getQueryHeadlines(queryText: String,completion: @escaping(Result<[Article],Error>)->Void){
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=\(queryText)&apiKey=0d8efc4eb1c44e22bbe93459486fdf57") else {
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
