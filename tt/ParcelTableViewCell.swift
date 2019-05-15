//
//  ParcelTavleViewCell.swift
//  tt
//
//  Created by programista on 14/05/2019.
//  Copyright © 2019 programista. All rights reserved.
//

import UIKit

class ParcelTableViewCell: UITableViewCell {
    // MARK: - Properties
    var parcel: PPParcel? {
        didSet {
            guard let parcel = parcel else { return }
            updateNoteInfo(parcel: parcel)
        }
    }
    @IBOutlet fileprivate var parcelNumer: UILabel!
    
}
    extension ParcelTableViewCell {
        
        @objc  func updateNoteInfo(parcel: PPParcel) {
            parcelNumer.text = parcel.numer
            // noteCreateDate.text = note.dateCreated.description
        }
    }


