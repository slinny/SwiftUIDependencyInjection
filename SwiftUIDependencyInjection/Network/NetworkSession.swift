//
//  UserAPIManager.swift
//  SwiftUIDependencyInjection
//
//  Created by Siran Li on 7/28/24.
//

import Foundation
import Alamofire

class URLSessionManager: NetworkSession {
    private var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchData(from urlString: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        session.dataTask(with: url) { data, _, _ in
            completion(data)
        }.resume()
    }
}

class AlamofireManager: NetworkSession {
    func fetchData(from urlString: String, completion: @escaping (Data?) -> Void) {
        AF.request(urlString).responseData { response in
            completion(response.data)
        }
    }
}


