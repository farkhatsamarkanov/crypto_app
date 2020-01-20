import Foundation
import UIKit

class ConverterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // OBJECTS
    @IBOutlet weak var BaseQuotePickerView: UIPickerView!
    @IBOutlet weak var InputField: UITextField!
    @IBOutlet weak var ConvertionResultLabel: UILabel!
    @IBAction func ConvertButton(_ sender: Any) {
        view.endEditing(true)
        if InputField.text! != "" {
            ConvertionResultLabel.text = String(Double(InputField.text!)!*activeBaseQuotePrice/activeConvertionQuotePrice)
        }
    }
    
    // VARIABLES
    var convQuotes: [QuoteCached] = []
    var activeBaseQuotePrice: Double = 0.0
    var activeConvertionQuotePrice: Double = 0.0
    // var quoteProvider:QuoteProvider?
    let realmOps = RealmOps()
                
    override func viewDidLoad() {
        super.viewDidLoad()
        ConvertionResultLabel.layer.borderColor = UIColor.lightGray.cgColor
        ConvertionResultLabel.layer.borderWidth = 1.0
        ConvertionResultLabel.layer.cornerRadius = 6.0
        convQuotes = realmOps.readData()
        
        if let unwrapedConvPrice = Double(convQuotes[0].priceUSD) {
            activeBaseQuotePrice = unwrapedConvPrice
            activeConvertionQuotePrice = unwrapedConvPrice
        }
        NotificationCenter.default.addObserver(self, selector: #selector(received(notif:)), name: Constants.notificationName, object: nil)
        configureTextField()
        configureTapGesture()
        BaseQuotePickerView.reloadAllComponents()
    }
    //Observer
    @objc func received(notif: Notification) {
        convQuotes = realmOps.readData()
        BaseQuotePickerView.reloadAllComponents()
        
    }
    
    private func configureTapGesture () {
        let tapGesture = UITapGestureRecognizer (target: self, action: #selector(ConverterViewController.handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
       
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return convQuotes.count
        }
        else {
            return convQuotes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return convQuotes[row].name
        }
        else {
            return convQuotes[row].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let unwrapedPickerPrice = Double(convQuotes[row].priceUSD) {
            switch (component) {
            case 0:
                activeBaseQuotePrice = unwrapedPickerPrice
            case 1:
                activeConvertionQuotePrice = unwrapedPickerPrice
            default:break
            }
        }
    }
}
// will be used later
extension ConverterViewController: UITextFieldDelegate {
    private func configureTextField () {
        InputField.delegate = self
    }
}

