//
//  InfoPostingVew.swift
//  OnTheMap
//
//  Created by Joel on 9/19/16.
//  Copyright © 2016 Joel Pratt. All rights reserved.
//


import CoreLocation
import AddressBookUI
import UIKit

class InfoPostingViewController: UIViewController {
    
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!

    @IBOutlet weak var submitLocation: UIButton!
    
    var coordinate = CLLocationCoordinate2D?()
//    var mapController = MapViewController()
    var objectID = String()
//    var studentInfo = StudentInformationStore().studentInformationCollection
    
    @IBAction func submitLocation(sender: AnyObject) {
        
        let address = addressTextField.text
        if address != "" && firstNameTextField.text != "" && lastNameTextField.text != "" && urlTextField.text != "" {
            forwardGeocoding(address!)
        } else {
            print("enter address")
        }
    }
    
    //    func setCoordinate(coordinate: CLLocationCoordinate2D?) -> CLLocationCoordinate2D? {
    //        self.coordinate = coordinate
    //
    //        return coordinate
    //    }
    
    func forwardGeocoding(addres: String) {
        
        CLGeocoder().geocodeAddressString(addres) { (placemarks, error) in
            if error != nil {
                print(error)
                return
            }
            
            performUIUpdatesOnMain({
                if placemarks?.count > 0 {
                    let placemark = placemarks?[0]
                    let location = placemark?.location
                    
                    if let coordinate = location?.coordinate {
                        let studentLat = coordinate.latitude
                        let studentLong = coordinate.longitude
                        let objectID = self.isRepeatUser(firstNam: self.firstNameTextField.text!, lastName: self.lastNameTextField.text!)
                        print("obj ID after isRepeatUser call: \(objectID)")
                        if let id = objectID{
                            print("object ID for PUT call: \(id)")
                            ParseClient.sharedInstance().putStudentLocation(id, firstName: self.firstNameTextField.text!, lastName: self.lastNameTextField.text!, mediaURL: self.urlTextField.text!, locationString: self.addressTextField.text!, longitude: studentLong, latitude: studentLat, completionHandlerForPutStudentLocation: { (success, result, error) in
                                if success {
                                    print("the student's location was updated at \(result)")
                                }else {
                                    print("\(error)")
                                }
                            })
                        } else {
                            print("person not found")
//                            ParseClient.sharedInstance().postStudentLocation(self.firstNameTextField.text!, lastName: self.lastNameTextField.text!, mediaURL: self.urlTextField.text!, locationString: self.addressTextField.text!, longitude: studentLong, latitude: studentLat, completionHandlerForPostStudentLocations: { (success, result, error) in
//                                if success {
//                                    print("the student's location with id of \(result) has been posted")
//                                } else {
//                                    print("\(error)")
//                                }
//                                
//                            })
                        }
                    } else {
                        print("no coordinates")
                    }
                    
                    if placemark?.areasOfInterest?.count > 0 {
                        let areaOfInterest = placemark!.areasOfInterest![0]
                        print(areaOfInterest)
                    } else {
//                        print("no area of interest found")
                    }
                }
                
            })
        }
    }
    
    func isRepeatUser(firstNam name: String, lastName: String) -> String? {
        var id: String?
        var studentCount = 0
        print("Student Collection in isRepeatUser \(StudentInformationStore.sharedInstance.studentInformationCollection)")
        print("First Name: \(name) Last Name: \(lastName)")
        for (_, student) in StudentInformationStore.sharedInstance.studentInformationCollection.enumerate() {
            studentCount += 1
            print("Student number \(studentCount): \(student.firstName) \(student.lastName)")
            
            if student.lastName == lastName && student.firstName == name {
                
                id = student.objectID
                print("object ID from isRepeatUser: \(id)")
            }
        }
        return id
    }
    
}