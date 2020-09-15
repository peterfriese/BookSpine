//
//  BookEditView.swift
//  BookSpine
//
//  Created by Peter Friese on 07/05/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import SwiftUI

enum Mode {
  case new
  case edit
}

struct BookEditView: View {
  @Environment(\.presentationMode) private var presentationMode
  @ObservedObject var viewModel = BookViewModel()
  
  var mode: Mode = .new
  
  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Book")) {
          TextField("Title", text: $viewModel.book.title)
          TextField("Number of pages", value: $viewModel.book.numberOfPages, formatter: NumberFormatter())
        }
        
        Section(header: Text("Author")) {
          TextField("Author", text: $viewModel.book.author)
        }
      }
      .navigationBarTitle(mode == .new ? "New book" : viewModel.book.title,
                          displayMode: mode == .new ? .inline : .large)
      .navigationBarItems(
        leading:
          Button(action: { self.handleCancelTapped() }) {
            Text("Cancel")
          },
        trailing:
          Button(action: { self.handleDoneTapped() }) {
            Text(mode == .new ? "Done" : "Save")
          }
          .disabled(!viewModel.modified)
      )
    }
  }
  
  func handleCancelTapped() {
    dismiss()
  }
  
  func handleDoneTapped() {
    self.viewModel.handleDoneTapped()
    dismiss()
  }
  
  func dismiss() {
    self.presentationMode.wrappedValue.dismiss()
  }
}

struct BookEditView_Previews: PreviewProvider {
  static var previews: some View {
    let book = Book(title: "Changer", author: "Matt Gemmell", numberOfPages: 474)
    let bookViewModel = BookViewModel(book: book)
    return BookEditView(viewModel: bookViewModel, mode: .edit)
  }
}
