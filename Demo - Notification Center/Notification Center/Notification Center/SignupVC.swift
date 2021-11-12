//
//  SignupVC.swift
//  Notification Center
//
//  Created by Michael Lin on 10/23/21.
//

import UIKit

class SignupVC: UIViewController {

    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 25
        stack.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)

        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome,"
        label.textColor = .primaryText
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleSecLabel: UILabel = {
        let label = UILabel()
        label.text = "Create your account"
        label.textColor = .secondaryText
        label.font = .systemFont(ofSize: 17, weight: .medium)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailTextField: AuthTextField = {
        let textField = AuthTextField(title: "Email:")
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let fullnameTextField: AuthTextField = {
        let textField = AuthTextField(title: "Fullname:")
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let usernameTextField: AuthTextField = {
        let textField = AuthTextField(title: "Username:")
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField: AuthTextField = {
        let textField = AuthTextField(title: "Password:")
        textField.textField.isSecureTextEntry = true
        textField.textField.textContentType = .oneTimeCode
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let signinButton: LoadingButton = {
        let button = LoadingButton()
        button.layer.backgroundColor = UIColor.primary.cgColor
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.isUserInteractionEnabled = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let signUpActionLabel: HorizontalActionLabel = {
        let actionLabel = HorizontalActionLabel(
            label: "Already Have an Account?",
            buttonTitle: "Sign In")
        
        actionLabel.translatesAutoresizingMaskIntoConstraints = false
        return actionLabel
    }()
    
    private let contentEdgeInset = UIEdgeInsets(top: 100, left: 40, bottom: 30, right: 40)
    
    private let signinButtonHeight: CGFloat = 44.0
    
    private var bottomInsetConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        view.backgroundColor = .background
        
        view.addSubview(titleLabel)
        view.addSubview(titleSecLabel)
        
        let titleTopLable = titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: contentEdgeInset.top)
        titleTopLable.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            titleTopLable,
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                constant: contentEdgeInset.left),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                 constant: contentEdgeInset.right),
            titleSecLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                               constant: 3),
            titleSecLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            titleSecLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
        
        view.addSubview(stack)
        stack.addArrangedSubview(emailTextField)
        stack.addArrangedSubview(fullnameTextField)
        stack.addArrangedSubview(usernameTextField)
        stack.addArrangedSubview(passwordTextField)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                           constant: contentEdgeInset.left),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                            constant: -contentEdgeInset.right),
            stack.topAnchor.constraint(equalTo: titleSecLabel.bottomAnchor,
                                       constant: 60)
        ])
        
        view.addSubview(signinButton)
        NSLayoutConstraint.activate([
            signinButton.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            signinButton.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 55),
            signinButton.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
            signinButton.heightAnchor.constraint(equalToConstant: signinButtonHeight)
        ])
        
        signinButton.layer.cornerRadius = signinButtonHeight / 2
        
        view.addSubview(signUpActionLabel)
        NSLayoutConstraint.activate([
            signUpActionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpActionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
        ])
        
        bottomInsetConstraint = view.bottomAnchor.constraint(greaterThanOrEqualTo: signinButton.bottomAnchor, constant: contentEdgeInset.bottom)
        bottomInsetConstraint.isActive = true
    }
}

