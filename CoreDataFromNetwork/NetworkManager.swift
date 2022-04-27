
import Foundation
class NetworkManager{
    static func fetchResult(complitionHandler: @escaping (MyResponse?) -> Void ){
        
        let url = URL(string: "https://imdb-api.com/en/API/BoxOffice/k_uw09j68u")
        guard let newURL = url else{
            print("Error while unwrapping URL")
            return
        }
        
        let request = URLRequest(url: newURL)
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else{
                return
            }
            do{
                let result = try JSONDecoder().decode(MyResponse.self, from: data)
                complitionHandler(result)
            }catch let error{
                print(error.localizedDescription)
                complitionHandler(nil)
            }
        }
        task.resume()
    }
}
