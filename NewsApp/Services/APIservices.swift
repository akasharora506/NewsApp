import Foundation

final class APIservices {
    
    static let shared = APIservices()
    static internal let API_KEY = Bundle.main.infoDictionary?["API_KEY"] as! String
    static internal let ALT_API_KEY = Bundle.main.infoDictionary?["ALT_API_KEY"] as! String
    struct Constants {
        static let topHeadlinesURL = "https://newsapi.org/v2/top-headlines?country=in&apiKey=\(APIservices.ALT_API_KEY)&pageSize=10"
        static let topHeadlinesURLwithSource = "https://newsapi.org/v2/top-headlines?apiKey=\(APIservices.ALT_API_KEY)&pageSize=10"
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
    public func getQueryHeadlines(queryText: String,pageNumber: Int = 1,selectedSource: String = "",completion: @escaping(Result<[Article],Error>)->Void){
        var generatedURL = "https://newsapi.org/v2/everything?q=\(queryText)&pageSize=10&page=\(pageNumber)&apiKey=\(APIservices.ALT_API_KEY)"
        if(selectedSource != ""){
            generatedURL += "&sources=\(selectedSource)" }
        guard let url = URL(string: generatedURL) else {
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
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines/sources?apiKey=\(APIservices.ALT_API_KEY)&category=\(category)") else {
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

