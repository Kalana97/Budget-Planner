//
//  HomeVC.swift
//  Project Planner
//
//  Created by Kalana Rathnayaka on 5/25/21.
//

import UIKit
import RxCocoa
import RxSwift
import CoreData
import Charts

protocol TriggerActions {
    func loadData()
    func loadExpenses()
}

class HomeVC: UIViewController, TriggerActions {
    
    //MARK: outlets
    @IBOutlet weak var categoriesTableView: UITableView!
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var addCategoryBtn: UIButton!
    @IBOutlet weak var addExpenseBtn: UIButton!
    @IBOutlet weak var seperatorLineView: UIView!
    @IBOutlet weak var detailsContentView: UIView!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var totalBudgetLbl: UILabel!
    @IBOutlet weak var spentLbl: UILabel!
    @IBOutlet weak var remainingLbl: UILabel!
    
    //MARK: variables
    let bag = DisposeBag()
    let vm = HomeVM()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var tempIndex: Int?
    var chartArr: [Any?] = []
    var total: Float?
    var remainig: Float?
    var spent: Float?
    var temRemaining = 0.0
    var entries: [PieChartDataEntry] = Array()
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addObservers()
        self.setUptableView()
        self.setupUI()
//        self.setupPieChart()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.fetchCategories()
    }
    
    //MARK: functions
    func setupUI() {
        //seperator line shadow
        self.seperatorLineView.layer.shadowColor = UIColor.gray.cgColor
        self.seperatorLineView.layer.shadowOffset = .init(width: 0.5, height: 0.5)
        self.seperatorLineView.layer.shadowRadius = 8.0
        self.seperatorLineView.layer.shadowOpacity = 0.25
        self.seperatorLineView.layer.masksToBounds = false
        
        //details content View
        self.detailsContentView.layer.cornerRadius = 10.0
        
        //table view
        self.categoriesTableView.layer.cornerRadius = 10.0
        
        //cleaning all lables
        self.totalBudgetLbl.text = ""
        self.spentLbl.text = ""
        self.remainingLbl.text = ""
        
    }
    
    func addObservers() {
        self.addCategoryBtn.rx.tap
            .subscribe() {[weak self] event in
                self?.addCategoryBtnTapped()
            }
            .disposed(by: bag)
        
        self.addExpenseBtn.rx.tap
            .subscribe() {[weak self] event in
                self?.addExpenseBtnTapped()
            }
            .disposed(by: bag)
    }
    
    func addCategoryBtnTapped() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddNewCategoryVC") as! AddNewCategoryVC
        vc.homeVCdelegate = self
        self.present(vc, animated: true)
    }
    
    func addExpenseBtnTapped() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddNewExpenseVC") as! AddNewExpenseVC
        vc.vm.category = self.vm.selectedCategory
        vc.homeDelegateTwo = self
        self.present(vc, animated: true)
    }
    
    func fetchCategories() {
        do {
            self.vm.categories = try context.fetch(Category.fetchRequest())
            
            
            DispatchQueue.main.async {
                self.categoriesTableView.reloadData()
            }
        } catch {
            
        }
    }
    
    func loadData() {
        self.fetchCategories()
    }
    
    func loadExpenses() {
        self.vm.expenses = self.vm.categories[self.tempIndex!].expenses?.allObjects as! [Expense]
        self.detailsTableView.reloadData()
        self.setupPieChart()

    }
    
    
}

