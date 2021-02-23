//
//  ExamHistoryViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/02/05.
//

import GoogleMobileAds
import UIKit

protocol ExamHistoryViewProtocol: AnyObject {
  func updateTable(_ scores: [PlayScore])
  func presentErrorVC(_ error: Error)
}

class ExamHistoryViewController: UIViewController {
  // MARK: - Outlet
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var bannerView: GADBannerView!

  // MARK: - Property
  private var presenter: ExamHistoryPresenterProtocol!
  private var adController: AdController!

  private var scores: [PlayScore] = []

  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    presenter.viewDidLoad()
    adController.viewDidLoad(bannerView)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    adController.viewWillAppear()
  }

  override func viewWillTransition(
    to size: CGSize,
    with coordinator: UIViewControllerTransitionCoordinator
  ) {
    super.viewWillTransition(to: size, with: coordinator)
    adController.viewWillTransition(to: size, with: coordinator)
  }

  // MARK: - Method
  func inject(presenter: ExamHistoryPresenterProtocol, adController: AdController) {
    self.presenter = presenter
    self.adController = adController
  }
}

extension ExamHistoryViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0 < scores.count ? scores.count + 1 : 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.item == scores.count {
      let cell = tableView.dequeueReusableCell(withIdentifier: "AdBannerCell", for: indexPath)
      cell.heightAnchor.constraint(equalToConstant: adController.adSize.size.height).isActive = true
      return cell
    }

    guard
      let cell = tableView.dequeueReusableCell(
        withIdentifier: "ExamHistoryTableViewCell", for: indexPath) as? ExamHistoryTableViewCell
    else {
      fatalError("The dequeued cell is not instance of ExamHistoryTableViewCell.")
    }

    let item = scores[indexPath.item]

    cell.dateLabel.text = item.tookDateText
    cell.scoreLabel.text = item.score.text
    cell.averageAnswerTimeLabel.text = item.averageAnswerSecText

    return cell
  }
}

extension ExamHistoryViewController: ExamHistoryViewProtocol {
  // MARK: - View methods
  func updateTable(_ scores: [PlayScore]) {
    self.scores = scores
    self.tableView.reloadData()
    self.tableView.setContentOffset(CGPoint.zero, animated: false)
  }

  func presentErrorVC(_ error: Error) {
    presentUnexpectedErrorVC(error)
  }
}
