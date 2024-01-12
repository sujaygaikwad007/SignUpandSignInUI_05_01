import UIKit
import Firebase
import FirebaseCore
import FirebaseAuth
import FBSDKLoginKit
import AuthenticationServices
import GoogleSignIn


var iconClick = false


//Function for aleart
func showToast(controller:UIViewController ,message:String,seconds:Double)
{
    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    alert.view.alpha = 0.6
    alert.view.layer.cornerRadius = 15
    let CancelBtn = UIAlertAction(title: "Close", style: .destructive)
    alert.addAction(CancelBtn)
    
    controller.present(alert, animated: true, completion: nil)
    
    DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + seconds)
    {
        alert.dismiss(animated: true)
    }
}

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
    
    
    func validatation(){
        
        let email = txtEmailSignIn.text
        let password = txtPasswordSignIn.text
        
        if txtEmailSignIn.text!.isEmpty
        {
            showToast(controller: self, message: "Please Enter Email", seconds: 2)
            txtEmailSignIn.layer.borderColor = UIColor.red.cgColor
        }
        else if txtPasswordSignIn.text!.isEmpty
        {
            showToast(controller: self, message: "Please Enter Password", seconds: 2)
            txtPasswordSignIn.layer.borderColor = UIColor.red.cgColor
        }
        else{
            signInUser()
        }
    }
    
    
    //Sign-in using firebase
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
                showToast(controller: self, message: "Account does not exists", seconds: 2.0)
                
                
            } else {
                
                let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                self.navigationController?.pushViewController(homeVC, animated: true)
                self.txtEmailSignIn.text = ""
                self.txtPasswordSignIn.text = ""
                
            }
        }
        
    }
    
    //Sign-in using firebase
    
    
}
//Extension for SignInController-----End


//Extension for SignUp controller----Start
extension SignUpViewController:UITextFieldDelegate
{
    
    func validation()
    {
        let name = txtNameSignUp.text
        let email = txtEmailSignUp.text
        let birthDate = txtBirthDateSignUp.text
        let password = txtPasswordSignUp.text
        
        
        if txtNameSignUp.text!.isEmpty
        {
            showToast(controller: self, message: "Please Enter a Name", seconds: 2)
            txtNameSignUp.layer.borderColor = UIColor.red.cgColor
            
        }
        else if txtEmailSignUp.text!.isEmpty
        {
            showToast(controller: self, message: "Please Enter Email", seconds: 2)
            txtEmailSignUp.layer.borderColor = UIColor.red.cgColor
        }
        else if !(txtEmailSignUp.text?.isEmailValid)!
        {
            showToast(controller: self, message: "Please Enter a valid email", seconds: 2)
            txtEmailSignUp.layer.borderColor = UIColor.red.cgColor
        }
        else if txtBirthDateSignUp.text!.isEmpty
        {
            showToast(controller: self, message: "BirthDate field should not be empty", seconds: 2)
            txtBirthDateSignUp.layer.borderColor = UIColor.red.cgColor
            
        }
        else if txtPasswordSignUp.text!.isEmpty
        {
            showToast(controller: self, message: "Password field should not be empty", seconds: 2)
            txtPasswordSignUp.layer.borderColor = UIColor.red.cgColor
            
            
        }
        else if !(txtPasswordSignUp.text?.isPasswordValid)!
        {
            showToast(controller: self, message: "Please Enter a valid password", seconds: 2)
            txtPasswordSignUp.layer.borderColor = UIColor.red.cgColor
        }
        
        else
        {
            showToast(controller: self, message: "Account Created Successfully", seconds: 1.0)
            fireBaseSignUP()
        }
    }
    
    
    
    
    
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
            }
            else if let user = Auth.auth().currentUser {
                
                self.uploadProfilePicture()
                
                let signInVC = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
                signInVC.userEmail = email
                self.navigationController?.pushViewController(signInVC, animated: true)
                
            }
        }
    }
    
    //Extension for SignUp controller----End
    
}


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
        
        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                let userIdentifier = appleIDCredential.user
                let fullName = appleIDCredential.fullName
                let email = appleIDCredential.email
                
                print("User ID: \(userIdentifier)")
                print("Full Name: \(fullName?.givenName ?? "") \(fullName?.familyName ?? "")")
                print("Email: \(email ?? "")")
                
                navigateToHomePage()
                
            }
        }
        
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
    
    
    
    
    //Apple sign In code--------End
    
    
    
    //Google sign-in code--start
    
    func googleSignIn(){
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                return
                
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            print("googleSignInBtn--- \(credential)")
            navigateToHomePage()
            
        }
    }
    
    //Google sign-in code--end
    
    
    // facebook code-- start
    func facebookSignIn(){
        
        LoginManager().logIn(permissions: ["public_profile"], from: self) { result, error in
            if let error = error {
                print("Facebook login error: \(error.localizedDescription)")
                return
            }
            
            guard let result = result, !result.isCancelled else {
                print("Facebook login cancelled")
                return
            }
            
            let token = result.token?.tokenString
            
            let request = GraphRequest(graphPath: "me", parameters: ["fields": "id,email,first_name,last_name,picture,short_name,name,middle_name,name_format,age_range"], tokenString: token, version: nil, httpMethod: .get)
            request.start { connection, result, error in
                print("Result: \(result)")
                if let error = error {
                    print("Graph request error: \(error.localizedDescription)")
                    return
                }
                
                if let userData = result as? [String: Any] {
                    let email = userData["email"] as? String ?? ""
                    let name = userData["name"] as? String ?? ""
                    
                    print("Facebook User Data:")
                    print("Email: \(email)")
                    print("Name: \(name)")
                    
                    self.navigateToHomePage()
                    
                    
                }
            }
        }
        
        
    }
    
    
    
    // facebook code-- end
    
    
    //    navigate to home and sign-up--start
    func navigateToSignUpWithEmail(email: String?) {
        let signUpViewController = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        navigationController?.pushViewController(signUpViewController, animated: true)
    }
    
    func navigateToHomePage() {
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        navigationController?.pushViewController(homeViewController, animated: true)
    }
    //    navigate to home and sign-up--end
    
}
//Extension for authentication-----end


