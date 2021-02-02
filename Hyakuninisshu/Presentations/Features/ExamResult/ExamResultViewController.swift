//
//  ExamResultViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2021/01/08.
//

import UIKit

class ExamResultViewController: UIViewController {
  // MARK: - Outlet
  @IBOutlet weak var resultCollectionView: UICollectionView!

  // MARK: - Property
  private var examResult: ExamResult!

  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpLeftBackButton()

    resultCollectionView.backgroundColor = UIColor(patternImage: UIImage(named: "Tatami")!)

    resultCollectionView.dataSource = self
    resultCollectionView.delegate = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tabBarController?.tabBar.isHidden = true
  }

  // MARK: - Action
  @IBAction func didTapBackMenuButton(_ sender: Any) {
    popToNaviRoot()
  }

  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let destinationVC = segue.destination as? MaterialDetailViewController else {
      fatalError("Unexpected destination: \(segue.destination)")
    }

    guard let cell = sender as? UICollectionViewCell,
      let indexPath = resultCollectionView.indexPath(for: cell)
    else {
      fatalError("Unexpected sender: \(sender ?? "")")
    }

    let (material, _) = examResult.judgements[indexPath.row]
    destinationVC.material = material
  }

  // MARK: - Method
  func inject(examResult: ExamResult) {
    self.examResult = examResult
  }
}

extension ExamResultViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)
    -> Int
  {
    return examResult.judgements.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell
  {
    guard
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: "ExamResultCollectionViewCell", for: indexPath)
        as? ExamResultCollectionViewCell
    else {
      fatalError("The dequeued view is not instance of ExamResultCollectionViewCell.")
    }
    let (material, isCorrect) = examResult.judgements[indexPath.row]

    cell.noLabel.text = material.noTxt
    cell.correctImage.image =
      isCorrect ? #imageLiteral(resourceName: "Correct") : #imageLiteral(resourceName: "Wrong")
    let imageSize = collectionView.cellSize * 0.8
    cell.correctImage.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
    cell.correctImage.heightAnchor.constraint(equalToConstant: imageSize).isActive = true

    return cell
  }

  func collectionView(
    _ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    switch kind {
    case "UICollectionElementKindSectionHeader":
      guard
        let view = collectionView.dequeueReusableSupplementaryView(
          ofKind: UICollectionView.elementKindSectionHeader,
          withReuseIdentifier: "ExamResultHeaderView", for: indexPath)
          as? ExamResultCollectionViewHeader
      else {
        fatalError("The dequeued view is not instance of ExamResultHeaderView.")
      }
      view.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

      view.scoreView.value = examResult.score.score
      view.averageAnswerTimeView.value = examResult.score.averageAnswerSecText
      return view
    case "UICollectionElementKindSectionFooter":
      guard
        let view = collectionView.dequeueReusableSupplementaryView(
          ofKind: UICollectionView.elementKindSectionFooter,
          withReuseIdentifier: "ExamResultFooterView", for: indexPath)
          as? ExamResultCollectionViewFooter
      else {
        fatalError("The dequeued view is not instance of ExamResultFooterView.")
      }
      view.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

      return view
    default:
      fatalError("Unknown kind. value=\(kind)")
    }
  }
}

extension ExamResultViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 2
  }

  func collectionView(
    _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 2
  }

  func collectionView(
    _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let cellSize = collectionView.cellSize
    return CGSize(width: cellSize, height: cellSize)
  }

  func collectionView(
    _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
  }
}

extension UICollectionView {
  fileprivate var cellSize: CGFloat {
    return (frame.size.width - 32 - 10) / 5
  }
}
