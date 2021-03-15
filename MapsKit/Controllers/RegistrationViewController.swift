//
//  RegistrationViewController.swift
//  MapsKit
//
//  Created by Alex Larin on 01.03.2021.
//

import UIKit
import Kingfisher


class RegistrationViewController: UIViewController {
    
    let userRepository = UserRepository()
    var avatar = ""
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldState()
        addObservers()
    }
    
    @IBAction func createNewAccaunt(_ sender: Any) {
        let login = loginTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        let error = checkTextFields()
        let repeatLogin = try? userRepository.searchUser(login: login)
        if error == nil /*&& ((repeatLogin?.isEmpty) == true)*/ {
            userRepository.saveUserData(login: login, password: password, avatar: avatar)
            performSegue(withIdentifier: "toMain", sender: sender)
        }else{
            let alert = UIAlertController(title: "Error", message: "Аккаунт с таким именем уже существует", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default) { _ in
            }
            alert.addAction(action)
            present(alert, animated: true)
        }
    }
    @IBAction func addAvatar(_ sender: Any) {
        let alert = UIAlertController(title: "Выберете действие", message: "Для установки аватара", preferredStyle: .actionSheet)
        let photo = UIAlertAction(title: "Выбрать из галереи", style: .default){ (_) in
            self.photoSelect(type: .photoLibrary)
        }
        let camera = UIAlertAction(title: "Сделать фото", style: .default){ (_) in
            self.photoSelect(type: .camera)
        }
        let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(photo)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
    // метод проверки заполнения текстовых полей:
    func checkTextFields() -> String? {
        if loginTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Заполните все поля."
        }else{
            return nil
        }
    }
    // состояние полей textField - скрытие текста, автокоррекция:
    func textFieldState() {
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocorrectionType = .no
        loginTextField.autocorrectionType = .no
    }
    // Подписка на уведомления (приложение не активно - активно)
    func addObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(hideTextFields), name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(showTextFields), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    // скрыть логин и пароль
    @objc func hideTextFields() {
        self.passwordTextField.text = "SECURITY"
        self.loginTextField.text = "SECURITY"
        self.passwordTextField.isSecureTextEntry = false
        
    }
    // повтор регистрации
    @objc func showTextFields() {
        let alert = UIAlertController(title: "Error", message: "Повторите ввод", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { _ in
        }
        alert.addAction(action)
        present(alert, animated: true)
        self.passwordTextField.text = ""
        self.loginTextField.text = ""
        self.passwordTextField.isSecureTextEntry = true
    }
    // метод создания UIImagePickerController в зависимости от типа источника изображения:
    func photoSelect(type: UIImagePickerController.SourceType){
        // Проверка, поддерживает ли устройство камеру
        guard UIImagePickerController.isSourceTypeAvailable(type) else { return }
        // Создаём контроллер и настраиваем его
        let imagePickerController = UIImagePickerController()
        // Источник изображений:
        imagePickerController.sourceType = type
        // Изображение можно редактировать
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        
        // Показываем контроллер
        present(imagePickerController, animated: true)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "toMain" else {return}
        let destination = segue.destination as? MainViewController
        destination?.login = loginTextField.text ?? ""
    }
    
}

extension RegistrationViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
// Если нажали на кнопку Отмена, то UIImagePickerController надо закрыть
        picker.dismiss(animated: true)
    }
    // метод, когда выбираем снимок или видео:
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Пытаемся извлечь отредактированное изображение:
        if (info[UIImagePickerController.InfoKey.editedImage] as? UIImage) != nil{
            let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL
            self.avatar = imageURL?.path ?? ""
            // устанавливаем картинку:
            avatarImageView.kf.setImage(with: imageURL)
            // Пытаемся извлечь оригинальное изображение:
        }else if (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) != nil{
            let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL
            self.avatar = imageURL?.path ?? ""
            // устанавливаем картинку:
            avatarImageView.kf.setImage(with: imageURL)
        }
        // Закрываем UIImagePickerController
        picker.dismiss(animated: true)
    }
    
}

