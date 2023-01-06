//
//  HotTime22Long.swift
//  Me Electricity Bills
//
//  Created by Yasu Tanaka on 11/02/2016.
//  Copyright © 2016 Yasuhiro Tanaka. All rights reserved.
//

import Foundation

class HotTime22Long {

    let heating = Heating()

    let title = NSLocalizedString("Hot Time 22 Long", comment: "title for mainVC")

    var unitPrice = UserDefaults.standard.double(forKey: "unitPrice")
    var onSeason = 658.8
    var offSeason = 291.6

    let rate = 15.4

    var typeValue = UserDefaults.standard.double(forKey: "heatingTypeValue")
    var unit = UserDefaults.standard.double(forKey: "heatingUnit")
    var currentMeter = Heating.data.currentMeter
    var lastMeter = Heating.data.lastMeter
    var startMeter = Heating.data.startMeter

    var balance = Heating.data.balance
    var yen = Heating.data.yen
    var levy = UserDefaults.standard.double(forKey: "levy")
    var discount = UserDefaults.standard.double(forKey: "discount")
    var kwh = UserDefaults.standard.double(forKey: "heatingKwh")
    var numOfDays = Date.data.numberOfDays
    var dates = Foundation.Date.self

    var totalBalance: Double!

    var baseFee: Double! {
        return unit * unitPrice * typeValue
    }

    var kwhTotal: Double! {
        return currentMeter! - startMeter!
    }

    var yenForUsageVC: Double {
        return kwh * rate
    }

    var averageYen: Double {
        return yenForTotal / Double(numOfDays!)
    }

    var averageKwh: Double {
        return kwhTotal / Double(numOfDays!)
    }

    var yenForTotal: Double {
        return kwhTotal * rate
    }

    var yenTotal: Double! {
        return baseFee + floor(yenForTotal) + floor(levyTotal) - floor(discountTotal)
    }

    var levyTotal: Double {
        return kwhTotal * levy
    }

    var discountTotal: Double {
        return kwhTotal * discount
    }

    func getKwhUsed(currentMtrReading current: Double, lastMtrReading last: Double) -> Double {
        let kwhUsed = current - last
        kwh = kwhUsed
        return kwh
    }

    func getTotalBalance(_ heatingBalance: Double, lightingBalance: Double) -> Double {
        let balance = floor(heatingBalance) + floor(lightingBalance)
        totalBalance = balance
        return totalBalance
    }

}

