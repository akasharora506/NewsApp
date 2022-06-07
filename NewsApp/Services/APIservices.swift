import Foundation

final class APIservices {
    static let shared = APIservices()
    // swiftlint: disable force_cast
    static internal let APIKey = Bundle.main.infoDictionary?["API_KEY"] as! String
    static internal let AlternateAPIKey = Bundle.main.infoDictionary?["ALT_API_KEY"] as! String
    // swiftlint: enable force_cast
    struct Constants {
        static let topHeadlinesURL = "https://newsapi.org/v2/top-headlines?country=in&apiKey=\(APIservices.AlternateAPIKey)&pageSize=10"
        static let topHeadlinesURLwithSource = "https://newsapi.org/v2/top-headlines?apiKey=\(APIservices.AlternateAPIKey)&pageSize=10"
    }
    private init() {}
// API
    public func getTopHeadlines(pageNumber: Int,sources: String,completion: @escaping (Result<[Article], Error>,Int) -> Void) {
        var topHeadlineURL = ""
        if(sources != "") { topHeadlineURL = Constants.topHeadlinesURLwithSource+"&page=\(pageNumber)" + "&sources=\(sources)"} else {
            topHeadlineURL = Constants.topHeadlinesURL+"&page=\(pageNumber)"
        }

        guard let topHeadlineURL = URL(string: topHeadlineURL) else {
            return
        }
        let task = URLSession.shared.dataTask(with: topHeadlineURL) {data, _, error in
            if let error = error {
                completion(.failure(error), 0)
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIrespones.self, from: data)
                    completion(.success(result.articles), result.totalResults)
                } catch {
                    completion(.failure(error), 0)
                }
            }
        }
        task.resume()
    }
    public func getQueryHeadlines(queryText: String,pageNumber: Int = 1,selectedSource: String = "",completion: @escaping(Result<[Article],Error>) -> Void) {
        var generatedURL = "https://newsapi.org/v2/everything?q=\(queryText)&pageSize=10&page=\(pageNumber)&apiKey=\(APIservices.AlternateAPIKey)"
        if(selectedSource != "") {
            generatedURL += "&sources=\(selectedSource)" }
        guard let queryURL = URL(string: generatedURL) else {
            return
        }
        let task = URLSession.shared.dataTask(with: queryURL) {data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIrespones.self, from: data)
                    completion(.success(result.articles))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    public func getSources(for category: String,completion: @escaping(Result<[SourceDetail],Error>) -> Void) {
        guard let sourceURL = URL(string: "https://newsapi.org/v2/top-headlines/sources?apiKey=\(APIservices.AlternateAPIKey)&category=\(category)") else {
            return
        }
        let task = URLSession.shared.dataTask(with: sourceURL) {data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(SourceAPIResponse.self, from: data)
                    completion(.success(result.sources))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
