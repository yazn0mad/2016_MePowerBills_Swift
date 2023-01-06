//
//  DetailSetupVC.swift
//  Me Electricity Bills
//
//  Created by Yasu Tanaka on 07/12/2015.
//  Copyright © 2015 Yasuhiro Tanaka. All rights reserved.
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


class HeatingDetailsVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var unitTextField: UITextField!
    @IBOutlet weak var pickerLbl: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var startMtrLbl: UILabel!
    @IBOutlet weak var startMtrField: UITextField!
    @IBOutlet weak var startMtrBtn: UIButton!
    @IBOutlet weak var pickerBtn: UIButton!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var seasonSwitch: UISwitch!
    @IBOutlet weak var seasonLbl: UILabel!
    @IBOutlet weak var hintLbl: UILabel!

    let heating = Heating()
    let hot = HotTime22Long()

    var startMeter: Double!
    let oopsString = NSLocalizedString("Oops!", comment: "Oops! alert")
    let pickerData = ["85%超過", "85% ", "85未満"]
    var seasonSwitchIsOn: Bool!
    var seasonPrice: Double!

    enum Types: Double {
        case plus85 = 0.95
        case just85 = 1.0
        case minus85 = 1.05
    }

    let doubleFormatter: NumberFormatter = {
        let doubleFm = NumberFormatter()
        doubleFm.numberStyle = .none
        doubleFm.minimumFractionDigits = 0
        doubleFm.maximumFractionDigits = 1
        return doubleFm
    }()

    let intFormatter: NumberFormatter = {
        let intFm = NumberFormatter()
        intFm.numberStyle = .none
        return intFm
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.picker.dataSource = self
        self.picker.delegate = self
        selectBtn.isHidden = false
        picker.isHidden = true
        hintLbl.isHidden = false
        pickerLbl.isHidden = true

        if let oldValue = UserDefaults.standard.value(forKey: "heatingUnit") {
            unitTextField.text = intFormatter.string(from: NSNumber(value: oldValue as! Double))
            Heating.data.unit = oldValue as! Double
        }

        if let selected = UserDefaults.standard.value(forKey: "heatingSelected") as? String {
            hintLbl.isHidden = true
            pickerLbl.isHidden = false
            pickerLbl.text = selected
            Heating.data.hotType = selected
        }

        if let startMtr = UserDefaults.standard.value(forKey: "heatingStartReading") {
            startMtrField.text = doubleFormatter.string(from: NSNumber(value: startMtr as! Double))
            Heating.data.startMeter = startMtr as! Double
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if UserDefaults.standard.bool(forKey: "seasonSwitch") != false {
            seasonSwitch.setOn(true, animated: false)
            Heating.data.seasonSwitchOn = true
            seasonSwitchIsOn = true
            seasonPrice = hot.onSeason

        } else if UserDefaults.standard.bool(forKey: "seasonSwith") != true {
            seasonSwitch.setOn(false, animated: false)
            Heating.data.seasonSwitchOn = false
            seasonSwitchIsOn = false
            seasonPrice = hot.offSeason

        } else if Heating.data.seasonSwitchOn != true {
            seasonSwitch.setOn(false, animated: false)
            seasonSwitchIsOn = false
            seasonPrice = hot.offSeason

        } else {
            seasonSwitch.setOn(true, animated: false)
            seasonSwitchIsOn = true
            seasonPrice = hot.onSeason
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.standard.set(seasonSwitchIsOn, forKey: "seasonSwitch")
        UserDefaults.standard.set(seasonPrice, forKey: "unitPrice")
        UserDefaults.standard.synchronize()

    }


    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        let label = UILabel()
        let titleData = pickerData[row]
        let myTitle = NSAttributedString(string: titleData)
        label.attributedText = myTitle
        label.textAlignment = NSTextAlignment.center
        return label
    }

    func getDiscountType() {
        let row = picker.selectedRow(inComponent: 0)
        let selected = pickerData[row]
        var type: Double {
            if selected == "85%超過" {
                return Types.plus85.rawValue
            } else if selected == "85%" {
                return Types.just85.rawValue
            } else {
                return Types.minus85.rawValue
            }
        }
        Heating.data.typeValue = type

        UserDefaults.standard.set(type, forKey: "heatingTypeValue")
        UserDefaults.standard.synchronize()
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

    @IBAction func unitBtnPressed(_ sender: AnyObject) {

        if let text = unitTextField.text, !text.isEmpty {

            let newValue = Double(text)
            Heating.data.unit = newValue

            UserDefaults.standard.set(newValue!, forKey: "heatingUnit")
            UserDefaults.standard.synchronize()

        } else {
            let alert = UIAlertController(title: oopsString, message: "Please enter a number.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        view.endEditing(true)
    }

    @IBAction func pickerBtnPressed(_ sender: AnyObject) {
        picker.isHidden = false
        selectBtn.isHidden = false
        hintLbl.isHidden = true
        pickerLbl.isHidden = true
        startMtrLbl.isHidden = true
        startMtrField.isHidden = true
        startMtrBtn.isHidden = true
        seasonLbl.isHidden = true
        seasonSwitch.isHidden = true
    }

    @IBAction func selectBtnPressed(_ sender: AnyObject) {
        picker.isHidden = true
        let row = picker.selectedRow(inComponent: 0)
        let selected = pickerData[row]
        hintLbl.isHidden = true
        pickerLbl.isHidden = false
        pickerLbl.text = selected
        getDiscountType()

        startMtrLbl.isHidden = false
        startMtrField.isHidden = false
        startMtrBtn.isHidden = false
        seasonSwitch.isHidden = false
        seasonLbl.isHidden = false

        UserDefaults.standard.set(selected, forKey: "heatingSelected")
        UserDefaults.standard.synchronize()
    }

    @IBAction func meterBtnPressed(_ sender: AnyObject) {
        if let text = startMtrField.text, !text.isEmpty {
            
            let startMtr = Double(text)
            if startMtr >= 0.1 && startMtr <= 9999.9 {

                Heating.data.startMeter = startMtr

                UserDefaults.standard.set(startMtr!, forKey: "heatingStartReading")
                UserDefaults.standard.synchronize()

                view.endEditing(true)
            } else {
                let alert = UIAlertController(title: oopsString, message: "Please enter a valid value.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    @IBAction func seasonSwitchTurnedOn(_ sender: AnyObject) {

        if seasonSwitchIsOn == false {
            seasonSwitch.setOn(true, animated: true)
            seasonSwitchIsOn = true
            Heating.data.seasonSwitchOn = true
            seasonPrice = hot.onSeason

        } else {
            seasonSwitch.setOn(false, animated: true)
            seasonSwitchIsOn = false
            Heating.data.seasonSwitchOn = false
            seasonPrice = hot.offSeason
        }

    }
    

    @IBAction func okBtnPressed(_ sender: AnyObject) {

        if Heating.data.unit != nil && pickerLbl.text != "" && Heating.data.startMeter != nil && startMtrField.text != "" {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            let message = NSLocalizedString("Please fill out the blanks and tap Enter for each entry.", comment: "check input")
            let alert = UIAlertController(title: oopsString, message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func cancelBtnPressed(_ sender: AnyObject) {

        Heating.data.heatingSwitchOn = false

        UserDefaults.standard.set(false, forKey: "heatingSwitch")
        UserDefaults.standard.synchronize()

        self.navigationController?.popToRootViewController(animated: true)
    }

}
