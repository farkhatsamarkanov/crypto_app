import Foundation
class HistoricalProvider  {

    let realmOps = RealmOps()
    let userInfo = ["key":"value"]
    let networkDataFetcher = NetworkDataFetcher()
   
    var webResponse : [Datum] = []
    var currencySymbol = "BTC"

    
    private var timer: Timer?
    
    private func sendNotification() {
        NotificationCenter.default.post(name: Constants.notificationHist, object: nil, userInfo: userInfo)
    }
    
    //timer
    func reloadTimer() {
        sendNotification()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { timer in
            self.generateHist(symbol: self.currencySymbol)
        }
    }
    
    init(symbol : String) {
        self.currencySymbol = symbol
        self.generateHist(symbol: currencySymbol)
    }
    
    
    func generateHist (symbol : String) {
        self.networkDataFetcher.fetchHist(urlString: "https://min-api.cryptocompare.com/data/v2/histoday?fsym=\(symbol)&tsym=USD&limit=360") { (webResponse) in
            self.webResponse = webResponse.data.data
            
            
            
            DispatchQueue.main.async {
                self.realmOps.saveDatum(histData: self.webResponse)
                self.sendNotification()
            }
       }
    }
    
}
