//
//  SpeechManager.swift
//  
//
//  Created by 朱浩宇 on 2022/4/9.
//

import SwiftUI
import Speech
import AVFAudio

public class SpeechManager: NSObject, ObservableObject, SFSpeechRecognizerDelegate {
    public static let shared = SpeechManager()

    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    private var isConfig = false

    public var text: String = ""
    public var lastText = ""

    @Published public var onRecord = ""

    @Published public var mainText = ""

    public override init() {
        super.init()
        config()
    }

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

    public func startRecord() {
        print("do")

        if audioEngine.isRunning {
            stopRecord()
        }

        self.text = ""
        self.lastText = ""

        do {
            recognitionTask?.cancel()
            self.recognitionTask = nil

            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .measurement, options: [.defaultToSpeaker, .allowAirPlay, .allowBluetoothA2DP, .allowBluetooth])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            let inputNode = audioEngine.inputNode

            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

            guard let recognitionRequest = recognitionRequest else { return }

            recognitionRequest.shouldReportPartialResults = true
            recognitionRequest.requiresOnDeviceRecognition = true

            recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
                if let result = result {
                    for segments in result.bestTranscription.segments {
                        if segments.duration > 0.1 {
                            self.lastText += (self.text + " ")
                            self.text = ""
                            return
                        }
                    }

                    self.text = result.bestTranscription.formattedString

                    self.mainText = self.lastText + self.text

                    print(self.mainText)
                }
            }

            let recordingFormat = inputNode.outputFormat(forBus: 1)
            inputNode.removeTap(onBus: 1)
            inputNode.installTap(onBus: 1, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
                self.recognitionRequest?.append(buffer)
            }

            audioEngine.prepare()
            try audioEngine.start()
        } catch {
            print(error)
        }
    }

    public func stopRecord() {
        self.audioEngine.stop()
        self.recognitionRequest?.endAudio()
        self.recognitionTask?.cancel()
        self.recognitionTask = nil
    }
}

extension SpeechManager {
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if !available {
            DeviceState.shared.notSupport()
        }
    }
}
