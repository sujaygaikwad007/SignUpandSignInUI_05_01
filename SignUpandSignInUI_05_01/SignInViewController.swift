import UIKit

class SignInViewController: UIViewController {
    
    
    @IBOutlet weak var LoginInScrollView: UIScrollView!
    @IBOutlet weak var signInView: UIView!
    @IBOutlet weak var txtEmailSignIn: UITextField!
    @IBOutlet weak var txtPasswordSignIn: UITextField!
    @IBOutlet weak var SignInBtn: UIButton!
    
    var userEmail = ""
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardTappedAround()
        scrollViewEnbleDisable()
        cornerRadiusTxtField()
        addIconToTextField(textField: txtEmailSignIn, iconName: "email")
        addIconToTextField(textField: txtPasswordSignIn, iconName: "open-lock")
        eyeIconTxtField(for: txtPasswordSignIn, with: UIImageView())
        setupBackButton()
        txtEmailSignIn.delegate = self
        txtPasswordSignIn.delegate = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        txtEmailSignIn.text = userEmail
    }
    
    //Enble and Disable ScrollView
    func scrollViewEnbleDisable()
    {
        if UIDevice.current.hasNotch {
            
            LoginInScrollView.isScrollEnabled = false
        }
        else
        {
            LoginInScrollView.isScrollEnabled = true
            
        }
    }
    
    
    @IBAction func btnForgotPassTapped(_ sender: Any) {
        
    }
    
    
    
    @IBAction func btnSignInBtnTapped(_ sender: Any) {
        signInUser()
        
    }
    
    
    @IBAction func btnSignUpTapped(_ sender: Any) {
        
        let signUp = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(signUp, animated: true)
    }
    
    
    
    //Custom Back button ------- start
    func setupBackButton() {
        
            let backButton = UIButton(type: .custom)
            backButton.setImage(UIImage(named: "back"), for: .normal)
            backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
            let customBackButton = UIBarButtonItem(customView: backButton)

            navigationItem.leftBarButtonItem = customBackButton
        }

        @objc func backButtonTapped() {
            self.navigationController?.popToRootViewController(animated: true)
        }
    
    //Custom Back button ------- Stop

   
    
}
