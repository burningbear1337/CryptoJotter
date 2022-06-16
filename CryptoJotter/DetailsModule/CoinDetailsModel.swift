//
//  DetailsCoinModel.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 08.06.2022.
//

import Foundation

struct CoinDetailsModel: Codable {
    let name: String?
    let detailsCoinModelDescription: Description?
    let links: Links?
    let marketCapRank: Int?

    enum CodingKeys: String, CodingKey {
        case name
        case detailsCoinModelDescription = "description"
        case links
        case marketCapRank = "market_cap_rank"
    }
}

struct Description: Codable {
    let en: String?
}

struct Links: Codable {
    let homepage: [String]?
    let blockchainSite: [String]?

    enum CodingKeys: String, CodingKey {
        case homepage
        case blockchainSite = "blockchain_site"
    }
}
