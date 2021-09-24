//
//  MainVC.swift
//  Meet the Members
//
//  Created by Michael Lin on 1/18/21.
//

import Foundation
import UIKit

class MainVC: UIViewController {
    
    var count = 0
    var person = 0
    var answer: String?
    var answerChosen = false
    var answerButton = 0
    static var points = 0
    static var longestStreak = 0
    static var currentStreak = 0
    // Create a property for our timer, we will initialize it in viewDidLoad
    var timer: Timer?
    static var paused = false
    static var lastThree: [String] = []
    
    // MARK: STEP 7: UI Customization
    // Action Items:
    // - Customize your imageView and buttons.
    
    let imageView: UIImageView = {
        let view = UIImageView()
        
        // MARK: >> Your Code Here <<
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let buttons: [UIButton] = {
        return (0..<4).map { index in
            let button = UIButton()

            // Tag the button its index
            button.tag = index
            
            // MARK: >> Your Code Here <<
            
            button.backgroundColor = .blue
            
            button.translatesAutoresizingMaskIntoConstraints = false
            
            return button
        }
        
    }()
    
    // MARK: STEP 10: Stats Button
    // Action Items:
    // - Follow the examples you've seen so far, create and
    // configure a UIButton for presenting the StatsVC. Only the
    // callback function `didTapStats(_:)` was written for you.
        
    private let statsButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Stats", for: .normal)
        
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .white
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let pauseButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Pause", for: .normal)
        
        button.setTitleColor(.red, for: .normal)
        button.backgroundColor = .white
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let pointsLabel: UILabel = {
        let label = UILabel()
        
        // == UIColor.darkGray
        label.textColor = .darkGray
        
        label.text = "Points: " + String(MainVC.points)
        
        // == NSTextAlignment(expected type).center
        label.textAlignment = .center
        
        // == UIFont.systemFont(ofSize: 27, UIFont.weight.medium)
        label.font = .systemFont(ofSize: 20, weight: .medium)
        
        // Must have if you are using constraints.
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
            
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        // Create a timer that calls timerCallback() every one second
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
        
        // MARK: STEP 6: Adding Subviews and Constraints
        // Action Items:
        // - Add imageViews and buttons to the root view.
        // - Create and activate the layout constraints.
        // - Run the App
        
        // Additional Information:
        // If you don't like the default presentation style,
        // you can change it to full screen too! However, in this
        // case you will have to find a way to manually to call
        // dismiss(animated: true, completion: nil) in order
        // to go back.
        //
        // modalPresentationStyle = .fullScreen
                
        view.addSubview(imageView)
        view.addSubview(buttons[0])
        view.addSubview(buttons[1])
        view.addSubview(buttons[2])
        view.addSubview(buttons[3])
        view.addSubview(statsButton)
        view.addSubview(pauseButton)
        view.addSubview(pointsLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
        
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            imageView.heightAnchor.constraint(equalTo: view.widthAnchor)
    ])
        
        NSLayoutConstraint.activate([
            buttons[0].topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            buttons[0].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            buttons[0].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
    ])
        
        NSLayoutConstraint.activate([
            buttons[1].topAnchor.constraint(equalTo: buttons[0].bottomAnchor, constant: 20),
            buttons[1].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            buttons[1].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
    ])
        
        NSLayoutConstraint.activate([
            buttons[2].topAnchor.constraint(equalTo: buttons[1].bottomAnchor, constant: 20),
            buttons[2].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            buttons[2].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
    ])
        
        NSLayoutConstraint.activate([
            buttons[3].topAnchor.constraint(equalTo: buttons[2].bottomAnchor, constant: 20),
            buttons[3].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            buttons[3].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
    ])
        
        NSLayoutConstraint.activate([
            statsButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            statsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
            statsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70),
        ])
        
