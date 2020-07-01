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
  
  func addBook(_ book: Book) {
    do {
      let _ = try db.collection("books").addDocument(from: book)
    }
    catch {
      print(error)
    }
  }
  
  // MARK: - Model management
  
  func save() {
    addBook(self.book)
  }
  
  // MARK: - UI handlers
  
  func handleDoneTapped() {
    self.save()
  }

}
