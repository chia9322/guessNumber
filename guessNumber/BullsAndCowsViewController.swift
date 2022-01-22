import UIKit

class BullsAndCowsViewController: UIViewController {
    
    @IBOutlet var inputNumberLabels: [UILabel]!
    @IBOutlet var starImageViews: [UIImageView]!
    @IBOutlet var recordTextView: UITextView!
    @IBOutlet var messageLabel: UILabel!
    
    @IBOutlet var numberButtons: [UIButton]!
    @IBOutlet var okButton: UIButton!
    @IBOutlet var backButton: UIButton!
    
    var starIndex: Int = 5
    var numberOfGuess: Int = 0
    
    var current_idx: Int = -1
    var userNumbers: [Int] = []
    var password: [Int] = []
    
    var resultString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startNewGame()
    }
    
    
    @IBAction func numberPressed(_ sender: UIButton) {
        if current_idx < 3 {
            current_idx += 1
            // 將使用者選擇的數字顯示到上方label
            inputNumberLabels[current_idx].text = String(sender.tag)
            // 關閉數字鍵按鈕功能
            sender.isEnabled = false
        }
    }
    
    @IBAction func deleteNumber(_ sender: Any) {
        if current_idx >= 0 {
            if let currentNumber = Int(inputNumberLabels[current_idx].text!) {
                for numberButton in numberButtons {
                    if numberButton.tag == currentNumber {
                        // 清除上方label
                        inputNumberLabels[current_idx].text = ""
                        // 重新啟用被刪除數字的按鈕
                        numberButton.isEnabled = true
                        // 重設目前數字index
                        current_idx -= 1
                    }
                }
            }
        }
    }
    
    @IBAction func okPressed(_ sender: Any) {
        // 判斷是否為重來按鈕，如果是則重新開始遊戲
        if okButton.title(for: .normal) == "" {
            startNewGame()
        // 如果否代表為OK按鈕，確認使用者輸入的答案
        } else {
            checkAnswer()
        }
    }
    
    func checkAnswer() {
        // 如果使用者沒有輸入完四個數字則不會有任何動作
        if inputNumberLabels[3].text == "" { return }
        
        // 將數字寫入array中
        for numberLabel in inputNumberLabels {
            if let number = Int(numberLabel.text!) {
                userNumbers.append(number)
            }
        }
        
        // AB判斷
        var a: Int = 0
        var b: Int = 0
        for idx in 0...3 {
            if userNumbers[idx] == password[idx] {
                a += 1
            } else if password.contains(userNumbers[idx]) {
                b += 1
            }
        }
        
        // 在textView顯示判斷結果
        var userNumberString: String = ""
        for number in userNumbers {
            userNumberString += String(number)
        }
        resultString += "\(userNumberString) \(a)A\(b)B\n"
        recordTextView.text = resultString
        
        // 更新已猜測次數及更新畫面上的星星數目
        numberOfGuess += 1
        if numberOfGuess%2 == 0 {
            starImageViews[starIndex].image = UIImage(systemName: "")
            starIndex -= 1
        } else {
            starImageViews[starIndex].image = UIImage(systemName: "star.leadinghalf.fill")
        }
        
        // 判斷遊戲是否結束
        if a == 4 {
            messageLabel.text = "You're Right! Total Guess: \(numberOfGuess)"
            gameOver()
            print("gameOver")
        } else if starIndex < 0 {
            var passwordString: String = ""
            for number in password {
                passwordString += String(number)
            }
            messageLabel.text = "Game over. The answer is \(passwordString)"
            gameOver()
        } else {
            resetNumberKeyboard()
        }
    }
    
    func startNewGame() {
        // 重設星星數及猜的次數
        starIndex = 5
        for star in starImageViews {
            star.image = UIImage(systemName: "star.fill")
        }
        numberOfGuess = 0
        
        // 重設鍵盤及遊戲畫面
        resetNumberKeyboard()
        resultString = ""
        recordTextView.text = ""
        messageLabel.text = "What's your guess?"
        
        // 隨機產生四位數密碼
        password = []
        for _ in 0...3 {
            var randomNumber = Int.random(in: 0...9)
            // 如果數字已在password中則再隨機選取一次
            while password.contains(randomNumber) {
                randomNumber = Int.random(in: 0...9)
            }
            password.append(randomNumber)
        }
        print(password)
        
    }
    
    func resetNumberKeyboard() {
        current_idx = -1
        // 重設使用者輸入的數字
        userNumbers = []
        for numberLabel in inputNumberLabels {
            numberLabel.text = ""
        }
        // 重新開啟號碼鍵盤
        for button in numberButtons {
            button.isEnabled = true
        }
        backButton.isEnabled = true
        // 重設OK按鈕樣式
        okButton.setImage(UIImage(systemName: ""), for: .normal)
        okButton.setTitle("OK", for: .normal)
    }
    
    func gameOver() {
        // 關閉所有數字鍵功能
        for button in numberButtons {
            button.isEnabled = false
        }
        // 關閉刪除鍵功能
        backButton.isEnabled = false
        // 將OK鍵改為重新開始樣式
        okButton.setImage(UIImage(systemName: "arrow.counterclockwise.circle"), for: .normal)
        okButton.setTitle("", for: .normal)
    }

}
