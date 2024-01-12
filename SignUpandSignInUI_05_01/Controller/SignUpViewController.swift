import UIKit
import FirebaseDatabase
import FirebaseAuth


class SignUpViewController: UIViewController,UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    @IBOutlet weak var signUpView: UIView!
    @IBOutlet weak var signUpScrollView: UIScrollView!
    @IBOutlet weak var txtNameSignUp: UITextField!
    @IBOutlet weak var txtEmailSignUp: UITextField!
    @IBOutlet weak var txtBirthDateSignUp: UITextField!
    @IBOutlet weak var txtPasswordSignUp: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    var databaseRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtNameSignUp.delegate = self
        txtEmailSignUp.delegate = self
        txtBirthDateSignUp.delegate = self
        txtPasswordSignUp.delegate = self
        imagePicker.delegate = self

        
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
        
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.addGestureRecognizer(tapGesture)
        profileImageView.isUserInteractionEnabled = true

        databaseRef = Database.database().reference()
        
    }
    
    
    //Profile Picture--- start
    
    @objc func profileImageTapped() {
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
    
    
    }
    
    
    func uploadProfilePicture() {
            guard let user = Auth.auth().currentUser else {
                return
            }

            if let imageData = profileImageView.image?.jpegData(compressionQuality: 0.5) {
                // Convert image data to base64-encoded string
                let base64ImageString = imageData.base64EncodedString()
                // Save the base64 encoded image string directly to the Realtime Database
                self.databaseRef.child("users").child(user.uid).child("profilePicture").setValue(base64ImageString)
            }
        }

    
    
    @IBAction func btnSignUpTapped(_ sender: Any) {
        validation()

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
    
    
    
    // UIImagePickerControllerDelegate methods for image selection
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                profileImageView.contentMode = .scaleAspectFit
                profileImageView.image = pickedImage
            }

            dismiss(animated: true, completion: nil)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
    
}
