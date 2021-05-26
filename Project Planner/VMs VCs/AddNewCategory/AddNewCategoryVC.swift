//
//  AddNewCategoryVC.swift
//  Project Planner
//
//  Created by Kalana Rathnayaka on 5/25/21.
//

import UIKit
import RxCocoa
import RxSwift
import CoreData

class AddNewCategoryVC: UIViewController {
    //MARK: outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var categoryNameTF: UITextField!
    @IBOutlet weak var budgetTF: UITextField!
    @IBOutlet weak var addNotesTF: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var colorOneBtn: UIButton!
    @IBOutlet weak var colorTwoBtn: UIButton!
    @IBOutlet weak var colorThreeBtn: UIButton!
    @IBOutlet weak var colorFourBtn: UIButton!
    @IBOutlet weak var colorFiveBtn: UIButton!
    
    //MARK: varibales
    let vm = AddNewCategoryVM()
    let bag = DisposeBag()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var homeVCdelegate: TriggerActions?
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addObservers()
        self.setupUI()
        self.colorOneBtnTapped()
    }
    
    //MARK: functions
    func setupUI() {

        //container View
        self.containerView.layer.borderWidth = 1.0
        self.containerView.layer.cornerRadius = 10.0
        self.containerView.layer.borderColor = #colorLiteral(red: 0.7152985873, green: 1, blue: 1, alpha: 1)
        
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
        
        //color buttons corners
        self.colorOneBtn.layer.cornerRadius = 5.0
        self.colorTwoBtn.layer.cornerRadius = 5.0
        self.colorThreeBtn.layer.cornerRadius = 5.0
        self.colorFourBtn.layer.cornerRadius = 5.0
        self.colorFiveBtn.layer.cornerRadius = 5.0
        
    }
    
    
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
        
        self.categoryNameTF.rx.text
            .orEmpty
            .bind(to: self.vm.categoryName)
            .disposed(by: bag)
        
        self.budgetTF.rx.text
            .orEmpty
            .bind(to: self.vm.budget)
            .disposed(by: bag)
        
        self.addNotesTF.rx.text
            .orEmpty
            .bind(to: self.vm.notes)
            .disposed(by: bag)
        
        self.colorOneBtn.rx.tap
            .subscribe() {[weak self] event in
                self?.colorOneBtnTapped()
            }
            .disposed(by: bag)
        
        self.colorTwoBtn.rx.tap
            .subscribe() {[weak self] event in
                self?.colorTwoBtnTapped()
            }
            .disposed(by: bag)
        
        self.colorThreeBtn.rx.tap
            .subscribe() {[weak self] event in
                self?.colorThreeBtnTapped()
            }
            .disposed(by: bag)
        
        self.colorFourBtn.rx.tap
            .subscribe() {[weak self] event in
                self?.colorFourBtnTapped()
            }
            .disposed(by: bag)
        
        self.colorFiveBtn.rx.tap
            .subscribe() {[weak self] event in
                self?.colorFiveBtnTapped()
            }
            .disposed(by: bag)
    }
    
    func saveBtnTapped() {
        self.startLoading()
        let category = Category(context: context)
        category.budget = self.vm.budget.value
        category.categoryName = self.vm.categoryName.value
        category.notes = self.vm.notes.value
        category.colorName = self.vm.colorName.value
        
        try! context.save()
        self.stopLoading()
        
        let doneAlert = UIAlertController(title: "Done", message: "New category added.", preferredStyle: UIAlertController.Style.alert)

        doneAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
            self.homeVCdelegate?.loadData()
          }))

        present(doneAlert, animated: true, completion: nil)
        
    }
    
    func cancelBtnTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func colorOneBtnTapped() {
        self.vm.colorName.accept("ColorOne")
        self.colorOneBtn.layer.borderWidth = 1.0
        self.colorTwoBtn.layer.borderWidth = 0.0
        self.colorThreeBtn.layer.borderWidth = 0.0
        self.colorFourBtn.layer.borderWidth = 0.0
        self.colorFiveBtn.layer.borderWidth = 0.0
    }
    
    func colorTwoBtnTapped() {
        self.vm.colorName.accept("ColorTwo")
        self.colorOneBtn.layer.borderWidth = 0.0
        self.colorTwoBtn.layer.borderWidth = 1.0
        self.colorThreeBtn.layer.borderWidth = 0.0
        self.colorFourBtn.layer.borderWidth = 0.0
        self.colorFiveBtn.layer.borderWidth = 0.0
    }
    
    func colorThreeBtnTapped() {
        self.vm.colorName.accept("ColorThree")
        self.colorOneBtn.layer.borderWidth = 0.0
        self.colorTwoBtn.layer.borderWidth = 0.0
        self.colorThreeBtn.layer.borderWidth = 1.0
        self.colorFourBtn.layer.borderWidth = 0.0
        self.colorFiveBtn.layer.borderWidth = 0.0
    }
    
    func colorFourBtnTapped() {
        self.vm.colorName.accept("ColorFour")
        self.colorOneBtn.layer.borderWidth = 0.0
        self.colorTwoBtn.layer.borderWidth = 0.0
        self.colorThreeBtn.layer.borderWidth = 0.0
        self.colorFourBtn.layer.borderWidth = 1.0
        self.colorFiveBtn.layer.borderWidth = 0.0
    }
    
    func colorFiveBtnTapped() {
        self.vm.colorName.accept("ColorFive")
        self.colorOneBtn.layer.borderWidth = 0.0
        self.colorTwoBtn.layer.borderWidth = 0.0
        self.colorThreeBtn.layer.borderWidth = 0.0
        self.colorFourBtn.layer.borderWidth = 0.0
        self.colorFiveBtn.layer.borderWidth = 1.0
    }

}
