/* This file is modified on and referenced from
   https://github.com/AudioKit/AudioKit
 */
//
//  AppDelegate.swift
//  Recorder
//
//  Created by Aurelius Prochazka, revision history on Github.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import AudioKit
import AudioKitUI
import UIKit
import SpotlightLyrics
import AVFoundation

class RecordViewController: UIViewController {

    var micMixer: AKMixer!
    var recorder: AKNodeRecorder!
    var player: AKPlayer!
    var tape: AKAudioFile!
    var micBooster: AKBooster!
    var moogLadder: AKMoogLadder!
    var mainMixer: AKMixer!

    let mic = AKMicrophone()

    var state = State.readyToRecord
    private var timer: Timer? = nil
    private var currentTime: TimeInterval = 0
    private let totalDuration: TimeInterval = 332
    @IBOutlet private var plot: AKNodeOutputPlot?
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var resetButton: UIButton!
    @IBOutlet private weak var mainButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var lyricsView: LyricsView!
    
    var soundtrack: Soundtrack?
    
    var totalScore = 0
    var volumeScore = 0
    var pitchScore = 0
    
    var audioPlayer = AVAudioPlayer()
    
    var avPlayer: AVPlayer!
    
    enum State {
        case readyToRecord
        case recording
        case readyToPlay
        case playing

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        // Clean tempFiles !
        //AKAudioFile.cleanTempDirectory()

        // Session settings
        AKSettings.bufferLength = .medium

        do {
            try AKSettings.setSession(category: .playAndRecord, with: .allowBluetoothA2DP)
        } catch {
            AKLog("Could not set session category.")
        }

        AKSettings.defaultToSpeaker = true

        // Patching
        let monoToStereo = AKStereoFieldLimiter(mic, amount: 1)
        micMixer = AKMixer(monoToStereo)
        micBooster = AKBooster(micMixer)

        // Will set the level of microphone monitoring
        micBooster.gain = 0
        recorder = try? AKNodeRecorder(node: micMixer)
        if let file = recorder.audioFile {
            player = AKPlayer(audioFile: file)
        }
        player.isLooping = true
        player.completionHandler = playingEnded

        moogLadder = AKMoogLadder(player)

        mainMixer = AKMixer(moogLadder, micBooster)

        AudioKit.output = mainMixer
        do {
            try AudioKit.start()
        } catch {
            AKLog("AudioKit did not start!")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //print(soundtrack?.title)
        plot?.node = mic
        setupButtonNames()
        setupUIForRecording()
        // Read the test LRC file
        guard
            let path = Bundle.main.path(forResource: soundtrack?.title, ofType: "lrc"),
            let stream = InputStream(fileAtPath: path)
            else {
                return
        }
        
        var data = Data.init()
        
        stream.open()
        let bufferSize = 1024
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        while (stream.hasBytesAvailable) {
            let read = stream.read(buffer, maxLength: bufferSize)
            data.append(buffer, count: read)
        }
        stream.close()
        buffer.deallocate()
        let lyrics = String(data: data, encoding: .utf8)
        
        // Initialize the SpotlightLyrics view
        lyricsView.lyrics = lyrics
        lyricsView.lyricFont = UIFont.systemFont(ofSize: 13)
        lyricsView.lyricTextColor = UIColor.lightGray
        lyricsView.lyricHighlightedFont = UIFont.systemFont(ofSize: 13)
        lyricsView.lyricHighlightedTextColor = UIColor.black
        
        
        //Load the music once the view is loaded
        /*
        do{
            //
            
             //try AudioKit.start()
             //let audioFile = try AKAudioFile(forReading: URL(fileURLWithPath: Bundle.main.path(forResource: "XiTieJie", ofType: "mp3")!))
             //let player = try AKAudioPlayer(file: audioFile)
             //player.play()
            
            
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "XiTieJie", ofType: "mp3")!))
            audioPlayer.prepareToPlay();
        }
        catch let exception{
            print(exception)
        }*/
        //print(soundtrack?.title)

    }

