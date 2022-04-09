//
//  SpeechManager.swift
//  
//
//  Created by 朱浩宇 on 2022/4/9.
//

import SwiftUI
import Speech

class SpeechManager: NSObject, ObservableObject, SFSpeechRecognizerDelegate {
    static let shared = SpeechManager()

    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en_US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    private var isConfig = false

    @Published var text: String = ""
    var needToAppend = false
    @Published var lastText = ""

    @Published var onRecord = ""

    func config() {
        speechRecognizer?.delegate = self

        SFSpeechRecognizer.requestAuthorization { [weak self] (status) in
            switch status {
            case .authorized:
                self?.isConfig = true
            case .notDetermined: break
            case .denied: break
            case .restricted: break
            default: break
            }
        }
    }

    func startRecord() {
        if !isConfig {
            config()
        }

        if audioEngine.isRunning {
            stopRecord()
        }

        self.text = ""
        self.lastText = ""

        do {
            recognitionTask?.cancel()
            self.recognitionTask = nil

            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            let inputNode = audioEngine.inputNode

            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            guard let recognitionRequest = recognitionRequest else { return }

            recognitionRequest.shouldReportPartialResults = true
            recognitionRequest.requiresOnDeviceRecognition = true

            recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
                var isFinal = false

                if let result = result {
                    isFinal = result.isFinal

                    for segments in result.bestTranscription.segments {
                        if segments.duration > 0.1 {
                            self.lastText += (self.text + " ")
                            self.text = ""
                            return
                        }
                    }

                    self.text = result.bestTranscription.formattedString
                }

                if error != nil || isFinal {
                    self.audioEngine.stop()
                    inputNode.removeTap(onBus: 0)

                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                }
            }

            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.removeTap(onBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
                self.recognitionRequest?.append(buffer)
            }

            audioEngine.prepare()
            try audioEngine.start()
        } catch {
            print(error)
        }
    }

    func stopRecord() {
        self.audioEngine.stop()
        self.recognitionRequest?.endAudio()
        self.recognitionTask?.cancel()
        self.recognitionTask = nil
    }

    @objc func silence() {
        needToAppend = true
    }
}

extension SpeechManager {
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if !available {
            // TODO: Not support
            print("not support")
        }
    }
}