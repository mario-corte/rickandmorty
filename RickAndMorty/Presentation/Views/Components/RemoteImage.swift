//
//  RemoteImage.swift
//  RickAndMorty
//
//  Created by Mario Corte on 10/28/24.
//

import UIKit
import SwiftUI

struct RemoteImage: View {
    @ObservedObject var imageLoader: ImageLoader
    
    init(url: String) {
        imageLoader = ImageLoader(url: url)
    }
    
    var body: some View {
        if imageLoader.loading {
            ProgressView()
        }
        else {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                // Placeholder Image
            }
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var loading: Bool = false
    
    private var url: String
    private var task: URLSessionDataTask?
    
    init(url: String) {
        self.url = url
        loadImage()
    }
    
    private func loadImage() {
        if let cachedImage = ImageCache.shared.get(forKey: url) {
            image = cachedImage
            return
        }
        
        guard let url = URL(string: url) else { return }
        
        loading = true
        task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.loading = false
                guard let data = data, error == nil else { return }
                self.image = UIImage(data: data)
                guard let image = self.image else { return }
                ImageCache.shared.set(image, forKey: self.url)
            }
        }
        task?.resume()
    }
}

private class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func set(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func get(forKey key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }
}
