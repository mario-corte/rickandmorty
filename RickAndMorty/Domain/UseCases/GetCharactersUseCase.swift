//
//  GetCharactersUseCase.swift
//  RickAndMorty
//
//  Created by Mario Corte on 10/18/24.
//

import Combine
import UIKit

struct GetCharactersUseCase {
    let repository: RAMRespository = RAMRepositoryImpl(dataSource: RAMDataSourceImpl())
    
    // Combine
    func getCharacters(for page: Int, name: String) -> AnyPublisher<CharactersModel, APIError> {
        repository.getCharacters(for: page, name: name)
    }
    
    // Async/Await
    func getCharactersAsync(for page: Int, name: String?, status: String?, gender: String?) async throws -> CharactersModel {
        try await repository.getCharactersAsync(for: page, name: name, status: status, gender: gender)
    }
}




































//enum ImageFetchingError: Error {
//    case timeout
//    case unknown
//}
//
//protocol CatImageCellModel {
//    var placeholderImage: UIImage { get }
//    func fetchCatImage(completion: @escaping (Result<UIImage, ImageFetchingError>) -> Void)
//}
//
//
//final class CatImageCell: UICollectionViewCell {
//
//    private var imageView: UIImageView!
//
//    convenience init(imageView: UIImageView) {
//        self.init()
//        
//        self.imageView = imageView
//    }
//
//    func set(model: CatImageCellModel) {
//        model.fetchCatImage { [weak self] result in
//            switch result {
//            case .success(let image):
//                self?.imageView.image = image
//            case .failure(let error):
//                switch error {
//                case .timeout:
//                    // Retry
//                    self?.imageView.image = model.placeholderImage
//                case .unknown:
//                    self?.imageView.image = model.placeholderImage
//                }
//            }
//        }
//    }
//    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        imageView.image = nil
//    }
//}
