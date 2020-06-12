//
//  BookViewModel.swift
//  BookSpine
//
//  Created by Peter Friese on 09/06/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import Foundation
import Combine

enum Mode {
  case edit
  case add
}

class BookViewModel: ObservableObject {
  // MARK: - Public properties
  
  @Published var book: Book
  @Published var modified = false
  let mode: Mode
  let title: String
  
  // MARK: - Internal properties
  
  private var repository = BookRepository.sharedInstance
  private var cancellables = Set<AnyCancellable>()
  
  // MARK: - Constructors
  
  static func newBook() -> BookViewModel {
    BookViewModel(book: Book(title: "", author: "", numberOfPages: 0), mode: .add)
  }
  
  static func editBook(_ book: Book) -> BookViewModel {
    BookViewModel(book: book, mode: .edit)
  }
  
  init(book: Book, mode: Mode) {
    self.book = book
    self.mode = mode
    
    if (self.mode == .add) {
      self.title = "New Book"
    }
    else {
      self.title = book.title
    }
    
    self.$book
      .dropFirst()
      .debounce(for: 0.8, scheduler: RunLoop.main)
      .sink { [weak self] book in
        self?.modified = true
      }
      .store(in: &self.cancellables)
  }
  
  // MARK: - Model management
  
  func save() {
    repository.addBook(self.book)
  }
  
  func update() {
    repository.updateBook(self.book)
  }
  
  func remove() {
    repository.removeBook(self.book)
  }
  
  // MARK: - UI handlers
  
  func handleDoneTapped() {
    if mode == .add {
      self.save()
    }
    else {
      self.update()
    }
  }

}
