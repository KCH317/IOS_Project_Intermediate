//
//  LoginViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by 권찬호 on 2022/03/07.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 로그인 버튼 3개의 UI설정
        [emailLoginButton, googleLoginButton, appleLoginButton].forEach{
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.white.cgColor
            $0?.layer.cornerRadius = 30
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Navigation Bar 숨기기
        navigationController?.navigationBar.isHidden = true
        
        // Google Sign In WebView
//        GIDSignIn.sharedInstance.presentingViewController = self
    }
    
    @IBAction func googleLoginButtonTapped(_ sender: UIButton) {
        //  Firebase 인증
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
            if let error = error {
                print("ERROR", error.localizedDescription)
                return
            }
            
            guard let authentication = user?.authentication,
                  let idToken = authentication.idToken else { return }
            
            // Google 인증 토큰
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { _, _ in
                self.showMainViewController()
            }
        }
    }
    
    @IBAction func appleLoginButtonTapped(_ sender: UIButton) {
        //  Firebase 인증
    }
    
    
    // 메인 화면으로 이동
    private func showMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainViewController = storyboard.instantiateViewController(identifier: "MainViewController")
        mainViewController.modalPresentationStyle = .fullScreen
        navigationController?.show(mainViewController, sender: nil)
    }
    
}
