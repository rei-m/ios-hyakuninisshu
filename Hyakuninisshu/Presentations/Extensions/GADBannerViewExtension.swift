//
//  GADBannerViewExtension.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/02/05.
//

import GoogleMobileAds

extension GADBannerView {
  func load(_ adSize: GADAdSize) {
    self.adSize = adSize
    self.load(GADRequest())
  }
}
