//
//  ViewController.swift
//  ProjectX
//
//  Created by Ronald Bowser on 5/2/19.
//  Copyright © 2019 Ronald Bowser. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var colorSegment: UISegmentedControl!
    @IBOutlet var image: UIImageView!
    @IBOutlet var memeButton: UIButton!
    
    var memeImage: UIImage!
    var attrColor = UIColor.red
    var topText = ""
    var bottomText = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "iMeme it"
        
        memeButton.isHidden = true
        memeButton.layer.cornerRadius = 5
        memeButton.layer.borderWidth = 1
        memeButton.layer.borderColor = UIColor.darkGray.cgColor
        
        colorSegment.selectedSegmentIndex = 0
        colorSegment.tintColor = UIColor.lightGray
        colorSegment.setTitleTextAttributes([.foregroundColor: UIColor.red, .font: UIFont.boldSystemFont(ofSize: 18)], for: .selected)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pickPhoto))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(saveMeme))
        
    }
    // MARK: - UISEGMENTED CONTROL
    @IBAction func textColor(_ sender: UISegmentedControl) {
        if let drawingColor = (colorSegment?.selectedSegmentIndex) {
            
            switch drawingColor {
            case 0:
                colorSegment.setTitleTextAttributes([.foregroundColor: UIColor.red, .font: UIFont.boldSystemFont(ofSize: 18)], for: .selected)
                attrColor = UIColor.red
            case 1:
                colorSegment.setTitleTextAttributes([.foregroundColor: UIColor.blue, .font: UIFont.boldSystemFont(ofSize: 18)], for: .selected)
                attrColor = UIColor.blue
            case 2:
                colorSegment.setTitleTextAttributes([.foregroundColor: UIColor.yellow, .font: UIFont.boldSystemFont(ofSize: 18)], for: .selected)
                attrColor = UIColor.yellow
            case 3:
                colorSegment.setTitleTextAttributes([.foregroundColor: UIColor.green, .font: UIFont.boldSystemFont(ofSize: 18)], for: .selected)
                attrColor = UIColor.green
            default:
                print("oh hell")
            }
            createMeme()
        }
        
        
    }
    
    // MARK:- UIIMAGEPICKER
    @objc func pickPhoto() {
        let picker  = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
        
    }
    
    // MARK:- SAVE MEME FUNC
    @objc func saveMeme() {
        if let image = image.image{
            let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
            present(vc, animated: true)
        }
    }
    
    
    // MARK:- IMAGE PICKER
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[.editedImage] as? UIImage else { return }
        
        memeImage = pickedImage
        dismiss(animated: true)
        image.image = pickedImage
        memeButton.isHidden = false
        
    }
    
    // MARK:- CREATE MEME
    func createMeme() {
        
        let rect = CGRect(x: 0, y: 0, width: image.frame.width, height: image.frame.height)
        let renderer = UIGraphicsImageRenderer(bounds: rect)
       
        let ctxImage = renderer.image { ctx in
            
            let imageRect = CGRect(x: 0, y: 0, width: 374, height: 374)
            memeImage?.draw(in: imageRect)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let firstPosition = rect.offsetBy(dx: 0, dy: 0)
            let firstText = topText
            let firstAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 32),
                .foregroundColor: self.attrColor,
                .paragraphStyle: paragraphStyle
            ]
            
            let firstString = NSAttributedString(string: firstText, attributes: firstAttrs)
            firstString.draw(in: firstPosition)
            
            let secondPosition = rect.offsetBy(dx: 0, dy: 300)
            let secondText = bottomText
            let secondAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 32),
                .foregroundColor: self.attrColor,
                .paragraphStyle: paragraphStyle
            ]
            
            let secondString = NSAttributedString(string: secondText, attributes: secondAttrs)
            secondString.draw(in: secondPosition)
        }
           
        image.image = ctxImage
          
    }
    
    // MARK:- ADD MEME TEXT UIALERT CONTROLLER
    @IBAction func addMemeText(_ sender: Any) {
        
        let ac = UIAlertController(title: "Add Meme Text", message: nil, preferredStyle: .alert)
        
        ac.addTextField(configurationHandler: { (textField : UITextField!) -> Void in
            textField.placeholder = "Add First Line"
        })
        
        ac.addTextField(configurationHandler: { (textField : UITextField!) -> Void in
            textField.placeholder = "Add Second Line"
        })
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { [unowned self, ac] _ in
            let firstLine = ac.textFields![0]
            let secondline = ac.textFields![1]
            
            self.topText = firstLine.text!
            self.bottomText = secondline.text!
            
            self.createMeme()
        })
        
        let cancelation = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action: UIAlertAction!) -> Void in }
        )
        
        ac.addAction(saveAction)
        ac.addAction(cancelation)
        
        present(ac, animated: true)
        
        
        
    }
    
}

