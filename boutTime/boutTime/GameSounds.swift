//
//  GameSounds.swift
//  boutTime
//
//  Created by James McMillan on 7/12/16.
//  Copyright © 2016 jamesdmcmillan. All rights reserved.
//

import AudioToolbox

// Sound Effects Variables
var gameSound: SystemSoundID = 0
var gameSoundCorrect: SystemSoundID = 0
var gameSoundIncorrect: SystemSoundID = 0
var gameSoundFinished: SystemSoundID = 0
var gameSoundRetry: SystemSoundID = 0
var gameSoundTimerEnd: SystemSoundID = 0


// Sound effects helper methods, many of these were copied over from Project 2

struct SoundEffects {

    func loadGameSoundCorrect() {
        let pathToSoundFile = NSBundle.mainBundle().pathForResource("GameSoundCorrect", ofType: "wav")
        let soundURL = NSURL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL, &gameSoundCorrect)
    }

    func playGameSoundCorrect() {
        AudioServicesPlaySystemSound(gameSoundCorrect)
    }

    func loadGameSoundIncorrect() {
        let pathToSoundFile = NSBundle.mainBundle().pathForResource("GameSoundIncorrectBuzz", ofType: "wav")
        let soundURL = NSURL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL, &gameSoundIncorrect)
    }

    func playGameSoundIncorrect() {
        AudioServicesPlaySystemSound(gameSoundIncorrect)
    }

    func loadGameSoundTimerEnd() {
        let pathToSoundFile = NSBundle.mainBundle().pathForResource("GameSoundTimerEnd", ofType: "wav")
        let soundURL = NSURL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL, &gameSoundTimerEnd)
    }

    func playGameSoundTimerEnd() {
        AudioServicesPlaySystemSound(gameSoundTimerEnd)
    }

    func loadGameSoundFinished() {
        let pathToSoundFile = NSBundle.mainBundle().pathForResource("GameSoundFinished", ofType: "wav")
        let soundURL = NSURL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL, &gameSoundFinished)
    }

    func playGameSoundFinished() {
        AudioServicesPlaySystemSound(gameSoundFinished)
    }

    func loadGameSoundRetry() {
        let pathToSoundFile = NSBundle.mainBundle().pathForResource("GameSoundRetry", ofType: "wav")
        let soundURL = NSURL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL, &gameSoundRetry)
    }

    func playGameSoundRetry() {
        AudioServicesPlaySystemSound(gameSoundRetry)
    }
}