//
//  CovidData.swift
//  LetsGo
//
//  Created by Marc Llort Maulion on 06/12/2020.
//

import Foundation


import Foundation

// MARK: - CovidData
struct CovidData: Codable {
    let allowed: Bool
    let covid: Covid
    let destination, error, info, origin: String
    let passport: String
}

// MARK: - Covid
struct Covid: Codable {
    let country, countryCode, slug: String
    let newConfirmed, totalConfirmed, newDeaths, totalDeaths: Int
    let newRecovered, totalRecovered: Int
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case country = "Country"
        case countryCode = "CountryCode"
        case slug = "Slug"
        case newConfirmed = "NewConfirmed"
        case totalConfirmed = "TotalConfirmed"
        case newDeaths = "NewDeaths"
        case totalDeaths = "TotalDeaths"
        case newRecovered = "NewRecovered"
        case totalRecovered = "TotalRecovered"
        case date = "Date"
    }
}
