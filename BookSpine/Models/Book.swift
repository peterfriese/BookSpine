//
//  Book.swift
//  BookSpine
//
//  Created by Peter Friese on 15/04/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import Foundation
import FirebaseFirestoreSwift

struct Book: Identifiable, Codable {
  @DocumentID var id: String? = UUID().uuidString
  var title: String
  var author: String
  var numberOfPages: Int
  
  enum CodingKeys: String, CodingKey {
    case title
    case author
    case numberOfPages = "pages"
  }
}
