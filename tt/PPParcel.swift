//
//  Parcel.swift
//  tt
//
//  Created by programista on 12/05/2019.
//  Copyright © 2019 programista. All rights reserved.
//

import Foundation
import SWXMLHash


class PPParcel {
    init(n:String) {
        number = n
    }
    var number: String!

}

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
