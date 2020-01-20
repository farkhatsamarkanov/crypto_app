import Foundation
import RealmSwift

class RealmOps {
    func saveData(quotes:[Quote]) {
        do {
            let realm = try! Realm()
            try realm.write {
                let result = realm.objects(QuoteCached.self)
                realm.delete(result)
                let quotesRealm = fromQtoR(quotes: quotes)
                for i in quotesRealm {
                    realm.add(i)
                }
            }
        } catch {
            print("Error while writing to Realm: \(error)")
        }
    }
    
    func saveDatum(histData:[Datum]) {
        do {
            let realm = try! Realm()
            try realm.write {
                let result = realm.objects(DatumCached.self)
                realm.delete(result)
              let monthsAvgRealm = datumConverter(arrayOfPrices: histData)
              for i in monthsAvgRealm {
                  realm.add(i)
              }
            }
        } catch {
            print("Error while writing to Realm: \(error)")
        }
    }
    
    func readDatum() -> [Datum] {
        var quotes: [Datum] = []
        do {
            let realm = try Realm()
            let result = realm.objects(DatumCached.self)
         
            quotes = reversedDatumConverter(arrayOfCachedDatum: result)
            
        } catch {
            print("Error while reading data from Realm: \(error)")
        }
        return quotes
    }
    
    func readData() -> [QuoteCached] {
        var quotes: [QuoteCached] = []
        do {
            let realm = try Realm()
            let result = realm.objects(QuoteCached.self)
         
            for quote in result {
                let quoteModel = quote
                quotes.append(quoteModel)
            }
        } catch {
            print("Error while reading data from Realm: \(error)")
        }
        return quotes
    }
    
       
       func datumConverter (arrayOfPrices: [Datum]) -> [DatumCached] {
           var datumRealm: [DatumCached] = []
           for datum in arrayOfPrices {
               let datumCachedRealm = DatumCached()
            datumCachedRealm.time = datum.time
            datumCachedRealm.close = datum.close
            datumRealm.append(datumCachedRealm)
           }
           return datumRealm
       }
    
    func reversedDatumConverter (arrayOfCachedDatum: Results<DatumCached>) -> [Datum] {
        var datumRealm: [Datum] = []
        for datum in arrayOfCachedDatum {
            var datumCachedRealm = Datum(time: 0, close: 0)
            datumCachedRealm.time = datum.time
            datumCachedRealm.close = datum.close
            datumRealm.append(datumCachedRealm)
        }
        return datumRealm
    }
    
    func fromQtoR(quotes: [Quote]) -> [QuoteCached] {
        var quotesRealm: [QuoteCached] = []
        for quote in quotes {
            let quoteRealm = QuoteCached()
            quoteRealm.id = quote.id
            quoteRealm.name = quote.name
            quoteRealm.symbol = quote.symbol
            quoteRealm.rank = quote.rank
            quoteRealm.priceUSD = quote.priceUSD
            quoteRealm.priceBTC = quote.priceBTC
            quoteRealm.volumeUSD24h = quote.volumeUSD24h
            quoteRealm.marketCapUSD = quote.marketCapUSD
            quoteRealm.availableSupply = quote.availableSupply
            quoteRealm.totalSupply = quote.totalSupply
            if let unwrappedMaxSupply = quote.maxSupply {
                quoteRealm.maxSupply = unwrappedMaxSupply
            }
            quoteRealm.percentChange1h = quote.percentChange1h
            if let unwrappedPerc7d = quote.percentChange7d {
                quoteRealm.percentChange7d = unwrappedPerc7d
            }
            quoteRealm.percentChange24h = quote.percentChange24h
            quoteRealm.lastUpdated = quote.lastUpdated
            quotesRealm.append(quoteRealm)
        }
        return quotesRealm
    }
}
