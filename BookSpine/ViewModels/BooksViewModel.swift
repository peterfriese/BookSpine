//
//  BooksViewModel.swift
//  BookSpine
//
//  Created by Peter Friese on 15/04/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import Foundation
import FirebaseFirestore

class BooksViewModel: ObservableObject {
  @Published var books = [Book]()
  
  private var db = Firestore.firestore()
  private var listenerRegistration: ListenerRegistration?
  
  deinit {
    unregister()
  }
  
  func unregister() {
    if listenerRegistration != nil {
      listenerRegistration?.remove()
    }
  }
  
  func fetchData() {
    unregister()
    listenerRegistration = db.collection("books").addSnapshotListener { (querySnapshot, error) in
      guard let documents = querySnapshot?.documents else {
        print("No documents")
        return
      }
      
      self.books = documents.compactMap { queryDocumentSnapshot -> Book? in
        return try? queryDocumentSnapshot.data(as: Book.self)
      }
    }
  }
  
  func addBook(book: Book) {
    do {
      let _ = try db.collection("books").addDocument(from: book)
    }
    catch {
      print(error)
    }
  }
  
}

