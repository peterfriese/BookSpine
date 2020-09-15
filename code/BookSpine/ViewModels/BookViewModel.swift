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

class BookViewModel: ObservableObject {
  // MARK: - Public properties
  
  @Published var book: Book
  @Published var modified = false
  
  // MARK: - Internal properties
  
  private var cancellables = Set<AnyCancellable>()
  
  // MARK: - Constructors
  
  init(book: Book = Book(title: "", author: "", numberOfPages: 0)) {
    self.book = book
    
    self.$book
      .dropFirst()
      .sink { [weak self] book in
        self?.modified = true
      }
      .store(in: &self.cancellables)
  }
  
  // MARK: - Firestore
  
  private var db = Firestore.firestore()
  
  private func addBook(_ book: Book) {
    do {
      let _ = try db.collection("books").addDocument(from: book)
    }
    catch {
      print(error)
    }
  }
  
  private func updateBook(_ book: Book) {
    if let documentId = book.id {
      do {
        try db.collection("books").document(documentId).setData(from: book)
      }
      catch {
        print(error)
      }
    }
  }
  
  private func updateOrAddBook() {
    if let documentId = book.id {
      db.collection("books").document(documentId).getDocument { (documentSnapshot, error) in
        if let exists = documentSnapshot?.exists, exists == true {
          self.updateBook(self.book)
        }
        else {
          self.addBook(self.book)
        }
      }
    }
    else {
      addBook(book)
    }
  }
  
  private func removeBook() {
    if let documentId = book.id {
      db.collection("books").document(documentId).delete { error in
        if let error = error {
          print(error.localizedDescription)
        }
      }
    }
  }
  
  // MARK: - UI handlers
  
  func handleDoneTapped() {
    self.updateOrAddBook()
  }
  
  func handleDeleteTapped() {
    self.removeBook()
  }

}
