//
//  Book.swift
//  BookSpine
//
//  Created by Peter Friese on 15/04/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Book: Identifiable, Codable {
    @DocumentID var id: String?
    @ServerTimestamp var createdAt: Timestamp?
    var userId: String
    var title: String
    var author: String
    var numberOfPages: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt
        case userId
        case title
        case author
        case numberOfPages = "pages"
    }
}
