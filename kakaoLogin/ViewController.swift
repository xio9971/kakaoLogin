//
//  ViewController.swift
//  kakaoLogin
//
//  Created by 민트팟 on 2021/05/11.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKTalk
import KakaoSDKCommon
import KakaoSDKTemplate
import KakaoSDKLink


class ViewController: UIViewController {
    
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onKakaoLoginByAppTouched(_ sender: UIButton) {
     // 카카오톡 설치 여부 확인
        
        if (UserApi.isKakaoTalkLoginAvailable()) {
        // 카카오톡 로그인. api 호출 결과를 클로저로 전달.
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                // 예외 처리 (로그인 취소 등)
                print(error)
            }
            else {
                print("loginWithKakaoTalk() success.")
               // do something
                _ = oauthToken
               // 어세스토큰
               let accessToken = oauthToken?.accessToken
            }
        }
        }else {
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoAccount() success.")
                    
                    //do something
                    _ = oauthToken
                    // 어세스토큰
                    let accessToken = oauthToken?.accessToken
                    
                    //카카오 로그인을 통해 사용자 토큰을 발급 받은 후 사용자 관리 API 호출
                    self.setUserInfo()
                }
            }
        }
        
    }
    
    func setUserInfo() {
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                print("me() success.")
                //do something
                _ = user
                self.nicknameLabel.text = user?.kakaoAccount?.profile?.nickname
                
                if let url = user?.kakaoAccount?.profile?.profileImageUrl,
                    let data = try? Data(contentsOf: url) {
                    self.imageView.image = UIImage(data: data)
                }
            }
        }
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {

        /*
         메세지방식 (카카오어플 설치 안되있어도 가능)
         */
        
        let templateId = 53492

        TalkApi.shared.sendCustomMemo(templateId: Int64(templateId), templateArgs: ["msg":"메세지 파라미터"]) {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("success.")
            }
        }
  
        
        /*
         *링크방식 (카카오톡어플 설치 되있어야함) */
        
//        let templateId = 53492
//
//        LinkApi.shared.customLink(templateId: Int64(templateId), templateArgs:["msg":"메세지 파라미터"]) {(linkResult, error) in
//            if let error = error {
//                print(error)
//            }
//            else {
//                print("customLink() success.")
//                if let linkResult = linkResult {
//
//                    print("testlink!!! ->>> \(linkResult.url)")
//                    UIApplication.shared.open(linkResult.url, options: [:], completionHandler: nil)
//                }
//            }
//        }

        
    }
    
    
    
}

