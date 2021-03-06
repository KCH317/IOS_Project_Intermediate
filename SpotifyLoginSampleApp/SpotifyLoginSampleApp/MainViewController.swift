//
//  MainViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by 권찬호 on 2022/03/07.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var resetPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 뒤로 가기 시 팝 제스쳐 X
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Navigation Bar 숨기기
        navigationController?.navigationBar.isHidden = true
        
        // 로그인 고객에 이메일 가져오기
        let email = Auth.auth().currentUser?.email ?? "고객"
        
        welcomeLabel.text = """
        환영합니다.
        \(email)님
        """
        
        // 이메일로 로그인 한 사용자 검증
        let isEmailSignIn = Auth.auth().currentUser?.providerData[0].providerID == "password"
        resetPasswordButton.isHidden = !isEmailSignIn // 이메일 로그인이 아닐 경우 버튼 숨김
    }
    
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            // 첫 화면으로 돌아가기
            self.navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("ERROR : \(signOutError.localizedDescription)")
        }
        
        
    }
    
    // 이메일로 로그인 시 비밀번호 변경
    @IBAction func resetPasswordButtonTapped(_ sender: UIButton) {
        let email = Auth.auth().currentUser?.email ?? ""
        // 비밀번호 재설정 이메일을 보냄
        Auth.auth().sendPasswordReset(withEmail: email, completion: nil)
    }
}
