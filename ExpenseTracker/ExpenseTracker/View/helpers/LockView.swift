//
//  LockView.swift
//  LockWithBiometric
//
//  Created by IOS Developer on 15/12/2023.
//

import SwiftUI
import LocalAuthentication

struct LockView<Content:View>: View {
    
    var lockType:LockType
    var lockPin:String
    var isEnabled:Bool
    var lockWhenAppGoesBackground: Bool = true
    var forgotPin:()->() = {}
    
    @ViewBuilder var content:Content
    @State private var pin:String = ""
    @State private var animatedField:Bool = false
    @State private var isUnlocked: Bool = false
    @State private var noBiometricAccess: Bool = false
///lock content
    let context = LAContext()
    ///Scene Phase
    //////\.scenePhase: 这是一个特定的环境键，表示应用程序的当前场景生命周期阶段。场景生命周期阶段包括 .active、.inactive 和 .background，分别表示应用程序在前台活跃、前台非活跃和在后台运行。
    @Environment(\.scenePhase) private var phase;
    var body: some View {
        GeometryReader{
            let size = $0.size
            
            content.frame(width: size.width, height: size.height)
            
            if isEnabled && !isUnlocked{
                ZStack{
                    Rectangle()
                        .fill(.black)
                        .ignoresSafeArea()
                    if (lockType == .both && !noBiometricAccess) || lockType == .biometric {
                        Group{
                            if noBiometricAccess {
                                Text("Enable biometric auth")
                                    .font(.callout)
                                    .multilineTextAlignment(.center)
                                    .padding()
                            } else{
                                
                                //lock image
                                VStack(spacing:20){
                                    VStack(spacing: 6, content: {
                                        Image(systemName: "lock")
                                            .font(.largeTitle)
                                        
                                        Text("Tap to unlock")
                                            .font(.caption2)
                                            .foregroundStyle(.gray)
                                    })
                                    .frame(width: 100,height: 100)
                                    .background( .ultraThinMaterial,in: .rect(cornerRadius:10))
                                    .contentShape(.rect)
                                    .onTapGesture {
                                        unlockView()
                                    }
                                     
                                    if lockType == .both {
                                        Text("Eneter pin")
                                            .frame(width: 100, height: 40)
                                            .background( .ultraThinMaterial ,in: .rect(cornerRadius:10))
                                            .contentShape(.rect)
                                            .onTapGesture {
                                                noBiometricAccess = true
                                            }
                                    }
                                }
                            }
                        }
                    }else{
                        NumberPadPinView()
                    }
                }
                .environment(\.colorScheme,.dark)
                .transition(.offset(y:size.height + 100))
                
            }
            
        }
        .onChange(of: isEnabled, initial: true){
            oldValue,newValue in
            if newValue {
                unlockView()
            }
        }
        ///locking when app goes background
        .onChange(of: phase){oldValue,newValue in
            if newValue != .active && lockWhenAppGoesBackground {
                isUnlocked = false
                pin = ""
            }
            
            if newValue == .active && !isUnlocked && isEnabled {
                unlockView()
            }
        }
    }
    
    private func unlockView(){
        ///checking and unlocking view
        Task{
            if isBiometricAavilable && lockType != .number{
                ///requesting biometric unlock
                if let result = try? await
                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unlock the view"),result {
                    print("unlock")
                    withAnimation(.snappy, completionCriteria: .logicallyComplete) {
                        isUnlocked = true
                    } completion: {
                         pin = ""
                    }

                }
            }
            
            // no bio metritic permission
            noBiometricAccess = !isBiometricAavilable
        }
    }
    
    private var isBiometricAavilable:Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    @ViewBuilder
    func NumberPadPinView()-> some View{
        VStack(spacing: 15,  content: {
            Text("Enter Pin")
                .font(.title.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    if lockType == .both && isBiometricAavilable {
                        Button {
                             pin = ""
                            noBiometricAccess = false
                        } label: {
                            Image(systemName: "arrow.left")
                                .font(.title3)
                                .contentShape(.rect)
                        }
                        .tint(.white)
                        .padding(.leading)
                    }
                }
            
            HStack(spacing: 10, content: {
                ForEach(0..<4, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 50,height: 55)
                    ///showing pin at each box with the help of index
                        .overlay{
                            //save check
                            if pin.count > index {
                                let index = pin.index(pin.startIndex,offsetBy: index)
                                let string = String(pin[index])
                                
                                Text(string)
                                    .font(.title.bold())
                                    .foregroundStyle(.black)
                            }
                        }
                }
            })
            .keyframeAnimator(initialValue: CGFloat.zero, trigger: animatedField, content: { content, value in
                content.offset(x:value)
            }, keyframes: { _ in
                KeyframeTrack{
                    CubicKeyframe(30,duration: 0.07)
                    CubicKeyframe(-30,duration: 0.07)
                    CubicKeyframe(20,duration: 0.07)
                    CubicKeyframe(-20,duration: 0.07)
                    CubicKeyframe(0,duration: 0.07)
                }
            })
            .padding(.top,15)
            .overlay(alignment: .bottomTrailing, content: {
                Button(action:forgotPin, label: {
                    Text("Forget Pin ?")
                        .font(.callout)
                        .foregroundStyle(.white)
                        .offset(y:40)
                })
            })
            .frame(maxHeight:.infinity)
            
            GeometryReader{ _ in
                
                LazyVGrid(columns: Array(repeating: GridItem(), count: 3), content: {
                    
                    ForEach(1...9,id: \.self) { number in
                        Button(action: {
                            //add number to pin
                            if pin.count < 4 {
                                pin.append("\(number)")
                            }
                        } , label: {
                            
                            Text("\(number)")
                                .font(.title)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical,20)
                                .contentShape(.rect)
                        })
                        .tint(.white)
                    }
                    
                    Button(action: {
                        if !pin.isEmpty {
                            pin.removeLast()
                        }
                    }, label: {
                        Image(systemName: "delete.backward")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical,20)
                            .contentShape(.rect)
                    })
                    .tint(.white)
                    
                    Button(action: {
                        if pin.count <= 4 {
                            pin.append("0")
                        }
                    }, label: {
                        Text("0")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical,20)
                            .contentShape(.rect)
                    })
                    .tint(.white)
                    
                    
                })
                .frame(maxHeight: .infinity,alignment: .bottom)
                
            }
            .onChange(of: pin) { oldValue, newValue in
                if newValue.count == 4 {
                    if lockPin == pin {
                        print("unlocked")
                        withAnimation(.snappy, completionCriteria: .logicallyComplete) {
                            isUnlocked = true
                        } completion: {
                            pin = ""
                            noBiometricAccess = !isBiometricAavilable
                        }
                        
                    }else{
                        print("wrong pin")
                        pin = ""
                        animatedField.toggle()
                    }
                }
            }
        })
        .padding()
        .environment(\.colorScheme,.dark)
    }
    
    enum LockType:String{
        case biometric = "Bio metric Auth"
        case number = "Custom Number Lock"
        case both = "First xxxxxxx"
    }
}

#Preview {
    ContentView()
}
