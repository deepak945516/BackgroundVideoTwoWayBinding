//
//  ViewController.swift
//  BackgroundVideo
//
//  Created by Deepak Kumar on 16/01/19.
//  Copyright © 2019 deepak. All rights reserved.
//

import UIKit
import AVKit

final class LoginViewController: UIViewController {
    // MARK: - Properties
    private var playerViewController = AVPlayerViewController()
    @IBOutlet private weak var frontView: UIView!
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!

    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initialSetup()
        initialLayoutSetup()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    deinit {
        print("LoginViewController deinit called")
    }

    // MARK: - Private Methods
    private func initialSetup() {
        // Add mainFrontView to the view, later on we will bring to the front of the AVPlayer
        view.addSubview(frontView)
        frontView.fillSuperview()
        // Add observer to observe the end of the video, if end then replay it repeatedly
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidPlayToEndTime), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        playerViewController.showsPlaybackControls = false
        // Get the local backgroundVideo (named: videobackground.mp4) path
        if let videoBackgroundPath = Bundle.main.path(forResource: "videobackground", ofType: "mp4") {
            playVideo(with: videoBackgroundPath)
        }
    }

    private func initialLayoutSetup() {
        loginButton.makeCircle()
    }

    @objc private func videoDidPlayToEndTime() {
        playerViewController.player?.seek(to: CMTime.zero)
        playerViewController.player?.play()
    }

    private func playVideo(with url: String) {
        let player = AVPlayer(url: URL(fileURLWithPath: url))
        playerViewController.player = player
        view.addSubview(playerViewController.view)
        self.playerViewController.player?.play()
        view.bringSubviewToFront(frontView)
    }

    private func isEmailPasswordValid() -> (Bool, String) {
        var alertMessage = ""
        if emailField.text?.count == 0 {
            emailField.becomeFirstResponder()
            alertMessage = "Please enter email/username."
            return (false, alertMessage)
        } else if passwordField.text?.count == 0 {
            passwordField.becomeFirstResponder()
            alertMessage = "Please enter your password."
            return (false, alertMessage)
        }
        return (true, alertMessage)
    }

    // MARK: - IBAction Methods
    @IBAction private func loginButtonTapped(_ sender: UIButton) {
        let isValid = isEmailPasswordValid()
        if isValid.0 {
            print("Email/Username & Password validated successfully")
            // Now move to homeVdiewController
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as? ViewController {
                let navigationController = UINavigationController(rootViewController: viewController)
                navigationController.isNavigationBarHidden = false

//                UIApplication.shared.keyWindow?.rootViewController = navigationController
//                UIApplication.shared.keyWindow?.makeKeyAndVisible()
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.window?.rootViewController = navigationController
                }
            }
        } else {
            let alertController = UIAlertController(title: "MyApp", message: isValid.1, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                print("Ok button tapped")
            }))
            present(alertController, animated: true, completion: nil)
        }
    }
}

// MARK: - TextField Delegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailField:
            passwordField.becomeFirstResponder()
        default:
            self.view.endEditing(true)
        }
        return true
    }
}
