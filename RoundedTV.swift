//
//  RoundedTV.swift
//  Me Electricity Bills
//
//  Created by Yasu Tanaka on 06/12/2015.
//  Copyright © 2015 Yasuhiro Tanaka. All rights reserved.
//

import UIKit

class RoundedTV: UITableView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
    }


}
