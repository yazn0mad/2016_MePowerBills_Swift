//
//  SupportVC.swift
//  Me Electricity Bills
//
//  Created by Yasu Tanaka on 01/03/2016.
//  Copyright © 2016 Yasuhiro Tanaka. All rights reserved.
//

import UIKit

class SupportVC: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var sTitleLbl: UILabel!
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLbl.text = Support.strings.title
        sTitleLbl.text = Support.strings.subTitle

        textView.insertText(Support.strings.h1)
        textView.insertText("\n")
        textView.insertText(Support.strings.b1)
        textView.insertText("\n\n")

        textView.insertText(Support.strings.h2)
        textView.insertText("\n")
        textView.insertText(Support.strings.b2)
        textView.insertText("\n\n")

        textView.insertText(Support.strings.h3)
        textView.insertText("\n")
        textView.insertText(Support.strings.b3)
        textView.insertText("\n\n")

        textView.insertText(Support.strings.h4)
        textView.insertText("\n")
        textView.insertText(Support.strings.b4)
        textView.insertText("\n\n")

        textView.insertText(Support.strings.d1)
        textView.insertText("\n")
        textView.insertText(Support.strings.d2)
        textView.insertText("\n\n")

        textView.insertText(Support.strings.email)


    }

    @IBAction func okBtnPressed(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)

    }


}
