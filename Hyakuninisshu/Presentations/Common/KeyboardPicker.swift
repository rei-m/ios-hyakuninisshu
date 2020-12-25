//
//  PickerKeyboard.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/12/24.
//

import UIKit

class KeyboardPicker: UIControl {

    var data: [String] = ["1", "2", "3", "4", "5", "6", "7"]

    var text: String {
        get { titleLabel.text ?? "" }
        set(v) { titleLabel.text = v }
    }

    private var textTemp = ""

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

    // タッチされたらFirst Responderになる
    @objc func didTap(sender: KeyboardPicker) {
        becomeFirstResponder()
        borderView.backgroundColor = borderColorSelected
        bottomBorderHeightConstraint.constant = 2
    }
    
    override var canBecomeFirstResponder: Bool {
        get { true }
    }
            
    // inputViewをオーバーライドさせてシステムキーボードの代わりにPickerViewを表示
    override var inputView: UIView? {
        let row = data.firstIndex(of: text) ?? -1
        pickerView.selectRow(row, inComponent: 0, animated: false)
        textTemp = text
        return pickerView
    }

    override var inputAccessoryView: UIView? {
        return accessaryView
    }

    // ボタンを押したらresignしてキーボードを閉じる
    @objc func didTapDone(sender: UIButton) {
        text = textTemp
        resignFirstResponder()
        borderView.backgroundColor = borderColor
        bottomBorderHeightConstraint.constant = 1
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
        return data[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textTemp = data[row]
    }
}
