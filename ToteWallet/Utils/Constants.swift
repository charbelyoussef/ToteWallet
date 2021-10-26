//
//  Constants.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 9/30/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

import UIKit

struct Constants {
    
    static let defaultLogoName = ""
    static let urlPrefix = "https://totewallet.com"

    struct UIElements {
        static let pickerHeight:CGFloat = 240
        static let pickerToolbarHeight:CGFloat = 40
        static let iphone5Offset:CGFloat = 110
        static let iphone6Offset:CGFloat = 110
        static let iphone7Offset:CGFloat = 110
        static let iphone8Offset:CGFloat = 110
        static let iphoneXOffset:CGFloat = 50
        static let iphoneXsMaxOffset:CGFloat = 40
        static let iphone11ProMaxOffset:CGFloat = 40
        static let iphone12MiniMaxOffset:CGFloat = 50
    }
    
    
    struct RequestData {
    }
    
    struct DateFormat {
        static let FULL_DAY_OF_WEEK = "EEEE"
        static let SHORT_DAY_OF_WEEK = "EEE"
        static let DAY_OF_MONTH = "dd"
        static let LONG_MONTH = "MMMM"
        static let SHORT_MONTH = "MMM"
        static let MONTH_NUMBER = "MM"
        static let FULL_YEAR = "yyyy"
    }
    
    struct Errors {
        static let GENERAL_ERROR = "An error has occurred."
        static let PARSING_ERROR = "Parsing error."
        static let ERROR_FILL_ALL_FIELDS = "Kindly Fill all the fields"
        static let ERROR_NO_DATA = "No data was found."
        static let ERROR_NO_CONTENT = "No content was found."

        
        static let ERROR_INVALID_TOKEN = "Invalid token."
        
        static let PASSWORD_MISMATCH_ERROR = "These passwords are not identical."
        static let PIN_MISMATCH_ERROR = "These pins are not identical."
        static let PIN_LENGTH_ERROR = "Your pin should be at least 6 digits"

        static let PASSWORD_FORMAT_ERROR = "Please enter a valid password.\n\nPassword should:\n\nInclude at least one digit\nInclude at least one lowercase letter\nInclude at least one uppercase letter\nInclude at least one special character(@#$%^&amp;+=)\nHave no whitespaces\nBe at least 8 characters."
        
        static let ERR_EMAIL_NOT_VALID = "Email address not valid."
        
        static let ERR_TITLE_REQUIRED = "Title is required."
        static let ERR_FIRST_NAME_REQUIRED = "First name is required."
        static let ERR_LAST_NAME_REQUIRED = "Last name is required."
        static let ERR_EMAIL_REQUIRED = "Email address is required."
        static let ERR_MOBILE_REQUIRED = "Mobile number is required."
        
        static let ERR_TOKEN_NOT_SET = "unsetToken"
        static let ERR_TOKEN_FAILED_TO_GENERATE = "Could not generate token at the moment, please try again later."
    }

}
