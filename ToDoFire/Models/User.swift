//
//  User.swift
//  ToDoFire
//
//  Created by Юханов Сергей Сергеевич on 21/12/2018.
//  Copyright © 2018 Юханов Сергей Сергеевич. All rights reserved.
//

import Foundation
import Firebase

struct User {
    let uid: String
    let email: String
    
    init(user: Firebase.User) {
        self.uid = user.uid
        self.email = user.email!
    }
}
