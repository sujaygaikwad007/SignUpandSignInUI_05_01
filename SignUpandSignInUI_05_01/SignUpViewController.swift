import UIKit

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var signUpView: UIView!
    @IBOutlet weak var signUpScrollView: UIScrollView!
    @IBOutlet weak var txtNameSignUp: UITextField!
    @IBOutlet weak var txtEmailSignUp: UITextField!
    @IBOutlet weak var txtBirthDateSignUp: UITextField!
    @IBOutlet weak var txtPasswordSignUp: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    
     var email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtNameSignUp.delegate = self
        txtEmailSignUp.delegate = self
        txtBirthDateSignUp.delegate = self
        txtPasswordSignUp.delegate = self

        
        hideKeyboardTappedAround()
        setupBackButton()
        scrollViewEnbleDisable()
        cornerRadiusTxtField()
        addIconToTextField(textField: txtNameSignUp, iconName: "user")
        addIconToTextField(textField: txtEmailSignUp, iconName: "email")
        addIconToTextField(textField: txtBirthDateSignUp, iconName: "calendar")
        addIconToTextField(textField: txtPasswordSignUp, iconName: "open-lock")

        eyeIconTxtField(for: txtPasswordSignUp, with: UIImageView())
        
        setupDatePicker(for: txtBirthDateSignUp)

        
        txtEmailSignUp.text = email
        
        
        
    }
    
    
    
    @IBAction func btnSignUpTapped(_ sender: Any) {
        fireBaseSignUP()

    }
    
    
    
    
    //Enble and Disable ScrollView
    func scrollViewEnbleDisable()
    {
        if UIDevice.current.hasNotch {
            
            signUpScrollView.isScrollEnabled = false
        }
        else
        {
            signUpScrollView.isScrollEnabled = true
            
        }
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
        
        let signInVC = storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        self.navigationController?.pushViewController(signInVC, animated: true)
    }
    //Custom Back button ------- Stop
    
    
    //Date Picker---Start
    
    func setupDatePicker(for textField: UITextField) {
            let datePicker = UIDatePicker()

            datePicker.datePickerMode = .date

            textField.inputView = datePicker

            datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        }

        @objc func datePickerValueChanged() {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            txtBirthDateSignUp.text = dateFormatter.string(from: (txtBirthDateSignUp.inputView as! UIDatePicker).date)
        }
    
    
    
     //Date picker---End
    
    
    
    
}
