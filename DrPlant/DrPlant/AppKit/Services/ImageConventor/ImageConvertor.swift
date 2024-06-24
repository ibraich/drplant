//
//  ImageConventor.swift
//  DrPlant
//
//  Created by Adam Bokun on 24.06.24.
//

import Foundation
import SwiftUI

class ImageConvertor {
    static func convertImageToBase64Strings(image: UIImage?) -> [String] {
        guard let image = image else {
            return []
        }
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return []
        }
        let base64String = imageData.base64EncodedString()
        return [base64String]
    }
}

struct ImageConverterView: UIViewRepresentable {
    var image: Image
    @Binding var base64Strings: [String]
    
    func makeUIView(context: Context) -> some UIView {
        let uiView = UIView()
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        if let uiImage = image.asUIImage() {
            imageView.image = uiImage
            base64Strings = ImageConvertor.convertImageToBase64Strings(image: uiImage)
        }
        
        uiView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: uiView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: uiView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: uiView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: uiView.bottomAnchor),
        ])
        
        return uiView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

extension Image {
    func asUIImage() -> UIImage? {
        let hostingController = UIHostingController(rootView: self)
        let view = hostingController.view
        
        let targetSize = hostingController.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            view?.drawHierarchy(in: hostingController.view.bounds, afterScreenUpdates: true)
        }
    }
}
