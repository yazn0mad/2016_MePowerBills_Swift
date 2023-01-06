//
//  Lighting.swift
//  Me Electricity Bills
//
//  Created by Yasu Tanaka on 24/02/2016.
//  Copyright © 2016 Yasuhiro Tanaka. All rights reserved.
//


import UIKit

class Lighting : NSObject, NSCoding {

    static let data = Lighting()

    var startMeter: Double!
    var currentMeter: Double!
    var lastMeter: Double!
    var levy: Double!
    var discount: Double!
    var kwh: Double!
    var yen: Double!
    var balance: Double!
    var rate: Double!
    var unitPrice: Double!
    var basicRate: String!
    var lightingSwitchOn: Bool!

    init(startMeter: Double, currentMeter: Double, lastMeter: Double, levy: Double, discount: Double, kwh: Double, yen: Double, balance: Double, rate: Double, unitPrice: Double, basicRate: String, lightingSwitch: Bool) {

        self.startMeter = startMeter
        self.currentMeter = currentMeter
        self.lastMeter = lastMeter
        self.levy = levy
        self.discount = discount
        self.kwh = kwh
        self.yen = yen
        self.balance = balance
        self.rate = rate
        self.unitPrice = unitPrice
        self.basicRate = basicRate
        lightingSwitchOn = lightingSwitch

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
        aCoder.encode(kwh, forKey: "kwh")
        aCoder.encode(yen, forKey: "yen")
        aCoder.encode(balance, forKey: "balance")
        aCoder.encode(rate, forKey: "rate")
        aCoder.encode(unitPrice, forKey: "unitPrice")
        aCoder.encode(basicRate, forKey: "basicRate")
        aCoder.encode(lightingSwitchOn, forKey: "lightingSwitchOn")
    }

    required init(coder aDecoder: NSCoder) {

        startMeter = aDecoder.decodeDouble(forKey: "startMeter")
        currentMeter = aDecoder.decodeDouble(forKey: "currentMeter")
        lastMeter = aDecoder.decodeDouble(forKey: "lastMeter")
        levy = aDecoder.decodeDouble(forKey: "levy")
        discount = aDecoder.decodeDouble(forKey: "discount")
        kwh = aDecoder.decodeDouble(forKey: "kwh")
        yen = aDecoder.decodeDouble(forKey: "yen")
        balance = aDecoder.decodeDouble(forKey: "balance")
        rate = aDecoder.decodeDouble(forKey: "rate")
        unitPrice = aDecoder.decodeDouble(forKey: "unitPrice")
        basicRate = (aDecoder.decodeObject(forKey: "basicRate") as! String)
        lightingSwitchOn = aDecoder.decodeBool(forKey: "lightingSwitchOn")

        super.init()
    }
    
}
