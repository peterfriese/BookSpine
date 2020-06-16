//
//  BookViewModel.swift
//  BookSpine
//
//  Created by Peter Friese on 09/06/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import Foundation
import Combine
import FirebaseFirestore

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
  
  // MARK: - Firestore
  
  private var db = Firestore.firestore()
  
  func addBook(_ book: Book) {
    do {
      let _ = try db.collection("books").addDocument(from: book)
    }
    catch {
      print(error)
    }
  }

  
  func removeBook(_ book: Book) {
    if let bookId = book.id {
      db.collection("books").document(bookId).delete() { error in
        if let error = error {
          print("Unable to remove document: \(error.localizedDescription)")
        }
      }
    }
  }
  
  func updateBook(_ book: Book) {
    if let bookId = book.id {
      do {
        try db.collection("books").document(bookId).setData(from: book)
      }
      catch {
        fatalError("Unable to encode book: \(error.localizedDescription).")
      }
    }
  }
  
  // MARK: - Model management
  
  func save() {
    addBook(self.book)
  }
  
  func update() {
    updateBook(self.book)
  }
  
  func remove() {
    removeBook(self.book)
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
