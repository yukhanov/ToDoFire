//
//  ViewController.swift
//  ToDoFire
//
//  Created by Юханов Сергей Сергеевич on 20/12/2018.
//  Copyright © 2018 Юханов Сергей Сергеевич. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var warnLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    let segueIdentifier = "tasksSegue"
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference(withPath: "users")
        warnLabel.alpha = 0
        Auth.auth().addIDTokenDidChangeListener { [weak self] (auth, user) in
            if user != nil {
                self?.performSegue(withIdentifier: (self?.segueIdentifier)!, sender: self)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.text = ""
        passTextField.text = ""
    }
    
    func displayWarningLabel(withText text: String) {
        warnLabel.text = text
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: { [weak self] in
            self?.warnLabel.alpha = 1
        }) { [weak self] complete in
            self?.warnLabel.alpha = 0
        }
    }

    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passTextField.text, email != "", password != "" else {
            displayWarningLabel(withText: "Info is incorrect")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            if error != nil {
                self?.displayWarningLabel(withText: "Error occured")
                return
            }
            if user != nil {
                self?.performSegue(withIdentifier: (self?.segueIdentifier)!, sender: self)
                return
            }
            self?.displayWarningLabel(withText: "No such user")
        }
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passTextField.text, email != "", password != "" else {
            displayWarningLabel(withText: "Info is incorrect")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
          
         
            
            guard error == nil, user != nil else {
                
                print(error!.localizedDescription)
                return
            }
            
            let userRef = self?.ref.child((user?.user.uid)!)
            userRef?.setValue(["email": user?.user.email])
            
            
        }
    }
}

