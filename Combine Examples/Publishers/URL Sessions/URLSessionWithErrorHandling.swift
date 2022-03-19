//
//  URLSessionWithErrorHandling.swift
//  Combine Examples
//
//  Created by Steve Plavetzky on 3/19/22.
//

import SwiftUI
import Combine

struct ErrorForAlert: Error, Identifiable{
    let id = UUID()
    let title = "Error"
    var message = "Please try again later."
}

class URLSessionWithErrorHandlingVM: ObservableObject{
    @Published var dataToView: [CatFact] = []
    @Published var errorForAlert: ErrorForAlert?
    var cancellables: Set<AnyCancellable> = []
    
    func fetch(){
        let url = URL(string: "https://cat-fact.herokuapp.com/nothing")! // invalid site to show the error
        URLSession.shared.dataTaskPublisher(for: url)
            .map{$0.data}
            .decode(type: [CatFact].self, decoder: JSONDecoder())
            .sink(receiveCompletion: {[unowned self] completion in
                if case .failure(let error) = completion {
                    errorForAlert = ErrorForAlert(message: "Details: \(error.localizedDescription)")
                }
                
            }, receiveValue: {[unowned self] catFact in
                dataToView = catFact
            })
            .store(in: &cancellables)
    }
}


struct URLSessionWithErrorHandling: View {
    @StateObject var vm = URLSessionWithErrorHandlingVM()
    
    var body: some View {
        VStack{
            DescView(desc: "Here is an example of displaying an alert with an error message if an error is thrown in the pipeline.")
            
            List(vm.dataToView, id: \._id){ datum in
                Text(datum.text)
            }
            .font(.title3)
        }
        .font(.title)
        .onAppear{
            vm.fetch()
        }
        .alert(item: $vm.errorForAlert) {errorForAlert in
            Alert(title: Text(errorForAlert.title),
                  message: Text(errorForAlert.message))
        }
    }
}

struct URLSessionWithErrorHandling_Previews: PreviewProvider {
    static var previews: some View {
        URLSessionWithErrorHandling()
    }
}
