//
//  AdController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/02/06.
//

import GoogleMobileAds

class AdController {
  private weak var vc: UIViewController!
  private weak var bannerView: GADBannerView?

  var adSize: GADAdSize {
    let frame = { () -> CGRect in
      // Here safe area is taken into account, hence the view frame is used
      // after the view has been laid out.
      if #available(iOS 11.0, *) {
        return vc.view.frame.inset(by: vc.view.safeAreaInsets)
      } else {
        return vc.view.frame
      }
    }()
    return GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(frame.size.width)
  }

  init(vc: UIViewController) {
    self.vc = vc
  }

  func viewDidLoad(_ bannerView: GADBannerView) {
    bannerView.adUnitID = Env.shared.value(.adUnitId)
    bannerView.rootViewController = vc
    self.bannerView = bannerView
  }

  func viewWillAppear() {
    loadBannerAd()
  }

  func viewWillTransition(
    to size: CGSize,
    with coordinator: UIViewControllerTransitionCoordinator
  ) {
    coordinator.animate(alongsideTransition: { _ in
      self.loadBannerAd()
    })
  }

  private func loadBannerAd() {
    bannerView?.load(adSize)
  }
}
