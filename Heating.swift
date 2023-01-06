//
//  Heating.swift
//  Me Electricity Bills
//
//  Created by Yasu Tanaka on 23/12/2015.
//  Copyright © 2015 Yasuhiro Tanaka. All rights reserved.
//

import UIKit

class Heating : NSObject, NSCoding {

    static let data = Heating()

    var startMeter: Double!
    var currentMeter: Double!
    var lastMeter: Double!
    var levy: Double!
    var discount: Double!
    var kwh: Double!
    var yen: Double!
    var balance: Double!
    var rate: Double!
    var unit: Double!
    var typeValue: Double!
    var hotType: String!
    var heatingSwitchOn: Bool!
    var totalBalance: Double!
    var discountWebRequest = true
    var seasonSwitchOn: Bool!

    init(startMeter: Double, currentMeter: Double, lastMeter: Double, levy: Double, discount: Double, kwh: Double, yen: Double, balance: Double, rate: Double, unit: Double, typeValue: Double, hotType: String, heatingSwitch: Bool, totalBalance: Double, seasonSwitchOn: Bool) {

        self.lastMeter = lastMeter
        self.levy = levy
        self.discount = discount
        self.kwh = kwh
        self.yen = yen
        self.balance = balance
        self.rate = rate
        self.unit = unit
        self.typeValue = typeValue
        self.hotType = hotType
        heatingSwitchOn = heatingSwitch
        self.totalBalance = totalBalance
        self.seasonSwitchOn = seasonSwitchOn

        super.init()
    }

    override init() {
        super.init()
    }

    func encode(with aCoder: NSCoder) {

        aCoder.encode(startMeter, forKey: "startMeter")
        aCoder.encode(currentMeter, forKey: "currentMeter")
        aCoder.encode(lastMeter, forKey: "lastMeter")
        aCoder.encode(levy, forKey: "levy")
        aCoder.encode(discount, forKey: "discount")
        aCoder.encode(unit, forKey: "unit")
        aCoder.encode(hotType, forKey: "hotType")
        aCoder.encode(kwh, forKey: "kwh")
        aCoder.encode(yen, forKey: "yen")
        aCoder.encode(balance, forKey: "balance")
        aCoder.encode(typeValue, forKey: "typeValue")
        aCoder.encode(heatingSwitchOn, forKey: "heatingSwitchOn")
        aCoder.encode(totalBalance, forKey: "totalBalance")
        aCoder.encode(seasonSwitchOn, forKey: "seasonSwitchOn")
    }

    required init(coder aDecoder: NSCoder) {

        startMeter = aDecoder.decodeDouble(forKey: "startMeter")
        currentMeter = aDecoder.decodeDouble(forKey: "currentMeter")
        lastMeter = aDecoder.decodeDouble(forKey: "lastMeter")
        levy = aDecoder.decodeDouble(forKey: "levy")
        discount = aDecoder.decodeDouble(forKey: "discount")
        unit = aDecoder.decodeDouble(forKey: "unit")
        hotType = aDecoder.decodeObject(forKey: "hotType") as! String
        kwh = aDecoder.decodeDouble(forKey: "kwh")
        yen = aDecoder.decodeDouble(forKey: "yen")
        balance = aDecoder.decodeDouble(forKey: "balance")
        typeValue = aDecoder.decodeDouble(forKey: "typeValue")
        heatingSwitchOn = aDecoder.decodeBool(forKey: "heatingSwitchOn")
        totalBalance = aDecoder.decodeDouble(forKey: "totalBalance")
        seasonSwitchOn = aDecoder.decodeBool(forKey: "seasonSwitchOn")

        super.init()
    }
    
}
