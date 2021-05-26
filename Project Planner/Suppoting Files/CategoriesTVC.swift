//
//  CategoriesTVC.swift
//  Project Planner
//
//  Created by Kalana Rathnayaka on 5/25/21.
//

import UIKit

class CategoriesTVC: UITableViewCell {
    
    //MARK: outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var categoryNameLbl: UILabel!
    @IBOutlet weak var budgetLbl: UILabel!
    @IBOutlet weak var notesLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //corners and border
        self.containerView.layer.cornerRadius = 10.0
        self.containerView.layer.borderWidth = 1.0
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
