//
//  AddNewExpencesVM.swift
//  Project Planner
//
//  Created by Kalana Rathnayaka on 5/25/21.
//

import Foundation
import RxSwift
import RxCocoa

class AddNewExpensesVM {
    
    //MARK: variables
    var amount = BehaviorRelay<String>(value: "")
    var notes = BehaviorRelay<String>(value: "")
    var date = BehaviorRelay<String>(value: "")
    var occurence = BehaviorRelay<String>(value: "")
    var addToCalendar = BehaviorRelay<Bool>(value: false)
    var category: Category?
    var expenseDetails: Expense?
    
}
