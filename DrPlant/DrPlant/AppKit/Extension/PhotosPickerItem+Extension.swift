//
//  PhotosPickerItem+Extension.swift
//  DrPlant
//
//  Created by Dzmitry Semianovich on 13/07/2024.
//

import SwiftUI
import PhotosUI

extension PhotosPickerItem {
    func getImage() async throws -> Result<UIImage, Error>{
        let data = try await self.loadTransferable(type: Data.self)
        guard let data = data, let image = UIImage(data: data) else{
            return .failure(AppError.noImageFound)
        }
        return .success(image)
    }
}
