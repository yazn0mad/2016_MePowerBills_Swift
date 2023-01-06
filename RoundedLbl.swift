//
//  RoundedLbl.swift
//  Me Electricity Bills
//
//  Created by Yasu Tanaka on 07/12/2015.
//  Copyright © 2015 Yasuhiro Tanaka. All rights reserved.
//

import UIKit

class RoundedLbl: UILabel {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
    }

}
