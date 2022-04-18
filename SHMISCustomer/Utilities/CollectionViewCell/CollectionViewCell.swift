//
//  CollectionViewCell.swift
//  SHMISCustomer
//
//  Created by admin on 18/03/22.
//

import UIKit



class CollectionViewCell: UICollectionViewCell {
    
    
    class var reuseIdentifier: String {
        return "CollectionViewCellReuseIdentifier"
    }
    class var nibName: String {
        return "CollectionViewCell"
    }
    
    @IBOutlet weak var textview: UIView!
    @IBOutlet weak var textlbl: UILabel!
    @IBOutlet weak var headinglbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textview.layer.cornerRadius = 25.0
        headinglbl.font = FontHelper.defaultRegularFontWithSize(size: 15)
        headinglbl.textColor = UIColor(red: 26/255, green: 72/255, blue: 128/255, alpha: 1.0)
        textlbl.font = FontHelper.defaultRegularFontWithSize(size: 12)
        textlbl.textColor = .black
    }
    
    func configureCell(heading: String, description: String) {
        self.headinglbl.text = heading
        self.textlbl.text = description
    }

}

