import Foundation
class QuoteProvider {

    let realmOps = RealmOps()
    let userInfo = ["key":"value"]
    let networkDataFetcher = NetworkDataFetcher()
    var webResponse: [Quote?] = []
    var arrayOfQuotes: [Quote] = []
    let urlString = "https://api.coinmarketcap.com/v1/ticker/"
    private var timer: Timer?
    
    private func sendNotification() {
        NotificationCenter.default.post(name: Constants.notificationName, object: nil, userInfo: userInfo)
    }
    
    //timer
    func reloadTimer() {
        sendNotification()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { timer in
            self.generateQuotes()
        }
    }
    
    init() {
        self.generateQuotes()
    }
    
    func generateQuotes () {
        self.networkDataFetcher.fetchData(urlString: urlString) { (webResponse) in
           self.webResponse = webResponse
           for optionalQuote in self.webResponse{
               if let unwrappedQuote = optionalQuote {
                   self.arrayOfQuotes.append(unwrappedQuote)
               }
           }
            DispatchQueue.main.async {
                self.realmOps.saveData(quotes: self.arrayOfQuotes)
                self.sendNotification()
            }
       }
    }
    
}
