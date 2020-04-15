//
//  Book.swift
//  BookSpine
//
//  Created by Peter Friese on 15/04/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import Foundation

struct Book: Identifiable {
  let id: UUID
  var title: String
  var author: String
  var numberOfPages: Int
  var isRead: Bool
}
