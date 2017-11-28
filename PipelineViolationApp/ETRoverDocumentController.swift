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
    
    //Calls maxLength func on each text field on report document
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
        //Length of input text
        let length = textFieldName.text?.count
        //Input text
        let inText = textFieldName.text
        if (length! > max) {
            //Returns index that is the specified distance from the given index.
            let index = inText?.index((inText?.startIndex)!, offsetBy: max)
            //Chops string to meet maximum length condition
            textFieldName.text = textFieldName.text?.substring(to: index!)
        }
    }
    
    //Draws users text to the report document at specific
    //points on document and returns the new image
    func textToImage(drawText: NSString, inImage: UIImage, atPoint: CGPoint) -> UIImage {
        
        //Declare specific font variables
        let textColor: UIColor = UIColor.black
        let textFont: UIFont = UIFont(name: "Times New Roman", size: 12)!
        
        //Create the context of the passed image
        UIGraphicsBeginImageContext(inImage.size)
        
        //Set up the font attributes that will later be
        //used to determine how the text should be entered
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
    
    //For each text field, write the text onto the report doc and return final image
    func produceFinalImage() -> UIImage {
        var finalImage = textToImage(drawText: (DateOfReport.text!) as NSString, inImage: photo!, atPoint: CGPoint(x: 370, y: 58))
        finalImage = textToImage(drawText: (Description1.text!) as NSString, inImage: finalImage, atPoint: CGPoint(x: 50, y: 175))
        finalImage = textToImage(drawText: (Description2.text!) as NSString, inImage: finalImage, atPoint: CGPoint(x: 50, y: 193))
        finalImage = textToImage(drawText: (Description3.text!) as NSString, inImage: finalImage, atPoint: CGPoint(x: 50, y: 210))
        finalImage = textToImage(drawText: (Description4.text!) as NSString, inImage: finalImage, atPoint: CGPoint(x: 50, y: 226))
        finalImage = textToImage(drawText: (DateOfObservation.text!) as NSString, inImage: finalImage, atPoint: CGPoint(x: 225, y: 262))
        finalImage = textToImage(drawText: (RelatedEquipment.text!) as NSString, inImage: finalImage, atPoint: CGPoint(x: 275 , y: 280))
        finalImage = textToImage(drawText: String(round(1000*latitude)/1000) as NSString, inImage: finalImage, atPoint: CGPoint(x: 186, y: 328))
        finalImage = textToImage(drawText: String(round(1000*longitude)/1000) as NSString, inImage: finalImage, atPoint: CGPoint(x: 300, y: 328))
        return finalImage
    }
    
    
    //Configures mail controller and displays mail view controller
    @IBAction func SendEmail(_ sender: Any) {
        let mailComposeViewController = configureMailController()
        //check if current device is able to send email
        if MFMailComposeViewController.canSendMail() {
            //Display mail view controller
            self.present(mailComposeViewController, animated: true, completion: nil)
        }
        else {
            //Display error
            showMailError()
        }
        //After E-mail is sent, Direct user to create a Pin
        self.performSegue(withIdentifier: "PinSegue", sender: self)
    }
    
    
    //Creates mail controller with all attached images and returns said controller
    func configureMailController() -> MFMailComposeViewController {
        //Create mail controller variable
        let mailComposerVC = MFMailComposeViewController()
        //View is dismissed via view controller
        mailComposerVC.mailComposeDelegate = self
        //Pass user's input text to be written to report document
        let report = produceFinalImage()
        //Loop through images to attach to email after converting to png
        for pic in attachedPhotos {
            mailComposerVC.addAttachmentData(UIImagePNGRepresentation(pic)!, mimeType: "image/png", fileName: "")
        }
        //Convert report image to png
        let imageData = UIImagePNGRepresentation(report)
        //Attach report to email
        mailComposerVC.addAttachmentData(imageData!, mimeType: "image/png", fileName: "violation images")
        mailComposerVC.setToRecipients(["iperfitt@umich.edu"])
        mailComposerVC.setSubject("ET Rover Pipeline Violation")
        return mailComposerVC
    }
    
    //Displays error if email is not able to be sent
    func showMailError() {
        //Initialize alert controller
        let sendMailErrorAlert = UIAlertController(title: "Could not send email", message: "", preferredStyle: .alert)
        //Allow user to dismiss alert pop up
        let dismiss = UIAlertAction(title: "OK", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        //Display alert to user
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    //Tells the delegate that the user wants to dismiss the mail composition view.
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    //Called when user decides to import an image from phone to attach to report
    @IBAction func importImage(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        //Pick image from photo library
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true) {
        }
    }
    
    
    //Called when user decides to take a photo to attach to report
    @IBAction func TakePhoto(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .camera
        image.allowsEditing = false
        self.present(image, animated: true) {
        }
    }
    
    //Called once the user selects an image
    func imagePickerController(_ image: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //Unpack the image from the info dict
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //Add image to attachedPhotos array
            attachedPhotos.append(image)
        }
        else {
            //Error message
            print("Error occured picking image")
        }
        //Dismiss the view controller
        self.dismiss(animated: true, completion: nil)
    }
    
    //Obtain phone location
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
        //Use the highest level of accuracy for location data
        manager.desiredAccuracy = kCLLocationAccuracyBest
        //Requests permission to use location services while the app is in the foreground.
        manager.requestWhenInUseAuthorization()
        //Starts the generation of updates that report the user’s current location.
        manager.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
