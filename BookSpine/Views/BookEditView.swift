//
//  BookEditView.swift
//  BookSpine
//
//  Created by Peter Friese on 07/05/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import SwiftUI

struct BookEditView: View {
  @Environment(\.presentationMode) var presentationMode
  @ObservedObject var viewModel: BookViewModel
  
  @State private var presentActionSheet = false
  
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
        
        if viewModel.mode == .edit {
          Section {
            Button(action: { self.presentActionSheet.toggle() }) {
              Text("Delete book")
            }
          }
        }
        else {
          /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
        }
      }
      .navigationBarTitle(Text(self.viewModel.title), displayMode: .inline)
      .navigationBarItems(
        leading:
          Button(action: { self.handleCancelTapped() }) {
            Text("Cancel")
          },
        trailing:
          Button(action: { self.handleDoneTapped() }) {
            Text("Done")
          }
          .disabled(!viewModel.modified)
        )
        .actionSheet(isPresented: self.$presentActionSheet) {
          ActionSheet(title: Text("Are you sure?"),
                      buttons: [
                        .destructive(Text("Delete Book"),
                                     action: { self.handleDeleteTapped() }),
                        .cancel()
                      ])
      }
    }
    .onAppear() {
      print("BookDetailsView.onAppear() for \(self.viewModel.book.title)")
    }
    .onDisappear() {
      print("BookDetailsView.onDisappear() for \(self.viewModel.book.title)")
    }
  }
  
  func handleCancelTapped() {
    dismiss()
  }
  
  func handleDoneTapped() {
    self.viewModel.handleDoneTapped()
    dismiss()
  }
  
  func handleDeleteTapped() {
    self.viewModel.remove()
    dismiss()
  }
  
  func dismiss() {
    self.presentationMode.wrappedValue.dismiss()
  }
}

struct BookEditView_Previews: PreviewProvider {
  static var previews: some View {
    let book = Book(title: "Changer", author: "Matt Gemmell", numberOfPages: 474)
    let bookViewModel = BookViewModel(book: book, mode: .edit)
    return BookEditView(viewModel: bookViewModel)
  }
}
