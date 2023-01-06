//
//  Date.swift
//  Me Electricity Bills
//
//  Created by Yasu Tanaka on 18/02/2016.
//  Copyright © 2016 Yasuhiro Tanaka. All rights reserved.
//

import Foundation
class Date: NSObject, NSCoding {

    static let data = Date()

    var startDate : Foundation.Date!
    var lastDate: Foundation.Date!
    var currentDate: Foundation.Date!
    var numberOfDays: Int!
    var expiredAlertCanceled = UserDefaults.standard.bool(forKey: "dateExpired")

    override init() {
        super.init()
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(startDate, forKey: "startDate")
        aCoder.encode(lastDate, forKey: "lastDate")
    }

    required init(coder aDecoder: NSCoder) {
        startDate = aDecoder.decodeObject(forKey: "startDate") as! Foundation.Date
        lastDate = aDecoder.decodeObject(forKey: "lastDate") as! Foundation.Date
        super.init()
    }

    func countDays(_ startDate: Foundation.Date, endDate: Foundation.Date) -> Int {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day], from: startDate, to: endDate, options: [])
        return components.day!
    }

    
    

}
