import Foundation
struct Quote: Decodable {
    var id: String
    var name: String
    var symbol: String
    var rank: String
    var priceUSD: String
    var priceBTC: String
    var volumeUSD24h: String
    var marketCapUSD: String
    var availableSupply: String
    var totalSupply: String
    var maxSupply: String?
    var percentChange1h: String
    var percentChange24h: String
    var percentChange7d: String?
    var lastUpdated: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case rank
        case priceUSD = "price_usd"
        case priceBTC = "price_btc"
        case volumeUSD24h = "24h_volume_usd"
        case marketCapUSD = "market_cap_usd"
        case availableSupply = "available_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case percentChange1h = "percent_change_1h"
        case percentChange24h = "percent_change_24h"
        case percentChange7d = "percent_change_7d"
        case lastUpdated = "last_updated"
    }
}

