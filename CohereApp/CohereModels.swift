//
//  CohereModels.swift
//  CohereApp
//
//  Created by roman on 12/29/24.
//

import Foundation

struct CohereRequest: Codable {
    let prompt: String
    let model: String
    let max_tokens: Int
    let temperature: Double
}

struct CohereResponse: Codable {
    let text: String
}


