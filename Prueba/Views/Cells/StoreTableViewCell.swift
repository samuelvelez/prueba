//
//  StoreTableViewCell.swift
//  Prueba
//
//  Created by Samuel on 7/4/22.
//

import UIKit

class StoreTableViewCell: UITableViewCell {
    
    //MARK: - @IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCellWith(store: StoreInfo){
        nameLabel.text = store.attributes.name
        codeLabel.text = store.attributes.code
        addressLabel.text = store.attributes.full_address
    }
    
}
