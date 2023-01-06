//
//  Support.swift
//  Me Electricity Bills
//
//  Created by Yasu Tanaka on 01/03/2016.
//  Copyright © 2016 Yasuhiro Tanaka. All rights reserved.
//

import Foundation

class Support {

    static let strings = Support()

    let title = NSLocalizedString("How to set up Me Power Bills", comment: "title")
    let subTitle = NSLocalizedString("Please have your electricity bills ready to set up your app.", comment: "subTitle")

    let h1 = NSLocalizedString("1. Start Date: ", comment: "h1")
    let b1 = NSLocalizedString("Look up the date for the latest meter reading on your bills, labeled as 今回検針日, and set the date for the Start Date.", comment: "b1")

    let h2 = NSLocalizedString("2. Contract Types: ", comment: "h2")
    let b2 = NSLocalizedString("You must activate one or both of your contracts available in the Contract Types.", comment: "b2")

    let h3 = NSLocalizedString("3. Start Meter Reading: ", comment: "h3")
    let b3 = NSLocalizedString("Look up the last meter reading on your bills, labeled as 今回指示数, and enter the value in Detail Settings.", comment: "b3")

    let h4 = NSLocalizedString("4. Rates: ", comment: "h4")
    let b4 = NSLocalizedString("For Discount rate, look up 燃料費調査単価, which may change each month, and enter the amount labeled as (当月). For Levy, look up 再エネ発電賦課金単価. If you tap on the red question marks, you can look those up online (available only in Japanese).", comment: "b4")

    let d1 = NSLocalizedString("Disclaimer: ", comment: "d1")
    let d2 = NSLocalizedString("Please be aware this app is not associated with your power company. Contact the support at yazApps.com for questions and support. If all the items in the Settings and the Detail Settings are entered or selected correctly, the balance calculated by this app will match the amount calculated by the simulator provided by your power company on their website. However, the actual amount billed to you may not be exactly the same.", comment: "d2")


    let email = "support@yazapps.com"

}
