//
//  ViewController.swift
//  AppleLoginExample
//
//  Created by 조소정 on 2023/05/26.
//

import UIKit
import AuthenticationServices

enum UserDefaultKey {
    static let userIdentifier = "userIdentifier"
}

class ViewController: UIViewController {
    let appleLoginButton = ASAuthorizationAppleIDButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func updateUI() {
        setAppleLoginButton()
    }
    
    private func setAppleLoginButton() {
        appleLoginButton.addTarget(self, action: #selector(didTapAppleLoginButton), for: .touchUpInside)
        setAppleLoginButtonLayout()
    }
    
    private func setAppleLoginButtonLayout() {
        view.addSubview(appleLoginButton)
        appleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            appleLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            appleLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            appleLoginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            appleLoginButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    @objc private func didTapAppleLoginButton() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }


}

extension ViewController: ASAuthorizationControllerDelegate {
    //연동 성공
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email

            if let authorizationCode = appleIDCredential.authorizationCode, let identifyToken = appleIDCredential.identityToken {
                let codeString = String(data: authorizationCode, encoding: .utf8)
                let tokenString = String(data: identifyToken, encoding: .utf8)
                
            }
            UserDefaults.standard.set(userIdentifier, forKey: UserDefaultKey.userIdentifier)
            print("\(userIdentifier) \(fullName) \(email)")
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        //handle error
        print("error ocurred")
    }
}

// 버튼 클릭시 로그인 모달 창 present
extension ViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window ?? UIWindow()
    }
}

