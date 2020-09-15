//
//  BookDetailsView.swift
//  BookSpine
//
//  Created by Peter Friese on 15/09/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import SwiftUI

struct BookDetailsView: View {
  @Environment(\.presentationMode) var presentationMode
  @State var presentEditBookSheet = false
  
  var book: Book
  
  var body: some View {
    Form {
      Section(header: Text("Book")) {
        Text(book.title)
        Text("\(book.numberOfPages) pages")
      }
      
      Section(header: Text("Author")) {
        Text(book.author)
      }
    }
    .navigationBarTitle(book.title)
    .navigationBarItems(trailing: EditBookButton() {
      self.presentEditBookSheet.toggle()
    })
    .onAppear() {
      print("BookDetailsView.onAppear() for \(self.book.title)")
    }
    .onDisappear() {
      print("BookDetailsView.onDisappear()")
    }
    .sheet(isPresented: self.$presentEditBookSheet) {
      BookEditView(viewModel: BookViewModel(book: book), mode: .edit)
    }
  }
  
}

struct EditBookButton: View {
  var action: () -> Void
  var body: some View {
    Button(action: { self.action() }) {
      Text("Edit")
    }
  }
}


struct BookDetailsView_Previews: PreviewProvider {
  static var previews: some View {
    let book = Book(title: "Changer", author: "Matt Gemmell", numberOfPages: 474)
    return BookDetailsView(book: book)
  }
}
