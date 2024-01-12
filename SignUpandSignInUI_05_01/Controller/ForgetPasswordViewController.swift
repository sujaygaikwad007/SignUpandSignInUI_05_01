import UIKit

class ForgetPasswordViewController: UIViewController {
    
    @IBOutlet weak var txtForgetEmail: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var forgetPasswordScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollViewEnbleDisable()
        
        hideKeyboardTappedAround()
        addIconToTextField(textField: txtForgetEmail, iconName: "email")
        
        txtForgetEmail.delegate = self
        
        btnSend.layer.cornerRadius = 20.0
        
        
        txtForgetEmail.layer.borderWidth = 1
        txtForgetEmail.layer.cornerRadius = 20
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
    }
    
    @IBAction func btnSendTapped(_ sender: Any) {
        
        guard let email = txtForgetEmail.text , !email.isEmpty else {
            return
        }
        resetPassword(email: email)
    }
    
    
    @IBAction func backtoLoginBtn(_ sender: UIButton) {
        
        let signInVC = storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        self.navigationController?.pushViewController(signInVC, animated: true)
        
    }
    
    
    func scrollViewEnbleDisable()
    {
        if UIDevice.current.hasNotch {
            
            forgetPasswordScrollView.isScrollEnabled = false
        }
        else
        {
            forgetPasswordScrollView.isScrollEnabled = true
            
        }
    }
}



