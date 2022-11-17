import Foundation


//MARK: - Network Service
final class NetworkService {
    
    
    // MARK: Response News
    func getNews(completion: @escaping (Result<ResponseNews, Error>) -> Void) {
        
        guard let urlNews = URL(string: Constant.urlNews) else {return}
        
        URLSession.shared.dataTask(with: urlNews) { data, response, error in
            
            DispatchQueue.main.async {
                // check error
                if let error = error {
                    completion(.failure(error))
                    print(error.localizedDescription)
                }
                // check data
                else if let data = data {
                    do {
                        // json decode
                        let result = try JSONDecoder().decode(ResponseNews.self, from: data)
                        completion(.success(result))
                    } catch let jsonError {
                        print("Failed to decode JSON", jsonError)
                        
                    }
                }
            }
        }.resume()
    }
    
}
