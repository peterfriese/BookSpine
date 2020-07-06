//
//  BookViewModel.swift
//  BookSpine
//
//  Created by Peter Friese on 06/07/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import Foundation
import Firebase
import Combine

class BookViewModel: ObservableObject {
  @Published var book: Book
  @Published var modified = false
  
  private var db = Firestore.firestore()
  
  private var cancellables = Set<AnyCancellable>()
  
  init(book: Book = Book(title: "", author: "", numberOfPages: 0)) {
    self.book = book
    
    self.$book
      .dropFirst()
      .sink { [weak self] book in
        self?.modified = true
      }
      .store(in: &cancellables)
    
  }
  
  func addBook(book: Book) {
    do {
      let _ = try db.collection("books").addDocument(from: book)
    }
    catch {
      print(error)
    }
  }
  
  private func save() {
    addBook(book: self.book)
  }
  
  func handleDoneTapped() {
    self.save()
  }
  
}
