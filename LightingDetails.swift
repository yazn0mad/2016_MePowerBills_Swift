//
//  LightingVC.swift
//  Me Electricity Bills
//
//  Created by Yasu Tanaka on 08/02/2016.
//  Copyright © 2016 Yasuhiro Tanaka. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


class LightingDetailsVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerLbl: UILabel!
    @IBOutlet weak var pickerBtn: UIButton!
    @IBOutlet weak var pickerSelectBtn: UIButton!
    @IBOutlet weak var startMtrLbl: UILabel!
    @IBOutlet weak var startMtrField: UITextField!
    @IBOutlet weak var startMtrBtn: UIButton!
    @IBOutlet weak var hintLbl: UILabel!

    let lighting = Lighting()
    let bLighting = LightingB()

    var startMeter: Double!

    let pickerDataStrings = LightingB.basicRates
    let pickerDataValues = LightingB.unitPrices

    var selectedValue: Double!
    var selectedString: String!

    let oopsString = NSLocalizedString("Oops!", comment: "Oops! alert")

    let doubleFormatter: NumberFormatter = {
        let doubleFm = NumberFormatter()
        doubleFm.numberStyle = .none
        doubleFm.minimumFractionDigits = 0
        doubleFm.maximumFractionDigits = 1
        return doubleFm
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        pickerSelectBtn.isHidden = false
        pickerView.isHidden = true
        pickerLbl.isHidden = true
        hintLbl.isHidden = false

        if let selected = UserDefaults.standard.value(forKey: "lightingBasicRate") as? String {
            hintLbl.isHidden = true
            pickerLbl.isHidden = false
            pickerLbl.text = selected

            Lighting.data.basicRate = selected
        }

        if let oldValue = UserDefaults.standard.value(forKey: "lightingUnitPrice") {
            Lighting.data.unitPrice = oldValue as! Double
        }


        if let startMtr = UserDefaults.standard.value(forKey: "lightingStartReading") {
            startMtrField.text = doubleFormatter.string(from: NSNumber(value: startMtr as! Double))
            Lighting.data.startMeter = startMtr as! Double
        }
    }


    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataStrings.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataStrings[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedValue = pickerDataValues[row]
        Lighting.data.unitPrice = selectedValue
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        let titleData = pickerDataStrings[row]
        let myTitle = NSAttributedString(string: titleData)
        label.attributedText = myTitle
        label.textAlignment = NSTextAlignment.center
        return label
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let existingHasDecimal = textField.text?.range(of: ".")
        let replacementHasDecimal = string.range(of: ".")
        if existingHasDecimal != nil && replacementHasDecimal != nil {
            return false
        } else {
            return true
        }
    }

    @IBAction func pickerBtnPressed(_ sender: AnyObject) {
        pickerView.isHidden = false
        pickerSelectBtn.isHidden = false
        pickerLbl.isHidden = true
        hintLbl.isHidden = true
        startMtrLbl.isHidden = true
        startMtrField.isHidden = true
        startMtrBtn.isHidden = true
    }

    @IBAction func selectBtnPressed(_ sender: AnyObject) {

        pickerView.isHidden = true
        let row = pickerView.selectedRow(inComponent: 0)
        let selectedString = pickerDataStrings[row]
        pickerLbl.text = selectedString
        let rowValue = pickerDataValues[row]
        selectedValue = rowValue

        pickerLbl.isHidden = false
        hintLbl.isHidden = true

        startMtrLbl.isHidden = false
        startMtrField.isHidden = false
        startMtrBtn.isHidden = false

        UserDefaults.standard.set(selectedString, forKey: "lightingBasicRate")
        UserDefaults.standard.set(selectedValue, forKey: "lightingUnitPrice")
        UserDefaults.standard.synchronize()
    }

    @IBAction func meterEnterBtnPressed(_ sender: AnyObject) {
        if let text = startMtrField.text, !text.isEmpty {

            view.endEditing(true)
            let startMtr = Double(text)
            if startMtr >= 0.1 && startMtr <= 9999.9 {

                startMeter = startMtr
                Lighting.data.startMeter = startMeter

                UserDefaults.standard.set(startMtr!, forKey: "lightingStartReading")
                UserDefaults.standard.synchronize()
            } else {
                let enterNumString = NSLocalizedString("Please enter the digits.", comment: "enter digits for start meter")
                let alert = UIAlertController(title: oopsString, message: enterNumString, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    @IBAction func okBtnPressed(_ sender: AnyObject) {
        if pickerLbl.text != "" && Lighting.data.startMeter != nil && startMtrField.text != "" {

            self.navigationController?.popToRootViewController(animated: true)

        } else {
            let checkString = NSLocalizedString("Please enter the missing value(s).", comment: "check alert")
            let alert = UIAlertController(title: oopsString, message: checkString, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func cancelBtnPressed(_ sender: AnyObject) {

        Lighting.data.lightingSwitchOn = false

        UserDefaults.standard.set(false, forKey: "lightingSwitch")
        UserDefaults.standard.synchronize()

        self.navigationController?.popToRootViewController(animated: true)
    }
}

