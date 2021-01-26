//
//  MKPlacemark+Extension.swift
//  LetsGo
//
//  Created by Marc Llort Maulion on 19/12/20.
//

import MapKit
import Contacts

extension MKPlacemark {
    var formattedAddress: String? {
        guard let postalAddress = postalAddress else { return nil }
        return CNPostalAddressFormatter.string(from: postalAddress, style: .mailingAddress).replacingOccurrences(of: "\n", with: " ")
    }
}
