import UIKit
import FirebaseCore
import FirebaseAuth
import AuthenticationServices



var iconClick = false

//Extension for keyboard
extension UIViewController{
    func hideKeyboardTappedAround(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
}

//Extension for devices has notch
extension UIDevice {
    var hasNotch:Bool{
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}


//Extension for SignInController-----Start
extension SignInViewController:UITextFieldDelegate
{
    //Add corner Radius to the textField ---- Start
    func cornerRadiusTxtField()
    {
        signInView.layer.cornerRadius = 30.0
        SignInBtn.layer.cornerRadius = 20.0
        
        
        txtEmailSignIn.layer.borderWidth = 1
        txtEmailSignIn.layer.cornerRadius = 20
        
        txtPasswordSignIn.layer.borderWidth = 1
        txtPasswordSignIn.layer.cornerRadius=20
        
        
    }
    //Add corner Radius to the textField ---- End
    
    // Code for  Icon---- Start
    func addIconToTextField(textField: UITextField, iconName: String) {
        let iconImageView = UIImageView(image: UIImage(named: iconName))
        iconImageView.contentMode = .scaleAspectFit
        
        let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: textField.frame.height)) // Adjust the width as needed
        
        iconContainerView.addSubview(iconImageView)
        iconImageView.frame = CGRect(x: 10, y: 0, width: 20, height: textField.frame.height) // Adjust the positioning and size of the icon
        
        textField.leftView = iconContainerView
        textField.leftViewMode = .always
    }
    
    // Code for  Icon---- End
    
    
    //Code for Eye icon for password hide and show ---Start
    func eyeIconTxtField(for textField: UITextField, with iconImageView: UIImageView) {
        let passIcon = iconImageView
        passIcon.image = UIImage(named: "open")
        let contentView = UIView()
        contentView.addSubview(passIcon)
        
        contentView.frame = CGRect(x: 0, y: 0, width: UIImage(named: "close")!.size.width, height: UIImage(named: "close")!.size.height)
        
        passIcon.frame = CGRect(x: -10, y: 0, width: UIImage(named: "close")!.size.width, height: UIImage(named: "close")!.size.height)
        
        textField.rightView = contentView
        textField.rightViewMode = .always
        textField.clearButtonMode = .whileEditing
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        passIcon.isUserInteractionEnabled = true
        passIcon.addGestureRecognizer(tapGesture)
    }
    
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedImageView = sender.view as? UIImageView else { return }
        guard let textField = tappedImageView.superview?.superview as? UITextField else { return }
        
        if iconClick {
            iconClick = false
            tappedImageView.image = UIImage(named: "open")
            textField.isSecureTextEntry = false
        } else {
            iconClick = true
            tappedImageView.image = UIImage(named: "close")
            textField.isSecureTextEntry = true
        }
    }
    //Code for Eye icon for password hide and show ---End
    
    
    //Code for add border color after selecting--Start
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemCyan.cgColor
        
        if textField == txtEmailSignIn
        {
            addIconToTextField(textField: txtEmailSignIn, iconName: "filledemail")
            
        }
        else if textField == txtPasswordSignIn
        {
            addIconToTextField(textField: txtPasswordSignIn, iconName: "filledlock")
        }
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        
        addIconToTextField(textField: txtEmailSignIn, iconName: "email")
        addIconToTextField(textField: txtPasswordSignIn, iconName: "open-lock")
        
    }
    //Code for add border color after selecting-- End
    
    func signInUser()
    {
        guard let email = txtEmailSignIn.text ,let password = txtPasswordSignIn.text else
        {
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            
            if let error = error{
                
                print("Error creating user: \(error.localizedDescription)")
                self.txtEmailSignIn.layer.borderColor = UIColor.red.cgColor
                self.txtPasswordSignIn.layer.borderColor = UIColor.red.cgColor
                
                
            } else {
                
                let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                self.navigationController?.pushViewController(homeVC, animated: true)
                self.txtEmailSignIn.text = ""
                self.txtPasswordSignIn.text = ""
                
            }
        }
        
    }
    
}
//Extension for SignInController-----End


//Extension for SignUp controller----Start
extension SignUpViewController:UITextFieldDelegate
{
    //Add corner Radius to the textField ---- Start
    func cornerRadiusTxtField()
    {
        signUpView.layer.cornerRadius = 30.0
        btnSignUp.layer.cornerRadius = 20.0
        
        
        txtNameSignUp.layer.borderWidth = 1
        txtNameSignUp.layer.cornerRadius = 20
        
        txtEmailSignUp.layer.borderWidth = 1
        txtEmailSignUp.layer.cornerRadius=20
        
        txtBirthDateSignUp.layer.borderWidth = 1
        txtBirthDateSignUp.layer.cornerRadius=20
        
        txtPasswordSignUp.layer.borderWidth = 1
        txtPasswordSignUp.layer.cornerRadius=20
        
        
    }
    //Add corner Radius to the textField ---- End
    
