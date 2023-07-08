//
//  StartScreenViewController.swift
//  PlaneGame
//
//  Created by Сергей Киров on 04.07.2023.
//

import UIKit

private extension CGFloat {
    static let photoSide = 100.0
    static let spacer = 50.0
    static let fieldsWidth = 300.0
    static let cornerRadius = 5.0
    static let defaultGameSpeed = 0.005
}

class SettingsScreenViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    private let saveManager = SaveManager()
    var player: Player?
    private var gameSpeed: Double = .mediumGameSpeed
    private var userPhotoView: UIImageView?
    private var userrNameLabel: UILabel?
    private var userNameTextField: UITextField?
    private var planePicker: PlanePicker?
    private var difficultySegmentedControl: UISegmentedControl?
    private var imagePicker: UIImagePickerController?
    private var saveButton: UIButton?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        setupInterface()
        setupPlayerSettingsIfNeeded()
    }
    
    @IBAction func imageViewTapped(_ sender: UIButton) {
        guard let imagePicker = imagePicker else { return }
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func difficultyChanged() {
        guard let difficultySegmentedControl = difficultySegmentedControl else { return }
        switch difficultySegmentedControl.selectedSegmentIndex {
        case 0:
            gameSpeed = .mediumGameSpeed
        case 1:
            gameSpeed = .hardGameSpeed
        case 2:
            gameSpeed = .infernoGameSpeed
        default:
            break
        }
    }
    
    @IBAction func userNameTextFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            if let userrNameLabel = userrNameLabel {
                userrNameLabel.text = text
            }
        }
    }
    
    @IBAction func saveButtonIsPressed() {
        setupPlayer()
        dismiss(animated: true)
    }
    
    private func setupPlayer() {
        guard let userPhotoView = userPhotoView?.image else { return }
        guard let planeImage = planePicker?.imageView?.image else { return }
        guard let photo = saveManager.savePlayerPhoto(image: userPhotoView) else { return }
        guard let name = userrNameLabel?.text else { return }
        guard let plane = saveManager.savePlaneImage(image: planeImage) else { return }
        player = Player(photo: photo, name: name, plane: plane, gameSpeed: gameSpeed)
        print(player?.points)

        if let player = player {
            saveManager.savePlayer(player: player)
        }
    }
    
    private func setupInterface() {
        
        let center = view.frame.width / 2
        
        userPhotoView = UIImageView(frame:
                                        CGRect(
                                            x: 0,
                                            y: view.frame.minY + .photoSide,
                                            width: .photoSide,
                                            height: .photoSide))
        guard let userPhotoView = userPhotoView else { return }
        userPhotoView.image = UIImage(named: "Mountains")
        userPhotoView.center.x = center
        userPhotoView.layer.cornerRadius = .cornerRadius
        userPhotoView.clipsToBounds = true
        view.addSubview(userPhotoView)
        
        imagePicker = UIImagePickerController()
        guard let imagePicker = imagePicker else { return }
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        userPhotoView.addGestureRecognizer(tapGesture)
        userPhotoView.isUserInteractionEnabled = true
        
        userrNameLabel = UILabel(
            frame:
                CGRect(
                    x: 0,
                    y: userPhotoView.frame.maxY + .spacer,
                    width: .fieldsWidth,
                    height: .spacer))
        guard let userrNameLabel = userrNameLabel else { return }
        userrNameLabel.text = "Player 1"
        userrNameLabel.backgroundColor = .white
        userrNameLabel.center.x = center
        userrNameLabel.layer.cornerRadius = .cornerRadius
        userrNameLabel.clipsToBounds = true
        userrNameLabel.textAlignment = .center
        view.addSubview(userrNameLabel)
        
        userNameTextField = UITextField(
            frame:
                CGRect(
                    x: 0,
                    y: userrNameLabel.frame.maxY + .spacer,
                    width: .fieldsWidth,
                    height: .spacer))
        guard let userNameTextField = userNameTextField else { return }
        userNameTextField.borderStyle = .roundedRect
        userNameTextField.backgroundColor = .white
        userNameTextField.center.x = center
        userNameTextField.placeholder = "Enter your name"
        userNameTextField.addTarget(self, action: #selector(userNameTextFieldDidChange(_:)), for: .editingChanged)
        userNameTextField.delegate = self
        view.addSubview(userNameTextField)
        
        planePicker = PlanePicker(
            frame:
                CGRect(
                    x: 0,
                    y: userNameTextField.frame.maxY + .spacer,
                    width: .photoSide,
                    height: .photoSide))
        guard let planePicker = planePicker else { return }
        planePicker.center.x = center
        view.addSubview(planePicker)
        
        let planeLabel = UILabel(
            frame: CGRect (
                x: 0,
                y: planePicker.frame.maxY,
                width: .fieldsWidth,
                height: .spacer))
        planeLabel.center.x = center
        planeLabel.text = "Swipe for choose airplane"
        planeLabel.textAlignment = .center
        view.addSubview(planeLabel)
        
        difficultySegmentedControl = UISegmentedControl(items: ["Medium", "Hard", "Inferno"])
        guard let difficultySegmentedControl = difficultySegmentedControl else { return }
        difficultySegmentedControl.frame = CGRect(
            x: 0,
            y: planeLabel.frame.maxY + .spacer,
            width: .fieldsWidth,
            height: .spacer)
        difficultySegmentedControl.selectedSegmentIndex = 0
            difficultySegmentedControl.center.x = center
        difficultySegmentedControl.addTarget(self, action: #selector(difficultyChanged), for: .valueChanged)
        view.addSubview(difficultySegmentedControl)
        
        let difficultyLabel = UILabel(
            frame: CGRect(
                x: 0,
                y: difficultySegmentedControl.frame.maxY,
                width: .fieldsWidth,
                height: .spacer))
        difficultyLabel.text = "Choose difficulty"
        difficultyLabel.center.x = center
        difficultyLabel.textAlignment = .center
        view.addSubview(difficultyLabel)
        
        saveButton = UIButton()
        if let saveButton = saveButton {
            saveButton.frame = CGRect(
                x: 0,
                y: difficultyLabel.frame.maxY ,
                width: .fieldsWidth,
                height: .spacer)
            saveButton.setTitle("Save", for: .normal)
            saveButton.setTitleColor(.black, for: .normal)
            saveButton.backgroundColor = .green
            saveButton.center.x = view.frame.width / 2
            saveButton.layer.cornerRadius = .cornerRadius
            saveButton.addTarget(self, action: #selector(saveButtonIsPressed), for: .touchUpInside)
            view.addSubview(saveButton)
        }

    }
    
    private func setupPlayerSettingsIfNeeded() {
        guard let planePicker = planePicker else { return }
        guard let userrNameLabel = userrNameLabel else { return }
        guard let userPhotoView = userPhotoView else { return }

        if let player = saveManager.loadPlayer() {
            userPhotoView.image = saveManager.loadImage(fileName: player.photo)
            planePicker.updateImage(image: saveManager.loadImage(fileName: player.plane))
            userrNameLabel.text = player.name
            switch player.gameSpeed {
            case .hardGameSpeed:
                difficultySegmentedControl?.selectedSegmentIndex = 1
            case .infernoGameSpeed:
                difficultySegmentedControl?.selectedSegmentIndex = 2
            default:
                difficultySegmentedControl?.selectedSegmentIndex = 0
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        guard let userPhotoView = userPhotoView else { return }
        if let selectedImage = info[.originalImage] as? UIImage {
            userPhotoView.image = selectedImage
        }
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            if let userrNameLabel = userrNameLabel {
                userrNameLabel.text = text
            }
        }
        textField.text = ""
        textField.resignFirstResponder()
        return true
    }
    
}
