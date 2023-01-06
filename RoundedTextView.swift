//
//  RoundedTextView.swift
//  Me Electricity Bills
//
//  Created by Yasu Tanaka on 01/03/2016.
//  Copyright © 2016 Yasuhiro Tanaka. All rights reserved.
//

import UIKit

class RoundedTextView: UITextView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
    }
}