    // Code for  Icon---- Start
    func addIconToTextField(textField: UITextField, iconName: String) {
        let iconImageView = UIImageView(image: UIImage(named: iconName))
        iconImageView.contentMode = .scaleAspectFit
        
        let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: textField.frame.height)) // Adjust the width as needed
        
        iconContainerView.addSubview(iconImageView)
        iconImageView.frame = CGRect(x: 10, y: 0, width: 20, height: textField.frame.height) // Adjust the positioning and size of the icon
        
        textField.leftView = iconContainerView
        textField.leftViewMode = .always
    }
    
    // Code for  Icon---- End
    
    
    //Code for Eye icon for password hide and show ---Start
    func eyeIconTxtField(for textField: UITextField, with iconImageView: UIImageView) {
        let passIcon = iconImageView
        passIcon.image = UIImage(named: "open")
        let contentView = UIView()
        contentView.addSubview(passIcon)
        
        contentView.frame = CGRect(x: 0, y: 0, width: UIImage(named: "close")!.size.width, height: UIImage(named: "close")!.size.height)
        
        passIcon.frame = CGRect(x: -10, y: 0, width: UIImage(named: "close")!.size.width, height: UIImage(named: "close")!.size.height)
        
        textField.rightView = contentView
        textField.rightViewMode = .always
        textField.clearButtonMode = .whileEditing
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        passIcon.isUserInteractionEnabled = true
        passIcon.addGestureRecognizer(tapGesture)
    }
    
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedImageView = sender.view as? UIImageView else { return }
        guard let textField = tappedImageView.superview?.superview as? UITextField else { return }
        
        if iconClick {
            iconClick = false
            tappedImageView.image = UIImage(named: "open")
            textField.isSecureTextEntry = false
        } else {
            iconClick = true
            tappedImageView.image = UIImage(named: "close")
            textField.isSecureTextEntry = true
        }
    }
    //Code for Eye icon for password hide and show ---End
    
    
    //Code for add border color after selecting--Start
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemCyan.cgColor
        
        if textField == txtNameSignUp
        {
            addIconToTextField(textField: txtNameSignUp, iconName: "userfilled")
            
        }
        else if textField == txtEmailSignUp
        {
            addIconToTextField(textField: txtEmailSignUp, iconName: "filledemail")
        }
        else if textField == txtBirthDateSignUp
        {
            addIconToTextField(textField: txtBirthDateSignUp, iconName: "calendarfilled")
        }
        
        else if textField == txtPasswordSignUp
        {
            addIconToTextField(textField: txtPasswordSignUp, iconName: "filledlock")
        }
        
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        
        addIconToTextField(textField: txtNameSignUp, iconName: "user")
        addIconToTextField(textField: txtEmailSignUp, iconName: "email")
        addIconToTextField(textField: txtBirthDateSignUp, iconName: "calendar")
        addIconToTextField(textField: txtPasswordSignUp, iconName: "open-lock")
        
    }
    //Code for add border color after selecting-- End
    
    
    func fireBaseSignUP()
    {
        guard let name = txtNameSignUp.text,let email = txtEmailSignUp.text, let password = txtPasswordSignUp.text, let birthDate = txtBirthDateSignUp.text else {
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
            } else if let user = Auth.auth().currentUser {
                
                
                let signInVC = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
                signInVC.userEmail = email
                self.navigationController?.pushViewController(signInVC, animated: true)
                print("Account created")
            }
        }
    }
    
    
}
//Extension for SignUp controller----End




//Extension for the validation of textfields-----start
extension String
{
    
    var isEmailValid: Bool{
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
        
    }
    
    var isPasswordValid:Bool{
        
        let passwordRegEx = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,12}")
        return passwordRegEx.evaluate(with: self)
    }
    
}
//Extension for the validation of textfields-----end


//Extension for authentication-----start
extension WelcomeViewController:ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding
{
    
    ///Apple sign In code--------Start
    func appleLogin(){
        
        if #available(iOS 13.0, *){
            startSignInWithApple()
        } else {
            print("invalid ios version")
        }
        
        @available(iOS 13.0, *)
        func startSignInWithApple() {
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
        
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization)  {
        
        
        if let appleIdCredential = authorization.credential as? ASAuthorizationAppleIDCredential  {
            
            let userId = appleIdCredential.user
            
            if let identityTokenData = appleIdCredential.identityToken {
                if let identityTokenString = String(data: identityTokenData, encoding: .utf8) {
                    let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: identityTokenString, rawNonce: nil)
                    
                    Auth.auth().signIn(with: credential) { (authResult, error) in
                        if let error = error {
                            print("Error signing in with Apple: \(error.localizedDescription)")
                            return
                        }
                        
                        self.navigateToHomePage()
                        
                        if let user = Auth.auth().currentUser {
                            self.navigateToHomePage()
                        } else {
                            self.navigateToSignUpWithEmail(email: appleIdCredential.email)
                        }
                    }
                } else {
                    print("Error converting identityToken to string-----")
                }
            }
            else {
                print("Error: No identityToken found-----")
            }
        }
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
    
    
    
    func navigateToSignUpWithEmail(email: String?) {
        let signUpViewController = SignUpViewController()
        if let email = email {
            signUpViewController.email = email
        } else {
            signUpViewController.email = "default@example.com"
        }
        
        navigationController?.pushViewController(signUpViewController, animated: true)
    }
    
    func navigateToHomePage() {
        let homeViewController = HomeViewController()
        navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    //Apple sign In code--------End
    
    
}


