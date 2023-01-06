//
//  MeterVC.swift
//  Me Electricity Bills
//
//  Created by Yasu Tanaka on 06/12/2015.
//  Copyright © 2015 Yasuhiro Tanaka. All rights reserved.
//

import UIKit
import GoogleMobileAds

class MeterVC: UIViewController, UITextFieldDelegate, GADBannerViewDelegate {

    var admobView: GADBannerView = GADBannerView()
    let AdMobID = "ca-app-pub-4461718674523728/9866657495"

    @IBOutlet weak var mainLbl: UILabel!
    @IBOutlet weak var heatingTitleLbl: UILabel!
    @IBOutlet weak var heatingMeterField: UITextField!
    @IBOutlet weak var lightingTitleLbl: UILabel!
    @IBOutlet weak var lightingMeterField: UITextField!
    @IBOutlet weak var heatingEnterBtn: UIButton!
    @IBOutlet weak var heatingMeterView: RoundedView!
    @IBOutlet weak var lightingMeterView: RoundedView!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var hStartLbl: UILabel!
    @IBOutlet weak var lStartLbl: UILabel!
    @IBOutlet weak var hLastLbl: UILabel!
    @IBOutlet weak var lLastLbl: UILabel!

    let hot = HotTime22Long()
    var lastReading: Double!
    var currentReading: Double!
    var kwhForUsageLbl: Double!

    let bLighting = LightingB()
    var lastReadingLighting: Double!
    var currentReadingLighting: Double!
    var kwhForUsageLblLighting: Double!

    let doubleFormatter: NumberFormatter = {
        let doubleFm = NumberFormatter()
        doubleFm.numberStyle = .decimal
        doubleFm.minimumFractionDigits = 0
        doubleFm.maximumFractionDigits = 1
        return doubleFm
    }()

    let oopsString = NSLocalizedString("Oops!", comment: "Oops! alert")
    let wrongValueString = NSLocalizedString("Current meter reading must be greater than the last ", comment: "meter input alert")
    let enterReadingString = NSLocalizedString("Please enter correct meter reading.", comment: "enter meter alert")
    let periodString = NSLocalizedString(").", comment: "must be jpn period")
    let lastText = NSLocalizedString("Last: ", comment: "meterVC last label")
    let startText = NSLocalizedString("Start: ", comment: "meterVC start lablel")

