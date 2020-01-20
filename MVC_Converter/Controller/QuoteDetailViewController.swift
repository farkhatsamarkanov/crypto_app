import UIKit
import Charts

class QuoteDetailViewController: UIViewController {
    
    @IBOutlet weak var currencyIcon: UIImageView!
    @IBOutlet weak var rankLabelData: UILabel!
    @IBOutlet weak var quoteDetailNameLabel: UILabel!
    @IBOutlet weak var priceUSDLabelData: UILabel!
    @IBOutlet weak var IDLabelData: UILabel!
    @IBOutlet weak var priceBTCLabelData: UILabel!
    @IBOutlet weak var symbolLabelData: UILabel!
    @IBOutlet weak var nameLabelData: UILabel!
    @IBOutlet weak var volume24hLabelData: UILabel!
    @IBOutlet weak var totalSupplyLabelData: UILabel!
    @IBOutlet weak var maxSupplyLabelData: UILabel!
    @IBOutlet weak var lastUpdatedLabelData: UILabel!
    @IBOutlet weak var change7dLabelData: UILabel!
    @IBOutlet weak var change24hLabelData: UILabel!
    @IBOutlet weak var change1hLabelData: UILabel!
    @IBOutlet weak var marketCapLabelData: UILabel!
    @IBOutlet weak var availableSupplyLabelData: UILabel!
    @IBOutlet weak var mChart: LineChartView!
    
    let realmOps = RealmOps()
    var webResponseKeys : [Int] = []
    var webResponseValues : [Double] = []
    var monthsArray : [Double] = []
    var weeksArray : [Double] = []
    var daysArray : [Double] = []
    var xAxisArrayYear : [String] = []
    var dataForChart : [Datum] = []
    let dateFormatter = formatter()
    var quote: QuoteCached?
    var btcPrice: Double?
    var historicalProvider : HistoricalProvider?
    var dataEntries: [ChartDataEntry] = []
    
    func findAvgMonths (arrayOfDoubles: [Double]) -> [Double] {
        var arrayOfMonthsAvg : [Double] = []
        for i in stride(from: 0, to: 12, by: 1) {
            var sum : Double = 0
            for k in stride(from: 0 + (30 * i), through: 29 + (30 * i), by: 1) {
                sum += arrayOfDoubles[k]
            }
            arrayOfMonthsAvg.append(Double(round(sum*1000/30)/1000))
        }
        return arrayOfMonthsAvg
    }
    
    func findAxisNamesYear (arrayOfDates: [Int]) -> [String] {
        var arrayDatesMonthly : [String] = []
        for index in stride(from: 30, to: 361, by: 30) {
            arrayDatesMonthly.append(dateFormatter.formatDateForHist(unixDate: arrayOfDates[index]))
        }
        return arrayDatesMonthly
    }
    
    func findAvgWeeks (arrayOfDoubles: [Double]) -> [Double] {
        var arrayWeekly : [Double] = []
        for i in stride(from: 3, through: 0, by: -1) {
            var sum : Double = 0
            for k in stride(from: 6 + (7 * i), through: 0 + (7 * i), by: -1) {
                sum += arrayOfDoubles[arrayOfDoubles.count - 1 - k]
            }
            arrayWeekly.append(sum/7)
        }
        return arrayWeekly
    }
    
    func findAvgDays (arrayOfDoubles: [Double]) -> [Double] {
        var arrayDaily : [Double] = []
        for index in 353...(arrayOfDoubles.count - 1) {
            arrayDaily.append(arrayOfDoubles[index])
        }
        return arrayDaily
    }
    
    func prepareDataForChart(){
        if dataForChart.count != 0 {
        for element in self.dataForChart {
            self.webResponseKeys.append(element.time)
            self.webResponseValues.append(element.close)
        }
        self.monthsArray = self.findAvgMonths(arrayOfDoubles: self.webResponseValues)
        self.xAxisArrayYear = self.findAxisNamesYear(arrayOfDates: self.webResponseKeys)
        self.weeksArray = self.findAvgWeeks(arrayOfDoubles: self.webResponseValues)
        self.daysArray = self.findAvgDays(arrayOfDoubles: self.webResponseValues)
        }
    }
    
