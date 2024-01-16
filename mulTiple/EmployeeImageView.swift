//
//  EmployeeImageView.swift
//  mulTiple
//
//  Created by Emirhan Karahan on 14.01.2024.
//

import UIKit

final class EmployeeImageView: UIImageView {
    
    private var currentImageURL: String?
    
    func loadImage(urlString: String?) async throws {
        currentImageURL = urlString
        
        guard let urlString, let url = URL(string: urlString) else {
            throw EmployeeError.invalidURL
        }
        
        self.image = nil
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw EmployeeError.unexpectedStatusCode
        }
        
        guard let image = UIImage(data: data) else {
            throw EmployeeError.invalidURL
        }
        
        if self.currentImageURL == urlString {
            self.image = image
        }
    }
    
}
