//
//  ProfileViewController.swift
//  princonnectGuide
//
//  Created by 金超 on 2020/9/21.
//  Copyright © 2020 jinchao. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileViewController: UITableViewController {
    
    var iconString: String = ""
    var katakanaString: String = ""
    var catchCopyString: String = ""
    var heightString: String = ""
    var weightString: String = ""
    var birthdayString: String = ""
    var bloodTypeString: String = ""
    var realNameString: String = ""
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var katakanaName: UILabel!
    @IBOutlet weak var catchCopy: UILabel!
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var birthday: UILabel!
    @IBOutlet weak var bloodType: UILabel!
    @IBOutlet weak var realName: UILabel!
    
    let iconsPath = "file://" + NSHomeDirectory() + "/Documents/icons/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        icon.kf.setImage(with: URL(string: iconsPath + iconString)!)
        katakanaName.text = katakanaString
        catchCopy.text = catchCopyString
        height.text = heightString + "cm"
        weight.text = weightString + "kg"
        birthday.text = birthdayString
        bloodType.text = bloodTypeString
        realName.text = realNameString
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
