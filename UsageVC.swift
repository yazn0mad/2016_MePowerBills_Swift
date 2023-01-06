//
//  UsageVC.swift
//  Me Electricity Bills
//
//  Created by Yasu Tanaka on 05/02/2016.
//  Copyright © 2016 Yasuhiro Tanaka. All rights reserved.
//

import UIKit

import Foundation

import GoogleMobileAds

class UsageVC: UIViewController, GADBannerViewDelegate {

    var admobView: GADBannerView = GADBannerView()
    let AdMobID = "ca-app-pub-4461718674523728/9866657495"

    @IBOutlet weak var startDateLbl: UILabel!
    @IBOutlet weak var currentDateLbl: UILabel!
    @IBOutlet weak var heatingView: UIStackView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var lightingView: UIStackView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var kWhLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var dailyLbl: UILabel!
    @IBOutlet weak var titleLblLighting: UILabel!
    @IBOutlet weak var kWhLblLighting: UILabel!
    @IBOutlet weak var priceLblLighting: UILabel!
    @IBOutlet weak var dailyLblLighting: UILabel!

    let heating = Heating()
    let hot = HotTime22Long()
    let lighting = Lighting()
    let bLighting = LightingB()

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.roundingMode = .floor
        formatter.locale = Locale(identifier: "en_JP")
        return formatter
    }()

    let averageString = NSLocalizedString("Daily average: ", comment: "daily average label")

    override func viewDidLoad() {
        super.viewDidLoad()
        setCurrentAndLastDates()
    }

    override func viewWillAppear(_ animated: Bool) {
        startAdMob()

        if UserDefaults.standard.bool(forKey: "heatingSwitch") != true {

            heatingView.isHidden = true

        } else {

            titleLbl.text = hot.title
            kWhLbl.text = String(format: "%.0f", Heating.data.kwh)
            priceLbl.text = currencyFormatter.string(from: NSNumber(value: hot.yenForUsageVC))
            if Date.data.numberOfDays != nil && Date.data.numberOfDays > 0 {
                let kwhFm = NumberFormatter()
                kwhFm.numberStyle = .none
                let avgYenText = currencyFormatter.string(from: NSNumber(value: hot.averageYen))
                let avgKwhText = kwhFm.string(from: NSNumber(value: hot.averageKwh))
                dailyLbl.text = averageString + avgKwhText! + " kWh, " + avgYenText!
            } else {
                dailyLbl.text = averageString + "?"
            }
        }

        if UserDefaults.standard.bool(forKey: "lightingSwitch") != true {

            lightingView.isHidden = true

        } else{

            titleLblLighting.text = bLighting.title
            kWhLblLighting.text = String(format: "%.0f", Lighting.data.kwh)
            priceLblLighting.text = currencyFormatter.string(from: NSNumber(value: bLighting.yenForUsageVC))
            if Date.data.numberOfDays != nil && Date.data.numberOfDays > 0 {
                let kwhFm = NumberFormatter()
                kwhFm.numberStyle = .none
                let avgYenText = currencyFormatter.string(from: NSNumber(value: bLighting.averageYen))
                let avekwhText = kwhFm.string(from: NSNumber(value: bLighting.averageKwh))
                dailyLblLighting.text = averageString + avekwhText! + " kWh, " + avgYenText!
            } else {
                dailyLblLighting.text = averageString + "?"
            }
        }

        if heatingView.isHidden != true && lightingView.isHidden != true {
            lineView.isHidden = false
        } else {
            lineView.isHidden = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {

        admobView.delegate = nil
        admobView.removeFromSuperview()
        
        if heatingView.isHidden != true && lightingView.isHidden != true {
            prepareForTotalBalance()
        }
    }

    func appdelegate() -> AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
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

    func setCurrentAndLastDates() {

        let currentDate = Foundation.Date.init()
        currentDateLbl.text = dateFormatter.string(from: currentDate)
        Date.data.currentDate = currentDate

        if Date.data.lastDate != nil {
            let lastDate = Date.data.lastDate
            startDateLbl.text = dateFormatter.string(from: lastDate!)
        } else if Date.data.startDate != nil {
            let startDate = Date.data.startDate
            startDateLbl.text = dateFormatter.string(from: startDate!)
        } else {
            startDateLbl.text = "?"
        }
    }

    func saveHeating() {
        Heating.data.balance = hot.yenTotal
        UserDefaults.standard.set(Heating.data.balance, forKey: "heatingBalance")
        UserDefaults.standard.set(hot.kwhTotal, forKey: "heatingKwh")
        UserDefaults.standard.synchronize()
    }

    func saveLighting() {
        Lighting.data.balance = bLighting.yenTotal
        UserDefaults.standard.set(Lighting.data.balance, forKey: "lightingBalance")
        UserDefaults.standard.set(bLighting.kwhTotal, forKey: "lightingKwh")
        UserDefaults.standard.synchronize()
    }

    func prepareForTotalBalance() {
        Heating.data.totalBalance = hot.getTotalBalance(Heating.data.balance, lightingBalance: Lighting.data.balance)

        UserDefaults.standard.set(Heating.data.totalBalance, forKey: "totalBalance")
        UserDefaults.standard.synchronize()
    }

    @IBAction func okBtnPressed(_ sender: AnyObject) {

        Date.data.lastDate = Date.data.currentDate
        setCurrentAndLastDates()
        UserDefaults.standard.set(Date.data.lastDate, forKey: "lastDate")
        UserDefaults.standard.synchronize()

        if case heatingView.isHidden = false, lightingView.isHidden != false {
            saveHeating()
        } else if case lightingView.isHidden = false, heatingView.isHidden != false {
            saveLighting()
        } else {
            saveHeating()
            saveLighting()
        }
    }
}
