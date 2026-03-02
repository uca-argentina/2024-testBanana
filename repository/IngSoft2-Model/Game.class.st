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
		each asSpaceshipLogWithDeck: aDeck
	].

	^ self new
		initializePlayedBy: logs
		on: aBoard
		throwing: someDice
		wonAfter: aNumberOfLaps
		usingDeck: aDeck
]

{ #category : #'as yet unclassified' }
Game >> activateDoubleFor: aSpaceship [
	spaceshipWithDouble := aSpaceship.

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

	| loserShip alliedShips uniqueShips |

	loserShip := aLoserLog spaceship.

	alliedShips := OrderedCollection with: loserShip.

	activeCards do: [:c |
		(c class = MercenaryCard) ifTrue: [
			(c ally = loserShip) ifTrue: [ alliedShips add: c mercenary ].
			(c mercenary = loserShip) ifTrue: [ alliedShips add: c ally ].
		].
	].

	uniqueShips := OrderedCollection new.
	alliedShips do: [:ship |
		(uniqueShips includes: ship) ifFalse: [ uniqueShips add: ship ].
	].

	uniqueShips do: [:ship |
		(self dataFor: ship) decreaseShieldsByOne.
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
Game >> applyMercenaryBattleCostFor: aSpaceshipLog [
	| allyShip affectedShips uniqueShips |

	allyShip := aSpaceshipLog spaceship.

	"Si este ship es ALLY de al menos un mercenario activo, entonces el ally y todos sus mercenarios pierden 1 shield"
	affectedShips := OrderedCollection new.

	activeCards do: [:c |
		(c class = MercenaryCard) ifTrue: [
			(c ally == allyShip) ifTrue: [
				affectedShips add: c ally.
				affectedShips add: c mercenary.
			].
		].
	].

	affectedShips isEmpty ifTrue: [ ^ self ].

	uniqueShips := OrderedCollection new.
	affectedShips do: [:ship |
		(uniqueShips includes: ship) ifFalse: [ uniqueShips add: ship ].
	].

	uniqueShips do: [:ship |
		(self dataFor: ship) decreaseShieldsByOne
	].
]

{ #category : #action }
Game >> applyMercenaryBattleCostIfAnyForAlly: anAllySpaceship [
	| affectedShips uniqueShips allyShip |

	allyShip := anAllySpaceship asSpaceship.
	affectedShips := OrderedCollection new.

	activeCards do: [:c |
		(c class = MercenaryCard) ifTrue: [
			(c ally asSpaceship == allyShip) ifTrue: [
				affectedShips add: c ally asSpaceship.
				affectedShips add: c mercenary asSpaceship.
			].
		].
	].

	affectedShips isEmpty ifTrue: [ ^ self ].

	uniqueShips := OrderedCollection new.
	affectedShips do: [:ship |
		(uniqueShips includes: ship) ifFalse: [ uniqueShips add: ship ].
	].

	uniqueShips do: [:ship |
		(self dataFor: ship) decreaseShieldsByOne
	].
]

{ #category : #action }
Game >> applyMercenaryBattleCostIfNeededFor: aSpaceshipLog [
	| allyShip mercenaries affectedShips uniqueShips |

	allyShip := aSpaceshipLog spaceship.

	"Solo aplica si este ship es ALLY de al menos un mercenario"
	mercenaries := OrderedCollection new.
	activeCards do: [:c |
		(c class = MercenaryCard) ifTrue: [
			(c ally == allyShip) ifTrue: [ mercenaries add: c mercenary ].
		].
	].

	mercenaries isEmpty ifTrue: [ ^ self ].

	affectedShips := OrderedCollection with: allyShip.
	mercenaries do: [:m | affectedShips add: m ].

	uniqueShips := OrderedCollection new.
	affectedShips do: [:ship |
		(uniqueShips includes: ship) ifFalse: [ uniqueShips add: ship ].
	].

	uniqueShips do: [:ship |
		(self dataFor: ship) decreaseShieldsByOne
	].
]

{ #category : #action }
Game >> applyMoonwalkFor: aSpaceship  movingOthersBack: someSquares [
	self moveAllBut: aSpaceship back: someSquares.

]

{ #category : #'as yet unclassified' }
Game >> areAllied: aSpaceship and: anotherSpaceship [
	^ activeCards anySatisfy: [:c |
		(c class = MercenaryCard)
			and: [ c is: aSpaceship anAllyOf: anotherSpaceship ]
	]
]

{ #category : #action }
Game >> battleBetween: aSpaceship and: anotherSpaceship [

	| result1 result2 loser |
	Transcript show: 'BATTLE'; cr.

	result1 := self throwDice.
	result2 := self throwDice.

	loser :=
		(result1 > result2)
			ifTrue: [ anotherSpaceship ]
			ifFalse: [
				(result1 < result2)
					ifTrue: [ aSpaceship ]
					ifFalse: [ anotherSpaceship ] ].

	self reducePartyShieldsByOneOf: loser.


]

{ #category : #action }
Game >> battleIfNeededAt: position triggeredBy: movingSpaceship [

	| opponent |
	opponent := spaceshipsData
		detect: [:log |
			log spaceship ~= movingSpaceship
				and: [ log position = position ]]
		ifNone: [ ^ self ].

	self battleBetween: movingSpaceship and: opponent spaceship.




]

{ #category : #action }
Game >> battleIn: position triggeredBy: movingSpaceship [

	| opponent |
	opponent := spaceshipsData
		detect: [ :log |
			(log spaceship == movingSpaceship) not
				and: [ log position = position ] ]
		ifNone: [ ^ self ].

	self battleBetween: movingSpaceship and: opponent spaceship.


]

{ #category : #action }
Game >> battleRollFor: aSpaceshipLog [
	| allyShip mercenaries maxRoll |

	allyShip := aSpaceshipLog spaceship.

	mercenaries := OrderedCollection new.
	activeCards do: [:c |
		(c class = MercenaryCard) ifTrue: [
			(c ally asSpaceship == allyShip) ifTrue: [
				mercenaries add: c mercenary asSpaceship
			].
		].
	].

	maxRoll := aSpaceshipLog lastMoveRoll.

	mercenaries do: [:mercShip |
		| roll |
		roll := (self dataFor: mercShip) lastMoveRoll.
		(roll > maxRoll) ifTrue: [ maxRoll := roll ].
	].

	^ maxRoll

]

{ #category : #action }
Game >> calculateFinalPositionFor: aSpaceship [

	| diceResult newPosition cardModifier |
	diceResult := self throwDice.

	cardModifier := 0.
	activeCards do: [ :card |
		cardModifier := (card playOn: aSpaceship) + cardModifier ].
	diceResult := diceResult + cardModifier.

	(self dataFor: aSpaceship) move: diceResult.
	newPosition := self positionOf: aSpaceship.

	board
		applyEffectFor: aSpaceship
		afterMovingTo: newPosition
		whenPlaying: self
]

{ #category : #action }
Game >> cardBonusFor: aSpaceship [
	| bonus |

	bonus := 0.

	"Speed: suma +1 por cada SpeedCard activa que targetea a este spaceship"
	activeCards do: [:c |
		(c class = SpeedCard) ifTrue: [
			(c affectedSpaceship == aSpaceship) ifTrue: [ bonus := bonus + 1 ].
		].
	].

	"Acceleration: bonus global +1 por cada AccelerationCard activa"
	activeCards do: [:c |
		(c class = AccelerationCard) ifTrue: [ bonus := bonus + 1 ].
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
	^ (aCard class = SpeedCard)
		or: [ aCard class = AccelerationCard
		or: [ aCard class = MercenaryCard ] ]
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

{ #category : #action }
Game >> play: aCard from: aSpaceship targeting: anotherTarget [

	| spaceshipData |

	self validateIf: aCard canBePlayedBy: aSpaceship.

	spaceshipData := self dataFor: aSpaceship.
	spaceshipData removeCardFromHand: aCard.

	aCard from: aSpaceship withTarget: anotherTarget useIn: self.

	spaceshipData drawOneCardAfterPlaying.
]

{ #category : #action }
Game >> playTurn [
    | spaceship |
    state validateTurn.
    spaceship := self nextSpaceshipToPlay.
    (self dataFor: spaceship) playIn: self.
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

{ #category : #action }
Game >> reducePartyShieldsByOneOf: loser [

	| log |
	log := self dataFor: loser.
	log decreaseShieldsByOne.
	log resetPosition.

	
]

{ #category : #'as yet unclassified' }
Game >> registerDoubleForNextBattleOf: aSpaceship [
	doubleTarget := aSpaceship.

]

{ #category : #removing }
Game >> removeActiveCard: aCard [
	(activeCards includes: aCard)
		ifFalse: [ Error signal: 'Selected card is not active' ].

	activeCards remove: aCard.
]

{ #category : #action }
Game >> repeatLastEffectFor: aSpaceship [ 

	lastEffectTriggered applyIn: self for: aSpaceship.	
	lastTypeOfCardPlayed := RepeatCard .
	
	

]

{ #category : #action }
Game >> resolveBattleIfNeededFor: aSpaceship arrivingWith: arrivingRoll [
	| square opponentLog currentLog currentRoll opponentRoll loserLog |

	square := self positionOf: aSpaceship.
	square = 1 ifTrue: [ ^ self ].

	opponentLog := spaceshipsData
		detect: [:log |
			(log spaceship ~~ aSpaceship)
				and: [ (self positionOf: log spaceship) = square ] ]
		ifNone: [ ^ self ].

	(self areAllied: aSpaceship and: opponentLog spaceship) ifTrue: [ ^ self ].

	currentLog := self dataFor: aSpaceship.

	"Costo mercenario: si alguno es ALLY de mercenarios, ese grupo pierde 1 shield al ocurrir batalla"
	self applyMercenaryBattleCostIfAnyForAlly: currentLog spaceship.
	self applyMercenaryBattleCostIfAnyForAlly: opponentLog spaceship.

	currentRoll := self battleRollFor: currentLog.
	opponentRoll := self battleRollFor: opponentLog.

	loserLog := (currentRoll <= opponentRoll)
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

	| aSpaceship position |
	aSpaceship := self nextSpaceshipToPlay.

	self calculateFinalPositionFor: aSpaceship.
	position := self positionOf: aSpaceship.

	self battleIn: position triggeredBy: aSpaceship.

	self checkForWinnerFor: aSpaceship.




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

{ #category : #validation }
Game >> validateIf: aCard canBePlayedBy: aSpaceship [
	| spaceshipData |

	state validateStateForCards.

	(self isPermanentCard: aCard)
		ifTrue: [
			(self nextSpaceshipToPlay == aSpaceship)
				ifFalse: [ Error signal: 'Card cannot be played out of turn' ]
		].

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
