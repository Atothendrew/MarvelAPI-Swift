//
//  ContentView.swift
//  Shared
//
//  Created by Andrew Williamson on 5/31/22.
//

import SwiftUI



struct ContentView: View {
    
    @State var comics = [Comic]()

    var body: some View {
        
        List(comics) { book in
            VStack(alignment: .leading) {
            Text("\(book.title!)")
                        .font(.title)
                        .foregroundColor(.red)
                        .padding(.bottom)
            HStack{
                if let description = book.description {
                    Text("\(description)")
                                .font(.body)
                                .fontWeight(.bold)
                }
                
            Text("\(book.resourceURI!)")
                            .font(.body)
                            .fontWeight(.semibold)
                    }
                    Spacer()
                }
                if let image = book.thumbnail {
                    let url = URL(string: image.path.replacingOccurrences(of: "http", with: "https") + "/portrait_xlarge." + image.ext)
                    
                    AsyncImage(url: url)
                    
                }
            
        }.onAppear() {
            Comic.getComics { (comics) in
                self.comics = comics ?? []
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
