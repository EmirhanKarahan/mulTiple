//
//  AppConfig.swift
//  mulTiple
//
//  Created by Emirhan Karahan on 16.01.2024.
//

import Foundation

struct AppConfig {
    static let apiUrl = (Bundle.main.infoDictionary?["API_URL"] as? String) ?? ""
    static let appName = (Bundle.main.infoDictionary?["APP_NAME"] as? String) ?? ""
    static let customerId = (Bundle.main.infoDictionary?["CUSTOMER_ID"] as? String) ?? ""
}