    // CallBack triggered when playing has ended
    // Must be seipatched on the main queue as completionHandler
    // will be triggered by a background thread
    func playingEnded() {
        DispatchQueue.main.async {
            self.setupUIForPlaying ()
        }
    }
    private func lv() {
        if (timer != nil) {
            timer?.invalidate()
            timer = nil
        }
        
        currentTime = 0
        lyricsView.scroll(toTime: currentTime, animated: true)
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { (_) in
            self.lyricsView.scroll(toTime: self.currentTime, animated: true)
            self.currentTime += 0.5
            if (self.currentTime >= self.totalDuration) {
                //self.stop()
            }
            
        })
    }
    
    private func lv_reset() {
        if (timer != nil) {
            timer?.invalidate()
            timer = nil
        }
        
        currentTime = 0
        lyricsView.scroll(toTime: currentTime, animated: false)
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { (_) in
            self.lyricsView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .middle, animated: true)


        })
    }
    
    private func bgmPlay(){
        avPlayer = AVPlayer(url: URL.init(fileURLWithPath: Bundle.main.path(forResource: soundtrack?.title, ofType: "mp3")!))
        avPlayer.play();
        print("playing music!")
    }
    
    private func bgmStop(){
        avPlayer.pause()
        avPlayer.seek(to: .zero)
        // try to stop rolling after stopping recording
        //lyricsView.timer.pause()
        //lyricsView.timer.seek(toTime: 0)
        print("Stop playing music!")
    }
    
    @IBAction func mainButtonTouched(sender: UIButton) {
        switch state {
        case .readyToRecord :
            infoLabel.text = "Recording"
        
            
            
            mainButton.setTitle("Stop", for: .normal)
            state = .recording
            // microphone will be monitored while recording
            // only if headphones are plugged
            if AKSettings.headPhonesPlugged {
                micBooster.gain = 1
            }
            do {
                try recorder.record()
            } catch { AKLog("Errored recording.") }
            bgmPlay()
            lv()
            

        case .recording :
            // Microphone monitoring is muted
            micBooster.gain = 0
            tape = recorder.audioFile!
            player.load(audioFile: tape)

            if let _ = player.audioFile?.duration {
                recorder.stop()
                bgmStop()
                tape.exportAsynchronously(name: "TempTestFile.m4a",
                                          baseDir: .documents,
                                          exportFormat: .m4a) {_, exportError in
                    if let error = exportError {
                        AKLog("Export Failed \(error)")
                    } else {
                        AKLog("Export succeeded")
                    }
                }
                setupUIForPlaying()
            }
        case .readyToPlay :
            player.play()
            infoLabel.text = "Playing..."
            mainButton.setTitle("Stop", for: .normal)
            state = .playing
            plot?.node = player

        case .playing :
            player.stop()
            setupUIForPlaying()
            plot?.node = mic
        }
    }

    struct Constants {
        static let empty = ""
    }

    func setupButtonNames() {
        resetButton.setTitle(Constants.empty, for: UIControl.State.disabled)
        mainButton.setTitle(Constants.empty, for: UIControl.State.disabled)
        saveButton.setTitle(Constants.empty, for: UIControl.State.disabled)
        
    }

    func setupUIForRecording () {
        state = .readyToRecord
        infoLabel.text = "Ready to record"
        mainButton.setTitle("Record", for: .normal)
        resetButton.isEnabled = false
        saveButton.isEnabled = false
        resetButton.isHidden = true
        saveButton.isHidden = true
        micBooster.gain = 0
        setSliders(active: false)
//        lyricsView.scroll(toTime: 0, animated: true)
    }

    func setupUIForPlaying () {
        let recordedDuration = player != nil ? player.audioFile?.duration  : 0
        infoLabel.text = "Recorded: \(String(format: "%0.1f", recordedDuration!)) seconds"
        mainButton.setTitle("Play", for: .normal)
        state = .readyToPlay
        resetButton.isHidden = false
        saveButton.isHidden = false
        resetButton.isEnabled = true
        saveButton.isEnabled = true
        setSliders(active: true)
    }

    func setSliders(active: Bool) {

    }

    /*
    @IBAction func loopButtonTouched(sender: UIButton) {

        if player.isLooping {
            player.isLooping = false
            sender.setTitle("Loop is Off", for: .normal)
        } else {
            player.isLooping = true
            sender.setTitle("Loop is On", for: .normal)

        }

    }
 */
    @IBAction func resetButtonTouched(sender: UIButton) {
        player.stop()
        plot?.node = mic
        
        do {
            try recorder.reset()
            
        } catch { AKLog("Errored resetting.") }

        //try? player.replaceFile((recorder.audioFile)!)
        setupUIForRecording()
        //lv_reset()
        lv_reset()
    }
    
    
    @IBAction func saveButtonTouched(_ sender: UIButton) {
        print("Saving Record")
        //player.load(audioFile: tape)
        print(tape)
        //exportAsset(tape, fileName: "test-saving")
        //player.play()
        /*tape.exportAsynchronously(name: "TestFile.caf",
                                  baseDir: .documents,
                                  exportFormat: .caf) {_, exportError in
                                    if let error = exportError {
                                        print("Failed to save file")
                                    } else {
                                        print("Saving File Succeeded")
                                    }
        }*/
    }
    
    /*
    func exportAsset(_ asset: AVAsset, fileName: String) {
        print("\(#function)")
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let trimmedSoundFileURL = documentsDirectory.appendingPathComponent(fileName)
        print("saving to \(trimmedSoundFileURL.absoluteString)")
        
        
        
        if FileManager.default.fileExists(atPath: trimmedSoundFileURL.absoluteString) {
            print("sound exists, removing \(trimmedSoundFileURL.absoluteString)")
            do {
                if try trimmedSoundFileURL.checkResourceIsReachable() {
                    print("is reachable")
                }
                
                try FileManager.default.removeItem(atPath: trimmedSoundFileURL.absoluteString)
            } catch {
                print("could not remove \(trimmedSoundFileURL)")
                print(error.localizedDescription)
            }
            
        }
        
        print("creating export session for \(asset)")
        
        if let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) {
            exporter.outputFileType = AVFileType.m4a
            exporter.outputURL = trimmedSoundFileURL
            
            // e.g. the first 5 seconds
            let startTime = CMTimeMake(0, 1)
            let stopTime = CMTimeMake(5, 1)
            exporter.timeRange = CMTimeRangeFromTimeToTime(startTime, stopTime)
            
            //            // set up the audio mix
            //            let tracks = asset.tracksWithMediaType(AVMediaTypeAudio)
            //            if tracks.count == 0 {
            //                return
            //            }
            //            let track = tracks[0]
            //            let exportAudioMix = AVMutableAudioMix()
            //            let exportAudioMixInputParameters =
            //            AVMutableAudioMixInputParameters(track: track)
            //            exportAudioMixInputParameters.setVolume(1.0, atTime: CMTimeMake(0, 1))
            //            exportAudioMix.inputParameters = [exportAudioMixInputParameters]
            //            // exporter.audioMix = exportAudioMix
            
            // do it
            exporter.exportAsynchronously(completionHandler: {
                print("export complete \(exporter.status)")
                
                switch exporter.status {
                case  AVAssetExportSession.Status.failed:
                    
                    if let e = exporter.error {
                        print("export failed \(e)")
                    }
                    
                case AVAssetExportSession.Status.cancelled:
                    print("export cancelled \(String(describing: exporter.error))")
                default:
                    print("export complete")
                }
            })
        } else {
            print("cannot create AVAssetExportSession for asset \(asset)")
        }
        
    }
    */

    
    func updateFrequency(value: Double) {
        
    }

    func updateResonance(value: Double) {

    }
    
    
    
    @IBAction func showResult(_ sender: Any) {
        // Hardcoded -> testing purposes
        self.totalScore = 10
        self.volumeScore = 20
        self.pitchScore = 30
        
        // Call to the the analyzer
        
        // Jump to the result page
        performSegue(withIdentifier: "redirectResultPage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var viewController = segue.destination as! ResultViewController
        viewController.musicTitle = soundtrack!.title
        viewController.totalScore = self.totalScore
        viewController.pitchScore = self.pitchScore
        viewController.volumeScore = self.volumeScore
    }
    
}
