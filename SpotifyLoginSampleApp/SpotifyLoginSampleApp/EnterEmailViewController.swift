//
//  EnterEmailViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by 권찬호 on 2022/03/07.
//

import UIKit

class EnterEmailViewController: UIViewController{
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 다음 버튼 UI 설정
        nextButton.layer.cornerRadius = 30
        
        // 다음 버튼 시작 시 비활성화
        nextButton.isEnabled = false
        
        // textField 값 넘기기
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        // 화면 시작 시 이메일 텍스트필드에 커서 위치
        emailTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Navigation Bar 보이기
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
    }
}

// textField delegate
extension EnterEmailViewController: UITextFieldDelegate{
    // return 버튼이 눌렸을 때 키보드가 내려가기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    // 다음 버튼 다시 활성화
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isEmailEmpty = emailTextField.text == ""
        let isPasswordEmpty = passwordTextField.text == ""
        // 이메일과 패스워드가 있을 때 다시 활성화
        nextButton.isEnabled =  !isEmailEmpty && !isPasswordEmpty
    }
}