// extension for reset password--start
extension ForgetPasswordViewController: UITextFieldDelegate{
    
    // Code for  Icon---- Start
    func addIconToTextField(textField: UITextField, iconName: String) {
        let iconImageView = UIImageView(image: UIImage(named: iconName))
        iconImageView.contentMode = .scaleAspectFit
        
        let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: textField.frame.height)) // Adjust the width as needed
        
        iconContainerView.addSubview(iconImageView)
        iconImageView.frame = CGRect(x: 10, y: 0, width: 20, height: textField.frame.height) // Adjust the
        textField.leftView = iconContainerView
        textField.leftViewMode = .always
    }
    
    // Code for  Icon---- End
    
    
    
    //Code for add border color after selecting--Start
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemCyan.cgColor
        
        if textField == txtForgetEmail
        {
            addIconToTextField(textField: txtForgetEmail, iconName: "filledemail")
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        
        addIconToTextField(textField: txtForgetEmail, iconName: "email")
        
    }
    //Code for add border color after selecting-- End
    
    
    // function to reset password
    func resetPassword(email: String){
        Auth.auth().sendPasswordReset(withEmail: email){ error in
            if let error = error {
                print("Password reset failed: \(error.localizedDescription)")
            }
            else {
                print("Password reset email sent successfully.")
                self.txtForgetEmail.text = ""
                let emailVC = self.storyboard?.instantiateViewController(withIdentifier: "EmailVerifyViewController") as! EmailVerifyViewController
                self.navigationController?.pushViewController(emailVC, animated: true)
                
            }
        }
    }
    
}
// extension for reset password--end


