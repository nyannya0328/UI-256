//
//  ContentView.swift
//  UI-256
//
//  Created by nyannyan0328 on 2021/07/09.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
       Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



struct Home : View{
    @State var showSheet : Bool = false
    @State var tap  = false
    
    @StateObject var model = home()
    
    var body: some View{
        
        
        NavigationView{
            
            
            Button {
                
            
                    
                model.show.toggle()
              
                
            } label: {
                Text("Present Sheet")
                    .font(.title.bold())
                    .foregroundColor(.black)
            }
            .navigationTitle("Half Model Sheet")
            .halfSheet(showSheet: $model.show) {
                
                SheetView()
                    .environmentObject(model)
                
             
                
            } onEnd: {
                
                
                print("")
            }

        }
    }
}

class home : ObservableObject{
    
    @Published var tap = false
    @Published var show = false
    
}


struct SheetView : View{
    
    @EnvironmentObject var model : home
    
    
    var body: some View{
        
        ZStack{
            
            model.tap ? Color.red : Color.green
            
            VStack{
                
                Text(model.tap ? "Tap Again" : "Tap")
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .onTapGesture {
                        model.tap.toggle()
                    }
                
                
                
                Button {
                    
                    model.show.toggle()
                    
                } label: {
                    
                    Text("Close")
                        .foregroundColor(.white)
                }
                .padding(10)

                
                
            }
        }
        .ignoresSafeArea()
        
        
        
    }
}


extension View{
    
    func halfSheet<SheetView : View>(showSheet : Binding<Bool>,@ViewBuilder sheetView : @escaping()->SheetView,onEnd : @escaping()->()) -> some View{
        
        
        return self
        
        
            .background(
            
                HalfSheetHelper(onEnd: onEnd, sheetView: sheetView(), showSheet: showSheet)
            )
            .onChange(of: showSheet.wrappedValue) { newValue in
                if !newValue{
                    
                    onEnd()
                }
            }
        
        
        
    }
    
    
}

struct HalfSheetHelper<SheetView : View> : UIViewControllerRepresentable{
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    
    var onEnd : ()->()
    
    var sheetView : SheetView
    
     var controller = UIViewController()
    
    @Binding var showSheet : Bool
    
    func makeUIViewController(context: Context) -> UIViewController {
        controller.view.backgroundColor = .clear
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
       
        
        if showSheet{
            
            
            if uiViewController.presentedViewController == nil{
                
                
                let sheetController = CustomHostingController(rootView: sheetView)
                sheetController.presentationController?.delegate = context.coordinator
                uiViewController.present(sheetController, animated: true)
                
               
                
                
                
                
                
            }
            
            
        }
        
        else{
            
            
            if uiViewController.presentedViewController != nil{
                
                uiViewController.dismiss(animated: true)
                
             
                
                
                
                
                
                
            }
        }
        
       
        
    }
    
    class Coordinator : NSObject,UISheetPresentationControllerDelegate{
        
        var parent : HalfSheetHelper
        
        init(parent:HalfSheetHelper){
            
            self.parent = parent
        }
        
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            parent.showSheet = false
        }
        
        
        
    }
}
class CustomHostingController<Content : View> : UIHostingController<Content>{
    
    
    override func viewDidLoad() {
        
        if let permissonController = presentationController as? UISheetPresentationController{
            
            
            permissonController.detents = [
            
                .medium(),
                .large()
            
            ]
            
            permissonController.prefersGrabberVisible = true
        }
        
    }
    
    
    
}
