//
//  BookRepository.swift
//  BookSpine
//
//  Created by Chris Bearden on 8/15/20.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import Foundation
import Combine
import FirebaseFirestore

struct FirestoreReferenceManager {
    static let db = Firestore.firestore()
    
    // switch between development and production environment to safely test your app
    static let environment = "development"
//    static let environment = "production"
    
    static let collectionPath = "books"
    static let root = db.collection(environment).document(FBKeys.userId).collection(collectionPath)
    
    struct FBKeys {
        // replace "userId" with Auth.auth().currentUser?.uid ?? "unknown"
        static let userId = "userId"
    }
    
    static func searchBooks(documentId: String) -> DocumentReference {
        return root.document(documentId)
    }
}

class BookRepository: ObservableObject {
    
    @Published var books = [Book]()
    
    
    
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
            listenerRegistration = FirestoreReferenceManager.root.addSnapshotListener { (querySnapshot, error) in
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

    func searchBook(_ book: String = "") {
        let searchKey = book.lowercased()
            self.books = []
            FirestoreReferenceManager.root
                .whereField("books", isEqualTo: "books")
                .order(by: "createdTime")
                .addSnapshotListener(includeMetadataChanges: false) { (querySnapshot, error) in
                    if let querySnapshot = querySnapshot {
                        self.books = querySnapshot.documents.compactMap { document -> Book? in
                            let data = try? document.data(as: Book.self)
                            if data != nil && ((data?.title.lowercased().range(of: searchKey)) != nil) {
                                return data
                            }
                            return nil
                        }
                    }
            }
        }
    
    func addBook(_ book: Book) {
        do {
            var userBook = book
            userBook.userId = FirestoreReferenceManager.FBKeys.userId
            let _ = try FirestoreReferenceManager.root.addDocument(from: userBook)
        }
        catch {
            print(error)
        }
    }
    // added the update book from the document reference and called setData
    func updateBook(_ book: Book) {
        if let bookId = book.id {
            do {
                try FirestoreReferenceManager.root.document(bookId).setData(from: book)
            }
            catch {
                fatalError("Unable to encode task: \(error.localizedDescription).")
            }
        }
    }
    func removeBook(_ book: Book) {
            if let bookId = book.id {
                FirestoreReferenceManager.root.document(bookId).delete { (error) in
                    if let error = error {
                        print("Unable to remove document: \(error.localizedDescription)")
                    }
                }
            }
        }
    
}

