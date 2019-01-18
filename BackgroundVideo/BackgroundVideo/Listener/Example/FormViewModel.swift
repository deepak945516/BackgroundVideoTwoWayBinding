//
//  FormViewModel.swift
//  BackgroundVideo
//
//  Created by Deepak Kumar on 17/01/19.
//  Copyright © 2019 deepak. All rights reserved.
//

import Foundation

struct FormViewModel {
    let name: Observable<String> = Observable()
    let companyName: Observable<String> = Observable()
    var yearsOfExperience: Observable<Double> = Observable()
    let isCurrentEmployer: Observable<Bool> = Observable(false)
    let approxSalary: Observable<Float> = Observable()
    let comments: Observable<String> = Observable()

    func getExperienceString() -> String {
        if let yearsOfExperience = yearsOfExperience.value {
            return "\(String(describing: yearsOfExperience)) yrs"
        }
        return "--"
    }

    func getSalaryString() -> String {
        if let approxSalary = approxSalary.value {
            let normalizedValue = String(format: "%.2f", approxSalary)
            return "\(normalizedValue)k"
        }
        return "--"
    }

    func getPrettyString() -> String {
        return
            "Name: \(String(describing: name.value ?? "--"))\n" +
                "Company: \(String(describing: companyName.value ?? "--"))\n" +
                "Experience: \(getExperienceString())\n" +
                "Current Employer?: \(((isCurrentEmployer.value ?? false) ? "YES" : "NO"))\n" +
                "approx Salary: \(getSalaryString())\n" +
        "Comments: \(String(describing: comments.value ?? "--"))"
    }
}
