"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  ""State when the game is finished""

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them.

Public API and Key Messages

- message one
- message two
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.

Internal Representation and Key Implementation Points.


    Implementation Points
"
Class {
	#name : #GameFinishedState,
	#superclass : #Object,
	#instVars : [
		'spaceshipsData'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
GameFinishedState class >> with: someSpaceshipsData [
	^ self new initializeWith: someSpaceshipsData
]

{ #category : #initialization }
GameFinishedState >> initializeWith: someSpaceshipsData [
	spaceshipsData := someSpaceshipsData.
	^ self
]

{ #category : #testing }
GameFinishedState >> isOngoing [
	^ false
]

{ #category : #validation }
GameFinishedState >> validateStateForCards [

Error signal: 'Cards cannot be played after game is over'
]

{ #category : #analyzing }
GameFinishedState >> validateTurn [
	Error signal: 'Game has already ended'.
]

{ #category : #accessing }
GameFinishedState >> winnerOf: someSpaceshipsData after: someLaps [

	| dataForWinner |
	dataForWinner := someSpaceshipsData
		detect: [ :data | data laps >= someLaps ]
		ifNone: [ NotFound signal ].

	^ dataForWinner spaceship
]
