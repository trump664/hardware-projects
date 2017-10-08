//
//  ImageTableViewCell.swift
//  KeepItSafe
//
//  Created by Mariah Jenkins on 7/18/16.
//  Copyright © 2016 TTU. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell
{
    //MARK: Properties
    
    @IBOutlet weak var historyImage: UIImageView!
    @IBOutlet weak var imageLabel: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
    

}
