//
//  ViewController.swift
//  CollectionViewTest
//
//  Created by Дмитрий Толстых on 09/04/2019.
//

import UIKit

private enum Constants {
    static let spacing: CGFloat = 1
    static let borderWidth: CGFloat = 0
    static let reuseID = "wordCell"
}

class ReadArticleCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var pronunciationLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
         
         NSLayoutConstraint.activate([
         contentView.leftAnchor.constraint(equalTo: leftAnchor),
         contentView.rightAnchor.constraint(equalTo: rightAnchor),
         contentView.topAnchor.constraint(equalTo: topAnchor),
         contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
         ])
    }
}

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    var lessonwords:[LessonClass] = []
    
    var zntemp:[CnWord] = []
    
    var SentencesStringArr_ZN:[String] = []
    var SentencesStringArr_PN:[String] = []
    
    var ZNcharacters: [String] = []
    var PNcharacters: [String] = []
    
    var WordNow = 0
    
    var indexPaths = [IndexPath]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Заполняем класс
        
        zntemp.append(CnWord(cnword: "我 星期日 不 忙 ， 有 空儿 ， 什么 事儿 呢 ？", pnword: "wo xingqitian bu mang , you kongr , shenme shir ne ?"))
        zntemp.append(CnWord(cnword: "谢 谢 ! 我 几 点 应该 来 ？", pnword: "xie xie ! wo ji dian yinggai lai ?"))
        zntemp.append(CnWord(cnword: "我 想 请 您 来 我 家 。", pnword: "wo xiang qing nin lai wo jia ."))
        zntemp.append(CnWord(cnword: "我 星期 不 忙 ， 有 空儿 ， 什么 事儿 呢 ？", pnword: "wo xingqi bu mang , you kongr , shenme shir ne ?"))
        
        lessonwords.append(LessonClass(id: 0, cnword: zntemp))
        
        ///
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        dump(lessonwords)
        
        let znch = lessonwords[0].CNWORD
        for word in znch {
            SentencesStringArr_ZN.append(word.CHword)
            SentencesStringArr_PN.append(word.PNword)
        }
        
        WordNow = 0
        
        UpdateWord()
        
        //flow.estimatedItemSize = CGSize(width: 30, height: 60)
        flow.itemSize = UICollectionViewFlowLayout.automaticSize
    }
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var flow: UICollectionViewFlowLayout! {
        didSet {
            flow.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            flow.itemSize = UICollectionViewFlowLayout.automaticSize
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ZNcharacters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let wordCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.reuseID, for: indexPath) as! ReadArticleCollectionViewCell
        
        wordCell.pronunciationLabel.text = ZNcharacters[indexPath.row]
        wordCell.wordLabel.text = PNcharacters[indexPath.row]
        
        indexPaths.append(indexPath)
        
        return wordCell
    }
    
    func UpdateWord() {
        self.PNcharacters.removeAll()
        self.ZNcharacters.removeAll()
        
        let character1 = SentencesStringArr_ZN[WordNow].components(separatedBy: " ")
        for word in character1 {
            PNcharacters.append(word)
        }
        
        let character2 = SentencesStringArr_PN[WordNow].components(separatedBy: " ")
        for word in character2 {
            ZNcharacters.append(word)
        }
        
        self.collectionView.reloadData()
        
        //self.collectionView.reloadItems(at: indexPaths)
    }
    
    @IBAction func NextWord(_ sender: Any) {
        WordNow = WordNow + 1
        UpdateWord()
    }
    
}

class LessonClass: Codable {
    var ID: Int
    var CNWORD: [CnWord]
    
    init(id: Int, cnword: [CnWord]) {
        self.ID = id
        self.CNWORD = cnword
    }
}

class CnWord: Codable {
    var CHword: String
    var PNword: String
    
    init(cnword: String, pnword: String) {
        self.CHword = cnword
        self.PNword = pnword
    }
}
