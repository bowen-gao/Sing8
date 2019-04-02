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
    private var ftimer: Timer? = nil
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
    var volumeScore = 0.0
    var pitchScore = 0
    var comment = ""
    var recordFile = ""
    var count = 0
    @IBOutlet weak var currentScoreLabel: UILabel!
    @IBOutlet weak var correctKeyLabel: UILabel!
    @IBOutlet weak var userKeyLabel: UILabel!
    
    let noteFrequencies = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    let noteNamesWithSharps = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
    let noteNamesWithFlats = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]
    var micarray:[Float]=[]
    var playerarray:[Float]=[]
    var pitchscore_array:[Int]=[]
    var audioPlayer = AVAudioPlayer()
    
    var bgm_player: AKPlayer!
    
    var tracker_mic: AKFrequencyTracker!
    var tracker_player: AKFrequencyTracker!
    
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
        do{
            let file = try AKAudioFile(forReading: URL.init(fileURLWithPath: Bundle.main.path(forResource: soundtrack?.title, ofType: "mp3")!))
            bgm_player = AKPlayer(audioFile: file)
        }
        catch{
            AKLog("bgm player error")
        }
        moogLadder = AKMoogLadder(player)
        tracker_mic = AKFrequencyTracker(mic)
        tracker_player = AKFrequencyTracker(bgm_player)
        mainMixer = AKMixer(moogLadder, micBooster, tracker_mic, tracker_player)
        AudioKit.output = mainMixer
        do {
            try AudioKit.start()
        } catch {
            AKLog("AudioKit did not start!")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool){
        do{
            try AudioKit.stop()
        }catch{
            print("error")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        //print(soundtrack?.title)
        do{
            //let file = try AKAudioFile(forReading: URL.init(fileURLWithPath: Bundle.main.path(forResource: soundtrack?.title, ofType: "mp3")!))
            let filename = soundtrack?.title
            let file = try AKAudioFile(readFileName: filename ?? " ")
            bgm_player.load(audioFile: file)
        }
        catch{
            AKLog("bgm player error")
        }
        pitchscore_array=[]
        micarray=[]
        playerarray=[]
        pitchScore=0
        volumeScore=100
        bgm_player.isLooping = true
        bgm_player.completionHandler = playingEnded
        currentScoreLabel.text = "0"
        correctKeyLabel.text = "-"
        userKeyLabel.text = "-"
        plot?.node = mic
        setupButtonNames()
        setupUIForRecording()
        // Read the test LRC file
        var name = soundtrack?.title
        let newname = String(name?.dropLast(4) ?? " ")
        print(newname)
        guard
            let path = Bundle.main.path(forResource: newname, ofType: "lrc"),
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
        
        currentTime = -8
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
        print(soundtrack?.title)
        bgm_player.play();
        print("playing music!")
    }
    
    private func bgmStop(){
        bgm_player.pause()
        //bgm_player.seek(to: .zero)
        // try to stop rolling after stopping recording
        //lyricsView.timer.pause()
        //lyricsView.timer.seek(toTime: 0)
        print("Stop playing music!")
    }
    @objc func updateF() {
        //infoLabel.text = String(format: "%0.1f", tracker.frequency)
        //print(tracker.amplitude)
        count = count + 1
        if(count<150){
            return
        }
        if(tracker_player.frequency>1000){
            return
        }
        print(tracker_player.frequency)
        if(tracker_mic.amplitude > 0.02){
            var f=Float(tracker_mic.frequency)
            micarray.append(f)
        }
        if(tracker_player.amplitude > 0.05){
            var f=Float(tracker_player.frequency)
            playerarray.append(f)
        }
        if micarray.count == 10 {
            
            var n=micarray.count
            var m=playerarray.count
            if(m<1){
                return
            }
            var dtw = Array(repeating: Array(repeating: 0.0, count: m+1), count: n+1)
            for i in 1...n {
                dtw[i][0] = Double.infinity
            }
            for i in 1...m {
                dtw[0][i] = Double.infinity
            }
            dtw[0][0] = 0
            for i in 1...n {
                for j in 1...m {
                    var cost = abs(micarray[i-1] - playerarray[j-1])
                    dtw[i][j] = cost + min(dtw[i-1][j], dtw[i][j-1], dtw[i-1][j-1])    // match
                }
            }
            var sum = playerarray.reduce(0, +)
            var cur_score = Int(100*(1 - dtw[n][m] / sum))
            if cur_score<0 {
                cur_score=0
            }
            pitchscore_array.append(cur_score)
            self.pitchScore = Int(pitchscore_array.reduce(0, +)/pitchscore_array.count)
            currentScoreLabel.text = String(self.pitchScore)
            micarray=[]
            playerarray=[]
        }
        if tracker_player.amplitude > 0.05 {
            //print(tracker_player.frequency)
            var frequency = Float(tracker_player.frequency)
            while frequency > Float(noteFrequencies[noteFrequencies.count - 1]) {
                frequency /= 2.0
            }
            while frequency < Float(noteFrequencies[0]) {
                frequency *= 2.0
            }
            
            var minDistance: Float = 10_000.0
            var index = 0
            
            for i in 0..<noteFrequencies.count {
                let distance = fabsf(Float(noteFrequencies[i]) - frequency)
                if distance < minDistance {
                    index = i
                    minDistance = distance
                }
            }
            let octave = Int(log2f(Float(tracker_player.frequency) / frequency))

            //print("\(noteNamesWithSharps[index])\(octave)")
            correctKeyLabel.text = "\(noteNamesWithSharps[index])\(octave)"

            //noteNameWithFlatsLabel.text = "\(noteNamesWithFlats[index])\(octave)"
        }
        if tracker_mic.amplitude > 0.05 {
            var frequency = Float(tracker_mic.frequency)
            while frequency > Float(noteFrequencies[noteFrequencies.count - 1]) {
                frequency /= 2.0
            }
            while frequency < Float(noteFrequencies[0]) {
                frequency *= 2.0
            }
            
            var minDistance: Float = 10_000.0
            var index = 0
            
            for i in 0..<noteFrequencies.count {
                let distance = fabsf(Float(noteFrequencies[i]) - frequency)
                if distance < minDistance {
                    index = i
                    minDistance = distance
                }
            }
            let octave = Int(log2f(Float(tracker_mic.frequency) / frequency))
            
            //print("\(noteNamesWithSharps[index])\(octave)")
            userKeyLabel.text = "\(noteNamesWithSharps[index])\(octave)"
            
            //noteNameWithFlatsLabel.text = "\(noteNamesWithFlats[index])\(octave)"
        }
        if 2*tracker_mic.amplitude < tracker_player.amplitude {
            self.volumeScore = self.volumeScore-0.1
        }
        else if tracker_mic.amplitude > tracker_mic.amplitude*3 {
            self.volumeScore = self.volumeScore-0.1
        }
        else {
            self.volumeScore = self.volumeScore + 0.1
        }
        if self.volumeScore<0 {
            self.volumeScore = 0
        }
        if self.volumeScore>100 {
            self.volumeScore = 100
        }
        
    }
    @IBAction func mainButtonTouched(sender: UIButton) {
        do {
            try AudioKit.start()
        } catch {
            AKLog("AudioKit did not start!")
        }
        if (ftimer != nil) {
            ftimer?.invalidate()
            ftimer = nil
        }
        count = 0
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
            self.volumeScore = 100
            ftimer=Timer.scheduledTimer(timeInterval: 0.1,
                                 target: self,
                                 selector: #selector(RecordViewController.updateF),
                                 userInfo: nil,
                                 repeats: true)

        case .recording :
            // Microphone monitoring is muted
            micBooster.gain = 0
            tape = recorder.audioFile!
            player.load(audioFile: tape)

            if let _ = player.audioFile?.duration {
                recorder.stop()
                bgmStop()
                let currentTime = NSDate()
                let formatter = DateFormatter()
                formatter.timeZone = TimeZone.current
                formatter.dateFormat = "yyyy-MM-dd-HH-mm"
                let timeStamp = formatter.string(from: currentTime as Date)
                let fileName = "record+"+timeStamp+"+"+(soundtrack?.title)!+"+"+String(Int(0.8*self.pitchScore+0.2*self.volumeScore))+"+"
                // Filename Format: record+timeStamp+musicName+score+.wav
                self.recordFile = fileName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!+".wav"
                tape.exportAsynchronously(name: self.recordFile,
                                          baseDir: .documents,
                                          exportFormat: .wav) {_, exportError in
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
        pitchscore_array=[]
        pitchScore=0
        volumeScore=100
        micarray=[]
        playerarray=[]
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
        
    }
    

    
    func updateFrequency(value: Double) {
        
    }

    func updateResonance(value: Double) {

    }
    
    
    
    @IBAction func showResult(_ sender: Any) {
        
        // Hardcoded -> testing purposes
        self.totalScore = Int(0.8*self.pitchScore+0.2*self.volumeScore)
        //self.volumeScore = 20
        //self.pitchScore = 30
        if self.pitchScore>80 {
            self.comment="Excellent pitch accuracy!"
        }
        else {
            self.comment="You should improve pitch accuracy!"
        }
        if self.volumeScore>80 {
            self.comment=self.comment+"\nNice voice！"
        }
        else{
            self.comment=self.comment+"\nYou should sing louder!"
        }


        // Jump to the result page
        performSegue(withIdentifier: "redirectResultPage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var viewController = segue.destination as! ResultViewController
        viewController.musicTitle = soundtrack!.title
        viewController.totalScore = self.totalScore
        viewController.pitchScore = self.pitchScore
        viewController.volumeScore = Int(self.volumeScore)
        viewController.comment = self.comment
        viewController.fileName = self.recordFile
    }
    
}
