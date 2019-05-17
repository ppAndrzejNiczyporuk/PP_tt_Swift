//
//  testRecorded.swift
//  ttUITests
//
//  Created by programista on 16/05/2019.
//  Copyright © 2019 programista. All rights reserved.
//

import XCTest

class testRecorded: XCTestCase {
    var parcelsTest:[String] = ["testp0","testp1","testp-1", "testp-2", "testp-99"]
    var pStatus:[String:String] =
        ["0":"Ok",
         "1":"są inne przesyłki o takim numerze",
         "2":"przesyłka o podanym numerze jest w systemie, ale nie ma zdarzeń w podanym okresie",
         "-1":"w systemie nie ma przesyłki o takim numerze.",
         "-2":"podany numer przesyłki jest błędny",
         "-99":"inny błąd"
    ]
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
       // readJSONParcelData()
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
     
        XCUIApplication().launch()
        
        
        

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
       let app = XCUIApplication()
        
        for parcel in parcelsTest{
            app.navigationBars["Parcels"].buttons["Add"].tap()
            let newParcelAlert = app.alerts["New Parcel"]
            newParcelAlert.collectionViews.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .textField).element.typeText(parcel)
            newParcelAlert.buttons["Save"].tap()
            app.tables.staticTexts[parcel].tap()
            //sprawdzenie statusów po literze "p"
            let statusStr = String(parcel.split(separator: "p")[1]) as String
            let statusOpis = pStatus[statusStr]
            
            if statusStr != "0"
            {
            // Check the string displayed on the label is correct
                XCTAssertEqual(statusOpis, app.textFields["statusLabel"].value as? String)
            }
            
            //return to list
            app.navigationBars["Parcels"].buttons["Parcels"].tap()
            
            //delete row
            app.tables.staticTexts[parcel].swipeLeft()
            app.tables.buttons["Delete"].tap()
        }
    }

}
