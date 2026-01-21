"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  Data for a spaceship

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them.

Public API and Key Messages

- message one
- message two
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.

Internal Representation and Key Implementation Points.

    Instance Variables
	laps:		<Object>
	position:		<Object>
	shields:		<Object>
	spaceship:		<Object>


    Implementation Points
"
Class {
	#name : #SpaceshipLog,
	#superclass : #Object,
	#instVars : [
		'spaceship',
		'shields',
		'position',
		'state',
		'cards'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
SpaceshipLog class >> for: aSpaceship withDeck: someCards [

	^self new initializeFor: aSpaceship withDeck: someCards
]

{ #category : #'instance creation' }
SpaceshipLog class >> randomCardsfor: aSpaceship [

	^self new initializeRandomCardsFor: aSpaceship
]

{ #category : #comparing }
SpaceshipLog >> = anotherSpaceship [

	
	^position = anotherSpaceship position 
]

{ #category : #comparing }
SpaceshipLog >> >= anotherSpaceship [

	self laps = anotherSpaceship laps
		ifFalse: [ ^ self laps >= anotherSpaceship laps ]
		ifTrue: [ ^ self position >= anotherSpaceship position ]
		

		
]

{ #category : #adding }
SpaceshipLog >> addCard: aCard [

cards add: aCard .
]

{ #category : #adding }
SpaceshipLog >> addRandomCard [

	| cardTypes randomCard |
	cardTypes := OrderedCollection
		             with: AccelerationCard
		             with: SpeedCard
		             with: MercenaryCard
		             with: RedoCard
		             with: RepeatCard.
		randomCard := cardTypes atRandom.
		cards add: randomCard new.
]

{ #category : #initialization }
SpaceshipLog >> beginIn: aBoard [

	position := PositionTracker beginIn: aBoard.
]

{ #category : #accessing }
SpaceshipLog >> cards [
^cards 
]

{ #category : #accessing }
SpaceshipLog >> changePositionTo: newPosition [

position := newPosition .
]

{ #category : #accessing }
SpaceshipLog >> changeStateTo: aState [ 

state := aState 
]

{ #category : #adding }
SpaceshipLog >> decreaseShieldsByOne [ 
	shields := shields -1 max: 0.
	shields = 0 ifTrue: [ state := Turn1RechargeState new  ].
]

{ #category : #comparing }
SpaceshipLog >> hash [ 

^shields hash + position hash + spaceship hash 
]

{ #category : #initialization }
SpaceshipLog >> initializeFor: aSpaceship withDeck: someCards [

	spaceship := aSpaceship .
	state := NoPenaltyState new.
	shields := 3.
	cards:= OrderedCollection withAll:  someCards.
]

{ #category : #initialization }
SpaceshipLog >> initializeRandomCardsFor: aSpaceship [

	spaceship := aSpaceship .
	state := NoPenaltyState new.
	shields := 3.
	cards:= OrderedCollection new.
	2 timesRepeat: [ self addRandomCard].
]

{ #category : #accessing }
SpaceshipLog >> laps [
^position laps  
]

{ #category : #accessing }
SpaceshipLog >> move: someSquares [

position move: someSquares 
]

{ #category : #accessing }
SpaceshipLog >> moveTo: aPosition [

	position moveTo:  aPosition 
]

{ #category : #action }
SpaceshipLog >> playIn: aGame [

	state playIn: aGame 
]

{ #category : #accessing }
SpaceshipLog >> position [
^position square
]

{ #category : #adding }
SpaceshipLog >> rechargeShields [

	shields := 3
]

{ #category : #removing }
SpaceshipLog >> removeCardFromHand: aCard [

 cards remove: (aCard class)
]

{ #category : #accessing }
SpaceshipLog >> shields [
^shields 
]

{ #category : #accessing }
SpaceshipLog >> spaceship [
^spaceship 
]

{ #category : #accessing }
SpaceshipLog >> state [ 
^state 
]

{ #category : #validation }
SpaceshipLog >> validateThatSpaceshipHasCard: aCard [
	
	(cards includes: aCard class) ifFalse: [
		Error signal:
			'A Spaceship cannot play a card that is not in its hand' ]
]
