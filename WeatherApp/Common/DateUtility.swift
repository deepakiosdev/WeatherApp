//
//  DateUtility.swift
//  WeatherApp
//
//  Created by Dipak Pandey on 02/11/18.
//  Copyright © 2018 Dipak Pandey. All rights reserved.
//

import Foundation

struct DateUtility {
    
   private let rawDate: String
    
    init(date: String) {
        self.rawDate = date
    }
    
    //Formated string in display format
    var forcastDateTimeString: String {
       
        let sourceDateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = convertDate(fromSourceFormat: sourceDateFormat, toFormat: "MMM d, yyyy")
        let timeString = convertDate(fromSourceFormat: sourceDateFormat, toFormat: "hh:mm a")
        
        let formatedDate =  (dateString ?? "") + "\n\n" + (timeString ?? "")
       // print("=============rawDate:\(self.rawDate)\nformatedDate:\(formatedDate)\n\n\n")
        return formatedDate
    }

    // Converts Date String from sourceFormat to required fromat
    private func convertDate(fromSourceFormat sourceFormat: String, toFormat : String) -> String? {
        
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = sourceFormat
        guard let date = dateFormatter.date(from: rawDate) else {
            return nil
        }
        
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = toFormat
        let formatedString = dateFormatter.string(from: date)
        
        return formatedString
    }
    
}




