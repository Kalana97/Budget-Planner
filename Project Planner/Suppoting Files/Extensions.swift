//
//  Extensions.swift
//  Project Planner
//
//  Created by Kalana Rathnayaka on 5/25/21.
//

import Foundation
import UIKit
import FSCalendar
import RappleProgressHUD

//MARK: calander extension
extension AddNewExpenseVC {

    func setupCalander() {
        //desibling next and previous name labels
        self.fsCalander.appearance.headerMinimumDissolvedAlpha = 0
        
        //selecting rectangle
        self.fsCalander.appearance.borderRadius = 0.4
//        self.fsCalander.appearance.headerTitleFont = UIFont(name: "Poppins-Bold", size: 14)
        self.fsCalander.appearance.borderSelectionColor = #colorLiteral(red: 0.9607843137, green: 0.5215686275, blue: 0.231372549, alpha: 1)
        self.fsCalander.appearance.selectionColor = #colorLiteral(red: 0.9607843137, green: 0.5215686275, blue: 0.231372549, alpha: 1)
        self.fsCalander.appearance.titleTodayColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.fsCalander.appearance.todayColor = #colorLiteral(red: 0.9607843137, green: 0.5215686275, blue: 0.231372549, alpha: 1)
        self.fsCalander.appearance.caseOptions = FSCalendarCaseOptions.weekdayUsesSingleUpperCase
//        self.fsCalander.appearance.weekdayFont = UIFont(name: "Poppins-Medium", size: 14)
//        self.calendar.appearance.titleFont = UIFont(name: "Poppins-SemiBold", size: 13)
        
    }
    
    func nextTapped() {
        self.fsCalander.setCurrentPage(getNextMonth(date: self.fsCalander.currentPage), animated: true)
    }
    
    func previousTapped() {
        self.fsCalander.setCurrentPage(getPreviousMonth(date: self.fsCalander.currentPage), animated: true)
    }
    
    func getNextMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: 1, to:date)!
    }
    
    func getPreviousMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: -1, to:date)!
    }
    
}

extension HomeVC {
    // -------- RappleProgressHUD -------- //
    // Start loading
    func startLoading() {
        RappleActivityIndicatorView.startAnimating()
    }
    
    // Start loading with text
    func startLoadingWithText(label: String) {
        RappleActivityIndicatorView.startAnimatingWithLabel(label)
    }
    
    // Stop loading
    func stopLoading() {
        RappleActivityIndicatorView.stopAnimation()
    }
    
    func startLoadingWithProgress(current: CGFloat, total:CGFloat) {
        RappleActivityIndicatorView.setProgress(current/total)
    }
}

extension AddNewCategoryVC {
    // -------- RappleProgressHUD -------- //
    // Start loading
    func startLoading() {
        RappleActivityIndicatorView.startAnimating()
    }
    
    // Start loading with text
    func startLoadingWithText(label: String) {
        RappleActivityIndicatorView.startAnimatingWithLabel(label)
    }
    
    // Stop loading
    func stopLoading() {
        RappleActivityIndicatorView.stopAnimation()
    }
    
    func startLoadingWithProgress(current: CGFloat, total:CGFloat) {
        RappleActivityIndicatorView.setProgress(current/total)
    }
}

extension AddNewExpenseVC {
    // -------- RappleProgressHUD -------- //
    // Start loading
    func startLoading() {
        RappleActivityIndicatorView.startAnimating()
    }
    
    // Start loading with text
    func startLoadingWithText(label: String) {
        RappleActivityIndicatorView.startAnimatingWithLabel(label)
    }
    
    // Stop loading
    func stopLoading() {
        RappleActivityIndicatorView.stopAnimation()
    }
    
    func startLoadingWithProgress(current: CGFloat, total:CGFloat) {
        RappleActivityIndicatorView.setProgress(current/total)
    }
}

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}


