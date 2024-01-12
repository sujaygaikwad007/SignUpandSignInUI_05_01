import UIKit

class EmailVerifyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false

       navigatetoSignIn()
    }
    
    
    func navigatetoSignIn(){
        
        let delay = 3.0
        
        DispatchQueue.main.asyncAfter(deadline:.now() + delay ){
            let signInVC = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
            self.navigationController?.pushViewController(signInVC, animated: true)
        }
        }
        
    }



    

