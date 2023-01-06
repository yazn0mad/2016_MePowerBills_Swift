//
//  ViewController.swift
//  Me Electricity Bills
//
//  Created by Yasu Tanaka on 04/12/2015.
//  Copyright © 2015 Yasuhiro Tanaka. All rights reserved.
//

import UIKit
import GoogleMobileAds

class MainVC: UIViewController, GADBannerViewDelegate {

    var admobView: GADBannerView = GADBannerView()
    let AdMobID = "ca-app-pub-4461718674523728/9866657495"

    let hot = HotTime22Long()
    let date = Date()
    let bLighting = LightingB()

    @IBOutlet weak var currentDateLbl: UILabel!
    @IBOutlet weak var startDateLbl: UILabel!
    @IBOutlet weak var lastDateLbl: UILabel!
    @IBOutlet weak var heatingView: RoundedView!
    @IBOutlet weak var lightingView: RoundedView!
    @IBOutlet weak var totalBalanceView: RoundStackView!
    @IBOutlet weak var heatingTitleLbl: UILabel!
    @IBOutlet weak var heatingTotalKwhLbl: UILabel!
    @IBOutlet weak var heatingBalanceLbl: UILabel!
    @IBOutlet weak var lightingTitleLbl: UILabel!
    @IBOutlet weak var lightingTotalKwhLbl: UILabel!
    @IBOutlet weak var lightingBalanceLbl: UILabel!
    @IBOutlet weak var totalBalanceLbl: UILabel!
    @IBOutlet weak var numOfDaysLbl: UILabel!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var resetBtnLbl: UILabel!
    @IBOutlet weak var anchorView: UIView!

    var startDate: Foundation.Date!
    var currentMeter: Double!
    var currentDate: Foundation.Date!
    var heatingSwitchIsOn: Bool!
    var lightingSwitchIsOn: Bool!
    var numOfDays = Date.data.numberOfDays
    let oopsString = NSLocalizedString("Oops!", comment: "Oops! alert")
    let resetTitle = NSLocalizedString("Reset all?", comment: "reset all settings alert")
    let resetMessage = NSLocalizedString("Are you sure you want to erase all data?", comment: "comment for all reset alert")
    let cancelTitle = NSLocalizedString("Cancel", comment: "cancel for all reset alert")
    let allResetTitle = NSLocalizedString("All Reset", comment: "reset for all reset alert")
    let ignoreTitle = NSLocalizedString("Ignore", comment: "ignore for starting over")
    let expirationTitle = NSLocalizedString("It's been over 30 days!", comment: "it's been over 30 days alert")
    let expirationMessage = NSLocalizedString("Reset and start over?", comment: "reset and start over question")
    let pleaseTapMeterString = NSLocalizedString("Please tap METER button.", comment: "tap meter btn")
    let kwhUnknownString = NSLocalizedString("kWh: Unknown", comment: "kwh unknown")
    let goToTheSettingString = NSLocalizedString("Please go to the Settings and choose your contract type.", comment: "go to the settings alert")
    let enterStartMtr = NSLocalizedString("Start meter value is missing. Please go back to the Detail Setup.", comment: "startMtr value missing")


