//
//  ContentView.swift
//  Pinch
//
//  Created by Anuj Soni on 12/03/22.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Functions
    func resetImageState()->(){
    withAnimation(.spring()){
    imageScale = 1
    imageOffset = .zero
    }
    }
    // MARK: - Scaling Property
    @State private var isAnimating:Bool = false
    @State private var imageScale:CGFloat = 1
    @State private var imageOffset:CGSize = CGSize.zero
    
    var body: some View {
        
        NavigationView{
        
        ZStack{
            
            // MARK: - Transparent Background
            Color.clear
            
            // MARK: - page image
            Image("magazine-front-cover")
                .resizable()
                .scaledToFit()
                //.aspectRatio(contentMode:.fit)
                .cornerRadius(10)
                .padding()
                .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                .opacity(isAnimating ? 1:0)
                .animation(.linear(duration:1), value: isAnimating)
                .offset(x:imageOffset.width,y:imageOffset.height)
                .scaleEffect(imageScale)
               
        }
        // MARK: 1- On Tap Gesture
        .onTapGesture(count:2){
            withAnimation(.spring()){
            if imageScale == 1{
                imageScale = 5
            }else{
//                imageScale = 1
//                imageOffset = .zero
                resetImageState()
            }
            }
        }
        // MARK: 2 - Drag Gesture
        .gesture(
            DragGesture()
            .onChanged{value in
            withAnimation(.linear(duration:1))
            {
            imageOffset = value.translation
            }
            }
            .onEnded{_ in
            if imageScale<=1{
            resetImageState()
            }
            }
        )
        .onAppear{
            //withAnimation(.linear(duration:1)){
            isAnimating.toggle()
            //}
        }
        // MARK: - Info Panel
        .overlay(alignment:.top, content: {
            InfoPanelView(scale:imageScale, offset:imageOffset)
                .padding(.horizontal)
                .padding(.top,30)
        })
        // MARK: - Controls
        .overlay(alignment:.bottom){
        Group{
        HStack{
        //Scale Down
        Button{
        withAnimation(.spring()){
        if imageScale>1{
        imageScale -= 1
            
        if imageScale <= 1{
        resetImageState()
        }
        }
        }
        } label: {
        ControlImageView(symbolname:"minus.magnifyingglass")
        }
        //Reset
        Button{
        resetImageState()
        } label: {
        ControlImageView(symbolname:"arrow.up.left.and.down.right.magnifyingglass")
        }
        //Scale Up
        Button{
        withAnimation(.spring()){
        if imageScale<5{
        imageScale += 1
               
        if imageScale > 5{
        imageScale = 5
        }
        }
        }
        } label: {
        ControlImageView(symbolname:"plus.magnifyingglass")
        }
        }//CONTROLS
        .padding(EdgeInsets(top:12, leading: 20, bottom: 12, trailing: 20))
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .opacity(isAnimating ? 1:0)
            /*alternative
            On HStack
             .frame() //deprciated warning
             .padding(.bottom,30)
             */
        }//GROUP
        .padding(.bottom,30)
        }//OVERLAY
        .navigationTitle("Pinch & Zoom")
        .navigationBarTitleDisplayMode(.inline)
        }.navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.light)
        
    }
}


