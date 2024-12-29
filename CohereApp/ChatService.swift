//
//  ChatService.swift
//  CohereApp
//
//  Created by roman on 12/29/24.
//

import Alamofire

class ChatService {
    func sendMessage(prompt: String, completion: @escaping (String?) -> Void) {
        let request = CohereRequest(
            prompt: prompt,
            model: "command-xlarge-nightly",
            max_tokens: 100,
            temperature: 0.7
        )

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(CohereAPI.apiKey)",
            "Content-Type": "application/json"
        ]

        AF.request(
            CohereAPI.baseURL,
            method: .post,
            parameters: request,
            encoder: JSONParameterEncoder.default,
            headers: headers
        )
        .validate(statusCode: 200..<300)
        .responseDecodable(of: CohereResponse.self) { response in
            switch response.result {
            case .success(let data):
                print("Decoded response: \(data)")
                completion(data.text)
            case .failure(let error):
                print("Error: \(error)")
                if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                    print("Raw server response: \(responseString)")
                }
                completion(nil)
            }
        }
    }
}
