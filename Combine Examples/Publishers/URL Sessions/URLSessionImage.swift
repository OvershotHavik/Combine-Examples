//
//  URLSessionImage.swift
//  Combine Examples
//
//  Created by Steve Plavetzky on 3/19/22.
//

import SwiftUI
import Combine

class URLSessionImageVM: ObservableObject{
    @Published var image: Image?
    @Published var errorForAlert: ErrorForAlert?
    
    var cancellables: Set<AnyCancellable> = []
    func fetch() {
        let url = URL(string: "https://d31ezp3r8jwmks.cloudfront.net/C3JrpZx1ggNrDXVtxNNcTz3t")!
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map{$0.data}
            .tryMap {data in
                guard let uiImage = UIImage(data: data) else {
                    throw ErrorForAlert(message: "Did not receive a valid image.")
                }
                return Image(uiImage: uiImage)
            }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {[unowned self] completion in
                if case .failure(let error) = completion {
                    if error is ErrorForAlert{
                        //This is checking to see if there is an error in the tryMap block
                        errorForAlert = (error as! ErrorForAlert)
                    } else {
                        //This is the generic catch 
                        errorForAlert = ErrorForAlert(message: "Details: \(error.localizedDescription)")
                    }
                }
            }, receiveValue: {[unowned self] image in
                self.image = image
            })
            .store(in: &cancellables)
        
    }
}


struct URLSessionImage: View {
    @StateObject var vm = URLSessionImageVM()
    
    var body: some View {
        VStack{
            DescView(desc: "You can use the dataTaskPublisher operator to download images with a URL")
            vm.image
        }
        .onAppear{
            vm.fetch()
        }
        .alert(item: $vm.errorForAlert) {error in
            Alert(title: Text(error.title),
                  message: Text(error.message))
        }
    }
}

struct URLSessionImage_Previews: PreviewProvider {
    static var previews: some View {
        URLSessionImage()
    }
}



