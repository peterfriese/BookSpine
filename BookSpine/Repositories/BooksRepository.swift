//
//  BookRepository.swift
//  BookSpine
//
//  Created by Peter Friese on 15/04/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import Foundation
import Combine

class BooksRepository: ObservableObject {
  @Published var books: [Book] = [
    .init(id: .init(), title: "The Pragmatic Programmer", author: "David Thomas, Andrew Hunt", numberOfPages: 321, isRead: false),
    .init(id: .init(), title: "Changer", author: "Matt Gemmell", numberOfPages: 474, isRead: true),
    .init(id: .init(), title: "Toll", author: "Matt Gemmell", numberOfPages: 474, isRead: true)
  ]
  
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    $books.sink { books in
      print("Received valued")
    }
    .store(in: &cancellables)
  }
}
