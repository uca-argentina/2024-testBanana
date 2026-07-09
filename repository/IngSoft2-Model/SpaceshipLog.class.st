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
		'maxShields',
		'position',
		'state',
		'cards',
		'hasDoubleNextBattle',
		'deck',
		'name',
		'lastMoveRoll'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
SpaceshipLog class >> for: aSpaceship drawingFrom: aDeck [
	^ self new initializeFor: aSpaceship drawingFrom: aDeck
]

{ #category : #'instance creation' }
SpaceshipLog class >> for: aSpaceship withDeck: someCards [

	^self new initializeFor: aSpaceship withDeck: someCards
]

{ #category : #'instance creation' }
SpaceshipLog class >> randomCardsfor: aSpaceship [
	^ self new initializeRandomCardsFor: aSpaceship
]

{ #category : #comparing }
SpaceshipLog >> >= anotherSpaceship [

	self laps = anotherSpaceship laps
		ifFalse: [ ^ self laps >= anotherSpaceship laps ]
		ifTrue: [ ^ self position >= anotherSpaceship position ]
		

		
]

{ #category : #'as yet unclassified' }
SpaceshipLog >> activateDoubleForNextBattle [
	hasDoubleNextBattle := true.
]

{ #category : #'as yet unclassified' }
SpaceshipLog >> activateDoubleNextBattle [
	hasDoubleNextBattle := true.
]

{ #category : #adding }
SpaceshipLog >> addCard: aCard [
	cards add: aCard
]

{ #category : #adding }
SpaceshipLog >> addCardToHand: aCardClass [
	cards add: aCardClass

]

{ #category : #adding }
SpaceshipLog >> addRandomCard [
	| validTypes |

	validTypes := OrderedCollection
		with: AccelerationCard
		with: SpeedCard
		with: MercenaryCard
		with: RedoCard
		with: RepeatCard.

	cards add: (validTypes atRandom) new
]

{ #category : #accessing }
SpaceshipLog >> asSpaceship [
	^ spaceship
]

{ #category : #converting }
SpaceshipLog >> asSpaceshipLogWithDeck: aDeck [
	deck := aDeck.
	^ self
]

{ #category : #'as yet unclassified' }
SpaceshipLog >> battleRollFrom: aRoll [

	(self consumeDoubleNextBattleIfActive)
		ifTrue: [ ^ aRoll * 2 ].

	^ aRoll
]

{ #category : #initialization }
SpaceshipLog >> beginIn: aBoard [
    position := PositionTracker beginIn: aBoard.

]

{ #category : #initialization }
SpaceshipLog >> cardInstanceFrom: aCardOrCardClass [

	(aCardOrCardClass isBehavior)
		ifTrue: [ ^ aCardOrCardClass new ].

	^ aCardOrCardClass

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
    state := aState.

]

{ #category : #'as yet unclassified' }
SpaceshipLog >> consumeDoubleIfPresent [
	| wasActive |
	wasActive := hasDoubleNextBattle.
	hasDoubleNextBattle := false.
	^ wasActive
]

{ #category : #'as yet unclassified' }
SpaceshipLog >> consumeDoubleNextBattleIfActive [

	| wasActive |

	wasActive := hasDoubleNextBattle = true.
	hasDoubleNextBattle := false.

	^ wasActive
]

{ #category : #'as yet unclassified' }
SpaceshipLog >> consumeDoubleNextIfActive [
	^ self consumeDoubleNextBattleIfActive
]

{ #category : #'as yet unclassified' }
SpaceshipLog >> dealInitialCardsFromOwnDeck [
	2 timesRepeat: [
		cards add: self drawCardFromOwnDeck
	].
]

{ #category : #adding }
SpaceshipLog >> decreaseShieldsByOne [ 
	shields := shields -1 max: 0.
	shields = 0 ifTrue: [ state := Turn1RechargeState new  ].
]

{ #category : #'as yet unclassified' }
SpaceshipLog >> discard: aCard [

	| discard |
	discard addLast: aCard class
]

{ #category : #adding }
SpaceshipLog >> drawCardFromDeck [
	^ deck removeFirst
]

{ #category : #'as yet unclassified' }
SpaceshipLog >> drawCardFromOwnDeck [
	deck ifNil: [ Error signal: 'Deck is missing' ].
	^ deck draw
]

{ #category : #'as yet unclassified' }
SpaceshipLog >> drawFromOwnDeck [
	| card |
	(deck respondsTo: #draw) ifTrue: [ ^ deck draw ].

	card := deck removeFirst.
	deck addLast: card.
	^ card
]

{ #category : #'as yet unclassified' }
SpaceshipLog >> drawOneCardAfterPlaying [

	deck ifNil: [ ^ self ].

	cards add: self drawCardFromOwnDeck.
]

{ #category : #comparing }
SpaceshipLog >> equals: anotherObject [
	^ self = anotherObject
]

{ #category : #'as yet unclassified' }
SpaceshipLog >> hasDoubleNextBattle [
	^ hasDoubleNextBattle = true
]

{ #category : #'as yet unclassified' }
SpaceshipLog >> increaseShieldByOne [

	shields = maxShields ifTrue: [
		maxShields := maxShields + 1 ].

	shields := shields + 1.

]

{ #category : #initialization }
SpaceshipLog >> initializeFor: aSpaceship drawingFrom: aDeck [

	spaceship := aSpaceship.
	deck := aDeck.
	cards := OrderedCollection new.

	maxShields := 3.
	shields := maxShields.

	state := NoPenaltyState new.
	hasDoubleNextBattle := false.
	lastMoveRoll := 0.

	self dealInitialCardsFromOwnDeck.

	^ self
]

{ #category : #initialization }
SpaceshipLog >> initializeFor: aSpaceship withDeck: someCards [

	spaceship := aSpaceship.
	deck := nil.
	cards := OrderedCollection new.

	someCards do: [ :eachCard |
		cards add: (self cardInstanceFrom: eachCard)
	].

	maxShields := 3.
	shields := maxShields.

	state := NoPenaltyState new.
	hasDoubleNextBattle := false.
	lastMoveRoll := 0.

	^ self


]

{ #category : #initialization }
SpaceshipLog >> initializeRandomCardsFor: aSpaceship [
	| validTypes |

	spaceship := aSpaceship.
	state := NoPenaltyState new.

	maxShields := 3.
	shields := maxShields.

	cards := OrderedCollection new.
	hasDoubleNextBattle := false.
	lastMoveRoll := 0.

	validTypes := OrderedCollection
		with: AccelerationCard
		with: SpeedCard
		with: MercenaryCard
		with: RedoCard
		with: RepeatCard.

	2 timesRepeat: [
		cards add: (validTypes atRandom) new
	].

	^ self

]

{ #category : #testing }
SpaceshipLog >> isInNoPenaltyState [
	^ state isKindOf: NoPenaltyState

]

{ #category : #accessing }
SpaceshipLog >> laps [
^position laps  
]

{ #category : #accessing }
SpaceshipLog >> lastMoveRoll [
	^ lastMoveRoll ifNil: [ 0 ].
]

{ #category : #accessing }
SpaceshipLog >> move: someSquares [
	position move: someSquares.
]

{ #category : #'as yet unclassified' }
SpaceshipLog >> moveBy: movement in: aGame [

	| newPosition |
	newPosition := position + movement.
	position := aGame board normalize: newPosition for: self.
	aGame checkBattleAt: position triggeredBy: spaceship.
	aGame checkForWinner.

]

{ #category : #accessing }
SpaceshipLog >> moveTo: aPosition [

	position moveTo:  aPosition 
]

{ #category : #action }
SpaceshipLog >> playIn: aGame [
    state playFor: self in: aGame.

]

{ #category : #accessing }
SpaceshipLog >> position [
^position square
]

{ #category : #adding }
SpaceshipLog >> rechargeShields [

	shields := maxShields.
]

{ #category : #'as yet unclassified' }
SpaceshipLog >> recordLastMoveRoll: aNumber [
	lastMoveRoll := aNumber.
]

{ #category : #removing }
SpaceshipLog >> removeCardFromHand: aCard [

	| wantedClass cardToRemove |

	wantedClass := aCard class.

	cardToRemove := cards
		detect: [ :each |
			(each class = wantedClass) or: [ each = wantedClass ]
		]
		ifNone: [
			Error signal: 'A Spaceship cannot play a card that is not in its hand'
		].

	cards remove: cardToRemove.
]

{ #category : #initialization }
SpaceshipLog >> resetPosition [
	position reset.

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

	| wantedClass |

	wantedClass := aCard class.

	(cards anySatisfy: [ :each |
		(each class = wantedClass) or: [ each = wantedClass ]
	]) ifFalse: [
		Error signal: 'A Spaceship cannot play a card that is not in its hand'
	]
]
