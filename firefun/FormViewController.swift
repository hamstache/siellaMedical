//
//  FormViewController.swift
//  
//
//  Created by Josh Moynihan on 6/29/17.
//
//

import UIKit
import FirebaseDatabase
import MessageUI

class FormViewController: UIViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate {
    
    var ref:DatabaseReference?
    
    var serial = ""
    
    var batteryValue = ""
    var chassisleakageValue = ""
    var exteriorValue = ""
    var groundresistanceValue = ""
    var leadleakageValue = ""
    var performanceverifValue = ""
    var powercordValue = ""
    var testingperformedbyValue = ""
    
    @IBAction func emailForm(_ sender: Any) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    @IBOutlet weak var customerOutlet: UITextField!
    @IBOutlet weak var addressOutlet: UITextField!
    @IBOutlet weak var contactOutlet: UITextField!
    @IBOutlet weak var contactnoOutlet: UITextField!
    @IBOutlet weak var facilityOutlet: UITextField!
    @IBOutlet weak var modelOutlet: UITextField!
    @IBOutlet weak var manufrOutlet: UITextField!
    @IBOutlet weak var serialOutlet: UITextField!
    @IBOutlet weak var exteriorOutlet: UISegmentedControl!
    @IBOutlet weak var powercordOutlet: UISegmentedControl!
    @IBOutlet weak var batteryOutlet: UISegmentedControl!
    @IBOutlet weak var groundresistanceOutlet: UISegmentedControl!
    @IBOutlet weak var chassisleakageOutlet: UISegmentedControl!
    @IBOutlet weak var leadleakageOutlet: UISegmentedControl!
    @IBOutlet weak var performanceverifOutlet: UISegmentedControl!
    @IBOutlet weak var noteOutlet: UITextField!
    @IBOutlet weak var lastpmOutlet: UITextField!
    @IBOutlet weak var nextpmdueOutlet: UITextField!
    @IBOutlet weak var datetestedOutlet: UITextField!
    @IBOutlet weak var testingperformedbyOutlet: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBAction func saveBtn(_ sender: Any) {
        //TODO write the save new entry or update existing entry in database
        
        if (newForm == "True") {
            serial = serialOutlet.text!
        }
        
        //Updating existing records by serial number
        let batterySelected = batteryOutlet.selectedSegmentIndex
        if (batterySelected == 0){
            batteryValue = "True"
        }
        else{
            batteryValue = "False"
        }
        
        let chassisleakageSelected = chassisleakageOutlet.selectedSegmentIndex
        if (chassisleakageSelected == 0){
            chassisleakageValue = "True"
        }
        else{
            chassisleakageValue = "False"
        }
        let exteriorSelected = exteriorOutlet.selectedSegmentIndex
        if (exteriorSelected == 0){
            exteriorValue = "True"
        }
        else{
            exteriorValue = "False"
        }
        
        let groundresistanceSelected = groundresistanceOutlet.selectedSegmentIndex
        if (groundresistanceSelected == 0){
            groundresistanceValue = "True"
        }
        else{
            groundresistanceValue = "False"
        }
        let leadleakageSelected = leadleakageOutlet.selectedSegmentIndex
        if (leadleakageSelected == 0){
            leadleakageValue = "True"
        }
        else{
            leadleakageValue = "False"
        }
        let performanceverifSelected = performanceverifOutlet.selectedSegmentIndex
        if (performanceverifSelected == 0){
            performanceverifValue = "True"
        }
        else{
            performanceverifValue = "False"
        }
        let powercordSelected = powercordOutlet.selectedSegmentIndex
        if (powercordSelected == 0){
            powercordValue = "True"
        }
        else{
            powercordValue = "False"
        }
        
        
        let form = [
            "address":  addressOutlet.text,
            "battery": batteryValue,
            "chassisleakage":   chassisleakageValue,
            "contact":  contactOutlet.text,
            "contactno": contactnoOutlet.text,
            "customer":   customerOutlet.text,
            "datetested":  datetestedOutlet.text,
            "exterior": exteriorValue,
            "facility":   facilityOutlet.text,
            "groundresistance":  groundresistanceValue,
            "lastpm": lastpmOutlet.text,
            "leadleakage":   leadleakageValue,
            "manufr":  manufrOutlet.text,
            "model": modelOutlet.text,
            "nextpmdue":   nextpmdueOutlet.text,
            "note":  noteOutlet.text,
            "performanceverif": performanceverifValue,
            "powercord":   powercordValue,
            "testingperformedby": testingperformedbyOutlet.text
        ] as [String : Any]
        
        self.ref?.child("forms").child(serial).setValue(form)
        
        self.performSegue(withIdentifier: "save", sender: self)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        customerOutlet.resignFirstResponder()
        addressOutlet.resignFirstResponder()
        contactOutlet.resignFirstResponder()
        contactnoOutlet.resignFirstResponder()
        facilityOutlet.resignFirstResponder()
        modelOutlet.resignFirstResponder()
        manufrOutlet.resignFirstResponder()
        serialOutlet.resignFirstResponder()
        noteOutlet.resignFirstResponder()
        lastpmOutlet.resignFirstResponder()
        nextpmdueOutlet.resignFirstResponder()
        datetestedOutlet.resignFirstResponder()
        testingperformedbyOutlet.resignFirstResponder()
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapView(_:)))
        
        
        self.customerOutlet.delegate = self
        self.addressOutlet.delegate = self
        self.contactOutlet.delegate = self
        self.contactnoOutlet.delegate = self
        self.facilityOutlet.delegate = self
        self.modelOutlet.delegate = self
        self.manufrOutlet.delegate = self
        self.serialOutlet.delegate = self
        self.noteOutlet.delegate = self
        self.lastpmOutlet.delegate = self
        self.nextpmdueOutlet.delegate = self
        self.datetestedOutlet.delegate = self
        self.testingperformedbyOutlet.delegate = self
        
        customerOutlet.returnKeyType = .done
        addressOutlet.returnKeyType = .done
        contactOutlet.returnKeyType = .done
        contactnoOutlet.returnKeyType = .done
        facilityOutlet.returnKeyType = .done
        modelOutlet.returnKeyType = .done
        manufrOutlet.returnKeyType = .done
        serialOutlet.returnKeyType = .done
        noteOutlet.returnKeyType = .done
        lastpmOutlet.returnKeyType = .done
        nextpmdueOutlet.returnKeyType = .done
        datetestedOutlet.returnKeyType = .done
        testingperformedbyOutlet.returnKeyType = .done
        
        //Establish connection to database
        ref = Database.database().reference()
        let first = globalString.components(separatedBy: " ").first!
        serial = first
        self.serialOutlet.text = first
        
        if (newForm == "False"){
            /*reading SIELLA DATA FROM DATABASE*/
            ref?.child("forms").child(first).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value for a specific serial number
                let value = snapshot.value as? NSDictionary
                let address = value?["address"] as? String ?? ""
                //print(address)
                self.addressOutlet.text = address
                let battery = value?["battery"] as? String ?? ""
                //print(battery)
                if (battery == "True"){
                    // select the first segment
                    self.batteryOutlet.selectedSegmentIndex = 0;
                }
                else {
                    // turn off the current selection
                    self.batteryOutlet.selectedSegmentIndex = 1;
                }
                let chassisleakage = value?["chassisleakage"] as? String ?? ""
                //print(chassisleakage)
                if (chassisleakage == "True"){
                    // select the first segment
                    self.chassisleakageOutlet.selectedSegmentIndex = 0;
                }
                else {
                    // turn off the current selection
                    self.chassisleakageOutlet.selectedSegmentIndex = 1;
                }
                let contact = value?["contact"] as? String ?? ""
                //print(contact)
                self.contactOutlet.text = contact
                let contactno = value?["contactno"] as? String ?? ""
                //print(contactno)
                self.contactnoOutlet.text = contactno
                let customer = value?["customer"] as? String ?? ""
                //print(customer)
                self.customerOutlet.text = customer
                let datetested = value?["datetested"] as? String ?? ""
                //print(datetested)
                self.datetestedOutlet.text = datetested
                let exterior = value?["exterior"] as? String ?? ""
                //print(exterior)
                if (exterior == "True"){
                    // select the first segment
                    self.exteriorOutlet.selectedSegmentIndex = 0;
                }
                else {
                    // turn off the current selection
                    self.exteriorOutlet.selectedSegmentIndex = 1;
                }
                let facility = value?["facility"] as? String ?? ""
                //print(facility)
                self.facilityOutlet.text = facility
                let groundresistance = value?["groundresistance"] as? String ?? ""
                //print(groundresistance)
                if (groundresistance == "True"){
                    // select the first segment
                    self.groundresistanceOutlet.selectedSegmentIndex = 0;
                }
                else {
                    // turn off the current selection
                    self.groundresistanceOutlet.selectedSegmentIndex = 1;
                }
                let lastpm = value?["lastpm"] as? String ?? ""
                //print(lastpm)
                self.lastpmOutlet.text = lastpm
                let leadleakage = value?["leadleakage"] as? String ?? ""
                //print(leadleakage)
                if (leadleakage == "True"){
                    // select the first segment
                    self.leadleakageOutlet.selectedSegmentIndex = 0;
                }
                else {
                    // turn off the current selection
                    self.leadleakageOutlet.selectedSegmentIndex = 1;
                }
                let manufr = value?["manufr"] as? String ?? ""
                //print(manufr)
                self.manufrOutlet.text = manufr
                let model = value?["model"] as? String ?? ""
                //print(model)
                self.modelOutlet.text = model
                let nextpmdue = value?["nextpmdue"] as? String ?? ""
                //print(nextpmdue)
                self.nextpmdueOutlet.text = nextpmdue
                let note = value?["note"] as? String ?? ""
                //print(note)
                self.noteOutlet.text = note
                let performanceverif = value?["performanceverif"] as? String ?? ""
                //print(performanceverif)
                if (performanceverif == "True"){
                    // select the first segment
                    self.performanceverifOutlet.selectedSegmentIndex = 0;
                }
                else {
                    // turn off the current selection
                    self.performanceverifOutlet.selectedSegmentIndex = 1;
                }
                let powercord = value?["powercord"] as? String ?? ""
                //print(powercord)
                if (powercord == "True"){
                    // select the first segment
                    self.powercordOutlet.selectedSegmentIndex = 0;
                }
                else {
                    // turn off the current selection
                    self.powercordOutlet.selectedSegmentIndex = 1;
                }
                let testingperformedby = value?["testingperformedby"] as? String ?? ""
                //print(testingperformedby)
                self.testingperformedbyOutlet.text = testingperformedby
                
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
            /* END SIELLA MEDICAL DATA RETRIEVAL */
        }
        else {
            //New form doesn't load any existing information
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tapView(_ sender: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //Adding email functionality
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        var ext = ""
        var pwrcrd = ""
        var btry = ""
        var grnd = ""
        var chss = ""
        var ldl = ""
        var pfrm = ""
        
        if (exteriorOutlet.selectedSegmentIndex == 0){
            ext = "True"
        } else {
            ext = "False"
        }
        if (powercordOutlet.selectedSegmentIndex == 0){
            pwrcrd = "True"
        } else {
            pwrcrd = "False"
        }
        if (batteryOutlet.selectedSegmentIndex == 0){
            btry = "True"
        } else {
            btry = "False"
        }
        if (groundresistanceOutlet.selectedSegmentIndex == 0){
            grnd = "True"
        } else {
            grnd = "False"
        }
        if (chassisleakageOutlet.selectedSegmentIndex == 0){
            chss = "True"
        } else {
            chss = "False"
        }
        if (leadleakageOutlet.selectedSegmentIndex == 0){
            ldl = "True"
        } else {
            ldl = "False"
        }
        if (performanceverifOutlet.selectedSegmentIndex == 0){
            pfrm = "True"
        } else {
            pfrm = "False"
        }
        
        
        
        mailComposerVC.setToRecipients(["your@email.com"])
        mailComposerVC.setSubject("Safety Check for "+customerOutlet.text!)
        mailComposerVC.setMessageBody("Hello, \n\n Here is the PM and Electrical Safety Check for:\n\n "+serialOutlet.text!+" "+manufrOutlet.text!+" "+modelOutlet.text!+" \n\nCustomer: "+customerOutlet.text!+"\nAddress: "+addressOutlet.text!+"\nContact: "+contactOutlet.text!+"\nContact #: "+contactnoOutlet.text!+"\nFacility: "+facilityOutlet.text!+"\nModel: "+modelOutlet.text!+"\nManufr: "+manufrOutlet.text!+"\nSerial: "+serialOutlet.text!+"\n\nDevice Condition: \nExterior: "+ext+"\nPower Cord: "+pwrcrd+"\nBattery: "+btry+"\n\nElectrical Safety: \nGround Resistance: "+grnd+"\nChassis Leakage: "+chss+"\nLead Leakage: "+ldl+"\nPerformance Verification: "+pfrm+"\nNote: "+noteOutlet.text!+"\nLast P.M.: "+lastpmOutlet.text!+"\nNext P.M. Due: "+nextpmdueOutlet.text!+"\nDate Tested: "+datetestedOutlet.text!+"\nTesting Performed By: "+testingperformedbyOutlet.text!+"\n", isHTML: false)
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could not send email", message: "Your device could not send the email. Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
//        switch result.value {
//        case MFMailComposeResultCancelled.value:
//            print("Cancelled mail")
//        case MFMailComposeResultSent.value:
//            print("Mail sent")
//        default:
//            break
//        }
    }

}
