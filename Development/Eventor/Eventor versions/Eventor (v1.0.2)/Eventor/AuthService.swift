//
//  AuthService.swift
//  Eventor
//
//  Created by Saleh on 23/05/1440 AH.
//  Copyright © 1440 Eventor. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class AuthSevice {
   
    static func signIn(email: String, password: String, onSucces: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            
            onSucces()
        })
    }
    
    static func signUp(username: String, email: String, password: String, accountType: String, ucity: String, uBirthDate: String, UphoneNo: String, imageData: Data, onSucces: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error: Error?) in
            if (error != nil) {
                onError(error!.localizedDescription)
                return
            }
            let UID = (Auth.auth().currentUser?.uid)!
            let StorageRef = Storage.storage().reference(forURL: "gs://eventor-f52a8.appspot.com")
            let ProfileImageRef = StorageRef.child("ProfileImage").child(UID)
            ProfileImageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if error != nil {
                    return
                }
                ProfileImageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    let ProfileImageURL = downloadURL
                    let ProfileImageURLString = ProfileImageURL.absoluteString
                    let ref = Database.database().reference()
                    let UsersRef = ref.child("Users")
                    let NewUserRef = UsersRef.child(UID)
                    NewUserRef.setValue(["UserName": username, "AccountType": accountType, "Email": email, "Ucity": ucity, "UBirthDate": uBirthDate, "UphoneNb": UphoneNo, "ProfileImage": ProfileImageURLString])
                }
                onSucces()
            }
        })
    }
}

