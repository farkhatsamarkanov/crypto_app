import Foundation

class NetworkDataFetcher {
    
    func request(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
        
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else { return }
                completion(.success(data))
            
        }.resume()
    }
    
    func fetchData(urlString: String, response: @escaping (Array<Quote?>) -> Void) {
        request(urlString: urlString) { (result) in
            switch result {
            case .success(let data):
                do {
                    let recievedData = try JSONDecoder().decode(Array<Quote>.self, from: data)
                    response(recievedData)
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    
                }
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
                
            }
        }
    }
    
    func fetchHist (urlString: String, response: @escaping (Historical) -> Void) {
        request(urlString: urlString) { (result) in
            switch result {
            case .success(let data):
                do {
                    let recievedData = try JSONDecoder().decode(Historical.self, from: data)
                    response(recievedData)
                    print(urlString)
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                }
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
            }
        }
    }
    
}

