//
//  ContentView.swift
//  BookSpine
//
//  Created by Peter Friese on 15/04/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct BooksListView: View {
  @StateObject var viewModel = BooksViewModel()
  @State var presentAddBookSheet = false
  
  private var addButton: some View {
    Button(action: { self.presentAddBookSheet.toggle() }) {
      Image(systemName: "plus")
    }
  }
  
  private func bookRowView(book: Book) -> some View {
    NavigationLink(destination: BookDetailsView(book: book)) {
      VStack(alignment: .leading) {
        Text(book.title)
          .font(.headline)
        Text(book.author)
          .font(.subheadline)
        Text("\(book.numberOfPages) pages")
          .font(.subheadline)
      }
    }
  }
  
  var body: some View {
    NavigationView {
      List {
        ForEach (viewModel.books) { book in
          bookRowView(book: book)
        }
        .onDelete() { indexSet in
          viewModel.removeBooks(atOffsets: indexSet)
        }
      }
      .navigationBarTitle("Books")
      .navigationBarItems(trailing: addButton)
      .onAppear() {
        print("BooksListView appears. Subscribing to data updates.")
        self.viewModel.subscribe()
      }
      .onDisappear() {
        // By unsubscribing from the view model, we prevent updates coming in from
        // Firestore to be reflected in the UI. Since we do want to receive updates
        // when the user is on any of the child screens, we keep the subscription active!
        // 
        // print("BooksListView disappears. Unsubscribing from data updates.")
        // self.viewModel.unsubscribe()
      }
      .sheet(isPresented: self.$presentAddBookSheet) {
        BookEditView()
      }
    }
  }
}

struct BooksListView_Previews: PreviewProvider {
  static var previews: some View {
    BooksListView()
  }
}
