//
//  BookRepository.swift
//  BookSpine
//
//  Created by Peter Friese on 15/04/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import Foundation
import Combine

import FirebaseFirestore

class BaseBookRepository: ObservableObject, BookRepository {
  @Published var books = [Book]()
  
  func fetchData() {
  }
}

protocol BookRepository {
  func fetchData()
}

class TestDataBooksRepository: BaseBookRepository {
  override func fetchData() {
    self.books = [
      .init(id: .init(), title: "The Ultimate Hitchhiker's Guide to the Galaxy: Five Novels in One Outrageous Volume", author: "Douglas Adams", numberOfPages: 815, isRead: true),
      .init(id: .init(), title: "Changer", author: "Matt Gemmell", numberOfPages: 474, isRead: true),
      .init(id: .init(), title: "Toll", author: "Matt Gemmell", numberOfPages: 474, isRead: true)
    ]
  }
}

class FirestoreBooksRepository: BaseBookRepository {
  private var db = Firestore.firestore()
  
  override func fetchData() {
    db.collection("books").addSnapshotListener { (querySnapshot, error) in
      guard let documents = querySnapshot?.documents else {
        print("No documents")
        return
      }
      
      self.books = documents.map { queryDocumentSnapshot -> Book in
        let data = queryDocumentSnapshot.data()
        let title = data["title"] as? String ?? ""
        let author = data["author"] as? String ?? ""
        let numberOfPages = data["pages"] as? Int ?? 0
        let isRead = data["read"] as? Bool ?? false
        
        return Book(id: .init(), title: title, author: author, numberOfPages: numberOfPages, isRead: isRead)
      }
    }
  }
}
