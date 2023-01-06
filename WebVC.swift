//
//  WebVC.swift
//  Me Electricity Bills
//
//  Created by Yasu Tanaka on 27/02/2016.
//  Copyright © 2016 Yasuhiro Tanaka. All rights reserved.
//

import UIKit
import WebKit

import GoogleMobileAds

class WebVC: UIViewController, GADBannerViewDelegate, WKNavigationDelegate {

    var admobView: GADBannerView = GADBannerView()
    let AdMobID = "ca-app-pub-4461718674523728/9866657495"

    let heating = Heating()
    var destination = URLRequest(url: URL(string: "http://www.yazapps.com")!)

    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var titleLbl: UILabel!

    var webView: WKWebView!

    let discount = URL(string: "http://www.hepco.co.jp/home/price/system/system02.html")
    let levy = URL(string: "http://www.hepco.co.jp/home/price/recyclable_promotion/system02.html")

    let discountTitle = NSLocalizedString("Find \"＜従量電灯Ａ以外＞\" -?円??銭", comment: "looking for discount")
    let levyTitle = NSLocalizedString("Find \"上記以外の低圧･高圧･特別高圧\" ?円??銭", comment: "looking for levy")

    required init?(coder aDecoder: NSCoder) {
        self.webView = WKWebView(frame: CGRect.zero)
        super.init(coder: aDecoder)
    }

    override func viewWillDisappear(_ animated: Bool) {
        admobView.delegate = nil
        admobView.removeFromSuperview()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        startAdMob()
        barView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 40)
        let pref = WKPreferences()
        pref.javaScriptEnabled = true
        let config = WKWebViewConfiguration()
        config.preferences = pref
        webView = WKWebView(frame: view.bounds, configuration: config)
        view.addSubview(webView)
        view.addSubview(admobView)

        if Heating.data.discountWebRequest == true {
            destination = URLRequest(url: discount!)
            titleLbl.text = discountTitle
        } else {
            destination = URLRequest(url: levy!)
            titleLbl.text = levyTitle
        }
        webView.load(destination)
        }

    func appdelegate() -> AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }

    func startAdMob(){
        admobView = GADBannerView(adSize:kGADAdSizeBanner)
        let SH = UIScreen.main.bounds.height
        admobView.frame.origin = CGPoint(x: 0, y: SH - 158)
        admobView.frame.size = CGSize(width: self.view.frame.width, height: admobView.frame.height)
        admobView.adUnitID = AdMobID
        admobView.delegate = self
        admobView.rootViewController = self
        let admobRequest:GADRequest = GADRequest()
        admobView.load(admobRequest)
        self.view.addSubview(admobView)
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
        
}
