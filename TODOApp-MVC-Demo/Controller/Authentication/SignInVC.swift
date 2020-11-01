import UIKit

class SignInVC: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK:- Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    // MARK:- IBActions
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            !email.isEmpty, email.isValidEmail,
            !password.isEmpty, password.isValidPassword else {
                openAlert(title: "Fields Required!", message: "Please enter a valid Email Address & Password", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.cancel], actions: nil)
                return
        }

        signIn(with: email, password: password)
    }
    
    @IBAction func createAccBtnPressed(_ sender: UIButton) {
        let signUpVC = SignUpVC.create()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    // MARK:- Public Methods
    class func create() -> SignInVC {
        let signInVC: SignInVC = UIViewController.create(storyboardName: Storyboards.authentication, identifier: ViewControllers.signInVC)
        return signInVC
    }
    
    // MARK:- Private Methods
    private func goToMainVC() {
        let todoListVC = TodoListVC.create()
        navigationController?.pushViewController(todoListVC, animated: true)
    }
    
    private func signIn(with email: String, password: String) {
        self.showActivityIndicator()
        APIManager.login(with: email, password: password) { [weak self] (error, loginData) in
            
            DispatchQueue.main.async {
                self?.hideActivityIndicator()
            }
            
            if let error = error {
                print(error.localizedDescription)
                self?.openAlert(title: "Attention!", message: "Your email or password is incorrect, please try again", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.cancel], actions: nil)
            } else if let loginData = loginData {
                print(loginData.token)
                UserDefaultsManager.shared().token = loginData.token
                
                self?.goToMainVC()
            }
        }
    }
}
