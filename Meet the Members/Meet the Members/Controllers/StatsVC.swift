//
//  StatsVC.swift
//  Meet the Members
//
//  Created by Michael Lin on 1/18/21.
//

import UIKit

class StatsVC: UIViewController {
    
    // MARK: STEP 11: Going to StatsVC
    
    
    var longestStreak = 0
    var lastThree: [String] = []
    
    
    init(longestStreak: Int, lastThree: [String] = []) {
        self.longestStreak = longestStreak
        self.lastThree = lastThree.reversed()
        // Delegate rest of the initialization to super class
        // designated initializer.
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: >> Your Code Here <<
    
    // MARK: STEP 12: StatsVC UI
    // Action Items:
    // - Initialize the UI components, add subviews and constraints
    private let longestStreakLabel: UILabel = {
        let label = UILabel()
        
        // == UIColor.darkGray
        label.textColor = .darkGray
        
        label.text = "Longest Streak"
        
        // == NSTextAlignment(expected type).center
        label.textAlignment = .center
        
        // == UIFont.systemFont(ofSize: 27, UIFont.weight.medium)
        label.font = .systemFont(ofSize: 27, weight: .medium)
        
        // Must have if you are using constraints.
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let longestStreakNumberLabel: UILabel = {
        let label = UILabel()
        
        // == UIColor.darkGray
        label.textColor = .darkGray
        
        label.text = String(MainVC.longestStreak)
        
        // == NSTextAlignment(expected type).center
        label.textAlignment = .center
        
        // == UIFont.systemFont(ofSize: 27, UIFont.weight.medium)
        label.font = .systemFont(ofSize: 27, weight: .medium)
        
        // Must have if you are using constraints.
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let lastThreeLabel: UILabel = {
        let label = UILabel()
        
        // == UIColor.darkGray
        label.textColor = .darkGray
        
        label.text = "Last Three Results: "
        
        // == NSTextAlignment(expected type).center
        label.textAlignment = .center
        
        // == UIFont.systemFont(ofSize: 27, UIFont.weight.medium)
        label.font = .systemFont(ofSize: 27, weight: .medium)
        
        // Must have if you are using constraints.
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let lastThreeResultsLabel: UILabel = {
        let label = UILabel()
        
        // == UIColor.darkGray
        label.textColor = .darkGray
        
        if MainVC.lastThree.count == 0 {
            label.text = ""
        }
        
        if MainVC.lastThree.count == 1 {
            label.text = MainVC.lastThree[0]
        }
        if MainVC.lastThree.count == 2 {
            label.text = MainVC.lastThree[1] + "," + MainVC.lastThree[0]
        }
        if MainVC.lastThree.count >= 3 {
            MainVC.lastThree = MainVC.lastThree.reversed()
            label.text = MainVC.lastThree[0] +  "," + MainVC.lastThree[1] + "," + MainVC.lastThree[2]
        }
        
        // == NSTextAlignment(expected type).center
        label.textAlignment = .center
        
        // == UIFont.systemFont(ofSize: 27, UIFont.weight.medium)
        label.font = .systemFont(ofSize: 20, weight: .medium)
        
        // Must have if you are using constraints.
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(longestStreakLabel)
        view.addSubview(longestStreakNumberLabel)
        view.addSubview(lastThreeLabel)
        view.addSubview(lastThreeResultsLabel)
        view.backgroundColor = .white

        // MARK: >> Your Code Here <<
    
    
    NSLayoutConstraint.activate([
        // You can use the view.topAnchor. But it's different, why?
        // https://developer.apple.com/documentation/uikit/uiview/positioning_content_relative_to_the_safe_area
        longestStreakLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200),
        
        // For your understanding, here's what it's saying:
        //     welcomeLabel.leadingAnchor = view.leadingAnchor + 50
        longestStreakLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
        
        //     welcomeLabel.trailingAnchor = view.trailingAnchor - 50
        longestStreakLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
    ])
        
        NSLayoutConstraint.activate([
            
            longestStreakNumberLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 250),
            
            
            longestStreakNumberLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            
            longestStreakNumberLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
        ])
        
        NSLayoutConstraint.activate([
            
            lastThreeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 350),
            
            
            lastThreeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            
            
            lastThreeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
        ])
        
        NSLayoutConstraint.activate([
            
            lastThreeResultsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 400),
            
            
            lastThreeResultsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            
            lastThreeResultsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
        ])
}
}
            
