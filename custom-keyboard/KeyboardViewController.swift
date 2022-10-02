//
//  KeyboardViewController.swift
//  custom-keyboard
//
//  Created by 신동원 on 2022/09/30.
//

import UIKit

enum keyType {
    
    case delete
    case enter
    case space
    case shift
}

class KeyboardViewController: UIInputViewController {
    
    var nextKeyboardButton: CustomButton!
    var spaceButton: CustomButton!
    var shiftButton: CustomButton!
    var returnButton: CustomButton!
    var deleteButton: CustomButton!
    var numberLineButtons: [CustomButton]!
    var topLineButton: [CustomButton]! //"ㅂ,ㅈ,ㄷ,ㄱ,ㅅ,ㅛ,ㅕ,ㅑ,ㅐ,ㅔ
    var middleLineButtons: [CustomButton]! //"ㅁ,ㄴ,ㅇ,ㄹ,ㅎ,ㅗ,ㅓ,ㅏ,ㅣ
    var lastLineButtons: [CustomButton]! //"ㅋ,ㅌ,ㅊ,ㅍ,ㅠ,ㅜ,ㅡ
    
    var isShifted = false {
        didSet{
            self.changedShift()
        }
    }
    
    func setup() {
        
        self.numberLineButtons = self.makeButtons(keyboardLine: .number)
        self.topLineButton = self.makeButtons(keyboardLine: .qwerty)
        self.middleLineButtons = self.makeButtons(keyboardLine: .asdfgh)
        self.lastLineButtons = self.makeButtons(keyboardLine: .zxcvbn)
        
        self.nextKeyboardButton = CustomButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        self.spaceButton = CustomButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        self.shiftButton = CustomButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        self.returnButton = CustomButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        self.deleteButton = CustomButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        self.setButtonsLayout()
        
        self.shiftButton.setTitle("⇧", for: .normal)
        //self.deleteButton.setTitle(text: "", for: .normal)
        self.deleteButton.setTitle("", for: .normal)
        self.spaceButton.setTitle("space", for: .normal)
        self.returnButton.setTitle("enter", for: .normal)
        self.nextKeyboardButton.setImage(UIImage(systemName: "globe"), for: .normal)
        self.deleteButton.setImage(UIImage(systemName: "delete.backward"), for: .normal)
        
        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        self.shiftButton.addTarget(self, action: #selector(touchUpShiftKey), for: .touchUpInside)
        self.deleteButton.addTarget(self, action: #selector(touchUpDeleteKey), for: .touchUpInside)
        self.spaceButton.addTarget(self, action: #selector(touchUpSpaceKey), for: .touchUpInside)
        self.returnButton.addTarget(self, action: #selector(touchUpReturnKey), for: .touchUpInside)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillLayoutSubviews() {
        //        self.nextKeyboardButton.isHidden = !self.needsInputModeSwitchKey
        super.viewWillLayoutSubviews()
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }
    
    func setButtonsLayout() {
        let numberLineStackView = makeStackView(buttons: numberLineButtons)
        let topLineButton = makeStackView(buttons: topLineButton)
        let middleLineButton = makeStackView(buttons: middleLineButtons)
        let lastLineButton = makeStackView(buttons: lastLineButtons)
        
        let lastLineStackView = UIStackView(arrangedSubviews: [shiftButton, lastLineButton, deleteButton])
        lastLineStackView.alignment = .fill
        lastLineStackView.axis = .horizontal
        lastLineStackView.distribution = .fill
        lastLineStackView.spacing = 16
        lastLineStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let funcLineStackView = UIStackView(arrangedSubviews: [nextKeyboardButton, spaceButton, returnButton])
        funcLineStackView.alignment = .fill
        funcLineStackView.axis = .horizontal
        funcLineStackView.distribution = .fill
        funcLineStackView.spacing = 4
        funcLineStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(numberLineStackView)
        self.view.addSubview(topLineButton)
        self.view.addSubview(middleLineButton)
        self.view.addSubview(lastLineStackView)
        self.view.addSubview(funcLineStackView)
        
        let safeGuide = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            numberLineStackView.topAnchor.constraint(equalTo: safeGuide.topAnchor),
            numberLineStackView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 4),
            numberLineStackView.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -4),
            numberLineStackView.heightAnchor.constraint(equalToConstant: 40),
            
            topLineButton.topAnchor.constraint(equalTo: numberLineStackView.bottomAnchor, constant: 4),
            topLineButton.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor,constant: 4),
            topLineButton.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -4),
            topLineButton.heightAnchor.constraint(equalToConstant: 40),
            
            middleLineButton.topAnchor.constraint(equalTo: topLineButton.bottomAnchor, constant: 4),
            middleLineButton.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor,constant: 24),
            middleLineButton.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -24),
            middleLineButton.heightAnchor.constraint(equalToConstant: 40),
            
            shiftButton.widthAnchor.constraint(equalToConstant: 45),
            deleteButton.widthAnchor.constraint(equalToConstant: 45),
            
            lastLineStackView.topAnchor.constraint(equalTo: middleLineButton.bottomAnchor, constant: 4),
            lastLineStackView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor,constant: 4),
            lastLineStackView.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -4),
            lastLineStackView.heightAnchor.constraint(equalToConstant: 40),
            
            
            nextKeyboardButton.widthAnchor.constraint(equalToConstant: 40),
            nextKeyboardButton.heightAnchor.constraint(equalToConstant: 40),
            returnButton.widthAnchor.constraint(equalToConstant: 92),
            
            funcLineStackView.topAnchor.constraint(equalTo: lastLineStackView.bottomAnchor, constant: 4),
            funcLineStackView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 4),
            funcLineStackView.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -4),
            //funcLineStackView.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor)
        ])
    }
    
    func makeStackView(buttons:[CustomButton]) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 4
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
    func makeButtons(keyboardLine: KeyboardLine) -> [CustomButton] {
        
        var buttons = [CustomButton]()
        
        let list = KeyboardCharacter.getLineText(keyboardLine: keyboardLine)
        for character in list  {
            let button = CustomButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            button.setTitle(character, for: .normal)
            button.addTarget(self, action: #selector(keyboardButtonClicked(_:)), for: .touchUpInside)
            buttons.append(button)
        }
        return buttons
    }
    
    @objc func keyboardButtonClicked(_ sender: CustomButton) {
        
        if let character = sender.titleLabel?.text {
            UIDevice.current.playInputClick()
            self.textDocumentProxy.insertText(character)
        }
        isShifted = false
    }
    
    @objc func KeyboardFunctionButtonClicked(_ sender: CustomButton) {
        
    }
    
    @objc func touchUpSpaceKey() {
        self.textDocumentProxy.insertText(" ")
        UIDevice.current.playInputClick()
        isShifted = false
    }
    
    @objc func touchUpReturnKey() {
        self.textDocumentProxy.insertText("\n")
        UIDevice.current.playInputClick()
        isShifted = false
    }
    
    @objc func touchUpDeleteKey() {
        self.textDocumentProxy.deleteBackward()
        UIDevice.current.playInputClick()
        isShifted = false
    }
    
    @objc func touchUpShiftKey() {
        UIDevice.current.playInputClick()
        isShifted = isShifted ? false : true
    }
    
    func changedShift(){
        if isShifted {
            for key in self.topLineButton {
                let character = key.titleLabel?.text
                switch character {
                case "ㅂ":
                    key.setTitle("ㅃ", for: .normal)
                case "ㅈ":
                    key.setTitle("ㅉ", for: .normal)
                case "ㄷ":
                    key.setTitle("ㄸ", for: .normal)
                case "ㄱ":
                    key.setTitle("ㄲ", for: .normal)
                case "ㅅ":
                    key.setTitle("ㅆ", for: .normal)
                case "ㅐ":
                    key.setTitle("ㅒ", for: .normal)
                case "ㅔ":
                    key.setTitle("ㅖ", for: .normal)
                default: break
                }
            }
        } else {
            for key in self.topLineButton {
                let character = key.titleLabel?.text
                switch character {
                case "ㅃ":
                    key.setTitle("ㅂ", for: .normal)
                case "ㅉ":
                    key.setTitle("ㅈ", for: .normal)
                case "ㄸ":
                    key.setTitle("ㄷ", for: .normal)
                case "ㄲ":
                    key.setTitle("ㄱ", for: .normal)
                case "ㅆ":
                    key.setTitle("ㅅ", for: .normal)
                case "ㅒ":
                    key.setTitle("ㅐ", for: .normal)
                case "ㅖ":
                    key.setTitle("ㅔ", for: .normal)
                default: break
                }
            }
        }
    }
}