    func prepareDataForDetailView() {
        if let quote = quote, let btcPrice = btcPrice{
            quoteDetailNameLabel.text = "\(quote.name)  (\(quote.symbol))"
            rankLabelData.text = "\(quote.rank)"
            priceUSDLabelData.text = "\(quote.priceUSD) $"
            IDLabelData.text = "\(quote.id)"
            if let unwrapedPriceUSD = Double(quote.priceUSD) {
                priceBTCLabelData.text = "\(Double(round(unwrapedPriceUSD*1000000/btcPrice)/1000000)) BTC"
            }
            symbolLabelData.text = "\(quote.symbol)"
            nameLabelData.text = "\(quote.name)"
            volume24hLabelData.text = "\(quote.volumeUSD24h) $"
            totalSupplyLabelData.text = "\(quote.totalSupply) \(quote.symbol)"
            maxSupplyLabelData.text = "\(quote.maxSupply) \(quote.symbol)"
            change7dLabelData.text = "\(quote.percentChange7d) %"
            change24hLabelData.text = "\(quote.percentChange24h) %"
            change1hLabelData.text = "\(quote.percentChange1h) %"
            marketCapLabelData.text = "\(quote.marketCapUSD) $"
            lastUpdatedLabelData.text = "\(dateFormatter.formatDate(unixDate: quote.lastUpdated))"
            availableSupplyLabelData.text = "\(quote.availableSupply)"
            currencyIcon.image = UIImage(named: quote.id) ?? UIImage(named: "fillerIcon")
        }
    }
    
    @objc func received(notif: Notification) {
        dataForChart = realmOps.readDatum()
        prepareDataForChart()
        setChart(values: monthsArray, xAxisValues: xAxisArrayYear)
    }
    
    func setChart(values: [Double], xAxisValues: [String]) {
        mChart.noDataText = "No data available!"
        dataEntries.removeAll()
        let formato: LineChartFormatter = LineChartFormatter()
        
  
        formato.whatToShow(arrayOfDates: xAxisValues)
        for i in 0..<values.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
            formato.stringForValue(Double(i), axis: mChart.xAxis)
        }
        let xaxis:XAxis = XAxis()
        xaxis.valueFormatter = formato
        mChart.xAxis.valueFormatter = xaxis.valueFormatter
        
        let line1 = LineChartDataSet(entries: dataEntries, label: "Price")
        line1.colors = [NSUIColor.blue]
        line1.mode = .cubicBezier
        line1.cubicIntensity = 0.2
        
        let gradient = getGradientFilling()
        line1.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
        line1.drawFilledEnabled = true
        
        let data = LineChartData()
        
        data.addDataSet(line1)
        mChart.data = data
        mChart.setScaleEnabled(false)
        mChart.drawGridBackgroundEnabled = false
        mChart.xAxis.drawAxisLineEnabled = false
        mChart.xAxis.labelCount = xAxisValues.count - 1
        mChart.xAxis.drawGridLinesEnabled = false
        //mChart.xAxis.gra
        mChart.xAxis.avoidFirstLastClippingEnabled = true
        mChart.leftAxis.drawAxisLineEnabled = false
        mChart.leftAxis.drawGridLinesEnabled = false
        mChart.rightAxis.drawAxisLineEnabled = false
        mChart.rightAxis.drawGridLinesEnabled = false
        mChart.legend.enabled = false
        mChart.xAxis.enabled = true
        mChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        mChart.leftAxis.enabled = false
        mChart.rightAxis.enabled = false
        mChart.xAxis.drawLabelsEnabled = true
        mChart.setViewPortOffsets(left: 20.0, top: 20.0, right: 20.0, bottom: 20.0)
        
        mChart.animate(xAxisDuration: 1.0)
        mChart.data?.notifyDataChanged()
        mChart.notifyDataSetChanged()
       
        
    }
    
    
    // MARK: Creating gradient for filling space under the line chart
    
    private func getGradientFilling() -> CGGradient {
        let coloTop = UIColor(red: 141/255, green: 133/255, blue: 220/255, alpha: 1).cgColor
        let colorBottom = UIColor(red: 230/255, green: 155/255, blue: 210/255, alpha: 1).cgColor
        let gradientColors = [coloTop, colorBottom] as CFArray
        let colorLocations: [CGFloat] = [0.7, 0.0]
        return CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(received(notif:)), name: Constants.notificationHist, object: nil)
        if let quote = quote {
            historicalProvider = HistoricalProvider(symbol: quote.symbol)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       // dataForChart = realmOps.readDatum()
        
        //historicalProvider?.reloadTimer()
        prepareDataForChart()
        prepareDataForDetailView()
        //setChart(values: monthsArray, xAxisValues: xAxisArrayYear)
        
    }
}

