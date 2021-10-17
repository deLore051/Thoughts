//
//  StorageManager.swift
//  ThoughtsBlogApp
//
//  Created by Stefan Dojcinovic on 14.10.21..
//

import UIKit
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    
    private let container = Storage.storage()
    
    private init() {}

    public func uploadUserProfilePicture(email: String, image: UIImage?, completion: @escaping (Bool) -> Void) {
        let path = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        guard let pngData = image?.pngData() else {
            return
        }
        container
            .reference(withPath: "profile_pictures/\(path)/photo.png")
            .putData(pngData, metadata: nil) { metadata, error in
                guard metadata != nil, error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
    }
    
    public func downloadUrlForProfilePicture(path: String, completion: @escaping (URL?) -> Void) {
        container
            .reference(withPath: path)
            .downloadURL { url, error in
                completion(url)
            }
    }
    
    public func uploadBlogHeaderImage(image: UIImage?, completion: @escaping (Bool) -> Void) {
        
    }
    
    public func downloadUrlForPostHeader(user: User, completion: @escaping (URL?) -> Void) {
        
    }
}
