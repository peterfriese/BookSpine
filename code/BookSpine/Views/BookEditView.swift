//
//  BookEditView.swift
//  BookSpine
//
//  Created by Peter Friese on 07/05/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import SwiftUI

struct BookEditView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var bookCellVM: BookCellViewModel
    
    var onCommit: (Result<Book, InputError>) -> Void = { _ in }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Book")) {
                    TextField("Title", text: $bookCellVM.book.title,
                        onCommit: {
                        if !self.bookCellVM.book.title.isEmpty {
                            self.onCommit(.success(self.bookCellVM.book))
                        }
                        else {
                            self.onCommit(.failure(.empty))
                        }
                        }).id(bookCellVM.book.id)
                    
                    TextField("Number of pages", value: $bookCellVM.book.numberOfPages, formatter: NumberFormatter(),
                              onCommit: {
                                if (self.bookCellVM.book.numberOfPages == 0) {
                                  self.onCommit(.success(self.bookCellVM.book))
                              }
                              else {
                                  self.onCommit(.failure(.empty))
                              }
                              }).id(bookCellVM.book.id)
                }
                
                Section(header: Text("Author")) {
                    TextField("Author", text: $bookCellVM.book.author,
                              onCommit: {
                                if !self.bookCellVM.book.author.isEmpty {
                                  self.onCommit(.success(self.bookCellVM.book))
                              }
                              else {
                                  self.onCommit(.failure(.empty))
                              }
                              }).id(bookCellVM.book.id)
                }
            }
            .navigationBarTitle("New book", displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button(action: { self.handleCancelTapped() }) {
                        Text("Cancel")
                    },
                trailing:
                    Button(action: { self.handleDoneTapped() }) {
                        Text("Done")
                    }
                    .disabled(!bookCellVM.modified)
            )
        }
    }
    
    func handleCancelTapped() {
        dismiss()
    }
    
    func handleDoneTapped() {
//        self.bookCellVM.handleDoneTapped()
        dismiss()
    }
    
    func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }
}
