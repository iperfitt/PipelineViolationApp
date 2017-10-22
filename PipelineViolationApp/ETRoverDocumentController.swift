//
//  ETRoverDocumentController.swift
//  PipelineViolationApp
//
//  Created by Perfitt, Ian on 9/18/17.
//  Copyright © 2017 Perfitt, Ian. All rights reserved.
//

import UIKit
import MessageUI
import MapKit
import CoreLocation
import Firebase
import FirebaseDatabase

class ETRoverDocumentController: UIViewController, MFMailComposeViewControllerDelegate,
    UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITextViewDelegate, CLLocationManagerDelegate
{
    
    let photo = UIImage(named: "ETRoverViolation.png")
    
    var latitude = 0.0
    
    var longitude = 0.0
    
    @IBOutlet weak var DateOfReport: UITextField!
    
    @IBOutlet weak var Description1: UITextField!
    
    @IBOutlet weak var Description2: UITextField!
    
    @IBOutlet weak var Description3: UITextField!
    
    @IBOutlet weak var Description4: UITextField!
    
    @IBOutlet weak var DateOfObservation: UITextField!
    
    @IBOutlet weak var RelatedEquipment: UITextField!
    
    var attachedPhotos:[UIImage] = []
    
    //Each text field function calls on maxLength
    //with specific lenght limits on entered text
    @IBAction func DateOfReport_textChange(_ sender: UITextField) {
        maxLength(textFieldName: DateOfReport, max: 15)
    }
    
    @IBAction func Description1_textChange(_ sender: UITextField) {
        maxLength(textFieldName: Description1, max: 80)
    }
    
    @IBAction func Description2_textChange(_ sender: UITextField) {
        maxLength(textFieldName: Description2, max: 80)
    }
    
    @IBAction func Description3_textChange(_ sender: UITextField) {
        maxLength(textFieldName: Description3, max: 80)
    }
    
    @IBAction func Description4_textChange(_ sender: UITextField) {
        maxLength(textFieldName: Description4, max: 80)
    }
    
    @IBAction func DateOfObservation_textChange(_ sender: UITextField) {
        maxLength(textFieldName: DateOfObservation, max: 13)
    }
    
    @IBAction func Equipment_textChange(_ sender: UITextField) {
        maxLength(textFieldName: RelatedEquipment, max: 20)
    }
    
    
    //Limits the amount of characters allowed in a text field
    func maxLength(textFieldName: UITextField, max:Int) {
        let length = textFieldName.text?.characters.count
        let metin = textFieldName.text
        if (length! > max) {
            //Returns an index that is the specified distance from the given index.
            let index = metin?.index((metin?.startIndex)!, offsetBy: max)
            //Chops the string to meet maximum length condition
            textFieldName.text = textFieldName.text?.substring(to: index!)
        }
    }
    
    
    func textToImage(drawText: NSString, inImage: UIImage, atPoint: CGPoint) -> UIImage {
        
        //Setup the font specific variables
        let textColor: UIColor = UIColor.black
        let textFont: UIFont = UIFont(name: "Times New Roman", size: 12)!
        
        //Setup the image context using the passed image
        UIGraphicsBeginImageContext(inImage.size)
        
        //Sets up the font attributes that will later be
        //used to dictate how the text should be entered
        let textFontAttributes = [NSFontAttributeName: textFont, NSForegroundColorAttributeName: textColor]
        
        //Put the image into a rectangle as large as the original image.
        inImage.draw(in: CGRect(x:0,y:0, width: inImage.size.width, height: inImage.size.height))
        
        //Creating a point with the space that is as big as the image.
        let rect: CGRect = CGRect(x: atPoint.x, y:atPoint.y, width:inImage.size.width, height: inImage.size.height)
        
        //Draw the text into an image.
        drawText.draw(in: rect, withAttributes: textFontAttributes)
        
        //Create a new image out of the images created
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        //End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    
    @IBAction func SendEmail(_ sender: Any) {
        let mailComposeViewController = configureMailController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        }
        else {
            showMailError()
        }
        self.performSegue(withIdentifier: "PinSegue", sender: self)
    }
    
    func configureMailController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        var finalImage = textToImage(drawText: (DateOfReport.text!) as NSString, inImage: photo!, atPoint: CGPoint(x: 370, y: 58))
        finalImage = textToImage(drawText: (Description1.text!) as NSString, inImage: finalImage, atPoint: CGPoint(x: 50, y: 175))
        finalImage = textToImage(drawText: (Description2.text!) as NSString, inImage: finalImage, atPoint: CGPoint(x: 50, y: 193))
        finalImage = textToImage(drawText: (Description3.text!) as NSString, inImage: finalImage, atPoint: CGPoint(x: 50, y: 210))
        finalImage = textToImage(drawText: (Description4.text!) as NSString, inImage: finalImage, atPoint: CGPoint(x: 50, y: 226))
        finalImage = textToImage(drawText: (DateOfObservation.text!) as NSString, inImage: finalImage, atPoint: CGPoint(x: 225, y: 262))
        finalImage = textToImage(drawText: (RelatedEquipment.text!) as NSString, inImage: finalImage, atPoint: CGPoint(x: 275 , y: 280))
        finalImage = textToImage(drawText: String(round(1000*latitude)/1000) as NSString, inImage: finalImage, atPoint: CGPoint(x: 186, y: 328))
        finalImage = textToImage(drawText: String(round(1000*longitude)/1000) as NSString, inImage: finalImage, atPoint: CGPoint(x: 300, y: 328))
        for pic in attachedPhotos {
            mailComposerVC.addAttachmentData(UIImagePNGRepresentation(pic)!, mimeType: "image/png", fileName: "hello")
        }
        let imageData = UIImagePNGRepresentation(finalImage)
        mailComposerVC.addAttachmentData(imageData!, mimeType: "image/png", fileName: "hello")
        mailComposerVC.setToRecipients(["iperfitt@umich.edu"])
        mailComposerVC.setSubject("Hello")
        mailComposerVC.setMessageBody("How are you doing?", isHTML: false)
        return mailComposerVC
    }
    
    func showMailError() {
        let sendMailErrorAlert = UIAlertController(title: "Could not send email", message: "Your device could not send email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    //IMAGE UPLOAD
    
    @IBAction func importImage(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true) {
            //After it is complete
            }
        }
    
    
    //TAKE A PHOTO FOR ATTACHMENT
    @IBAction func TakePhoto(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .camera
        image.allowsEditing = false
        self.present(image, animated: true) {
            //After it is complete
        }
    }
        func imagePickerController(_ image: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                attachedPhotos.append(image)
            }
            else {
                //Error message
                print("Error occured picking image")
            }
            self.dismiss(animated: true, completion: nil)
        }
    
    //Obtaining location
    let manager = CLLocationManager()
    
    //Called every single time the user changes its position
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.DateOfReport.delegate = self as? UITextFieldDelegate
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //Hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
