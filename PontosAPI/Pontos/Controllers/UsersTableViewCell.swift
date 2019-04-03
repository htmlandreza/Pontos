//
//  UsersTableViewCell.swift
//  Pontos
//
//  Created by Andreza Moreira on 28/03/19.
//  Copyright © 2019 Andreza Moreira. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // preprando célula
    // prepara o usuário que a tableView está preenchendo naquela célula
    func prepare(with user: ClockifyUser){
        // itens da cell
        nameLabel.text = (user.name)
        emailLabel.text = ("E-mail: \(user.email)")
    }
}


