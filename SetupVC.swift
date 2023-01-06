//
//  SetupVC.swift
//  Me Electricity Bills
//
//  Created by Yasu Tanaka on 07/12/2015.
//  Copyright © 2015 Yasuhiro Tanaka. All rights reserved.
//

import UIKit


class SetupVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstTitleLbl: UILabel!
    @IBOutlet weak var secondTitleLbl: UILabel!
    @IBOutlet weak var discountTxtField: UITextField!
    @IBOutlet weak var allView: UIView!
    @IBOutlet weak var heatingDetailLbl: UILabel!
    @IBOutlet weak var lightingDetailLbl: UILabel!
    @IBOutlet weak var heatingSwitch: UISwitch!
    @IBOutlet weak var lightingSwitch: UISwitch!
    @IBOutlet weak var levyTxtField: UITextField!
    @IBOutlet weak var dateLbl: RoundedLbl!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateBtn : UIButton!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var discountStackView: UIStackView!
    @IBOutlet weak var levyStackView: UIStackView!
    @IBOutlet weak var anchorDiscount: UIView!
    @IBOutlet weak var anchorLevy: UIView!

    let heating = Heating()
    let lighting = Lighting()
    let hot = HotTime22Long()

    var dateLblDate: String!
    var heatingSwitchIsOn: Bool!
    var lightingSwitchIsOn: Bool!
    var unitLblString: String!
    var typeLblString: String!
    var lightingString: String!

    let oopsString = NSLocalizedString("Oops!", comment: "Oops! alert")
    let chkDiscountTitle = NSLocalizedString("What's the discount rate (燃料費調整単価)?", comment: "what's discount title")
    let chkOnlineMessage = NSLocalizedString("Go online to find out?", comment: "permission for using internet")
    let chkLevyTitle = NSLocalizedString("What's the levy rate (再エネ発電賦課金単価)?", comment: "what's levy title")
    let cancelTitle = NSLocalizedString("No", comment: "no to go online")
    let goOnlineTitle = NSLocalizedString("Yes", comment: "yes for online")
    let enterDiscountString = NSLocalizedString("Please enter the discount rate.", comment: "enter discount alert")
    let enterRightDiscount = NSLocalizedString("The value for discount is not valid.", comment: "enter right amount for discount")
    let enterLevyString = NSLocalizedString("Please enter the levy amount.", comment: "enter levy alert")
    let enterRightLevy = NSLocalizedString("The value entered for levy is not valid.", comment: "enter right amount for levy")
    let startDateString = NSLocalizedString("Please enter the start date.", comment: "start date alert")
    let turnSwitchString = NSLocalizedString("Please turn on at least one contract type.", comment: "turn on switch alert")

    let currentDate = Foundation.Date()

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    let doubleFormatter: NumberFormatter = {
        let doubleFm = NumberFormatter()
        doubleFm.numberStyle = .none
        doubleFm.minimumFractionDigits = 0
        doubleFm.maximumFractionDigits = 2
        return doubleFm
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        selectBtn.isHidden = true
        allView.isHidden = false
        datePicker.maximumDate = currentDate

        discountTxtField.delegate = self
        if let oldValue = UserDefaults.standard.value(forKey: "discount") {
            discountTxtField.text = doubleFormatter.string(from: NSNumber(value: oldValue as! Double))
            Heating.data.discount = oldValue as! Double
            Lighting.data.discount = oldValue as! Double
        } else if Heating.data.discount != nil {
            discountTxtField.text = String(Heating.data.discount)
        } else {
            discountTxtField.placeholder = "0.00"
        }

        levyTxtField.delegate = self
        if let oldValue = UserDefaults.standard.value(forKey: "levy") {
            levyTxtField.text = doubleFormatter.string(from: NSNumber(value: oldValue as! Double))
            Heating.data.levy = oldValue as! Double
            Lighting.data.levy = oldValue as! Double
        } else if Heating.data.levy != nil {
            levyTxtField.text = String(Heating.data.levy)
        } else {
            levyTxtField.placeholder = "0.00"

        }

        if let date = UserDefaults.standard.value(forKey: "startDate") as? Foundation.Date {
            dateLbl.text = dateFormatter.string(from: date)
            Date.data.startDate = date

        } else if Date.data.startDate != nil {
            dateLbl.text = dateFormatter.string(from: Date.data.startDate!)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Heating.data.discountWebRequest = true

        if UserDefaults.standard.bool(forKey: "heatingSwitch") != false {
            heatingSwitch.setOn(true, animated: false)
            heatingDetailLbl.isHidden = false
            if let unit = UserDefaults.standard.value(forKey: "heatingUnit") {
                unitLblString = String(describing: unit)
            }
            else {
                unitLblString = String(Heating.data.unit)
            }
            if let type = UserDefaults.standard.value(forKey: "heatingSelected") {
                typeLblString = type as! String
            }
            else {
                typeLblString = Heating.data.hotType
            }
            heatingDetailLbl.text = unitLblString + " kW, " + typeLblString
            Heating.data.heatingSwitchOn = true
            heatingSwitchIsOn = true

        } else if UserDefaults.standard.bool(forKey: "heatingSwith") != true {
            heatingSwitch.setOn(false, animated: false)
            heatingDetailLbl.isHidden = true
            Heating.data.heatingSwitchOn = false
            heatingSwitchIsOn = false

        } else if Heating.data.heatingSwitchOn != true {
            heatingSwitch.setOn(false, animated: false)
            heatingSwitchIsOn = false
            heatingDetailLbl.isHidden = true
        } else {
            heatingSwitch.setOn(true, animated: false)
            heatingSwitchIsOn = true
            heatingDetailLbl.isHidden = false
            heatingDetailLbl.text = "\(Heating.data.unit) kW, \(Heating.data.hotType)"
        }

        if UserDefaults.standard.bool(forKey: "lightingSwitch") != false {
            lightingSwitch.setOn(true, animated: false)
            lightingDetailLbl.isHidden = false

            if let text = UserDefaults.standard.value(forKey: "lightingBasicRate") {
                lightingString = text as! String
            } else {
                lightingString = Lighting.data.basicRate
            }
            lightingDetailLbl.text = lightingString
            Lighting.data.lightingSwitchOn = true
            lightingSwitchIsOn = true

        } else if UserDefaults.standard.bool(forKey: "lightingSwith") != true {
            lightingSwitch.setOn(false, animated: false)
            lightingDetailLbl.isHidden = true
            Lighting.data.lightingSwitchOn = false
            lightingSwitchIsOn = false

        } else if Lighting.data.lightingSwitchOn != true {
            lightingSwitch.setOn(false, animated: false)
            lightingSwitchIsOn = false
            lightingDetailLbl.isHidden = true
        } else {
            lightingSwitch.setOn(true, animated: false)
            lightingSwitchIsOn = true
            lightingDetailLbl.isHidden = false
            lightingDetailLbl.text = ""
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.standard.set(heatingSwitchIsOn, forKey: "heatingSwitch")
        UserDefaults.standard.set(lightingSwitchIsOn, forKey: "lightingSwitch")
        UserDefaults.standard.synchronize()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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

    @IBAction func heatingSwitchOn(_ sender: AnyObject) {

        if heatingSwitchIsOn == false {
            heatingSwitch.setOn(true, animated: true)
            heatingSwitchIsOn = true
            Heating.data.heatingSwitchOn = true
            heatingDetailLbl.isHidden = false
            performSegue(withIdentifier: "showHot", sender: heatingSwitch)
        } else {
            heatingSwitch.setOn(false, animated: true)
            heatingSwitchIsOn = false
            Heating.data.heatingSwitchOn = false
            heatingDetailLbl.isHidden = true
        }
    }

    @IBAction func lightingSwitchOn(_ sender: UISwitch) {

        if lightingSwitchIsOn == false {
            lightingSwitch.setOn(true, animated: true)
            lightingSwitchIsOn = true
            Lighting.data.lightingSwitchOn = true
            lightingDetailLbl.isHidden = false
            performSegue(withIdentifier: "showLighting", sender: lightingSwitch)
        } else {
            lightingSwitch.setOn(false, animated: true)
            lightingSwitchIsOn = false
            Lighting.data.lightingSwitchOn = false
            lightingDetailLbl.isHidden = true
        }
    }

    @IBAction func dateBtnPressed(_ sender: AnyObject) {

        allView.isHidden = true
        datePicker.isHidden = false
        okBtn.isHidden = true
        selectBtn.isHidden = false
        dateLbl.isHidden = true
    }

    @IBAction func selectBtnPressed (_ sender: AnyObject) {

        let date = datePicker.date
        dateLblDate = dateFormatter.string(from: date)
        Date.data.startDate = date

        UserDefaults.standard.set(date, forKey: "startDate")
        UserDefaults.standard.synchronize()

        selectBtn.isHidden = true
        datePicker.isHidden = true
        allView.isHidden = false
        okBtn.isHidden = false
        dateBtn.isHidden = false
        dateLbl.isHidden = false
        if dateLbl.text == nil || dateLbl.text == "" || dateLbl.text != String(dateLblDate) {
            dateLbl.text = dateLblDate
        }
    }

    @IBAction func okBtnPressed(_ sender: AnyObject) {

        if discountTxtField.text == nil || discountTxtField.text == "" {
            let alert = UIAlertController(title: oopsString, message: enterDiscountString, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)


            } else {
                let newValue = Double(discountTxtField.text!)
                Heating.data.discount = newValue
                Lighting.data.discount = newValue

                UserDefaults.standard.set(newValue!, forKey: "discount")
                UserDefaults.standard.synchronize()
            }

        if levyTxtField.text == nil || levyTxtField.text == "" {

            let alert = UIAlertController(title: oopsString, message: enterLevyString, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)



            } else {
                let newValue = Double(levyTxtField.text!)
                Heating.data.levy = newValue
                Lighting.data.levy = newValue

                UserDefaults.standard.set(newValue!, forKey: "levy")
                UserDefaults.standard.synchronize()

        }

        if Date.data.startDate == nil {

            let alert = UIAlertController(title: oopsString, message: startDateString, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)

        } else if Heating.data.heatingSwitchOn != true && Lighting.data.lightingSwitchOn != true {

            let alert = UIAlertController(title: oopsString, message: turnSwitchString, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil )
        }


    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let value = Double(discountTxtField.text!), value >= 9.9 {

            let alert = UIAlertController(title: oopsString, message: enterRightDiscount, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

        if let value = Double(levyTxtField.text!), value >= 9.9 {

            let alert = UIAlertController(title: oopsString, message: enterRightLevy, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }


        self.view.endEditing(true)
    }

    @IBAction func discountChkBtn(_ sender: AnyObject) {

        let chkDiscount = UIAlertController(title: chkDiscountTitle, message: chkOnlineMessage, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        chkDiscount.addAction(cancelAction)
        let goOnlineAction = UIAlertAction(title: goOnlineTitle, style: .default, handler: { (action) -> Void in

            let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "webVCNav")
            self.show(vc as! UIViewController, sender: vc)
        })
        chkDiscount.addAction(goOnlineAction)
        chkDiscount.popoverPresentationController?.sourceView = anchorDiscount
        present(chkDiscount, animated: true, completion: nil)

    }

    @IBAction func levyChkBtnPressed(_ sender: AnyObject) {

        Heating.data.discountWebRequest = false
        let chkLevy = UIAlertController(title: chkLevyTitle, message: chkOnlineMessage, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        chkLevy.addAction(cancelAction)
        let goOnlineAction = UIAlertAction(title: goOnlineTitle, style: .default, handler: { (action) -> Void in

            let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "webVCNav")
            self.show(vc as! UIViewController, sender: vc)
        })
        chkLevy.addAction(goOnlineAction)
        chkLevy.popoverPresentationController?.sourceView = anchorLevy
        present(chkLevy, animated: true, completion: nil)
    }

    @IBAction func supportBtnPressed(_ sender: AnyObject) {
        
    }

}
