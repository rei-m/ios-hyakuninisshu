//
//  TrainingViewController.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/23.
//

import UIKit

protocol TrainingViewProtocol: AnyObject {
    func updateRangeFrom(_ condition: RangeCondition)
    func updateRangeTo(_ condition: RangeCondition)
    func updateKimariji(_ condition: KimarijiCondition)
    func updateColor(_ condition: ColorCondition)
    func updateKamiNoKu(_ condition: DisplayStyleCondition)
    func updateShimoNoKu(_ condition: DisplayStyleCondition)
    func updateAnimationSpeed(_ condition: AnimationSpeedCondition)
    func updateRangeError(_ message: String?)
    func showAlertDialog()
    func goToNextVC(
        rangeFrom: RangeCondition,
        rangeTo: RangeCondition,
        kimariji: KimarijiCondition,
        kamiNoKu: DisplayStyleCondition,
        shimoNoKu: DisplayStyleCondition,
        animationSpeed: AnimationSpeedCondition
    )
}

class TrainingViewController: UIViewController {

    @IBOutlet weak var rangeFromPicker: KeyboardPicker!
    @IBOutlet weak var rangeToPicker: KeyboardPicker!
    @IBOutlet weak var kimarijiPicker: KeyboardPicker!
    @IBOutlet weak var colorPicker: KeyboardPicker!
    @IBOutlet weak var kamiNoKuPicker: KeyboardPicker!
    @IBOutlet weak var shimoNoKuPicker: KeyboardPicker!
    @IBOutlet weak var animationSpeedPicker: KeyboardPicker!

    @IBOutlet weak var rangeErrorLabel: UILabel!    
    private var rangeErrorHeightConstraint: NSLayoutConstraint?
    
    private var presenter: TrainingPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        rangeFromPicker.data = RangeCondition.FROM_DATA
        rangeToPicker.data = RangeCondition.TO_DATA
        kimarijiPicker.data = KimarijiCondition.DATA
        colorPicker.data = ColorCondition.DATA
        kamiNoKuPicker.data = DisplayStyleCondition.DATA
        shimoNoKuPicker.data = DisplayStyleCondition.DATA
        animationSpeedPicker.data = AnimationSpeedCondition.DATA

        rangeErrorHeightConstraint = rangeErrorLabel.constraints.first
        
        rangeFromPicker.delegate = self
        rangeToPicker.delegate = self
        kimarijiPicker.delegate = self
        colorPicker.delegate = self
        kamiNoKuPicker.delegate = self
        shimoNoKuPicker.delegate = self
        animationSpeedPicker.delegate = self
        presenter.viewDidLoad()
    }
    
    @IBAction func didStartTrainingButtonTapDone(_ sender: UIButton) {
        presenter.didStartTrainingButtonTapDone()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func inject(presenter: TrainingPresenterProtocol) {
        self.presenter = presenter
    }
}

extension TrainingViewController: TrainingViewProtocol {
    // MARK: - View methods
    func updateRangeFrom(_ condition: RangeCondition) {
        rangeFromPicker.currentItemIndex = RangeCondition.FROM_DATA.firstIndex(of: condition)!
    }
    
    func updateRangeTo(_ condition: RangeCondition) {
        rangeToPicker.currentItemIndex = RangeCondition.TO_DATA.firstIndex(of: condition)!
    }
    
    func updateKimariji(_ condition: KimarijiCondition) {
        kimarijiPicker.currentItemIndex = KimarijiCondition.DATA.firstIndex(of: condition)!
    }
    
    func updateColor(_ condition: ColorCondition) {
        colorPicker.currentItemIndex = ColorCondition.DATA.firstIndex(of: condition)!
    }
    
    func updateKamiNoKu(_ condition: DisplayStyleCondition) {
        kamiNoKuPicker.currentItemIndex = DisplayStyleCondition.DATA.firstIndex(of: condition)!
    }
    
    func updateShimoNoKu(_ condition: DisplayStyleCondition) {
        shimoNoKuPicker.currentItemIndex = DisplayStyleCondition.DATA.firstIndex(of: condition)!
    }
    
    func updateAnimationSpeed(_ condition: AnimationSpeedCondition) {
        animationSpeedPicker.currentItemIndex = AnimationSpeedCondition.DATA.firstIndex(of: condition)!
    }
    
    func updateRangeError(_ message: String?) {
        rangeErrorLabel.text = message
        rangeErrorHeightConstraint?.isActive = message == nil
    }
    
    func showAlertDialog() {
        let alert = UIAlertController(
            title: "エラー",
            message: "エラーがあります。画面をご確認ください。",
            preferredStyle: .alert
        )

        let defaultAction = UIAlertAction(title: "閉じる", style: .default)
        alert.addAction(defaultAction)
        
        self.present(alert, animated: true)
    }
    
    func goToNextVC(
        rangeFrom: RangeCondition,
        rangeTo: RangeCondition,
        kimariji: KimarijiCondition,
        kamiNoKu: DisplayStyleCondition,
        shimoNoKu: DisplayStyleCondition,
        animationSpeed: AnimationSpeedCondition
    ) {
        let vc = storyboard?.instantiateViewController(identifier: "TrainingStarterViewController")
        navigationController?.pushViewController(vc!, animated: false)
    }
}

extension TrainingViewController: KeyboardPickerDelegate {
    func didTapDone(_ keyboardPicker: KeyboardPicker, index: Int) {
        switch keyboardPicker {
        case rangeFromPicker:
            presenter.didChangeRangeFrom(RangeCondition.FROM_DATA[index])
        case rangeToPicker:
            presenter.didChangeRangeTo(RangeCondition.TO_DATA[index])
        case kimarijiPicker:
            presenter.didChangeKimariji(KimarijiCondition.DATA[index])
        case colorPicker:
            presenter.didChangeColor(ColorCondition.DATA[index])
        case kamiNoKuPicker:
            presenter.didChangeKamiNoKu(DisplayStyleCondition.DATA[index])
        case shimoNoKuPicker:
            presenter.didChangeShimoNoKu(DisplayStyleCondition.DATA[index])
        case animationSpeedPicker:
            presenter.didChangeAnimationSpeed(AnimationSpeedCondition.DATA[index])
        default:
            return
        }
    }
}
