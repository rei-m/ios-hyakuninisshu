//
//  UIViewControllerExtension.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/10.
//

import Foundation
import GoogleMobileAds
import UIKit

extension UIViewController {
  var requireAppDelegate: AppDelegate {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      fatalError("Missing AppDelegate.")
    }
    return appDelegate
  }

  var requireStoryboard: UIStoryboard {
    guard let storyboard = storyboard else {
      fatalError("Missing storyboard.")
    }
    return storyboard
  }

  var requireNavigationController: UINavigationController {
    guard let navigationController = navigationController else {
      fatalError("Missing navigationController.")
    }
    return navigationController
  }

  var diContainer: DIContainer {
    requireAppDelegate.diContainer
  }

  var adSize: GADAdSize {
    let frame = { () -> CGRect in
      // Here safe area is taken into account, hence the view frame is used
      // after the view has been laid out.
      if #available(iOS 11.0, *) {
        return view.frame.inset(by: view.safeAreaInsets)
      } else {
        return view.frame
      }
    }()
    return GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(frame.size.width)
  }

  func presentUnexpectedErrorVC(_ error: Error) {
    let storyboard = UIStoryboard(name: "Error", bundle: nil)
    let vc: UnexpectedErrorViewController = storyboard.instantiateViewController(
      identifier: .fatalError)
    vc.modalPresentationStyle = .fullScreen
    vc.error = error
    present(vc, animated: false)
  }

  func setUpLeftBackButton() {
    let leftButton = UIBarButtonItem(
      title: "戻る", style: UIBarButtonItem.Style.plain, target: self,
      action: #selector(popToNaviRoot))
    navigationItem.leftBarButtonItem = leftButton
  }

  func setUpAdBannerView(_ bannerView: GADBannerView) {
    bannerView.adUnitID = "ca-app-pub-3940256099942544/2435281174"
    bannerView.rootViewController = self
  }

  @objc func popToNaviRoot() {
    requireNavigationController.popToRootViewController(animated: true)
  }
}
