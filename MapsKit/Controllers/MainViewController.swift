//
//  MainViewController.swift
//  MapsKit
//
//  Created by Alex Larin on 01.03.2021.
//

import UIKit

class MainViewController: UIViewController {
    var login = ""
    let userBase = UserRepository()
    
    @IBAction func showMap(_ sender: Any) {
        performSegue(withIdentifier: "toMap", sender: nil)
        
    }
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isLogin")
        performSegue(withIdentifier: "toLaunch", sender: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = try? userBase.searchUser(login: login)
        user?.forEach{ user in
            
            let avatar = user.avatar
            avatarImageView.kf.setImage(with: URL(fileURLWithPath: avatar))
           
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "toMap" else {return}
        let destination = segue.destination as? ViewController
        destination?.login = self.login
    }
    
}