    let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.roundingMode = .floor
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }()

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    func appdelegate() -> AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }

    override func viewWillAppear(_ animated: Bool) {

        startAdMob()
        setDate()
        setHeatingBalanceLbl()
        setLightingBalanceLbl()
        setTotalBalanceLbl()

    }

    override func viewWillDisappear(_ animated: Bool) {

        admobView.delegate = nil
        admobView.removeFromSuperview()
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

    override func viewDidLoad() {
        super.viewDidLoad()
        setDate()
        resetBtn.isHidden = true
        resetBtnLbl.isHidden = true

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAlert()
    }

    func setDate() {
        
        currentDate = Foundation.Date.init()
        let todayString = NSLocalizedString("Today: ", comment: "date for today")
        currentDateLbl.text = todayString + dateFormatter.string(from: currentDate)

        if let lastDate = UserDefaults.standard.value(forKey: "lastDate") as? Foundation.Date {
            let lastDayString = NSLocalizedString("Last Date: ", comment: "date for last reading")
            lastDateLbl.text = lastDayString + dateFormatter.string(from: lastDate)
            Date.data.lastDate = lastDate

        } else {
            lastDateLbl.isHidden = true
        }

        if let startDate = UserDefaults.standard.value(forKey: "startDate") as? Foundation.Date {
            let startDateString = NSLocalizedString("Start Date: ", comment: "date for start reading")
            startDateLbl.text = startDateString + dateFormatter.string(from: startDate)
            Date.data.startDate = startDate
            numOfDaysLbl.isHidden = false
            let daysString = NSLocalizedString(" Days", comment: "num of days string")
            numOfDaysLbl.text = String(date.countDays(startDate, endDate: currentDate)) + daysString
            Date.data.numberOfDays = date.countDays(startDate, endDate: currentDate)
            showAlert()
            UserDefaults.standard.set(Date.data.numberOfDays, forKey: "numberOfDays")
            UserDefaults.standard.synchronize()
        } else {
            startDateLbl.isHidden = true
        }
    }

    func showAlert() {

        if Date.data.numberOfDays != nil && Date.data.numberOfDays > 30 {

            if UserDefaults.standard.bool(forKey: "dateExpired") != true {

                let expiredAlert = UIAlertController(title: expirationTitle, message: expirationMessage, preferredStyle: .actionSheet)

                let cancelAction = UIAlertAction(title: ignoreTitle, style: .cancel, handler: { (action) -> Void in
                    UserDefaults.standard.set(true, forKey: "dateExpired")
                })
                expiredAlert.addAction(cancelAction)

                let resetAction = UIAlertAction(title: allResetTitle, style: .destructive, handler: { (action) -> Void in

                    UserDefaults.standard.set(false, forKey: "heatingSwitch")
                    Heating.data.heatingSwitchOn = false
                    UserDefaults.standard.set(false, forKey: "lightingSwitch")
                    Lighting.data.lightingSwitchOn  = false
                    UserDefaults.standard.removeObject(forKey: "startDate")
                    Date.data.startDate = nil
                    UserDefaults.standard.removeObject(forKey: "discount")
                    Heating.data.discount = nil
                    Lighting.data.discount = nil
                    UserDefaults.standard.removeObject(forKey: "lastDate")
                    UserDefaults.standard.removeObject(forKey: "heatingStartReading")
                    UserDefaults.standard.removeObject(forKey: "heatingLastReading")
                    UserDefaults.standard.removeObject(forKey: "heatingCurrentReading")
                    UserDefaults.standard.removeObject(forKey: "heatingKwh")
                    UserDefaults.standard.removeObject(forKey: "heatingBalance")
                    UserDefaults.standard.removeObject(forKey: "lightingStartReading")
                    UserDefaults.standard.removeObject(forKey: "lightingLastReading")
                    UserDefaults.standard.removeObject(forKey: "lightingCurrentReading")
                    UserDefaults.standard.removeObject(forKey: "lightingKwh")
                    UserDefaults.standard.removeObject(forKey: "lightingBalance")
                    UserDefaults.standard.removeObject(forKey: "totalBalance")
                    Heating.data.lastMeter = nil
                    Heating.data.kwh = nil
                    Heating.data.yen = nil
                    Heating.data.balance = nil
                    Lighting.data.lastMeter = nil
                    Lighting.data.kwh = nil
                    Lighting.data.yen = nil
                    Lighting.data.balance = nil
                    Date.data.numberOfDays = nil

                    let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "mainVC")
                    self.show(vc as! UIViewController, sender: vc)
                })
                expiredAlert.addAction(resetAction)
                expiredAlert.popoverPresentationController?.sourceView = anchorView
                present(expiredAlert, animated: true, completion: nil)
            }
        }
    }

    func setHeatingBalanceLbl() {

        if UserDefaults.standard.bool(forKey: "heatingSwitch") != true && Heating.data.heatingSwitchOn != true {
            heatingView.isHidden = true
        } else {
            heatingView.isHidden = false
            heatingTitleLbl.text = hot.title

            resetBtn.isHidden = false
            resetBtnLbl.isHidden = false

            if let balance = UserDefaults.standard.value(forKey: "heatingBalance") {
                heatingBalanceLbl.text = currencyFormatter.string(from: balance as! NSNumber)!
                let kwh = UserDefaults.standard.value(forKey: "heatingKwh")

                heatingTotalKwhLbl.text = String(format: "%0.f", kwh as! Double) + " kWh"

            } else {
                heatingBalanceLbl.textColor = UIColor.white

                heatingBalanceLbl.text = pleaseTapMeterString
                heatingTotalKwhLbl.textColor = UIColor.white

                heatingTotalKwhLbl.text = kwhUnknownString
            }
        }
    }

    func setLightingBalanceLbl() {

        if UserDefaults.standard.bool(forKey: "lightingSwitch") != true && Lighting.data.lightingSwitchOn != true {
            lightingView.isHidden = true
        } else {
            lightingView.isHidden = false
            lightingTitleLbl.text = bLighting.title

            resetBtn.isHidden = false
            resetBtnLbl.isHidden = false

            if let balance = UserDefaults.standard.value(forKey: "lightingBalance") {
                let kwh = UserDefaults.standard.value(forKey: "lightingKwh")
                lightingTotalKwhLbl.text = String(format: "%0.f", kwh as! Double) + " kWh"
                lightingBalanceLbl.text = currencyFormatter.string(from: balance as! NSNumber)!

            } else {

                lightingTotalKwhLbl.textColor = UIColor.white

                lightingTotalKwhLbl.text = kwhUnknownString
                lightingBalanceLbl.textColor = UIColor.white
                lightingBalanceLbl.text = pleaseTapMeterString
            }
        }
    }

    func setTotalBalanceLbl() {

        if UserDefaults.standard.bool(forKey: "heatingSwitch") != true || UserDefaults.standard.bool(forKey: "lightingSwitch") != true {
            totalBalanceView.isHidden = true
        } else {
            if let balance = UserDefaults.standard.value(forKey: "totalBalance") {
                totalBalanceLbl.text = currencyFormatter.string(from: balance as! NSNumber)
            }
        }
    }

    @IBAction func setupBtn(_ sender: AnyObject) {
    }

    @IBAction func meterBtn(_ sender: AnyObject) {

        if UserDefaults.standard.bool(forKey: "heatingSwitch") != true &&
         Heating.data.heatingSwitchOn != true && UserDefaults.standard.bool(forKey: "lightingSwitch") != true && Lighting.data.lightingSwitchOn != true {

            let alert = UIAlertController(title: oopsString, message: goToTheSettingString, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)

        } else if heatingBalanceLbl.text == pleaseTapMeterString && Heating.data.startMeter == nil || lightingBalanceLbl.text == pleaseTapMeterString && Lighting.data.startMeter == nil {
            let alert = UIAlertController(title: oopsString, message: enterStartMtr, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func resetBtnPressed(_ sender: AnyObject) {

        let allReset = UIAlertController(title: resetTitle, message: resetMessage, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        allReset.addAction(cancelAction)

        let resetAction = UIAlertAction(title: allResetTitle, style: .destructive, handler: { (action) -> Void in

            UserDefaults.standard.set(false, forKey: "heatingSwitch")
            Heating.data.heatingSwitchOn = false
            UserDefaults.standard.set(false, forKey: "lightingSwitch")
            Lighting.data.lightingSwitchOn  = false
            UserDefaults.standard.removeObject(forKey: "startDate")
            Date.data.startDate = nil
            UserDefaults.standard.removeObject(forKey: "discount")
            Heating.data.discount = nil
            Lighting.data.discount = nil
            UserDefaults.standard.removeObject(forKey: "lastDate")
            UserDefaults.standard.removeObject(forKey: "heatingStartReading")
            UserDefaults.standard.removeObject(forKey: "heatingLastReading")
            UserDefaults.standard.removeObject(forKey: "heatingCurrentReading")
            UserDefaults.standard.removeObject(forKey: "heatingKwh")
            UserDefaults.standard.removeObject(forKey: "heatingBalance")
            UserDefaults.standard.removeObject(forKey: "lightingStartReading")
            UserDefaults.standard.removeObject(forKey: "lightingLastReading")
            UserDefaults.standard.removeObject(forKey: "lightingCurrentReading")
            UserDefaults.standard.removeObject(forKey: "lightingKwh")
            UserDefaults.standard.removeObject(forKey: "lightingBalance")
            UserDefaults.standard.removeObject(forKey: "totalBalance")
            Heating.data.lastMeter = nil
            Heating.data.kwh = nil
            Heating.data.yen = nil
            Heating.data.balance = nil
            Lighting.data.lastMeter = nil
            Lighting.data.kwh = nil
            Lighting.data.yen = nil
            Lighting.data.balance = nil
            Date.data.numberOfDays = nil

            let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "mainVC")
            self.show(vc as! UIViewController, sender: vc)
        })
        allReset.addAction(resetAction)
        allReset.popoverPresentationController?.sourceView = anchorView
        present(allReset, animated: true, completion: nil)
    }

}

