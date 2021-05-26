//
//  ExpensesTVC.swift
//  Project Planner
//
//  Created by Kalana Rathnayaka on 5/25/21.
//

import UIKit

class ExpensesTVC: UITableViewCell {

    //MARK: outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var note: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //corners and border
        self.containerView.layer.cornerRadius = 10.0
        self.containerView.layer.borderWidth = 1.0
        
        //progressView
        self.progressView.layer.cornerRadius = 5.0
        self.progressView.layer.borderWidth = 0.6
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //set the values for top,left,bottom,right margins
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 15, left: 5, bottom: 0, right: 5))
    }

}
