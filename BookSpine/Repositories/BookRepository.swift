//
//  BookRepository.swift
//  BookSpine
//
//  Created by Peter Friese on 10/06/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class BookRepository: ObservableObject {
  
  static let sharedInstance = BookRepository()
  
  private init() {
  }
  
  @Published var books = [Book]()
  
  private var db = Firestore.firestore()
  private var listenerRegistration: ListenerRegistration?
  
  deinit {
    unsubscribe()
  }
  
  func unsubscribe() {
    if listenerRegistration != nil {
      listenerRegistration?.remove()
      listenerRegistration = nil
    }
  }
  
  func subscribe() {
    if listenerRegistration == nil {
      listenerRegistration = db.collection("books").addSnapshotListener { (querySnapshot, error) in
        guard let documents = querySnapshot?.documents else {
          print("No documents")
          return
        }
        
        self.books = documents.compactMap { queryDocumentSnapshot in
          try? queryDocumentSnapshot.data(as: Book.self)
        }
      }
    }
  }
  
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
}

