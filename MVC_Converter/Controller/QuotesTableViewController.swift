import UIKit
import AnimatableReload

class QuotesTableViewController: UITableViewController {
    
    var quotes: [QuoteCached] = []
    var quoteProvider: QuoteProvider?
    let dateFormatter = formatter()
    let realmOps = RealmOps()
   // let gradientView = GradientView()
    
    @IBAction func refreshQuotesAction(_ sender: UIBarButtonItem) {
        quoteProvider?.reloadTimer()
        AnimatableReload.reload(tableView: tableView, animationDirection: "right")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //adding gradient to background
        let gradientView = GradientView(frame: self.view.bounds)
        tableView.backgroundView = gradientView
        //if offline, read data from DB
        quotes = realmOps.readData()
        //observer for refresh notifications
        NotificationCenter.default.addObserver(self, selector: #selector(received(notif:)), name: Constants.notificationName, object: nil)
        //checking if it is app's first launch
        if UserDefaults.standard.bool(forKey: "isSecondLaunch") == false {
            let alert = UIAlertController(title: "Hello!", message: "Using this app you can get latest cryptocurrency rates and convert them from one to another...", preferredStyle: .alert)
            let action = UIAlertAction(title: "Begin!", style: .default)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            UserDefaults.standard.set(true, forKey: "isSecondLaunch")
        }
        quoteProvider = QuoteProvider()
        quoteProvider?.reloadTimer()
        AnimatableReload.reload(tableView: tableView, animationDirection: "right")
       
    }
    
    //observer
    @objc func received(notif: Notification) {
        quotes = realmOps.readData()
        tableView.reloadData()
    }
    // MARK: Table view settings
    override func numberOfSections(in tableView: UITableView) -> Int {
        return quotes.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    // Set the spacing between sections
    /*  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return 20
     }
     // Make the background color show through
     override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     let headerView = UIView()
     headerView.backgroundColor = UIColor(red: 178/255.0, green: 178/255.0, blue: 178/255.0, alpha: 1.0)
     return headerView
     }*/
      
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quoteCellIdentifier", for: indexPath) as! QuoteCell
        let quote = quotes[indexPath.section]
        
        cell.nameLabel.text = "\(quote.name)"
        cell.availableSupplyLabel.text = "\(quote.availableSupply) \(quote.symbol)"
        cell.symbolLabel.text = "(\(quote.symbol))"
        cell.marketCapLabel.text = "\(quote.marketCapUSD) $"
        cell.percentageChange24hLabel.text = "\(quote.percentChange24h) %"
        if let doublePerc = Double(quote.percentChange24h) {
            if doublePerc > 0 {
                cell.percentageChange24hLabel.textColor = UIColor.green
            } else if doublePerc < 0 {
                cell.percentageChange24hLabel.textColor = UIColor.red
            } else if doublePerc == 0 {
                cell.percentageChange24hLabel.textColor = UIColor.yellow
            }
        }
        cell.lastUpdatedLabel.text = "\(dateFormatter.formatDate(unixDate: quote.lastUpdated))"
        cell.priceUSDLabel.text = "\(quote.priceUSD) $"
        cell.twfhVolumeLabel.text = "\(quote.volumeUSD24h) $"
        cell.currencyImage.image = UIImage(named: quote.id) ?? UIImage(named: "fillerIcon")
        cell.backgroundCardView.backgroundColor = UIColor(red: 254/255.0, green: 254/255.0, blue: 254/255.0, alpha: 1.0)
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        cell.backgroundCardView.layer.cornerRadius = 10.0
        cell.backgroundCardView.layer.masksToBounds = true
        cell.shadowView.layer.shadowPath = UIBezierPath(roundedRect: cell.shadowView.bounds, cornerRadius: cell.backgroundCardView.layer.cornerRadius).cgPath
        cell.shadowView.backgroundColor = UIColor.clear
        cell.shadowView.layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
        cell.shadowView.layer.shadowOffset = CGSize(width: 5, height: 5)
        cell.shadowView.layer.shadowRadius = 3.0
        cell.shadowView.layer.shadowOpacity = 0.8
        return cell
    }
    //segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "toDetail" else {
            return
        }
        if let quoteDetail = segue.destination as? QuoteDetailViewController {
            if let cell = sender as? QuoteCell {
                if let indexPath = tableView.indexPath(for: cell) {
                    let quote = quotes[indexPath.section]
                    var btcPricee: Double = 0.0
                    for i in quotes {
                        if i.name == "Bitcoin" {
                            if let unwrapedPrice = Double(i.priceUSD) {
                                btcPricee = unwrapedPrice
                            }
                        }
                    }
                    quoteDetail.quote = quote
                    quoteDetail.btcPrice = btcPricee
                }
            }
        }
    }
}

