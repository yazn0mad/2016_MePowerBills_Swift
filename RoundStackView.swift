//
//  RoundStackView.swift
//  Me Electricity Bills
//
//  Created by Yasu Tanaka on 22/02/2016.
//  Copyright © 2016 Yasuhiro Tanaka. All rights reserved.
//

import UIKit

class RoundStackView: UIStackView {

    class RoundedView: UIView {

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            layer.cornerRadius = 5.0
        }
    }


}
