//
//  LoginViewController.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2020/11/05.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var idValue: UITextField!
    @IBOutlet weak var pwValue: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginButton(_ sender: UIButton) {
        
        guard let id: String = idValue.text, id.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        guard let pw: String = pwValue.text, pw.isEmpty == false else {
            showAlert(message: "빈칸을 채워주세요")
            return
        }
        let data: [String: String] = ["id": id, "pw": pw]
        print("login data \(data)")
        
        guard let url = URL(string: "http://192.168.35.215:3000/loginProcess") else {
            return
        } // 데이터를 보낼 서버 url
        
        var request = URLRequest(url: url) // URLRequest 구조체 타입인 request 인스턴스 생성
        request.httpMethod = "POST" // httpMethod 프로퍼티에 "POST" 메소드 입력
            
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            // JSONSerializtion 객체는 데이터를 json 형식으로 변경해준다
        } catch {
            print(error.localizedDescription)
        }
        
        // 헤더 필드 추가
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept-Type")
        
        // URLSession을 이용해서 데이터를 서버에 전송
        let session = URLSession.shared
        session.dataTask(with: request) {(data, response, error) in
            DispatchQueue.main.async() {
                if let result = String(data: data!, encoding: .utf8), result == "success" {
                    self.transitionHome()
                } else {
                    self.showAlert(message: "아이디와 비밀번호를 확인해주세요")
                }
            }
        }.resume()
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "알림",
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func transitionHome() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController)
        let rootViewController = UINavigationController(rootViewController: homeViewController)
        
        //self.navigationController?.popToRootViewController(animated: true)
        view.window?.rootViewController = rootViewController
        view.window?.makeKeyAndVisible()
/*
        // navigation stack에 homeView push
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC")
        self.navigationController?.pushViewController(homeViewController!, animated: true)
 */
        
/*
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
*/
        
/*
        // homeViewController에 대한 참조 상수
        let homeViewController = storyboard?.instantiateViewController(identifier:
                                                                        Constants.Storyboard.homeViewController)
                                                                        as? HomeViewController
        
        view.window?.rootViewController = homeViewController // rootViewController 속성에 homeViewController 할당
        view.window?.makeKeyAndVisible() // makekeyAndVisible() 메서드 호출
 */
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
