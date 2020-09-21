//
//  ProfileViewController.swift
//  princonnectGuide
//
//  Created by 金超 on 2020/9/21.
//  Copyright © 2020 jinchao. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController {
    
    var catchCopyString: String = ""
    var heightString: String = ""
    var weightString: String = ""
    var birthdayString: String = ""
    var bloodTypeString: String = ""
    var realNameString: String = ""
    
    
    @IBOutlet weak var catchCopy: UILabel!
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var birthday: UILabel!
    @IBOutlet weak var bloodType: UILabel!
    @IBOutlet weak var realName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
