//
//  BooksViewModel.swift
//  BookSpine
//
//  Created by Peter Friese on 15/04/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import Foundation
import Combine
import FirebaseFirestore

class BooksViewModel: ObservableObject {
  @Published var books = [Book]()
  
  private var repository = BookRepository.sharedInstance
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    // subscribe to any changes in the repository
    repository.$books
      .assign(to: \.books, on: self)
      .store(in: &cancellables)
  }
  
  func subscribe() {
    repository.subscribe()
  }
  
  func unsubscribe() {
    repository.unsubscribe()
  }
  
  func removeBooks(at indexSet: IndexSet) {
    let booksToRemove = indexSet.lazy.map { self.books[$0] }
    booksToRemove.forEach { book in
      repository.removeBook(book)
    }
  }
  
}