        NSLayoutConstraint.activate([
            pauseButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            pauseButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
            pauseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70),
        ])
        
        NSLayoutConstraint.activate([
            pointsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            pointsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
            pointsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70),
        ])
     
         
    
        
        // MARK: STEP 9: Bind Callbacks to the Buttons
        // Action Items:
        // - Bind the `didTapAnswer(_:)` function to the buttons.
        
        // MARK: >> Your Code Here <<
    
        buttons[0].addTarget(self, action: #selector(didTapAnswer(_:)), for: .touchUpInside)
        buttons[1].addTarget(self, action: #selector(didTapAnswer(_:)), for: .touchUpInside)
        buttons[2].addTarget(self, action: #selector(didTapAnswer(_:)), for: .touchUpInside)
        buttons[3].addTarget(self, action: #selector(didTapAnswer(_:)), for: .touchUpInside)
        statsButton.addTarget(self, action: #selector(didTapStats(_:)), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(didTapPause(_:)), for: .touchUpInside)
        
        // MARK: STEP 10: Stats Button
        // See instructions above.
        
        // MARK: >> Your Code Here <<
    }
    
    // What's the difference between viewDidLoad() and
    // viewWillAppear()? What about viewDidAppear()?
    override func viewWillAppear(_ animated: Bool) {
        // MARK: STEP 13: Resume Game
        // Action Items:
        // - Reinstantiate timer when view appears
        if animated == true {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
        }
        super.viewWillAppear(animated)
        
    }
    
    func getNextQuestion() {
        // MARK: STEP 5: Data Model
        // Action Items:
        // - Get a question instance from `QuestionProvider`
        // - Configure the imageView and buttons with information from
        //   the question instance
        
        // MARK: >> Your Code Here <<
        let question = QuestionProvider.shared.nextQuestion()
        let image = question?.image
        let newAnswer = question?.answer
        let choices = question?.choices
        
        answer = newAnswer
        
        imageView.image = image
        buttons[0].setTitle(choices?[0], for: .normal)
        buttons[1].setTitle(choices?[1], for: .normal)
        buttons[2].setTitle(choices?[2], for: .normal)
        buttons[3].setTitle(choices?[3], for: .normal)
        
    }
    
    // MARK: STEP 8: Buttons and Timer Callback
    // Action Items:
    // - Complete the callback function for the 4 buttons.
    // - Complete the callback function for the timer instance
    //
    // Additional Information:
    // Take some time to plan what should be in here.
    // The 4 buttons should share the same callback.
    //
    // Add instance properties and/or methods
    // to the class if necessary. You may need to come back
    // to this step later on.
    //
    // Hint:
    // - The timer will fire every one second.
    // - You can use `sender.tag` to identify which button is pressed.
    
    @objc func timerCallback() {
        pointsLabel.text = "Points: " + String(MainVC.points)
        count += 1
        for button in buttons {
            if button.titleLabel!.text == answer {
                answerButton = button.tag
                }
            }
        
        if (count >= 5) {
            buttons[answerButton].backgroundColor = .systemGreen
            if (count == 7) {
            buttons[answerButton].backgroundColor = .blue
            count = 0
            MainVC.currentStreak = 0
                MainVC.lastThree.append("Incorrect")
            getNextQuestion()
            }
        }
        
        if (answerChosen == true) {
            if count == 2 {
                buttons[answerButton].backgroundColor = .blue
                buttons[person].backgroundColor = .blue
                count = 0
                getNextQuestion()
                MainVC.points += 1
                answerChosen = false
            }
        }
        if (MainVC.currentStreak > MainVC.longestStreak) {
            MainVC.longestStreak = MainVC.currentStreak
        }
    }
    
    @objc func didTapAnswer(_ sender: UIButton) {
        person = sender.tag
        if (buttons[person].titleLabel!.text == answer){
            answerChosen = true
            MainVC.currentStreak += 1
            MainVC.lastThree.append("Correct")
            buttons[person].backgroundColor = .systemGreen
        }
        else {
            answerChosen = true
            buttons[person].backgroundColor = .systemRed
            buttons[answerButton].backgroundColor = .systemGreen
            MainVC.lastThree.append("Incorrect")
            MainVC.currentStreak = 0
        }
    }
    
    @objc func didTapStats(_ sender: UIButton) {
        
        let vc = StatsVC(longestStreak: MainVC.longestStreak, lastThree: MainVC.lastThree)
        timer?.invalidate()
        //vc.modalPresentationStyle = .fullScreen
        
        // MARK: STEP 11: Going to StatsVC
        // When we are navigating between VCs (e.g MainVC -> StatsVC),
        // we often need a mechanism for transferring data
        // between view controllers. There are many ways to achieve
        // this (initializer, delegate, notification center,
        // combined, etc.). We will start with the easiest one today,
        // which is custom initializer.
        //
        // Action Items:
        // - Pause the game when stats button is tapped
        // - Read the example in StatsVC.swift, and replace it with
        //   your custom init for `StatsVC`
        // - Update the call site here on line 139
        
        present(vc, animated: true, completion: nil)
        
    }
    
    @objc func didTapPause(_ sender: UIButton) {
        if MainVC.paused == false {
            MainVC.paused = true
            timer?.invalidate()
            pauseButton.setTitle("Resume", for: .normal)
        } else {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
            pauseButton.setTitle("Pause", for: .normal)
            MainVC.points = 0
            MainVC.paused = false
            }
        }
}


//add score
