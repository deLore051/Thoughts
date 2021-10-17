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
    
    public func getUser(email: String, completion: @escaping (User?) -> Void) {
        let documentID = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        database.collection("users").document(documentID).getDocument { snapshot, error in
            guard let data = snapshot?.data() as? [String: String],
                  let username = data["username"],
                  error == nil else {
                print("Failed at getting user info from firebase")
                return
            }
            
            let ref = data["profile_photo"]
            let user = User(username: username, email: email, profilePictureReference: ref)
            completion(user)
        }
    }
    
    public func updateProfilePhoto(email: String, completion: @escaping (Bool) -> Void) {
        // Used the email as unique key for the path
        let path = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        
        let photoReference = "profile_pictures/\(path)/photo.png"
        // Reference for the user in the database
        let dbReference = database
            .collection("users")
            .document(path)
        // We get the users documents and update with the latest value for the profile picture
        dbReference.getDocument { snapshot, error in
            guard var data = snapshot?.data(), error == nil else {
                return
            }
            data["profile_photo"] = photoReference
            dbReference.setData(data) { error in
                completion(error == nil)
            }
        }
    }
 
}
