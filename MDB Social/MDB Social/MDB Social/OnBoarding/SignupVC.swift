//
//  SignupVC.swift
//  MDB Social
//
//  Created by Michelle Chang on 31/10/21.
//

import UIKit

import NotificationBannerSwift

class SignupVC: UIViewController {
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 25
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Sign up to continue"
        lbl.textColor = .primaryText
        lbl.font = .systemFont(ofSize: 20, weight: .semibold)
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    private let nameTextField: AuthTextField = {
        let tf = AuthTextField(title: "Full Name:")
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let emailTextField: AuthTextField = {
        let tf = AuthTextField(title: "Email:")
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let usernameTextField: AuthTextField = {
        let tf = AuthTextField(title: "Username:")
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let passwordTextField: AuthTextField = {
        let tf = AuthTextField(title: "Password:")
        tf.textField.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let passwordTextField2: AuthTextField = {
        let tf = AuthTextField(title: " Re-Enter Password:")
        tf.textField.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let signupButton: LoadingButton = {
        let btn = LoadingButton()
        btn.layer.backgroundColor = UIColor.primary.cgColor
        btn.setTitle("Sign Up", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        btn.isUserInteractionEnabled = true
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let signInActionLabel: HorizontalActionLabel = {
        let actionLabel = HorizontalActionLabel(
            label: "Already have an account?",
            buttonTitle: "Sign In")
        
        actionLabel.translatesAutoresizingMaskIntoConstraints = false
        return actionLabel
    }()
    
    private let contentEdgeInset = UIEdgeInsets(top: 120, left: 40, bottom: 30, right: 40)
    
    private let signupButtonHeight: CGFloat = 44.0
    
    private var bannerQueue = NotificationBannerQueue(maxBannersOnScreenSimultaneously: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: contentEdgeInset.top),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: contentEdgeInset.left),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -contentEdgeInset.right)
        ])
        
        view.addSubview(stack)
        stack.addArrangedSubview(nameTextField)
        stack.addArrangedSubview(emailTextField)
        stack.addArrangedSubview(usernameTextField)
        stack.addArrangedSubview(passwordTextField)
        stack.addArrangedSubview(passwordTextField2)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                       constant: 60),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                   constant: contentEdgeInset.left),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                    constant: -contentEdgeInset.right)
                ])
        
        view.addSubview(signupButton)
                NSLayoutConstraint.activate([
                    signupButton.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
                    signupButton.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 30),
                    signupButton.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
                    signupButton.heightAnchor.constraint(equalToConstant: signupButtonHeight)
                ])
        
        signupButton.layer.cornerRadius = signupButtonHeight / 2
        signupButton.addTarget(self, action: #selector(didTapSignUp(_:)), for: .touchUpInside)
    }
    
    @objc func didTapSignUp(_ sender: UIButton) {
        guard let name = nameTextField.text, name != "" else {
            showErrorBanner(withTitle: "Name missing", subtitle: "Please input name to proceed")
        return
        }
        
        guard let email = emailTextField.text, email != "" else {
            showErrorBanner(withTitle: "Email missing", subtitle: "Please input email to proceed")
            return
        }
        
        guard let username = usernameTextField.text, username != "" else {
            showErrorBanner(withTitle: "Username missing", subtitle: "Please input username to proceed")
            return
        }
        
        guard let password = passwordTextField.text, password != "" else {
            showErrorBanner(withTitle: "Password missing", subtitle: "Please input password to proceed")
            return
        }
        
        guard let password2 = passwordTextField2.text, password2 == password else{
            showErrorBanner(withTitle: "Password does not match", subtitle: "Please input correct password to proceed")
            return
        }
        
        signupButton.showLoading()
        SOCAuthManager.shared.signUp(withFullName: name, withEmail: email, withUsername: username,withPassword: password) { [weak self] result in
                    defer {
                        self?.signupButton.hideLoading()
                    }
                    
                    switch result {
                    case .success:
                        guard let window = UIApplication.shared
                                .windows.filter({ $0.isKeyWindow }).first else { return }
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                        window.rootViewController = vc
                        let options: UIView.AnimationOptions = .transitionCrossDissolve
                        let duration: TimeInterval = 0.3
                        UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: nil)
                    case .failure(let error):
                        self?.showErrorBanner(withTitle: error.localizedDescription)
                    }
                }
                
            }
    private func showErrorBanner(withTitle title: String, subtitle: String? = nil) {
        guard bannerQueue.numberOfBanners == 0 else { return }
        let banner = FloatingNotificationBanner(title: title, subtitle: subtitle,
                                                titleFont: .systemFont(ofSize: 17, weight: .medium),
                                                subtitleFont: subtitle != nil ?
                                                    .systemFont(ofSize: 14, weight: .regular) : nil,
                                                style: .warning)
        
        banner.show(bannerPosition: .top,
                    queue: bannerQueue,
                    edgeInsets: UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15),
                    cornerRadius: 10,
                    shadowColor: .primaryText,
                    shadowOpacity: 0.3,
                    shadowBlurRadius: 10)
    }
}
