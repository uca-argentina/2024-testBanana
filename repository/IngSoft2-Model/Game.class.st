Class {
	#name : #Game,
	#superclass : #Object,
	#instVars : [
		'spaceships',
		'board',
		'state',
		'dice',
		'spaceshipsData',
		'laps',
		'activeCards',
		'lastTypeOfCardPlayed',
		'lastEffectTriggered',
		'doubleTarget',
		'lastRolls',
		'spaceshipWithDouble',
		'deck'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #initialization }
Game class >> playedBy: someSpaceships on: aBoard throwing: someDice wonAfter: aNumberOfLaps [
	^ self new
		initializePlayedBy: someSpaceships
		on: aBoard
		throwing: someDice
		wonAfter: aNumberOfLaps
]

{ #category : #initialization }
Game class >> playedBy: somePlayers
	on: aBoard
	throwing: someDice
	wonAfter: aNumberOfLaps
	usingDeck: aDeck [

	| logs |

	logs := somePlayers collect: [ :each |
		SpaceshipLog
			for: each asSpaceship
			drawingFrom: aDeck
	].

	^ self new
		initializePlayedBy: logs
		on: aBoard
		throwing: someDice
		wonAfter: aNumberOfLaps
		usingDeck: aDeck
]

{ #category : #adding }
Game >> addActiveCard: aCard [

lastTypeOfCardPlayed := aCard class.
activeCards add: aCard.

]

{ #category : #adding }
Game >> addCardFor: aSpaceship [

	| log |
	log := self dataFor: aSpaceship.
	log addCard: deck draw.

]

{ #category : #adding }
Game >> addRandomCardFor: aSpaceship [

(self dataFor: aSpaceship) addRandomCard.
]

{ #category : #'as yet unclassified' }
Game >> applyBattlePenaltyTo: aLoserLog [

	(self shipsAffectedByBattleLossOf: aLoserLog)
		do: [ :ship |
			(self dataFor: ship) decreaseShieldsByOne
		].

	aLoserLog resetPosition.
]

{ #category : #accessing }
Game >> applyEffectFor: aSpaceship afterMovingTo: aSquare whenPlaying: aGame [
	^ board applyEffectFor: aSpaceship afterMovingTo: aSquare whenPlaying: aGame
]

{ #category : #action }
Game >> applyHyperSpaceJumpFor: aSpaceship [ 

	self  decreaseShieldByOneOf: aSpaceship.
	(self dataFor: aSpaceship ) move: 4.
	
]

{ #category : #action }
Game >> applyMoonwalkFor: aSpaceship  movingOthersBack: someSquares [
	self moveAllBut: aSpaceship back: someSquares.

]

{ #category : #'as yet unclassified' }
Game >> areAllied: aSpaceship and: anotherSpaceship [

	^ activeCards anySatisfy: [ :card |
		card
			createsAllianceBetween: aSpaceship
			and: anotherSpaceship
	]
]

{ #category : #action }
Game >> battleBetween: aSpaceship and: anotherSpaceship [

	| logA logB battleA battleB loserLog |

	(self areAllied: aSpaceship and: anotherSpaceship)
		ifTrue: [ ^ self ].

	logA := self dataFor: aSpaceship.
	logB := self dataFor: anotherSpaceship.

	battleA := self battleRollFor: logA.
	battleB := self battleRollFor: logB.

	"En battleBetween:, si empatan pierde el primero."
	loserLog := (battleA <= battleB)
		ifTrue: [ logA ]
		ifFalse: [ logB ].

	self applyBattlePenaltyTo: loserLog.


]

{ #category : #action }
Game >> battleRollFor: aSpaceshipLog [

	| totalRoll |

	totalRoll := self throwDiceFor: aSpaceshipLog spaceship.

	(self mercenariesOf: aSpaceshipLog spaceship)
		do: [ :mercenary |
			totalRoll := totalRoll
				+ (self throwDiceFor: mercenary)
		].

	^ aSpaceshipLog battleRollFrom: totalRoll
]

{ #category : #action }
Game >> cardBonusFor: aSpaceship [

	| bonus |

	bonus := 0.

	activeCards do: [ :each |
		bonus := bonus + (each movementBonusFor: aSpaceship)
	].

	^ bonus
]

{ #category : #action }
Game >> changeStateOf: aSpaceship to: aState [

	(self dataFor: aSpaceship ) changeStateTo: aState 
]

{ #category : #'as yet unclassified' }
Game >> checkBattleFor: aSpaceship [

	| itsPosition rival |

	itsPosition := self positionOf: aSpaceship.

	rival := spaceshipsData
		detect: [ :log |
			log spaceship ~= aSpaceship
			and: [ log position = itsPosition ] ]
		ifNone: [ ^ self ].

	self battleBetween: aSpaceship and: rival spaceship.


]

{ #category : #'as yet unclassified' }
Game >> checkForWinnerFor: aSpaceship [

	((self lapsOf: aSpaceship) >= laps)
		ifTrue: [ self end ].

]

{ #category : #'as yet unclassified' }
Game >> consumeDouble [
	spaceshipWithDouble := nil.


]

{ #category : #converting }
Game >> convertToSquares: aParsecDistance [
	^board convertToSquares: aParsecDistance
	
]

{ #category : #accessing }
Game >> dataFor: aSpaceship [
    ^ spaceshipsData
        detect: [:data |
            data spaceship == aSpaceship ]
        ifNone: [ Error signal: 'That spaceship is not a player in this game' ].


]

{ #category : #'as yet unclassified' }
Game >> dealInitialCards [

	spaceshipsData do: [:log |
		2 timesRepeat: [
			log addCard: deck draw
		]
	].

]

{ #category : #adding }
Game >> decreaseAllShieldsByOne [

	spaceshipsData do: [ :dataForASpaceship |
		dataForASpaceship decreaseShieldsByOne ]
]

{ #category : #adding }
Game >> decreaseShieldByOneOf: aSpaceship [

	(self dataFor: aSpaceship) decreaseShieldsByOne  
]

{ #category : #action }
Game >> detonateAtomicBomb [
	self moveAllBackToBeginning .
	self decreaseAllShieldsByOne .
]

{ #category : #accessing }
Game >> dice [
^ dice.
]

{ #category : #adding }
Game >> end [
	state := GameFinishedState new.

]

{ #category : #'as yet unclassified' }
Game >> hasDoubleFor: aSpaceship [
	^ spaceshipWithDouble = aSpaceship


]

{ #category : #'as yet unclassified' }
Game >> increaseShieldByOneOf: aSpaceship [
    (self dataFor: aSpaceship) increaseShieldByOne.

]

{ #category : #initialization }
Game >> initializePlayedBy: somePlayers
	on: aBoard
	throwing: someDice
	wonAfter: aNumberOfLaps [

	spaceshipsData := OrderedCollection newFrom: (somePlayers collect: [:each |
		(each isKindOf: SpaceshipLog)
			ifTrue: [ each ]
			ifFalse: [ SpaceshipLog randomCardsfor: each ]
	]).

	board := aBoard.

	self initializeSpaceships.

	state := GameOngoingState new.
	dice := someDice.
	laps := aNumberOfLaps.
	activeCards := OrderedCollection new.
	lastEffectTriggered := NullEffect new.
]

{ #category : #initialization }
Game >> initializePlayedBy: someSpaceships 
	on: aBoard 
	throwing: someDice 
	wonAfter: aNumberOfLaps 
	usingDeck: aDeck [

	spaceshipsData := OrderedCollection withAll: someSpaceships.
	board := aBoard.
	deck := aDeck.

	self initializeSpaceships.
	self dealInitialCards.

	state := GameOngoingState new.
	dice := someDice.
	laps := aNumberOfLaps.
	activeCards := OrderedCollection new.
	lastEffectTriggered := NullEffect new.

]

{ #category : #initialization }
Game >> initializeSpaceships [
	spaceships := OrderedCollection newFrom: (spaceshipsData collect: [:dataForASpaceship |
		dataForASpaceship spaceship
	]).

	spaceshipsData do: [:dataForASpaceship |
		dataForASpaceship beginIn: board
	].

]

{ #category : #action }
Game >> is: spaceship in: position [

	^ (self positionOf: spaceship) = position
]

{ #category : #action }
Game >> is: spaceship notAnAllyOf: aSpaceship [

	^ activeCards allSatisfy: [ :card |
		  (card is: aSpaceship anAllyOf: spaceship) not ]
]

{ #category : #accessing }
Game >> isOngoing [

^ state isOngoing.
]

{ #category : #testing }
Game >> isPermanentCard: aCard [

	| cls |

	cls := aCard class.

	(cls = RedoCard) ifTrue: [ ^ false ].
	(cls = CancellationCard) ifTrue: [ ^ false ].
	(cls = RepeatCard) ifTrue: [ ^ false ].

	^ true
]

{ #category : #accessing }
Game >> lapsOf: aSpaceship [ 
 ^ (self dataFor:  aSpaceship) laps
]

{ #category : #accessing }
Game >> leaderBoard [

	^ spaceships asSortedCollection: [ :sp1 :sp2 |
		  (self dataFor: sp1) >= (self dataFor: sp2) ]
]

{ #category : #action }
Game >> make: aSpaceship move: someSquares [
	(self dataFor: aSpaceship) move: someSquares

]

{ #category : #'as yet unclassified' }
Game >> mercenariesOf: aSpaceship [

	| mercenaries |

	mercenaries := OrderedCollection new.

	activeCards do: [ :each |
		each addMercenariesOf: aSpaceship to: mercenaries
	].

	^ mercenaries
]

{ #category : #action }
Game >> move: aSpaceship byParsecs: aParsecAmount [

	| squaresToMove |
	squaresToMove := self convertToSquares: aParsecAmount.
	self make: aSpaceship move: squaresToMove.
]

{ #category : #action }
Game >> move: aSpaceship to: aPosition [ 

	(self dataFor: aSpaceship) moveTo: aPosition  .

]

{ #category : #action }
Game >> moveAllBackToBeginning [
	
	spaceshipsData do: [ :dataForASpaceship | dataForASpaceship moveTo: 1 ]
]

{ #category : #action }
Game >> moveAllBut: aSpaceship back: someSquares [

	| backAmount |
	backAmount := someSquares abs.

	spaceshipsData do: [:log |
		(log spaceship == aSpaceship)
			ifFalse: [ log move: backAmount negated ]
	].
]

{ #category : #accessing }
Game >> nextSpaceshipToPlay [
	^ spaceships first.
]

{ #category : #adding }
Game >> nextTurn [

	|aSpaceship|
	aSpaceship := spaceships removeFirst.
	spaceships addLast: aSpaceship.
	
]

{ #category : #'as yet unclassified' }
Game >> play: aCard from: aSpaceship targeting: anotherTarget [

	| spaceshipData |

	aCard validateTarget: anotherTarget in: self.
	self validateIf: aCard canBePlayedBy: aSpaceship.

	spaceshipData := self dataFor: aSpaceship.
	spaceshipData removeCardFromHand: aCard.

	aCard
		from: aSpaceship
		withTarget: anotherTarget
		useIn: self.

	aCard shouldBeRememberedAsLastPlayedCard
		ifTrue: [
			lastTypeOfCardPlayed := aCard class
		].

	spaceshipData drawOneCardAfterPlaying.
]

{ #category : #action }
Game >> playTurn [

	state validateTurn.
	self playTurnFor: self nextSpaceshipToPlay.
]

{ #category : #'as yet unclassified' }
Game >> playTurnFor: aSpaceship [

	(self dataFor: aSpaceship) playIn: self.
	self nextTurn.
]

{ #category : #accessing }
Game >> players [
	^ spaceshipsData collect: [ :each | each spaceship ]


]

{ #category : #accessing }
Game >> positionOf: aSpaceship [ 

	^(self dataFor: aSpaceship )  position
]

{ #category : #adding }
Game >> rechargeShieldsOf: aSpaceship [
	(self dataFor: aSpaceship ) rechargeShields
]

{ #category : #action }
Game >> redoLastCardPlayedFor: aSpaceship withTarget: aTarget [
	| aCard |
	self validateLastCardPlayed.
	(self dataFor: aSpaceship) addCard: lastTypeOfCardPlayed. 
	aCard:= lastTypeOfCardPlayed new.
	self play: aCard from: aSpaceship  targeting: aTarget
]

{ #category : #'as yet unclassified' }
Game >> removeActiveCard: aCard [

	self validateActiveCardSelected: aCard.
	activeCards remove: aCard.
]

{ #category : #action }
Game >> repeatLastEffectFor: aSpaceship [ 

	lastEffectTriggered applyIn: self for: aSpaceship.	
	lastTypeOfCardPlayed := RepeatCard .
	
	

]

{ #category : #action }
Game >> resolveBattleIfNeededFor: aSpaceship arrivingWith: arrivingRoll [

	| square opponentLog currentLog currentBattleRoll opponentBattleRoll loserLog |

	square := self positionOf: aSpaceship.
	square = 1 ifTrue: [ ^ self ].

	opponentLog := spaceshipsData
		detect: [ :log |
			(log spaceship ~~ aSpaceship)
				and: [ (self positionOf: log spaceship) = square ] ]
		ifNone: [ ^ self ].

	(self areAllied: aSpaceship and: opponentLog spaceship)
		ifTrue: [ ^ self ].

	currentLog := self dataFor: aSpaceship.

	currentBattleRoll := self battleRollFor: currentLog.
	opponentBattleRoll := self battleRollFor: opponentLog.

	loserLog := (currentBattleRoll <= opponentBattleRoll)
		ifTrue: [ currentLog ]
		ifFalse: [ opponentLog ].

	self applyBattlePenaltyTo: loserLog.
]

{ #category : #adding }
Game >> saveLastEffectTriggeredTo: anEffect [

lastEffectTriggered := anEffect deepCopy .
]

{ #category : #accessing }
Game >> shieldsOf: aSpaceship [ 

	^(self dataFor: aSpaceship) shields 
]

{ #category : #'as yet unclassified' }
Game >> shipsAffectedByBattleLossOf: aLoserLog [

	| loserShip affectedShips uniqueShips |

	loserShip := aLoserLog spaceship.

	affectedShips := OrderedCollection new.
	affectedShips add: loserShip.

	activeCards do: [ :card |
		card
			shipsAffectedByLossOf: loserShip
			addTo: affectedShips
	].

	uniqueShips := OrderedCollection new.

	affectedShips do: [ :ship |
		(uniqueShips anySatisfy: [ :each |
			each == ship
		])
			ifFalse: [ uniqueShips add: ship ]
	].

	^ uniqueShips
]

{ #category : #action }
Game >> skipTurn [
	|aSpaceship|
	aSpaceship := self nextSpaceshipToPlay .
	self rechargeShieldsOf: aSpaceship.
	self nextTurn.
	
]

{ #category : #action }
Game >> speedBonusFor: aSpaceship [
	(activeCards anySatisfy: [:c | (c class = SpeedCard) and: [ c owner == aSpaceship ] ])
		ifTrue: [ ^ 1 ].
	^ 0
]

{ #category : #action }
Game >> throwDice [
	| base bonus |

	base := 0.
	dice do: [:aDie | base := base + aDie throw ].

	bonus := self speedBonusFor: self nextSpaceshipToPlay.
	^ base + bonus
]

{ #category : #action }
Game >> throwDiceFor: aSpaceship [
	| base |
	base := 0.
	dice do: [:aDie | base := base + aDie throw ].
	^ base + (self cardBonusFor: aSpaceship)
]

{ #category : #action }
Game >> turn [
	^ self playTurn




]

{ #category : #action }
Game >> turnFor: aSpaceship [

	| diceResult data |

	diceResult := self throwDiceFor: aSpaceship.

	data := self dataFor: aSpaceship.
	data recordLastMoveRoll: diceResult.
	data move: diceResult.

	board
		applyEffectFor: aSpaceship
		afterMovingTo: (self positionOf: aSpaceship)
		whenPlaying: self.

	self resolveBattleIfNeededFor: aSpaceship arrivingWith: diceResult.
	self checkForWinnerFor: aSpaceship.
]

{ #category : #'as yet unclassified' }
Game >> validateActiveCardSelected: aCard [

	(activeCards includes: aCard)
		ifFalse: [
			Error signal: 'Selected card is not active'
		].
]

{ #category : #'as yet unclassified' }
Game >> validateIf: aCard canBePlayedBy: aSpaceship [

	| spaceshipData |

	state validateStateForCards.

	aCard
		validateIfCardCanBePlayedBy: aSpaceship
		in: self.

	spaceshipData := self dataFor: aSpaceship.
	spaceshipData validateThatSpaceshipHasCard: aCard.
]

{ #category : #validation }
Game >> validateLastCardPlayed [
	lastTypeOfCardPlayed ifNil: [Error signal: 'There are no cards played to redo'.]
]

{ #category : #validation }
Game >> validateMercenaryAvailability: aSpaceship [
	| ship |

	ship := aSpaceship asSpaceship.

	(spaceships includes: ship)
		ifFalse: [ Error signal: 'That spaceship is not a player in this game' ].

	(activeCards anySatisfy: [:c |
		(c class = MercenaryCard) and: [ c mercenary asSpaceship == ship ]
	]) ifTrue: [ Error signal: 'Selected spaceship is already a mercenary' ].
]

{ #category : #accessing }
Game >> winner [
	^ state winnerOf: spaceshipsData after: laps

]
