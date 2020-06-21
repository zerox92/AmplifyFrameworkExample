//
//  ViewController.swift
//  AmplifyFramework
//
//  Created by Anjum, Zeeshan on 15/06/2020.
//  Copyright © 2020 Anjum, Zeeshan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var userNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configure()
    }
}

//MARK: IBActions
extension ViewController {
    @IBAction func hostedUiPressed(_ sender: Any) {
        if let navigationController = self.navigationController {
            Cognito.showHostedUI(navigationController: navigationController) { (error) in
                guard error == nil else {return}
                
                DispatchQueue.main.async {
                    self.configure()
                }
            }
        }
    }
    
    @IBAction func builtInUiPressed(_ sender: Any) {
        if let navigationController = self.navigationController {
            Cognito.showBuiltInUi(navigationController: navigationController)
        }
    }
    
    @IBAction func globalSignOutPressed(_ sender: Any) {
        Cognito.signOut {[weak self] (error) in
            guard let self = self else {return}
            
            DispatchQueue.main.async {
                self.configure()
            }
        }
    }
    
    @IBAction func usernamePressed(_ sender: Any) {
        Cognito.getUsername(nil)
    }
    
    @IBAction func tokensPressed(_ sender: Any) {
        Cognito.getTokens()
    }
}

//MARK: Private Methods
extension ViewController {
    private func configure() {
        Cognito.getUsername { (username) in
            self.userNameLabel.text = username
        }
    }
}
