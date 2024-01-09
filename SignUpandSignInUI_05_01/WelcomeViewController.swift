import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var welcomeScrollview: UIScrollView!
    
    @IBOutlet weak var loginWithGoogleBtn: UIButton!
    @IBOutlet weak var loginWithFacebookBtn: UIButton!
    @IBOutlet weak var loginWithAppleIDBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.isNavigationBarHidden = false
        scrollViewEnbleDisable()
        cornerRadius()
    }
    
    //Enble and Disable ScrollView
    func scrollViewEnbleDisable()
    {
        if UIDevice.current.hasNotch {
            welcomeScrollview.isScrollEnabled = false
        }
        else
        {
            welcomeScrollview.isScrollEnabled = true
            
        }
    }
    
    func cornerRadius()
    {
        loginWithGoogleBtn.layer.cornerRadius = 20.0
        loginWithFacebookBtn.layer.cornerRadius = 20.0
        loginWithAppleIDBtn.layer.cornerRadius = 20.0

    }
    

    @IBAction func appleBtnTapped(_ sender: UIButton) {
        appleLogin()
    }
    
    
    @IBAction func googleBtnTapped(_ sender: UIButton) {
    }
    
    
    @IBAction func facebookBtnTapped(_ sender: UIButton) {
    }
    
    
    @IBAction func loginBtnTapped(_ sender: UIButton) {
        
        let signInVC = storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        self.navigationController?.pushViewController(signInVC, animated: true)
    }
    
}