    func appdelegate() -> AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }

    override func viewWillAppear(_ animated: Bool) {
        startAdMob()
    }

    override func viewWillDisappear(_ animated: Bool) {

        admobView.delegate = nil
        admobView.removeFromSuperview()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        okBtn.isHidden = true
        hLastLbl.isHidden = true
        lLastLbl.isHidden = true
        if UserDefaults.standard.bool(forKey: "heatingSwitch") != true {
            heatingMeterView.isHidden = true

        } else {
            heatingMeterView.isHidden = false
            heatingTitleLbl.text = hot.title
            heatingMeterField.delegate = self
            if let currentReadingDefault = UserDefaults.standard.value(forKey: "heatingCurrentReading") {
                Heating.data.currentMeter = currentReadingDefault as! Double
            }
            if let lastReadingDefault = UserDefaults.standard.value(forKey: "heatingLastReading") {
                Heating.data.lastMeter = lastReadingDefault as! Double
                hLastLbl.isHidden = false
                hLastLbl.text = lastText + String(Heating.data.lastMeter)
            }
            if let startReadingDefault = UserDefaults.standard.value(forKey: "heatingStartReading") {
                Heating.data.startMeter = startReadingDefault as! Double
                hStartLbl.text = startText + String(Heating.data.startMeter)
            }
        }

        if UserDefaults.standard.bool(forKey: "lightingSwitch") != true {
            lightingMeterView.isHidden = true
        } else {
            lightingMeterView.isHidden = false
            lightingTitleLbl.text = bLighting.title
            lightingMeterField.delegate = self
            if let currentDefault = UserDefaults.standard.value(forKey: "lightingCurrentReading") {
                Lighting.data.currentMeter = currentDefault as! Double
            }
            if let lastDefault = UserDefaults.standard.value(forKey: "lightingLastReading") {
                Lighting.data.lastMeter = lastDefault as! Double
                lLastLbl.isHidden = false
                lLastLbl.text = lastText + String(Lighting.data.lastMeter)
            }
            if let startDefault = UserDefaults.standard.value(forKey: "lightingStartReading") {
                Lighting.data.startMeter = startDefault as! Double
                lStartLbl.text = startText + String(Lighting.data.startMeter)
            }
        }
    }

    func startAdMob(){

        admobView = GADBannerView(adSize:kGADAdSizeBanner)
        admobView.frame.origin = CGPoint(x: 0, y: self.view.frame.size.height - admobView.frame.height)
        admobView.frame.size = CGSize(width: self.view.frame.width, height: admobView.frame.height)
        admobView.adUnitID = AdMobID
        admobView.delegate = self
        admobView.rootViewController = self
        let admobRequest:GADRequest = GADRequest()
        admobView.load(admobRequest)
        self.view.addSubview(admobView)
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

    func setKwhForHeatingLbl() {

        kwhForUsageLbl = hot.getKwhUsed(currentMtrReading: currentReading, lastMtrReading: lastReading)
        Heating.data.kwh = kwhForUsageLbl
        UserDefaults.standard.set(Heating.data.kwh, forKey: "heatingKwh")
        UserDefaults.standard.synchronize()
    }

    func setKwhForLightingLbl() {

        kwhForUsageLblLighting = bLighting.getKwhUsed(currentMtrReading: currentReadingLighting, lastMtrReading: lastReadingLighting)
        Lighting.data.kwh = kwhForUsageLblLighting
        UserDefaults.standard.set(Lighting.data.kwh, forKey: "lightingKwh")
        UserDefaults.standard.synchronize()
    }

    func setYenForLbl() {
        let yenForLbl = Heating.data.kwh * hot.rate
        Heating.data.yen = yenForLbl
    }

    func setYenForLightingLbl() {
        let yenForLblLighting = bLighting.getPriceForKwh()
        Lighting.data.yen = yenForLblLighting
    }

    @IBAction func heatingEnterBtnPressed(_ sender: AnyObject) {

        if let text = heatingMeterField.text, !text.isEmpty {
            currentReading = Double(text)
            if currentReading <= 9999.9 {

            Heating.data.currentMeter = currentReading

            if let last = Heating.data.lastMeter {
                lastReading = last
            } else if let start = Heating.data.startMeter {
                lastReading = start
            }

            if lastReading < currentReading {

                heatingMeterField.resignFirstResponder()
                setKwhForHeatingLbl()
                setYenForLbl()

                if lightingMeterView.isHidden != true && lightingMeterField.text == "" {
                    okBtn.isHidden = true
                } else {
                    okBtn.isHidden = false
                }
            } else {

                let alert = UIAlertController(title: oopsString, message: wrongValueString + "(" + String(lastReading) + periodString, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                heatingMeterField.text = ""
            }

            heatingMeterField.resignFirstResponder()
        } else {

            let alert = UIAlertController(title: oopsString, message: enterReadingString, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func heatingResetBtnPressed(_ sender: AnyObject) {

        heatingMeterField.text = ""
        Heating.data.lastMeter = nil
        hLastLbl.isHidden = true
        Date.data.lastDate = Date.data.startDate
        heatingMeterField.resignFirstResponder()
    }

    @IBAction func lightingEnterBtnPressed(_ sender: AnyObject) {

        if let text = lightingMeterField.text, !text.isEmpty {
            currentReadingLighting = Double(text)
            if currentReadingLighting <= 9999.9 {
            Lighting.data.currentMeter = currentReadingLighting

            if let last = Lighting.data.lastMeter {
                lastReadingLighting = last
            } else if let start = Lighting.data.startMeter {
                lastReadingLighting = start
            }

            if lastReadingLighting < currentReadingLighting {

                lightingMeterField.resignFirstResponder()
                setKwhForLightingLbl()
                setYenForLightingLbl()

                if heatingMeterView.isHidden != true && heatingMeterField.text == "" {
                    okBtn.isHidden = true
                } else {
                    okBtn.isHidden = false
                }
            } else {
                let alert = UIAlertController(title: oopsString, message: wrongValueString + "(" + String(lastReadingLighting) + periodString, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                lightingMeterField.text = ""
            }
            lightingMeterField.resignFirstResponder()
        } else {
            let alert = UIAlertController(title: oopsString, message: enterReadingString, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        }
    }

    @IBAction func lightingResetBtnPressed(_ sender: AnyObject) {
        lightingMeterField.text = ""
        Lighting.data.lastMeter = nil
        lLastLbl.isHidden = true
        Date.data.lastDate = Date.data.startDate
        lightingMeterField.resignFirstResponder()
    }

    @IBAction func okBtnPressed(_ sender: AnyObject) {

        if case heatingMeterView.isHidden = false, lightingMeterView.isHidden != false {
            sortOutHeating()
        } else if case lightingMeterView.isHidden = false, heatingMeterView.isHidden != false {
            sortOutLighting()
        } else if case lightingMeterView.isHidden = false, heatingMeterView.isHidden != true {
            sortOutHeating()
            sortOutLighting()
        }
        performSegue(withIdentifier: "showUsageVC", sender: nil)
    }

    func sortOutHeating() {

        if heatingMeterField.text != nil || heatingMeterField.text != "" {

            lastReading = currentReading
            Heating.data.lastMeter = lastReading

            UserDefaults.standard.set(currentReading, forKey: "heatingCurrentReading")
            UserDefaults.standard.set(lastReading, forKey: "heatingLastReading")
            UserDefaults.standard.synchronize()
        }
    }

    func sortOutLighting() {

        if lightingMeterField.text != nil || lightingMeterField.text != "" {

            lastReadingLighting = currentReadingLighting
            Lighting.data.lastMeter = lastReadingLighting

            UserDefaults.standard.set(currentReadingLighting, forKey: "lightingCurrentReading")
            UserDefaults.standard.set(lastReadingLighting, forKey: "lightingLastReading")
            UserDefaults.standard.synchronize()
        }
    }

    @IBAction func cancelBtnPressed(_ sender: AnyObject) {
        dismiss(animated: false, completion: nil)

    }

}
