//
//  PickerKeyboard.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/24.
//

import UIKit

protocol KeyboardPickerItem {
    var text: String { get }
}

class KeyboardPicker: UIControl {

    public var currentItem: KeyboardPickerItem {
        get { data[currentItemIndex] }
    }

    private var data: [KeyboardPickerItem] = []

    private var currentItemIndex: Int = -1
    private var currentItemIndexTemp: Int = -1

    private let titleLabel = UILabel()
    private let pickerView = UIPickerView()
    private let accessaryView = UIView()
    private let borderView = UIView()

    private var bottomBorderHeightConstraint: NSLayoutConstraint!
    private var borderColor: UIColor = UIColor.systemGray
    private var borderColorSelected: UIColor = UIColor(named: "AccentColor")!
    
    private func setUp() {
        // 自身のViewの設定
        backgroundColor = UIColor.clear

        // ラベルの設定
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textAlignment = .left
        addSubview(titleLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        borderView.backgroundColor = borderColor
        addSubview(borderView)
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        borderView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        borderView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bottomBorderHeightConstraint = borderView.heightAnchor.constraint(equalToConstant: 1)
        bottomBorderHeightConstraint.isActive = true

        // 右のアイコンの設定
        let arrowIcon = UIImageView()
        arrowIcon.image = UIImage(systemName: "arrowtriangle.down.fill")
        arrowIcon.tintColor = borderColor
        addSubview(arrowIcon)
        
        arrowIcon.translatesAutoresizingMaskIntoConstraints = false
        arrowIcon.widthAnchor.constraint(equalToConstant: 8).isActive = true
        arrowIcon.heightAnchor.constraint(equalToConstant: 8).isActive = true
        arrowIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4).isActive = true
        arrowIcon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        // キーボードの上に置くアクセサリービュー
        accessaryView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 48)
        accessaryView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        accessaryView.backgroundColor = .systemGroupedBackground
        
        // キーボードを閉じるための完了ボタン
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("選択", for: .normal)
        closeButton.addTarget(self, action: #selector(KeyboardPicker.didTapDone(sender:)), for: .touchDown)

        closeButton.translatesAutoresizingMaskIntoConstraints = false
        accessaryView.addSubview(closeButton)

        closeButton.topAnchor.constraint(equalTo: accessaryView.topAnchor).isActive = true
        closeButton.bottomAnchor.constraint(equalTo: accessaryView.bottomAnchor).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: accessaryView.leadingAnchor).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: accessaryView.trailingAnchor).isActive = true
        
        // キーボードエリアに表示するピッカー
        pickerView.delegate = self
        pickerView.backgroundColor = .white

        // イベントハンドラ
        addTarget(self, action: #selector(KeyboardPicker.didTap(sender:)), for: .touchDown)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    override var canBecomeFirstResponder: Bool {
        get { true }
    }
            
    // inputViewをオーバーライドさせてシステムキーボードの代わりにPickerViewを表示
    override var inputView: UIView? {
        if (currentItemIndex < 0) {
            return nil
        }
        
        pickerView.selectRow(currentItemIndex, inComponent: 0, animated: false)
        currentItemIndexTemp = currentItemIndex
        return pickerView
    }

    override var inputAccessoryView: UIView? {
        return accessaryView
    }

    public func setUpData(data: [KeyboardPickerItem], currentItemIndex: Int) {
        self.data = data
        self.currentItemIndex = currentItemIndex
        titleLabel.text = data[currentItemIndex].text
    }

    // タッチされたらFirst Responderになる
    @objc func didTap(sender: KeyboardPicker) {
        becomeFirstResponder()
        borderView.backgroundColor = borderColorSelected
        bottomBorderHeightConstraint.constant = 2
    }
    
    // ボタンを押したらresignしてキーボードを閉じる
    @objc func didTapDone(sender: UIButton) {
        resignFirstResponder()
        borderView.backgroundColor = borderColor
        bottomBorderHeightConstraint.constant = 1

        if (currentItemIndex < 0) {
            return
        }

        currentItemIndex = currentItemIndexTemp
        titleLabel.text = data[currentItemIndex].text
    }
}

extension KeyboardPicker: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row].text
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentItemIndexTemp = row
//        textTemp = data[row]
    }
}
