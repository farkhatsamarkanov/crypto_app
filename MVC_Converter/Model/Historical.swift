import Foundation

// MARK: - Historical
struct Historical: Decodable {
    let data: DataClass
    enum CodingKeys: String, CodingKey {
        case data = "Data"
    }
}

// MARK: - DataClass
struct DataClass: Decodable {
    let data: [Datum]
    enum CodingKeys: String, CodingKey {
        case data = "Data"
    }
}

// MARK: - Datum
struct Datum: Decodable {
    var time: Int
    var close: Double
}
