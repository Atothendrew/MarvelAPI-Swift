//
//  Keys.swift
//  DisneyMobileApp (iOS)
//
//  Created by Andrew Williamson on 6/2/22.
//

import Foundation
import SwiftUI

struct APIKeysInput: View {
    @Binding var ak: String {
        didSet {
            MarvelAPI.shared.publicKey = ak
        }
    }
    @Binding var pk: String {
        didSet {
            MarvelAPI.shared.privateKey = pk
        }
    }
    @State var connectionIsTested: Bool = false
    @State var testConnectionButtonText: String = "Test Connection"
    var body: some View {
        VStack {
            marvelLogoImage.padding()
            Spacer()
            Text("Please enter your API public access key")
                    .font(.headline)
                    .foregroundColor(.green)
                    .padding()
            TextField("What's the API public key?", text: $ak).padding()
            Text("Please enter your API private key")
                    .font(.headline)
                    .foregroundColor(.green)
                    .padding()
            SecureField("What's the API private key?", text: $pk).padding()
            Spacer()
            Button(testConnectionButtonText) {
                testConnectionButtonText = "Testing..."
                UserDefaults.standard.setValue(ak, forKey: "marvel_app_ak")
                UserDefaults.standard.setValue(pk, forKey: "marvel_app_pk")
                ComicResource().get(limit: 1) { comic in
                    if let comic = comic, !comic.isEmpty {
                        connectionIsTested = true
                        testConnectionButtonText = "✅ Success! Saved the values to UserDefaults 🥳"
                    } else {
                        connectionIsTested = false
                        testConnectionButtonText = "⚠️ Failed! Check your credentials and try again."
                    }
                }
            }
                    .padding()
        }
    }
}
