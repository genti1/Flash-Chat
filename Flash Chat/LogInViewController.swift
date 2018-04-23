//
//  LogInViewController.swift
//  Flash Chat
//
//  This is the view controller where users login


import UIKit
import Firebase
import SVProgressHUD

// Keychain Configuration
struct KeychainConfiguration {
    static let serviceName = "FlashChat"
    static let accessGroup: String? = nil
}

class LogInViewController: UIViewController {
    
    var passwordItems: [KeychainPasswordItem] = []
    var accountName: String?
    let bioAuth = BiometricIDAuth()
    
    //Textfields pre-linked with IBOutlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            passwordItems = try KeychainPasswordItem.passwordItems(forService: KeychainConfiguration.serviceName, accessGroup: KeychainConfiguration.accessGroup)
        }
        catch {
            fatalError("Error fetching password items - \(error)")
        }
        if !passwordItems.isEmpty{
            bioAuth.authenticateUser() {message in
                if let message = message {
                    // if the completion is not nil show an alert
                    let alertView = UIAlertController(title: "Error",
                                                      message: message,
                                                      preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK!", style: .default)
                    alertView.addAction(okAction)
                    self.present(alertView, animated: true)
                    
                } else {
                    self.enterKeychainData()
                    self.logInPressed(self)
                }
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func delButtonPressed(_ sender: Any) {
        do {
            passwordItems = try KeychainPasswordItem.passwordItems(forService: KeychainConfiguration.serviceName, accessGroup: KeychainConfiguration.accessGroup)
        }
        catch {
            fatalError("Error fetching password items - \(error)")
        }
        if !passwordItems.isEmpty{
            try! passwordItems[0].deleteItem()
            let alertView = UIAlertController(title: "Success", message: "Deleted keychain data", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK!", style: .default)
            alertView.addAction(okAction)
            self.present(alertView, animated: true)
        }else{
            print("Not removed")
            let alertView = UIAlertController(title: "Error", message: "Nothing to delete", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK!", style: .default)
            alertView.addAction(okAction)
            self.present(alertView, animated: true)
        }
    }
    func enterKeychainData(){
        do {
            passwordItems = try KeychainPasswordItem.passwordItems(forService: KeychainConfiguration.serviceName, accessGroup: KeychainConfiguration.accessGroup)
        }
        catch {
            fatalError("Error fetching password items - \(error)")
        }
        if !passwordItems.isEmpty{
            let passwordItem = passwordItems[0]
            emailTextfield.text = passwordItem.account
            do{
                passwordTextfield.text = try passwordItem.readPassword()
            }catch{
                fatalError("Error getting data from keychain \(error)")
            }
        }

    }

   
    @IBAction func logInPressed(_ sender: AnyObject) {
        guard let newAccountName = emailTextfield.text, let newPassword = passwordTextfield.text, !newAccountName.isEmpty && !newPassword.isEmpty else { return }
        do {
            if let originalAccountName = accountName {
                // Create a keychain item with the original account name.
                var passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: originalAccountName, accessGroup: KeychainConfiguration.accessGroup)

                // Update the account name and password.
                try passwordItem.renameAccount(newAccountName)
                try passwordItem.savePassword(newPassword)
            }
            else {
                // This is a new account, create a new keychain item with the account name.
                let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: newAccountName, accessGroup: KeychainConfiguration.accessGroup)

                // Save the password for the new item.
                try passwordItem.savePassword(newPassword)
            }
        }
        catch {
            fatalError("Error updating keychain - \(error)")
        }
        
        SVProgressHUD.show(withStatus: "Logging in")
        //TODO: Log in the user
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
//        Auth.auth().signIn(withEmail: emailTextfield.text!, password: try! passwordItem.readPassword()) { (user, error) in
            if error != nil{
                SVProgressHUD.dismiss()
                self.showLoginFailedAlert()
            }else{
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        }
        
    }
    
    private func showLoginFailedAlert() {
        let alertView = UIAlertController(title: "Login Problem",
                                          message: "Wrong username or password.",
                                          preferredStyle:. alert)
        let okAction = UIAlertAction(title: "Try again!", style: .default)
        alertView.addAction(okAction)
        present(alertView, animated: true)
    }


    
}  
