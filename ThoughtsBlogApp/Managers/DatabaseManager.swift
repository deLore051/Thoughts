//
//  DatabaseManager.swift
//  ThoughtsBlogApp
//
//  Created by Stefan Dojcinovic on 14.10.21..
//

import Foundation
import FirebaseFirestore

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Firestore.firestore()
    
    private init() { }
    
    public func insert(with blogPost: BlogPost, user: User, completion: @escaping (Bool) -> Void ) {
        
    }
    
    public func getAllPosts(completion: @escaping ([BlogPost]) -> Void ) {
        
    }
    
    public func getPostsForUser(for user: User, completion: @escaping ([BlogPost]) -> Void ) {
        
    }
    
    public func insert(user: User, completion: @escaping (Bool) -> Void ) {
        let documentID = user.email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        let data = [
            "email": user.email,
            "username": user.username
        ]
        
        database.collection("users").document(documentID).setData(data) { error in
            completion(error == nil)
        }
    }
 
}
