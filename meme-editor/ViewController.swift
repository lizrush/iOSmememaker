//
//  ViewController.swift
//  meme-editor
//
//  Created by liz on 9/4/17.
//  Copyright © 2017 liz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {

  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var cameraButton: UIBarButtonItem!
  @IBOutlet weak var topText: UITextField!
  @IBOutlet weak var bottomText: UITextField!
  @IBOutlet weak var toolbar: UIToolbar!
  @IBOutlet weak var navBar: UINavigationBar!

  struct Meme {
    var topTextField: String?
    var bottomTextField: String?
    var originalImage: UIImage?
    let memedImage: UIImage!
  }

  static let textAttributes:[String:Any] = [
    NSStrokeColorAttributeName: UIColor.black,
    NSForegroundColorAttributeName: UIColor.white,
    NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
    NSStrokeWidthAttributeName: -3.0
  ]

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    subscribeToKeyboardNotifications()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    unsubscribeFromKeyboardNotifications()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
    view.addGestureRecognizer(tap)

    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(clear))

    imageView.contentMode = .scaleAspectFit
    for textField in [topText, bottomText] as! [UITextField] {
      setTextAttributes(textField)
    }
  }

// MARK: Text attributes & delgates
  func setTextAttributes(_ textField: UITextField) {
    textField.defaultTextAttributes = ViewController.textAttributes
    textField.autocapitalizationType = .allCharacters
    textField.autocorrectionType = .no
    textField.textAlignment = .center
    textField.delegate = self
  }

  func textFieldDidBeginEditing(_ textField: UITextField) {
    if !textField.text!.isEmpty {
      textField.text = nil
    }
  }

  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }

  func dismissKeyboard() {
    view.endEditing(true)
  }

// MARK: ImagePickerControllers & delegate methods
  @IBAction func pickImage(_ sender: Any) {
    instantiateImagePickerController(UIImagePickerControllerSourceType .photoLibrary)
  }

  @IBAction func openCamera(_ sender: Any) {
    instantiateImagePickerController(UIImagePickerControllerSourceType .camera)
  }

  func instantiateImagePickerController(_ sourceType:UIImagePickerControllerSourceType){
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = sourceType
    present(imagePicker, animated: true, completion: nil)
  }

  func imagePickerController(_ picker:UIImagePickerController, didFinishPickingMediaWithInfo info: [String:Any]) {

    if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
      imageView.image = image
    }

    picker.dismiss(animated: true, completion: nil)
  }

  func imagePickerControllerDidCancel(_ picker:UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }

  // MARK: Save & share meme

  func share() {
    let memedImage = generateMemedImage()
    let activityView = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
    activityView.completionWithItemsHandler = { activity, success, items, error in
      if success {
        self.save(image: memedImage)
      } else {
        NSLog("There was an error saving/sharing meme: \(String(describing: error))" )
      }
    }

    present(activityView, animated: true, completion: nil)
  }

  func save(image: UIImage) {
    let meme = Meme(topTextField: topText.text, bottomTextField: bottomText.text, originalImage: imageView.image, memedImage: image)
  }

  func generateMemedImage() -> UIImage {
    toolbar.isHidden = true
    navBar.isHidden = true

    UIGraphicsBeginImageContext(self.view.frame.size)
    view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
    let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()

    toolbar.isHidden = false
    navBar.isHidden = false
    return memedImage
  }

  func clear() {
    imageView.image = nil
    topText.text = "TOP"
    bottomText.text = "BOTTOM"
  }

// MARK: Keyboard subscriptions & height management
  func subscribeToKeyboardNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)

    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }

  func unsubscribeFromKeyboardNotifications() {
    NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
  }

  func keyboardWillShow(_ notification:Notification) {
    if bottomText.isFirstResponder {
      view.frame.origin.y = 0 - getKeyboardHeight(notification)
    }
  }

  func keyboardWillHide(_ notification:Notification) {
    if bottomText.isFirstResponder {
      view.frame.origin.y += getKeyboardHeight(notification)
    }
  }

  func getKeyboardHeight(_ notification:Notification) -> CGFloat {
    let userInfo = notification.userInfo
    let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
    return keyboardSize.cgRectValue.height
  }
}

