//
//  PPParcel+CoreDataProperties.swift
//  tt
//
//  Created by programista on 14/05/2019.
//  Copyright © 2019 programista. All rights reserved.
//
//

import Foundation
import CoreData
import SWXMLHash

class PPParcel: NSManagedObject  {


//    @nonobjc public class func fetchRequest() -> NSFetchRequest<PPParcel> {
//        return NSFetchRequest<PPParcel>(entityName: "PPParcel")
//    }
    @NSManaged  var dataNadania: NSDate?
    @NSManaged  var krajNadania: String?
    @NSManaged  var krajPrzezn: String?
    @NSManaged  var numer: String?
    @NSManaged  var rodzPrzes: String?
    @NSManaged  var zakonczonoObsluge: Bool
    @NSManaged  var zdarzenia: NSOrderedSet?

}




//class PPParcel {
//    init(n:String) {
//        number = n
//    }
//    var number: String!
//
//}

struct Zdarzenie: XMLIndexerDeserializable {
    let jednostkaNazwa: String
    let czas: String
    let nazwa: String
    
    static func deserialize(_ node: XMLIndexer) throws -> Zdarzenie {
        return try Zdarzenie(
            jednostkaNazwa: node["ax21:jednostka"]["ax21:nazwa"].value(),
            czas: node["ax21:czas"].value(),
            nazwa: node["ax21:nazwa"].value()
        )
    }
}





