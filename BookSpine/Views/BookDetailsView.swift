//
//  BookDetailsView.swift
//  BookSpine
//
//  Created by Peter Friese on 15/04/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import SwiftUI

struct BookDetailsView: View {
  @Environment(\.presentationMode) var presentationMode
  @Binding var book: Book
  
  var body: some View {
    Form {
      Section(header: Text("Book")) {
        TextField("Title", text: $book.title)
        Stepper(value: $book.numberOfPages) {
          Text("Pages: \(book.numberOfPages)")
        }
      }
      Section(header: Text("Author")) {
        TextField("Name", text: $book.author)
      }
      Section {
        Button("Save") {
          self.presentationMode.wrappedValue.dismiss()
        }
      }
    }
  }
}

struct BookDetailsView_Previews: PreviewProvider {
  static var previews: some View {
    PreviewWrapper()
  }
  
  struct PreviewWrapper: View {
    @ObservedObject var repo = BooksRepository()
    
    var body: some View {
      BookDetailsView(book: $repo.books[0])
    }
  }
}
