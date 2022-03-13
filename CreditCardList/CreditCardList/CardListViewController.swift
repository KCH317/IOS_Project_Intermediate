//
//  CardListViewController.swift
//  CreditCardList
//
//  Created by 권찬호 on 2022/03/10.
//

import UIKit
import Kingfisher
import FirebaseDatabase

class CardListViewController: UITableViewController {
    
    var ref: DatabaseReference!     // firebase realtime database를 가지고 올 수 있는 레퍼런스
    
    var creditCardList: [CreditCard] = []
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        // UITableView Cell Register
        let nibName = UINib(nibName: "CardListCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "CardListCell")
        
        self.ref = Database.database().reference()   // 데이터베이스 선언
        
        // 어떤 데이터를 볼 것인지
        self.ref.observe(.value) { snapshot in
            guard let value = snapshot.value as? [String: [String: Any]] else { return }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value)
                let cardData = try JSONDecoder().decode([String: CreditCard].self, from: jsonData)
                let cardList = Array(cardData.values)
                self.creditCardList = cardList.sorted { $0.rank < $1.rank } // 순위대로
                
                // 테이블 뷰 리로드
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } catch let error {
                print("ERROR JSON parsing \(error.localizedDescription)")
            }
        }
    }
    
    // 리스트 수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditCardList.count
    }
     
    // 셀
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardListCell", for: indexPath) as? CardListCell else {return UITableViewCell()}
        
        cell.rankLabel.text = "\(creditCardList[indexPath.row].rank)위"
        cell.promotionLabel.text = "\(creditCardList[indexPath.row].promotionDetail.amount)만원 증정"
        cell.cardNameLabel.text = creditCardList[indexPath.row].name
        
        let imageURL = URL(string: creditCardList[indexPath.row].cardImageUrl)
        cell.cardImageView.kf.setImage(with: imageURL) // Kingfisher 사용
        
        
        return cell
    }
    
    // 셀높이
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // 셀 선택시 동작
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 상세화면전달
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let detailViewController = storyboard.instantiateViewController(identifier: "CardDetailViewController") as? CardDetailViewController else { return }
        
        detailViewController.promotionDetail = creditCardList[indexPath.row].promotionDetail
        self.show(detailViewController, sender: nil)
        
        // 셀선택
        let cardID = creditCardList[indexPath.row].id
//        ref.child("Item\(cardID)/isSelected").setValue(true)
        
        // 셀선택 option2
        self.ref.queryOrdered(byChild: "id").queryEqual(toValue: cardID).observe(.value) {[weak self] snapshot in
            guard let self = self,
                  let value = snapshot.value as? [String: [String: Any]],
                  let key = value.keys.first else { return }
            
            self.ref.child("\(key)/isSelected").setValue(true)
        }
    }
    
    // 행 삭제
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Firebase Realtime Database 삭제
            let cardID = creditCardList[indexPath.row].id
            self.ref.queryOrdered(byChild: "id").queryEqual(toValue: cardID).observe(.value) {[weak self] snapshot in
                guard let self = self,
                      let value = snapshot.value as? [String: [String: Any]],
                      let key = value.keys.first else { return }
                
                self.ref.child(key).removeValue()
            }
            
        }
    }
    
}