//Extension for the Edit profile----Start
extension UpdateProfileViewController : UITextFieldDelegate
{
    
    
    func validation(){
        let email = txtUpdateEmail.text
        let password = txtUpdatePassword.text
        let confirmPassword = txtUpdateConfPassword.text
        
        
        if txtUpdateEmail.text!.isEmpty
        {
            showToast(controller: self, message: "Please Enter Email", seconds: 2)
            txtUpdateEmail.layer.borderColor = UIColor.red.cgColor
        }
        else if !(txtUpdateEmail.text?.isEmailValid)!
        {
            showToast(controller: self, message: "Please Enter a valid email", seconds: 2)
            txtUpdateEmail.layer.borderColor = UIColor.red.cgColor
        }
        else if txtUpdatePassword.text!.isEmpty
        {
            showToast(controller: self, message: "Please Enter Password", seconds: 2)
            txtUpdatePassword.layer.borderColor = UIColor.red.cgColor
        }
        else if !(txtUpdatePassword.text?.isPasswordValid)!
        {
            showToast(controller: self, message: "Please Enter a valid password", seconds: 2)
            txtUpdatePassword.layer.borderColor = UIColor.red.cgColor
        }
        else if txtUpdateConfPassword.text!.isEmpty
        {
            showToast(controller: self, message: "Please Enter Password", seconds: 2)
            txtUpdateConfPassword.layer.borderColor = UIColor.red.cgColor
        }
        else if !(txtUpdateConfPassword.text?.isPasswordValid)!
        {
            showToast(controller: self, message: "Please Enter a valid password", seconds: 2)
            txtUpdateConfPassword.layer.borderColor = UIColor.red.cgColor
        }
        else if txtUpdatePassword.text != txtUpdateConfPassword.text
        {
            showToast(controller: self, message: "Passwords do not match", seconds: 2)
            txtUpdateConfPassword.layer.borderColor = UIColor.red.cgColor
        }
        else{
            
            updateProfile()
            uploadProfilePicture()
            let delay = 4.0
            
            DispatchQueue.main.asyncAfter(deadline:.now() + delay ){
                let signVC = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
            self.navigationController?.pushViewController(signVC, animated: true)
            }
            
        }
        
    }
    
    //Update user profile---start
    func updateProfile()
    {
        guard
            let email = txtUpdateEmail.text,
            let password = txtUpdatePassword.text,
            let confirmPassword = txtUpdateConfPassword.text else
            {
                return
            }
        
        
        if let user = Auth.auth().currentUser {
            
            
            user.sendEmailVerification(beforeUpdatingEmail: email) { error in
                
                if let emailError = error {
                    print("error while sending verification email \(error?.localizedDescription ?? " ")")
                    
                } else {
                    print("Email updated successfully to \(email)")
                    showToast(controller: self, message: "Please check our email for validation", seconds: 1.0)
                    user.updatePassword(to: confirmPassword) { error in
                        if let  error = error
                        {
                            print("Error while updating password\(error.localizedDescription)")
                        }
                
                        else
                        {
                            print("Password Update success-----\(confirmPassword)")
                            showToast(controller: self, message: "Password update Successfully ", seconds:2.0 )
                        }
                    }
                }
                
            }
            
            
        }
        
        
    }
    
    
    //Update user profile---end
    
    
    //Add corner Radius to the textField ---- Start
    func cornerRadiusTxtField()
    {
        btnUpdate.layer.cornerRadius = 20.0
        
        
        
        
        txtUpdateEmail.layer.borderWidth = 1
        txtUpdateEmail.layer.cornerRadius=20
        
        txtUpdatePassword.layer.borderWidth = 1
        txtUpdatePassword.layer.cornerRadius=20
        
        txtUpdateConfPassword.layer.borderWidth = 1
        txtUpdateConfPassword.layer.cornerRadius=20
        
        
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
        
        if textField == txtUpdateEmail
        {
            addIconToTextField(textField: txtUpdateEmail, iconName: "filledemail")
        }
        else if textField == txtUpdatePassword
        {
            addIconToTextField(textField: txtUpdatePassword, iconName: "filledlock")
        }
        
        else if textField == txtUpdateConfPassword
        {
            addIconToTextField(textField: txtUpdateConfPassword, iconName: "filledlock")
        }
        
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        
        addIconToTextField(textField: txtUpdateEmail, iconName: "email")
        addIconToTextField(textField: txtUpdatePassword, iconName: "open-lock")
        addIconToTextField(textField: txtUpdateConfPassword, iconName: "open-lock")
        
    }
    //Code for add border color after selecting-- End
    
}



//Extension for the Edit profile----End


