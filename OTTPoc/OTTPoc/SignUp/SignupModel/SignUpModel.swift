//
//  SignUpModel.swift
//  OTTPoc
//
//  Created by Janakiraman Kanagaraj on 14/04/25.
//

import Foundation
import SwiftData

@Model
class User {
    var id = UUID()
    var firstName: String
    var lastName: String
    var dob: Date
    var email: String
    var mobileNumber: String
    
    init(firstName: String, lastName: String, dob: Date, email: String, mobileNumber: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.dob = dob
        self.email = email
        self.mobileNumber = mobileNumber
    }
}

