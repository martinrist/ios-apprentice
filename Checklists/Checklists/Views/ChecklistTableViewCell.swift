//
//  ChecklistTableViewCell.swift
//  Checklists
//
//  Created by Martin Rist on 30/09/2019.
//  Copyright © 2019 Martin Rist. All rights reserved.
//

import UIKit

class ChecklistTableViewCell: UITableViewCell {
  
  // MARK: - Outlets
  @IBOutlet weak var checkmarkLabel: UILabel!
  @IBOutlet weak var checklistItemTextLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
