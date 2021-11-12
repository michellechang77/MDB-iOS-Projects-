import UIKit

class MainVC: UIViewController {
    @objc func didTap() {
        present(RecordVC())
    }
}

class RecordVC: UIViewController {
    
    var voice: [Int] = []
    
    override func viewDidLoad() {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 3) { [weak self]
            guard let self = self else { return }
            self.send()
        }
    }
    
    func send() {
        
    }
}
