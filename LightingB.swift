//
//  LightingB.swift
//  Me Electricity Bills
//
//  Created by Yasu Tanaka on 22/02/2016.
//  Copyright © 2016 Yasuhiro Tanaka. All rights reserved.
//

import Foundation

class LightingB {

    let lighting = Lighting()

    let title = NSLocalizedString("Lighting B", comment: "title for mainVC")

    let rateLow = 23.97     // kwh <= 120
    let rateMid = 30.26     //  121 =< kwh <= 280
    let rateHigh = 33.98    // kwh >= 281
    // let minRate = 250.8

    var rate = 0.0

    var baseFee: Double!    // = unitPrice

    static let unitPrices = [341.0, 511.50, 682.0, 1023.0, 1364, 1705.0, 2046.0]
    static let basicRates = ["10A", "15A", "20A", "30A", "40A", "50A", "60A"]
    var unitPrice = UserDefaults.standard.double(forKey: "lightingUnitPrice")

    var currentMeter = Lighting.data.currentMeter
    var lastMeter = Lighting.data.lastMeter
    var startMeter = Lighting.data.startMeter
    var balance = Lighting.data.balance
    var yen = Lighting.data.yen
    var levy = UserDefaults.standard.double(forKey: "levy")
    var discount = UserDefaults.standard.double(forKey: "discount")
    var kwh = UserDefaults.standard.double(forKey: "lightingKwh")
    var numOfDays = Date.data.numberOfDays
    var dates = Foundation.Date()
    var basicRate = Lighting.data.basicRate

    var lowKwhPacket: Double {
        return 120 * rateLow
    }

    var midKwhPacket: Double {
        return 160 * rateMid
    }

    var yenLowKwh: Double {
        return kwh * rateLow
    }

    var yenLowTotalKwh: Double {
        return kwhTotal * rateLow
    }

    var yenMidKwh: Double {
        return (kwh - 120) * rateMid
    }

    var yenMidTotalKwh: Double {
        return (kwhTotal - 120) * rateMid
    }

    var yenHighKwh: Double {
        return (kwh - 280) * rateHigh
    }

    var yenHighTotalKwh: Double {
        return (kwhTotal - 280) * rateHigh
    }

    func getPriceForKwh() -> Double {
        if kwh >= 281 {
            return yenHighKwh + midKwhPacket + lowKwhPacket
        } else if kwh >= 121 {
            return yenMidKwh + lowKwhPacket
        } else {
            return yenLowKwh
        }
    }

    func getPriceForTotalKwh() -> Double {
        if kwhTotal >= 281 {
            return yenHighTotalKwh + midKwhPacket + lowKwhPacket
        } else if kwhTotal >= 121 {
            return yenMidTotalKwh + lowKwhPacket
        } else {
            return yenLowTotalKwh
        }
    }

    var kwhTotal: Double! {
        return currentMeter! - startMeter!
    }
    // this returns kwh * rate:
    var yenForUsageVC: Double {
        let value = getPriceForKwh()
        return value + levyTotal - discountTotal
    }

    var averageYen: Double {
        return yenForTotal / Double(numOfDays!)
    }

    var averageKwh: Double {
        return kwhTotal / Double(numOfDays!)
    }

    // this returns kwhTotal * rate:
    var yenForTotal: Double {
        let value = getPriceForTotalKwh()
        return floor(value) + floor(levyTotal) - floor(discountTotal)
    }

    var yenTotal: Double! {
        return unitPrice + yenForTotal
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
    
}
