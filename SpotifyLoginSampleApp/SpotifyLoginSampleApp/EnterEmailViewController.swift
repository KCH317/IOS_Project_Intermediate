//
//  EnterEmailViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by 권찬호 on 2022/03/07.
//

import UIKit
import FirebaseAuth

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
        // Firebase Auth 이메일/비밀번호 인증
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        // 신규 사용자 생성
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            
            if let error = error {
                let code = ( error as NSError ).code
                switch code {
                case 17007: // 이미 가입한 계정일 때 오류 코드
                    // 로그인 화면으로 이동
                    self.loginUser(withEmail: email, password: password)
                default:
                    self.errorMessageLabel.text = error.localizedDescription
                }
            } else {
                // 로그인 성공 시 메인화면으로 이동
                self.showMainViewController()
            }
        }
    }
    
    // 메인 화면으로 이동
    private func showMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainViewController = storyboard.instantiateViewController(identifier: "MainViewController")
        mainViewController.modalPresentationStyle = .fullScreen
        navigationController?.show(mainViewController, sender: nil)
    }
    
    
    // 로그인
    private func loginUser(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error  in
            guard let self = self else { return }
            
            if let error = error {
                self.errorMessageLabel.text = error.localizedDescription
            } else {
                self.showMainViewController()
            }
        }
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
