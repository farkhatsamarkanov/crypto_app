import Foundation
import RealmSwift

class QuoteCached: Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var symbol = ""
    @objc dynamic var rank = ""
    @objc dynamic var priceUSD = ""
    @objc dynamic var priceBTC  = ""
    @objc dynamic var volumeUSD24h = ""
    @objc dynamic var marketCapUSD = ""
    @objc dynamic var availableSupply = ""
    @objc dynamic var totalSupply = ""
    @objc dynamic var maxSupply = ""
    @objc dynamic var percentChange1h = ""
    @objc dynamic var percentChange24h = ""
    @objc dynamic var percentChange7d = ""
    @objc dynamic var lastUpdated = ""
}

class DatumCached: Object {
    @objc dynamic var time: Int = 0
    @objc dynamic var close: Double = 0
}


