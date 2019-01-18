//
//  ViewController.swift
//  BackgroundVideo
//
//  Created by Deepak Kumar on 17/01/19.
//  Copyright © 2019 deepak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var companyField: UITextField!
    @IBOutlet weak var isCurrentEmployerSwitch: UISwitch!

    @IBOutlet weak var yearsOfExperienceStepper: UIStepper!
    @IBOutlet weak var selectedYearsOfExperienceLabel: UILabel!

    @IBOutlet weak var salaryRangeSlider: UISlider!
    @IBOutlet weak var selectedSalaryRangeLabel: UILabel!

    @IBOutlet private weak var commentTextView: BindableTextView!

    var labelPositionIsLeft: Bool = true

    // VIEW MODEL*
    var viewModel: FormViewModel = FormViewModel()

    // MARK: - Life Cycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
        self.navigationItem.title = "Survey Form"
        initialSetup()
        setupBindings()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(viewModel.getPrettyString())
        startAnimation()
        viewModel.comments.value = """
        You are awesome dear!!!

        Nice Work Done.
        """
    }

    override var prefersHomeIndicatorAutoHidden: Bool {
        return navigationController?.hidesBarsOnTap ?? false
    }

    // MARK: - Setup Method
    private func initialSetup() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .never
        let bgImageView = UIImageView(frame: view.frame)
        bgImageView.image = UIImage(named: "Wallpaper3")
        bgImageView.addBlurEffect()
        view.addSubview(bgImageView)
        view.sendSubviewToBack(bgImageView)
    }

    func setupBindings() {
        nameField.bind(with: viewModel.name)
        companyField.bind(with: viewModel.companyName)
        isCurrentEmployerSwitch.bind(with: viewModel.isCurrentEmployer)
        yearsOfExperienceStepper.bind(with: viewModel.yearsOfExperience)
        salaryRangeSlider.bind(with: viewModel.approxSalary)
        commentTextView.bind(with: viewModel.comments)

        selectedSalaryRangeLabel.observe(for: viewModel.approxSalary) {
            [unowned self](_) in
            self.selectedSalaryRangeLabel.text =
                self.viewModel.getSalaryString()
        }

        selectedYearsOfExperienceLabel.observe(for: viewModel.yearsOfExperience) {
            [unowned self](_) in
            self.selectedYearsOfExperienceLabel.text =
                self.viewModel.getExperienceString()
        }

        nameField.observe(for: viewModel.name) { [unowned self](_) in
            self.navigationItem.title = self.viewModel.name.value
            print(self.viewModel.name.value ?? "no")
        }
    }


    func startAnimation() {
        UIView.animate(withDuration: 0.3, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.curveEaseInOut, .repeat], animations: {
            if self.labelPositionIsLeft {
                self.nameField.center.y -= 40
            }
            else {
                self.nameField.center.x += 40
            }
            self.labelPositionIsLeft = !(self.labelPositionIsLeft)
        }, completion: nil)
    }

    // MARK: - IBAction Methods
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        if let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                let navigationController = UINavigationController(rootViewController: loginViewController)
                navigationController.isNavigationBarHidden = true
                appDelegate.window?.rootViewController = navigationController
            }
        }
    }
}

// MARK: - UITextField Delegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameField:
            companyField.becomeFirstResponder()
        default:
            view.endEditing(true)
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.text ?? "endEditing")
    }
}
