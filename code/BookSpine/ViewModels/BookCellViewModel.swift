//
//  BooksViewModel.swift
//  BookSpine
//
//  Created by Peter Friese on 15/04/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import Foundation
import Combine
import Firebase

class BookCellViewModel: ObservableObject, Identifiable  {
    
    @Published var bookRepository = BookRepository()
    @Published var book: Book
    @Published var modified = false
    
    var id: String = ""
    
    // MARK: - Internal properties
    private var cancellables = Set<AnyCancellable>()
    private var db = Firestore.firestore()
    
    static func newBook() -> BookCellViewModel {
        BookCellViewModel(book: Book(userId: "", title: "", author: "", numberOfPages: 0))
    }
    // MARK: - Constructors
    
    init(book: Book) {
        self.book = book
        
        self.$book
            .dropFirst()
            .sink { [weak self] book in
                self?.modified = true
            }
            .store(in: &self.cancellables)
        
        // use this pipeline to update the book
        $book
            .compactMap { $0.id }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
        
        $book
            .dropFirst()
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .sink { [weak self] book in
                self?.bookRepository.updateBook(book)
        }
        .store(in: &cancellables)
        
        $book
            .dropFirst()
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .sink { [weak self] book in
                self?.bookRepository.searchBook()
        }
        .store(in: &cancellables)
    }

}

