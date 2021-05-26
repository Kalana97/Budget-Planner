//
//  AddNewExpenseVC.swift
//  Project Planner
//
//  Created by Kalana Rathnayaka on 5/25/21.
//

import UIKit
import Foundation
import FSCalendar
import RxSwift
import RxCocoa
import CoreData

class AddNewExpenseVC: UIViewController, FSCalendarDataSource, FSCalendarDelegate {
    
    //MARK: outlets
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var notesTF: UITextField!
    @IBOutlet weak var fsCalander: FSCalendar!
    @IBOutlet weak var addTOCalendarBtn: UISwitch!
    @IBOutlet weak var oneOffView: UIView!
    @IBOutlet weak var dailyView: UIView!
    @IBOutlet weak var weeklyView: UIView!
    @IBOutlet weak var monthlyView: UIView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var buttonContainerView: UIView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var previeousBtn: UIButton!
    
    //MARK: variables
    let bag = DisposeBag()
    let vm = AddNewExpensesVM()
    var addToCalanderSelected = false
    fileprivate lazy var dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var homeDelegateTwo: TriggerActions?
    var isUpdating = false
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addObservers()
        self.setupUI()
        self.setupCalander()
        
        if isUpdating {
            self.setupTextFields()
        }
        
    }
    
    //MARK: functions
    func addObservers() {
        self.saveBtn.rx.tap
            .subscribe() {[weak self] event in
                self?.saveBtnTapped()
            }
            .disposed(by: bag)
        
        self.cancelBtn.rx.tap
            .subscribe() {[weak self] event in
                self?.cancelBtnTapped()
            }
            .disposed(by: bag)
        
        self.amountTF.rx.text
            .orEmpty
            .bind(to: self.vm.amount)
            .disposed(by: bag)
        
        self.notesTF.rx.text
            .orEmpty
            .bind(to: self.vm.notes)
            .disposed(by: bag)
        
        self.previeousBtn.rx.tap
            .subscribe() {[weak self] event in
                self?.previousTapped()
            }
            .disposed(by: bag)
        
        self.nextBtn.rx.tap
            .subscribe() {[weak self] event in
                self?.nextTapped()
            }
            .disposed(by: bag)
    }
    
    func setupUI() {
        
        //calander delegates
        self.fsCalander.dataSource = self
        self.fsCalander.delegate = self
        
        //getting sub views to front
        self.fsCalander.bringSubviewToFront(self.nextBtn)
        self.fsCalander.bringSubviewToFront(self.previeousBtn)
        
        //calander border
        self.fsCalander.layer.borderWidth = 0.5
        self.fsCalander.layer.borderColor = #colorLiteral(red: 0.831372549, green: 0.8745098039, blue: 0.9137254902, alpha: 1)
        self.fsCalander.layer.cornerRadius = 10.0
        
        //container View
        self.containerView.layer.borderWidth = 1.0
        self.containerView.layer.cornerRadius = 10.0
        self.containerView.layer.borderColor = #colorLiteral(red: 0.7152985873, green: 1, blue: 1, alpha: 1)
        
        //button container view
        self.buttonContainerView.layer.cornerRadius = 10.0
        self.oneOffView.layer.cornerRadius = 10.0
        self.weeklyView.layer.cornerRadius = 10.0
        self.dailyView.layer.cornerRadius = 10.0
        self.monthlyView.layer.cornerRadius = 10.0
        
        //buttons
        self.cancelBtn.layer.cornerRadius = 10.0
        self.saveBtn.layer.cornerRadius = 10.0
        
        //button shadows
        self.cancelBtn.layer.shadowColor = UIColor.gray.cgColor
        self.cancelBtn.layer.shadowOffset = .init(width: 0.5, height: 0.5)
        self.cancelBtn.layer.shadowRadius = 8.0
        self.cancelBtn.layer.shadowOpacity = 0.25
        self.cancelBtn.layer.masksToBounds = false
        
        self.saveBtn.layer.shadowColor = UIColor.gray.cgColor
        self.saveBtn.layer.shadowOffset = .init(width: 0.5, height: 0.5)
        self.saveBtn.layer.shadowRadius = 8.0
        self.saveBtn.layer.shadowOpacity = 0.25
        self.saveBtn.layer.masksToBounds = false
        
    }
    
    func setupTextFields() {
        self.amountTF.text = self.vm.expenseDetails?.amount
        self.notesTF.text = self.vm.expenseDetails?.notes
        if self.vm.expenseDetails?.addToCalendar == true {
            self.addTOCalendarBtn.isOn = true
        } else {
            self.addTOCalendarBtn.isOn = false
        }
        
    }
       
    func saveBtnTapped() {
        self.startLoading()
        let expense = Expense(context: context)
        expense.amount = self.vm.amount.value
        expense.addToCalendar = self.vm.addToCalendar.value
        expense.date = self.vm.date.value
        expense.notes = self.vm.notes.value
        expense.occurrence = self.vm.occurence.value
        
        expense.addToCat(self.vm.category!)
        
        try! context.save()
        self.stopLoading()
        
        let doneAlert = UIAlertController(title: "Done", message: "New expense added.", preferredStyle: UIAlertController.Style.alert)

        doneAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
            self.homeDelegateTwo?.loadExpenses()
          }))

        present(doneAlert, animated: true, completion: nil)
    }
    
    func cancelBtnTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            print("did select date \(self.dateFormatter.string(from: date))")
        self.vm.date.accept(self.dateFormatter.string(from: date))
        }
    
}