//MARK: table view
extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    
    func setUptableView() {
        
        self.detailsTableView.dataSource = self
        self.detailsTableView.delegate = self
        self.detailsTableView.separatorStyle = .none
        
        self.categoriesTableView.dataSource = self
        self.categoriesTableView.delegate = self
        self.categoriesTableView.separatorStyle = .none
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //categories part
        if tableView == categoriesTableView {
            return self.vm.categories.count
        }
        
        //expenses part
        else {
            self.remainig = 0.0
            self.temRemaining = 0.0
            self.spent = 0.0
            self.entries.removeAll()
            return self.vm.expenses.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //categories part
        if tableView == categoriesTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoriesTVCID") as! CategoriesTVC
            cell.prepareForReuse()
            cell.selectionStyle = .none
            cell.categoryNameLbl.text = "Category: \(self.vm.categories[indexPath.row].categoryName ?? "")"
            cell.notesLbl.text = "\(self.vm.categories[indexPath.row].notes ?? "")"
            cell.budgetLbl.text = "Budget: \(self.vm.categories[indexPath.row].budget ?? "") $"
            cell.containerView.backgroundColor = UIColor(named: self.vm.categories[indexPath.row].colorName ?? "")
            return cell
        }
        
        //expenses part
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExpensesTVCID") as! ExpensesTVC
            cell.prepareForReuse()
            cell.selectionStyle = .none
            cell.amountLbl.text = "Amount: \(self.vm.expenses[indexPath.row].amount ?? "") $"
            cell.note.text = "Note: \(self.vm.expenses[indexPath.row].notes ?? "")"
            cell.dateLbl.text = "Date: \(self.vm.expenses[indexPath.row].date ?? "") \(self.vm.expenses[indexPath.row].occurrence ?? "")"
            let progress = ((self.vm.expenses[indexPath.row].amount?.floatValue ?? 0.0)/(vm.selectedCategory?.budget?.floatValue ?? 0.0))*100
            cell.progressView.progress = progress/100
            cell.progressLbl.text = "%\(progress)"
            self.calculateBudget(spendingVal: self.vm.expenses[indexPath.row].amount?.floatValue ?? 0.0)
            self.entries.append(PieChartDataEntry(value: Double(progress ), label: "\(self.vm.expenses[indexPath.row].notes ?? "") \(self.vm.expenses[indexPath.row].amount ?? "") $"))
            if indexPath.row == self.vm.expenses.count - 1 {
                self.entries.append(PieChartDataEntry(value: Double(self.remainig ?? 0.0) , label: "Remaining: \(self.remainig ?? 0.0) $"))
            }
            self.setupPieChart()
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == categoriesTableView {

            self.tempIndex = indexPath.row
            self.vm.selectedCategory = self.vm.categories[indexPath.row]
            self.vm.expenses = self.vm.categories[indexPath.row].expenses?.allObjects as! [Expense]
            self.totalBudgetLbl.text = "Budget: \(self.vm.selectedCategory?.budget ?? "0.0") $"
            self.total = self.vm.selectedCategory?.budget?.floatValue ?? 0.0
            if self.vm.expenses.count == 0 {
                self.spentLbl.text = "Spent: 0.0 $"
                self.remainingLbl.text = "Remaining: \(self.total ?? 0.0) $"
            }
            
            self.remainig = 0.0
            self.temRemaining = 0.0
            self.spent = 0.0
            self.detailsTableView.reloadData()
            self.setupPieChart()
        }
        
        else {
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "AddNewExpenseVC") as! AddNewExpenseVC
            vc.vm.category = self.vm.selectedCategory
            vc.homeDelegateTwo = self
            vc.vm.expenseDetails = self.vm.expenses[indexPath.row]
            vc.isUpdating = true
            self.present(vc, animated: true)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) ->
    UISwipeActionsConfiguration? {
        
        if tableView == detailsTableView {
            
            let deleteAction = UIContextualAction(style: .destructive, title: "") { (action, view, completion) in
                completion(true)
                
                let expenseToDelete = self.vm.expenses[indexPath.row]
                self.context.delete(expenseToDelete)
                
                do {
                    try self.context.save()
                } catch {
                    
                }
                
                self.fetchCategories()
                
                self.vm.expenses = self.vm.categories[self.tempIndex!].expenses?.allObjects as! [Expense]
                self.detailsTableView.reloadData()
                self.setupPieChart()

            }
            
            deleteAction.image = UIImage(named: "ic_delete")
            deleteAction.backgroundColor = UIColor.white
            
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        
        else {
            let deleteAction = UIContextualAction(style: .destructive, title: "") { (action, view, completion) in
                completion(true)
                let catToDelete = self.vm.categories[indexPath.row]
                self.context.delete(catToDelete)
                
                do {
                    try self.context.save()
                } catch {
                    
                }
                
                self.fetchCategories()
                self.categoriesTableView.reloadData()
                self.setupPieChart()
            }
            
            deleteAction.image = UIImage(named: "ic_delete")
            deleteAction.backgroundColor = UIColor.white
            
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
    }
    
    func calculateBudget(spendingVal: Float) {
        self.temRemaining += Double(spendingVal)
        self.remainig = ((self.total ?? Float(0.0)) - Float((self.temRemaining )))
        self.spentLbl.text = "Spent: \(self.temRemaining ) $"
        self.remainingLbl.text = "Remaining: \(self.remainig ?? 0.0) $"
        
    }
    
    
}

//MARK: pie chart
extension HomeVC {
    
    func setupPieChart() {
        self.pieChartView.chartDescription?.enabled = false
        self.pieChartView.drawHoleEnabled = false
        self.pieChartView.rotationAngle = 0
        self.pieChartView.rotationEnabled = false
        self.pieChartView.entryLabelColor = .black
        self.pieChartView.entryLabelFont?.withSize(15)
        self.pieChartView.isUserInteractionEnabled = false
        
        let dataset = PieChartDataSet(entries: self.entries, label: "")
        
        for _ in 0..<self.entries.count {
            dataset.colors.append(generateRandomColor())
        }
        //dataset.colors = [.red]
        dataset.drawValuesEnabled = false
        self.pieChartView.data = PieChartData(dataSet: dataset)
    }
}

//MARK: color generating
extension HomeVC {
    func generateRandomColor() -> UIColor {
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
}
