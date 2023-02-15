//
//  PostUploadController.swift
//  Nanameue Mini App
//
//  Created by Shahid on 2023-02-15.
//

import Foundation
import UIKit
import YPImagePicker

class PostUploadController: UIViewController, UIPickerViewDelegate {
    
    //MARK: - Properties
    
    private var postImage: UIImage? {
        didSet {
            selectedPicture.image = postImage
            if (postImage != nil) {
                removeImageBtn.isHidden = false
            }
        }
    }
    
    private let cancelBtn: UIButton =  {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(cancelSheetBtnPressed), for: .touchUpInside)
        return button
    }()
    
    private let postBtn: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(named: "sub_color")
        button.isEnabled = false
        button.setTitle("Post", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.layer.cornerRadius = 15
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(postBtnPressed), for: .touchUpInside)
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "profile")
        return imageView
    }()
    
    private lazy var postTextField: UITextView = {
        let textField = MultiLineInputTextView()
        textField.placeHolderText = "What's happening?"
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.delegate = self
        return textField
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Public post"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(named: "sub_color")
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private let textLengthCount: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray2
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "0/250"
        return label
    }()
    
    private let addPicBtn : UIButton =  {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "add_picture_icon"), for: .normal)
        button.tintColor = UIColor.white
        button.backgroundColor = UIColor(named: "main_color")
        button.addTarget(self, action: #selector(addPictureBtnPressed), for: .touchUpInside)
        return button
    }()
    
    private let removeImageBtn : UIButton =  {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(removeImage), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private let selectedPicture: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(cancelBtn)
        cancelBtn.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingLeft: 12)
        
        view.addSubview(postBtn)
        postBtn.setDimensions(height: 30, width: 75)
        postBtn.centerY(inView: cancelBtn)
        postBtn.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingRight: 12)
        
        view.addSubview(profileImageView)
        profileImageView.anchor(top: cancelBtn.bottomAnchor, left: view.leftAnchor,
                                paddingTop: 12, paddingLeft: 12)
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        
        view.addSubview(nameLabel)
        nameLabel.centerY(inView: profileImageView)
        nameLabel.anchor(left: profileImageView.rightAnchor, paddingLeft: 12)
        
        view.addSubview(postTextField)
        postTextField.setDimensions(height: 200, width: view.frame.width)
        postTextField.anchor(top: profileImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 52, paddingRight: 8)
        postTextField.delegate = self
        
        view.addSubview(selectedPicture)
        selectedPicture.layer.cornerRadius = 15
        selectedPicture.anchor(top: postTextField.bottomAnchor,
                               left: view.leftAnchor,
                               paddingTop: 12,
                               paddingLeft: 52,
                               width: view.layer.frame.width / 3,
                               height: 200)
        
        view.addSubview(textLengthCount)
        textLengthCount.anchor(top: selectedPicture.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingRight: 12)
        
        view.addSubview(addPicBtn)
        addPicBtn.setDimensions(height: 50, width: 50)
        addPicBtn.layer.cornerRadius = 25
        addPicBtn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        addPicBtn.anchor(top: selectedPicture.bottomAnchor, left: view.leftAnchor, paddingTop: 12, paddingLeft: 12)
        
        view.addSubview(removeImageBtn)
        removeImageBtn.setDimensions(height: 25, width: 25)
        removeImageBtn.contentEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        removeImageBtn.anchor(top: selectedPicture.topAnchor, right: selectedPicture.rightAnchor, paddingTop: 5, paddingRight: 5)
    }
    
    //MARK: - Helper functions
    func checkTextViewLength(_ textView: UITextView, maxLength: Int){
        if (textView.text.count > maxLength){
            textView.deleteBackward()
        }
    }
    
    func addImageRemoveBtn() {
        
    }
    
    func finishedPickingThePhoto(_ picker: YPImagePicker){
        picker.didFinishPicking { items, cancelled in
            picker.dismiss(animated: true) {
                guard let image = items.singlePhoto?.image else {return}
                self.postImage = image
            }
        }
    }
    
    //MARK: - actions
    
    @objc func cancelSheetBtnPressed() {
        self.dismiss(animated: true)
    }
    
    @objc func postBtnPressed() {
        
    }
    
    @objc func addPictureBtnPressed() {
        var imagePickerConfig = YPImagePickerConfiguration()
        imagePickerConfig.library.mediaType = .photo
        imagePickerConfig.library.maxNumberOfItems = 1
        imagePickerConfig.startOnScreen = .library
        imagePickerConfig.shouldSaveNewPicturesToAlbum = false
        imagePickerConfig.hidesBottomBar = false
        imagePickerConfig.screens = [.library]
        imagePickerConfig.hidesBottomBar = false
        
        let imagePicker = YPImagePicker(configuration: imagePickerConfig)
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true)
        
        finishedPickingThePhoto(imagePicker)
        
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        
        present(picker, animated: true)
    }
    
    @objc func removeImage() {
        removeImageBtn.isHidden = true
        postImage = nil
    }
}

// MARK: - UITextFieldDelegate

extension PostUploadController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkTextViewLength(textView, maxLength: 200)
        textLengthCount.text = "\(textView.text.count)/200"
        
        if (textView.text.count > 0){
            postBtn.backgroundColor = UIColor(named: "main_color")
            postBtn.isEnabled = true
        } else {
            postBtn.backgroundColor = UIColor(named: "sub_color")
            postBtn.isEnabled = false
        }
    }
}
