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
    
    private let container = Storage.storage().reference()
    
    private init() {}

    public func uploadUserProfilePicture(email: String, image: UIImage?, completion: @escaping (Bool) -> Void) {
        
    }
    
    public func downloadUrlForProfilePicture(user: User, completion: @escaping (URL?) -> Void) {
        
    }
    
    public func uploadBlogHeaderImage(image: UIImage?, completion: @escaping (Bool) -> Void) {
        
    }
    
    public func downloadUrlForPostHeader(user: User, completion: @escaping (URL?) -> Void) {
        
    }
}
