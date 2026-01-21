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
		'lastEffectTriggered'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #initialization }
Game class >> playedBy: someSpaceships on: aBoard throwing: someDice wonAfter: aNumberOfLaps [ 
	^self new initializePlayedBy: someSpaceships  on: aBoard  throwing: someDice wonAfter: aNumberOfLaps .
]

{ #category : #adding }
Game >> addActiveCard: aCard [

lastTypeOfCardPlayed := aCard class.
activeCards add: aCard.

]

{ #category : #adding }
Game >> addRandomCardFor: aSpaceship [

(self dataFor: aSpaceship) addRandomCard.
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

{ #category : #action }
Game >> battleBetween: aSpaceship and: aSpaceship2 [

	| loser resultForFirstPlayer resultForSecondPlayer |
	resultForFirstPlayer := self throwDice.
	activeCards  do: [ :card | resultForFirstPlayer := (card reinforce: aSpaceship in: self) + resultForFirstPlayer. ].
	resultForSecondPlayer := self throwDice.
	activeCards  do: [ :card | resultForSecondPlayer := (card reinforce: aSpaceship2 in: self) + resultForSecondPlayer. ].

	loser := resultForFirstPlayer > resultForSecondPlayer
		         ifTrue: [ aSpaceship2 ]
		         ifFalse: [ aSpaceship ].
	self reducePartyShieldsByOneOf: loser
]

{ #category : #action }
Game >> battleIn: position [

	| aSpaceship |
	aSpaceship := self nextSpaceshipToPlay.

	spaceships allButFirstDo: [ :spaceship |
		((self is: spaceship in: position) and:
			 (self is: spaceship notAnAllyOf: aSpaceship)) ifTrue: [
			self battleBetween: aSpaceship and: spaceship ] ]
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
Game >> changeStateOf: aSpaceship to: aState [

	(self dataFor: aSpaceship ) changeStateTo: aState 
]

{ #category : #action }
Game >> checkForWinner [ 

	|currentSpaceship|
	currentSpaceship := self nextSpaceshipToPlay .
	((self lapsOf: currentSpaceship  ) >= laps) ifTrue: [ self end  ]
]

{ #category : #converting }
Game >> convertToSquares: aParsecDistance [
	^board convertToSquares: aParsecDistance
	
]

{ #category : #accessing }
Game >> dataFor: aSpaceship [

^spaceshipsData detect: [:dataForASpaceship | dataForASpaceship spaceship = aSpaceship   ] ifNone: [ Error signal: 'That spaceship is not a player in this game' ].

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

{ #category : #initialization }
Game >> initializePlayedBy: someSpaceships on: aBoard throwing: someDice wonAfter: aNumberOfLaps [ 

spaceshipsData := OrderedCollection withAll:  someSpaceships.
board := aBoard.
self initializeSpaceships.
state := GameOngoingState new.

dice := someDice.
laps := aNumberOfLaps .
activeCards:= OrderedCollection new.
lastEffectTriggered:= NullEffect new.
]

{ #category : #initialization }
Game >> initializeSpaceships [

	spaceships := spaceshipsData collect: [ :dataForASpaceship |
		dataForASpaceship spaceship ].

	spaceshipsData do: [ :dataForASpaceship |
		dataForASpaceship beginIn: board ]
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

	(self dataFor: aSpaceship) move:  someSquares 

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

	| selectedSpaceships |
	selectedSpaceships:= spaceships select:[ :spaceship | spaceship ~= aSpaceship .].
	selectedSpaceships do: [ :spaceship |
		(self dataFor: spaceship) move:  someSquares negated 
		 ]
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
Game >> play: aCard from: aSpaceship targeting: anotherSpaceship [
	self validateIf: aCard  canBePlayedBy: aSpaceship .
	aCard from: aSpaceship withTarget: anotherSpaceship useIn: self.
	(self dataFor: aSpaceship) removeCardFromHand: aCard. 
	
]

{ #category : #action }
Game >> playTurn [
 
	| aSpaceship |
	state validateTurn.
	aSpaceship := self nextSpaceshipToPlay.
	(self dataFor: aSpaceship ) playIn: self.

	self nextTurn
]

{ #category : #accessing }
Game >> players [
^ spaceships.
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
	
	activeCards  do: [ :card | card reduceShieldsOfAllyOf: loser in: self ].
	(self dataFor: loser) decreaseShieldsByOne . 
	(self dataFor: loser) moveTo: 1
	
]

{ #category : #removing }
Game >> removeActiveCard: aCard [ 
	
	activeCards remove: aCard ifAbsent: [ Error signal: 'Selected card is not active'. ].
	lastTypeOfCardPlayed := CancellationCard .
]

{ #category : #action }
Game >> repeatLastEffectFor: aSpaceship [ 

	lastEffectTriggered applyIn: self for: aSpaceship.	
	lastTypeOfCardPlayed := RepeatCard .
	
	

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
Game >> throwDice [

	|result|
	result :=0.
	dice do: [ :aDie | result := result + aDie throw ].
 	^ result 
]

{ #category : #action }
Game >> turn [

	| aSpaceship position |
	aSpaceship := self nextSpaceshipToPlay .
	self calculateFinalPositionFor: aSpaceship.
	position := self positionOf: aSpaceship.
	position = 1 ifFalse: [ self battleIn: position ]. 
	self checkForWinner.
]

{ #category : #validation }
Game >> validateIf: aCard canBePlayedBy: aSpaceship [

	| spaceshipData |
	state validateStateForCards.
	
	spaceshipData := self dataFor: aSpaceship.
	spaceshipData validateThatSpaceshipHasCard: aCard .
]

{ #category : #validation }
Game >> validateLastCardPlayed [
	lastTypeOfCardPlayed ifNil: [Error signal: 'There are no cards played to redo'.]
]

{ #category : #validation }
Game >> validateMercenaryAvailability: aSpaceship [

	(activeCards anySatisfy: [ :card |
		 card mercenary = aSpaceship ]) ifTrue: [
		Error signal: 'Selected spaceship is already a mercenary' ]
]

{ #category : #accessing }
Game >> winner [

	^ state winnerOf: spaceshipsData after: laps 
]
