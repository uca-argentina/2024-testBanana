Class {
	#name : #GameTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #accessing }
GameTest >> createBoardOf: length distance: aDistance withEffects: someEffects wormholeBeginsAt: startPoint andEndsAt: endPoint [

	| squares |
	squares := OrderedCollection new.
	1 to: length  do: [ :i |
	squares add: (Square with: (NullEffect isIn: i)) ].

	someEffects do: [ :effect |
		squares at: effect position put: (Square with: effect) ].
	^ Board
		  with: squares
		  length: aDistance
		  wormholeBeginsAt: startPoint
		  andEndsAt: endPoint
]

{ #category : #tests }
GameTest >> should: anErrorBlock raise: anError withMessage: errorMessage [

self 
	should: anErrorBlock 
	raise: anError 
	withExceptionDo: [ :error |
										self assert: error messageText  equals: errorMessage  ].
]

{ #category : #tests }
GameTest >> test001WhenGameStartedThenIsOngoing [
	"Let the games begin"

	| aGame aSpaceship spaceshipsData aBoard |
	aSpaceship := Spaceship launch: ''.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog randomCardsfor: aSpaceship) .
	aBoard := self createBoardOf: 4 distance: (ParsecDistance of: 2)  withEffects: {  }  wormholeBeginsAt: 2 andEndsAt: 3.
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: nil
		         wonAfter: 1.
	^ self assert: aGame isOngoing
]

{ #category : #tests }
GameTest >> test002WhenGameEndsThenIsOver [

	| aGame aSpaceship spaceshipsData aBoard |
	aSpaceship := Spaceship launch: ''.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog randomCardsfor: aSpaceship) .
	aBoard := self createBoardOf: 4 distance: (ParsecDistance of: 2)  withEffects: {  }  wormholeBeginsAt: 2 andEndsAt: 3.
	aGame := Game
		         playedBy: spaceshipsData 
		         on: aBoard 
		         throwing: nil
		         wonAfter: 1.
	aGame end.

	self deny: aGame isOngoing
]

{ #category : #tests }
GameTest >> test003GameBeginsWithAPlayer [

	| aGame aSpaceship spaceshipsData aBoard |
	aSpaceship := Spaceship launch: ''.
	spaceshipsData := OrderedCollection with: aSpaceship.
	aBoard := self 
		createBoardOf: 4 
		distance: (ParsecDistance of: 2)  
		withEffects: { }  
		wormholeBeginsAt: 2 
		andEndsAt: 3.

	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard 
		         throwing: nil
		         wonAfter: 1.

	self
		assert: aGame players
		equals: (OrderedCollection with: aSpaceship)

]

{ #category : #tests }
GameTest >> test004SpaceshipChangedPositionByOneWhenMoved [

	| aSpaceship aGame spaceshipsData aBoard |
	aSpaceship := Spaceship launch: ''.
	spaceshipsData := OrderedCollection with: aSpaceship.
	aBoard := self 
		createBoardOf: 5 
		distance: 5 
		withEffects: { }  
		wormholeBeginsAt: 3 
		andEndsAt: 4.

	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard 
		         throwing: nil
		         wonAfter: 1.

	aGame move: aSpaceship to: 1.

	self assert: (aGame positionOf: aSpaceship) equals: 1

]

{ #category : #tests }
GameTest >> test005SpaceshipIsCreatedAtStartPoint [

	| aSpaceship aGame spaceshipsData aBoard |
	aSpaceship := Spaceship launch: ''.
	spaceshipsData := OrderedCollection with: aSpaceship.
	aBoard := self 
		createBoardOf: 4 
		distance: (ParsecDistance of: 2)  
		withEffects: { }  
		wormholeBeginsAt: 2 
		andEndsAt: 3.

	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard 
		         throwing: nil
		         wonAfter: 1.

	self assert: (aGame positionOf: aSpaceship) equals: 1

]

{ #category : #tests }
GameTest >> test006WhenGameHasOnlyOnePlayerThenThatPlayerWins [

	| aGame aSpaceship aBoard aDie spaceshipsData |
	aSpaceship := Spaceship launch: ''.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog randomCardsfor: aSpaceship) .
	aBoard := Board of: 6 wormholeBeginsAt: 3 andEndsAt: 4.
	aDie := LoadedDie of: 8.
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.
	aGame playTurn .
	self assert: aGame winner equals: aSpaceship
]

{ #category : #tests }
GameTest >> test008WhenGameIsOngoingThereIsNoWinner [

	| aGame aSpaceship aBoard spaceshipsData |
	aBoard := Board new.
	aSpaceship := Spaceship launch: ''.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog randomCardsfor: aSpaceship) .
	aBoard := self createBoardOf: 4 distance: (ParsecDistance of: 2)  withEffects: {  }  wormholeBeginsAt: 2 andEndsAt: 3.
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: nil
		         wonAfter: 1.

	self
		should: [ aGame winner ]
		raise: Error
		withMessage: 'The game is not over - there is no winner yet.'
]

{ #category : #tests }
GameTest >> test009SpaceshipDoesNotWinUntilItLandsOnTheLastSquare [

	| aGame aSpaceship aBoard spaceshipsData |
	aSpaceship := Spaceship launch: ''.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog randomCardsfor: aSpaceship) .
	aBoard := Board of: 2 wormholeBeginsAt: 1 andEndsAt: 2.
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: nil
		         wonAfter: 1.

	aGame end.

	self should: [ aGame winner equals: aSpaceship ] raise: NotFound
]

{ #category : #tests }
GameTest >> test011ASpaceshipMovesFiveSquaresWhenLoadedDieIsThrown [

	| aSpaceship aLoadedDie aBoard aGame someDice spaceshipsData anotherSpaceship |
	aSpaceship := Spaceship launch: ''.
	spaceshipsData := OrderedCollection 
	with: aSpaceship 
	with: anotherSpaceship.
	aLoadedDie := LoadedDie of: 5.
	someDice := OrderedCollection with: aLoadedDie.
	aBoard := Board of: 10 wormholeBeginsAt: 2 andEndsAt: 7.
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: someDice
		         wonAfter: 1.
	aGame playTurn.
	self assert: (aGame positionOf: aSpaceship) equals: 6
]

{ #category : #tests }
GameTest >> test012ASpaceshipMovesSevenSquaresWhenLoadedDieIsThrown [

	| aSpaceship aLoadedDie aBoard aGame stack someDice spaceshipsData anotherSpaceship |
	aSpaceship := Spaceship launch: ''.
	spaceshipsData := OrderedCollection 
	with: aSpaceship 
	with: anotherSpaceship.
	stack := OrderedCollection with: aSpaceship.
	aLoadedDie := LoadedDie of: 7.
	someDice := OrderedCollection with: aLoadedDie.
	aBoard := Board of: 10 wormholeBeginsAt: 2 andEndsAt: 3.
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: someDice
		         wonAfter: 1.
	aGame playTurn.
	self assert: (aGame positionOf: aSpaceship) equals: 8
]

{ #category : #tests }
GameTest >> test016GameIndicatesTurnWithOnePlayer [

	| aGame aSpaceship spaceshipsData aBoard |
	aSpaceship := Spaceship launch: ''.
	spaceshipsData := OrderedCollection with: aSpaceship.
	aBoard := self 
		createBoardOf: 4 
		distance: (ParsecDistance of: 2)  
		withEffects: { }  
		wormholeBeginsAt: 2 
		andEndsAt: 3.

	aGame := Game
		         playedBy: spaceshipsData 
		         on: aBoard 
		         throwing: nil
		         wonAfter: 1.

	self assert: aGame nextSpaceshipToPlay equals: aSpaceship

]

{ #category : #tests }
GameTest >> test017GameIndicatesFirstTurnWithTwoPlayers [

	| aGame aSpaceship anotherSpaceship spaceshipsData aBoard |
	aSpaceship := Spaceship launch: ''.
	anotherSpaceship := Spaceship launch: ''.
	spaceshipsData := OrderedCollection with: aSpaceship with: anotherSpaceship.
	aBoard := self 
		createBoardOf: 4 
		distance: (ParsecDistance of: 2)  
		withEffects: { }  
		wormholeBeginsAt: 2 
		andEndsAt: 3.

	aGame := Game
		         playedBy: spaceshipsData 
		         on: aBoard 
		         throwing: nil
		         wonAfter: 1.

	self assert: aGame nextSpaceshipToPlay equals: aSpaceship

]

{ #category : #tests }
GameTest >> test018GameIndicatesSecondTurnWithTwoPlayers [

	| aGame aSpaceship anotherSpaceship spaceshipsData aBoard |
	aSpaceship := Spaceship launch: ''.
	anotherSpaceship := Spaceship launch: ''.
	spaceshipsData := OrderedCollection with: aSpaceship with: anotherSpaceship.
	aBoard := self 
		createBoardOf: 4 
		distance: (ParsecDistance of: 2)  
		withEffects: { }  
		wormholeBeginsAt: 2 
		andEndsAt: 3.

	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard 
		         throwing: nil
		         wonAfter: 1.

	aGame nextTurn.
	self assert: aGame nextSpaceshipToPlay equals: anotherSpaceship

]

{ #category : #tests }
GameTest >> test019GameResetsTurnsForNextRound [

	| aGame aSpaceship anotherSpaceship spaceshipsData aBoard |
	aSpaceship := Spaceship launch: ''.
	anotherSpaceship := Spaceship launch: ''.
	spaceshipsData := OrderedCollection with: aSpaceship with: anotherSpaceship.
	aBoard := self 
		createBoardOf: 4 
		distance: (ParsecDistance of: 2)  
		withEffects: { }  
		wormholeBeginsAt: 2 
		andEndsAt: 3.

	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard 
		         throwing: nil
		         wonAfter: 1.

	aGame
		nextTurn;
		nextTurn.

	self assert: aGame nextSpaceshipToPlay equals: aSpaceship

]

{ #category : #tests }
GameTest >> test020GameWithMultiplePlayersKnowsTheWinner [

	| aGame aSpaceship anotherSpaceship aBoard aLoadedDie someDice spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog randomCardsfor: aSpaceship) with: (SpaceshipLog randomCardsfor: anotherSpaceship) .
	aLoadedDie := LoadedDie of: 12.
	someDice := OrderedCollection with: aLoadedDie.
	aBoard := Board of: 10 wormholeBeginsAt: 2 andEndsAt: 3.
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: someDice
		         wonAfter: 1.
	aGame playTurn.
	aGame end.

	self assert: aGame winner equals: aSpaceship
]

{ #category : #tests }
GameTest >> test021WhenGameIsOverLeaderboardIsShown [

	| aGame aSpaceship anotherSpaceship aBoard aLoadedDie someDice spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	spaceshipsData := OrderedCollection with: aSpaceship with: anotherSpaceship.

	aBoard := Board of: 6 wormholeBeginsAt: 1 andEndsAt: 2.
	aLoadedDie := LoadedDie of: 4.
	someDice := OrderedCollection with: aLoadedDie.

	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: someDice
		         wonAfter: 1.

	aGame playTurn.
	aGame playTurn.

	self
		assert: aGame leaderBoard asOrderedCollection
		equals: (OrderedCollection with: aSpaceship with: anotherSpaceship)

]

{ #category : #tests }
GameTest >> test022GameEndsAutomaticallyWhenSpaceshipPassesLastSquare [

	| aBoard aSpaceship aGame aLoadedDie someDice spaceshipsData |
	aBoard := Board of: 8 wormholeBeginsAt: 1 andEndsAt: 2.
	aSpaceship := Spaceship launch: ''.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog randomCardsfor: aSpaceship).
	aLoadedDie := LoadedDie of: 10.
	someDice := OrderedCollection with: aLoadedDie.
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: someDice
		         wonAfter: 1.
	aGame playTurn.

	self deny: aGame isOngoing
]

{ #category : #tests }
GameTest >> test023GameWithMultiplePlayersShowsLeaderBoard [

	| aGame aSpaceship anotherSpaceship yetAnotherSpaceship aBoard aLoadedDie someDice leaderboard spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	yetAnotherSpaceship := Spaceship launch: 'Three'.

	spaceshipsData := OrderedCollection 
		with: aSpaceship 
		with: anotherSpaceship 
		with: yetAnotherSpaceship.

	aBoard := Board of: 10 wormholeBeginsAt: 5 andEndsAt: 6.
	aLoadedDie := LoadedDie arrayOf:
		              (OrderedCollection with: 3 with: 2 with: 1).
	someDice := OrderedCollection with: aLoadedDie.

	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: someDice
		         wonAfter: 1.

	[ aGame isOngoing ] whileTrue: [ aGame playTurn ].

	leaderboard := aGame leaderBoard.

	self
		assert: leaderboard asOrderedCollection
		equals: (OrderedCollection
				 with: aSpaceship
				 with: anotherSpaceship
				 with: yetAnotherSpaceship)

]

{ #category : #tests }
GameTest >> test024GameStoresADie [

	| aGame aSpaceship aBoard aLoadedDie someDice spaceshipsData anotherSpaceship |
	aSpaceship := Spaceship launch: ''.
	spaceshipsData := OrderedCollection 
	with: aSpaceship 
	with: anotherSpaceship.
	aBoard := Board of: 10 wormholeBeginsAt: 1 andEndsAt: 2.
	aLoadedDie := LoadedDie of: 6.
	someDice := OrderedCollection with: aLoadedDie.
	aGame := Game
		         playedBy: spaceshipsData 
		         on: aBoard
		         throwing: someDice
		         wonAfter: 1.
	aGame playTurn.
	self assert: (aGame positionOf: aSpaceship) equals: 7
]

{ #category : #tests }
GameTest >> test025GameCanUseMultipleDice [

	| aGame aSpaceship  aBoard aLoadedDie anotherLoadedDie someDice spaceshipsData anotherSpaceship |
	aSpaceship := Spaceship launch: ''.
	spaceshipsData := OrderedCollection 
	with: aSpaceship 
	with: anotherSpaceship.
	aBoard := Board of: 12 wormholeBeginsAt: 1 andEndsAt: 2.
	aLoadedDie := LoadedDie of: 6.
	anotherLoadedDie := LoadedDie of: 4.
	someDice := OrderedCollection with: aLoadedDie with: anotherLoadedDie.
	aGame := Game
		         playedBy: spaceshipsData 
		         on: aBoard
		         throwing: someDice
		         wonAfter: 1.
	aGame playTurn.
	self assert: (aGame positionOf: aSpaceship) equals: 11
]

{ #category : #tests }
GameTest >> test031TurnCannotBePlayedIfGameIsOver [

	| aGame aSpaceship aDie aBoard spaceshipsData |
	aSpaceship := Spaceship launch: 'Millenium Falcon'.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog randomCardsfor: aSpaceship).
	aBoard := Board of: 5 wormholeBeginsAt: 1 andEndsAt: 2.
	aDie := LoadedDie of: 5.
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.
	aGame playTurn.

	self
		should: [ aGame playTurn ]
		raise: Error
		withMessage: 'Game has already ended'
]

{ #category : #tests }
GameTest >> test036GameCannotShowPositionOfSpaceshipsThatArentPlaying [

	| aGame aSpaceship anotherSpaceship aDie aBoard spaceshipsData |
	aSpaceship := Spaceship launch: 'Millenium Falcon'.
	anotherSpaceship := Spaceship launch: 'Death Star'.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog randomCardsfor: aSpaceship).
	aDie := LoadedDie of: 5.
	aBoard := Board of: 12 wormholeBeginsAt: 1 andEndsAt: 2.
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.

	self
		should: [ aGame positionOf: anotherSpaceship ]
		raise: Error
		withMessage: 'That spaceship is not a player in this game'
]

{ #category : #tests }
GameTest >> test39AfterSpaceshipPassesLastSquareForTheFirstTimeThenNumberOfLapsIsOne [

	| aGame aSpaceship aBoard aDie spaceshipsData anotherSpaceship |
	aSpaceship := Spaceship launch: ''.
	spaceshipsData := OrderedCollection 
	with: aSpaceship 
	with: anotherSpaceship.
	aBoard := Board of: 5 wormholeBeginsAt: 1 andEndsAt: 2.
	aDie := LoadedDie of: 8.
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.

	aGame playTurn.
	self assert: (aGame lapsOf: aSpaceship) equals: 1
]

{ #category : #tests }
GameTest >> test40AfterSpaceshipCrossesTheFinishLineTwiceThenHasTwoLaps [

	| aGame aSpaceship aBoard aDie spaceshipsData anotherSpaceship|
	aSpaceship := Spaceship launch: ''.
	spaceshipsData := OrderedCollection 
	with: aSpaceship 
	with: anotherSpaceship.
	aBoard := Board of: 5 wormholeBeginsAt: 1 andEndsAt: 2.
	aDie := LoadedDie of: 11.
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.

	aGame playTurn.
	self assert: (aGame lapsOf: aSpaceship) equals: 2
]

{ #category : #tests }
GameTest >> test42ASpaceshipStartsWithThreeShields [

	| aGame aSpaceship aDie aBoard spaceshipsData anotherSpaceship |
	aSpaceship := Spaceship launch: ''.
	spaceshipsData := OrderedCollection 
	with: aSpaceship 
	with: anotherSpaceship.
	aBoard := Board of: 4 wormholeBeginsAt: 1 andEndsAt: 2.
	aDie := LoadedDie of: 3.
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.
	self assert: (aGame shieldsOf: aSpaceship) equals: 3
]

{ #category : #tests }
GameTest >> test43AfterLosingABattleSpaceshipLosesAShield [

	| aGame aSpaceship anotherSpaceship aDie aBoard spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	spaceshipsData := OrderedCollection 
	with: aSpaceship 
	with: anotherSpaceship.
	aBoard := Board of: 4 wormholeBeginsAt: 1 andEndsAt: 2.
	aDie := LoadedDie arrayOf: (OrderedCollection with: 1 with: 3).
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.
	aGame battleBetween: aSpaceship and: anotherSpaceship.

	self assert: (aGame shieldsOf: aSpaceship) equals: 2
]

{ #category : #tests }
GameTest >> test44IfSpaceshipWinsBattleDoesntLoseShields [

	| aGame aSpaceship anotherSpaceship aDie aBoard spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	spaceshipsData := OrderedCollection 
	with: aSpaceship 
	with: anotherSpaceship.
	aBoard := Board of: 4 wormholeBeginsAt: 1 andEndsAt: 2.
	aDie := LoadedDie arrayOf: (OrderedCollection with: 5 with: 3).
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.
	aGame battleBetween: aSpaceship and: anotherSpaceship.

	self assert: (aGame shieldsOf: aSpaceship) equals: 3
]

{ #category : #tests }
GameTest >> test45SpaceshipLosesTwoBattlesAndLosesTwoShields [

	| aGame aSpaceship anotherSpaceship aDie aBoard spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	spaceshipsData := OrderedCollection 
	with: aSpaceship 
	with: anotherSpaceship.
	aBoard := Board of: 4 wormholeBeginsAt: 1 andEndsAt: 2.
	aDie := LoadedDie arrayOf: (OrderedCollection with: 1 with: 3).
	aGame := Game
		         playedBy: spaceshipsData 
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.
	aGame battleBetween: aSpaceship and: anotherSpaceship.
	aGame battleBetween: aSpaceship and: anotherSpaceship.

	self assert: (aGame shieldsOf: aSpaceship) equals: 1
]

{ #category : #tests }
GameTest >> test46AfterLosingBattleSpaceshipGetsSentToBeginning [

	| aGame aSpaceship anotherSpaceship aDie aBoard spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	spaceshipsData := OrderedCollection 
	with: aSpaceship 
	with: anotherSpaceship.
	aBoard := Board of: 4 wormholeBeginsAt: 1 andEndsAt: 2.
	aDie := LoadedDie arrayOf:
		        (OrderedCollection with: 3 with: 3 with: 4).
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.
	aGame playTurn.
	aGame battleBetween: aSpaceship and: anotherSpaceship.

	self assert: (aGame positionOf: aSpaceship) equals: 1
]

{ #category : #tests }
GameTest >> test47WhenTwoSpaceshipsLandOnTheSameSquareTheyBattle [

	| aGame aSpaceship anotherSpaceship aDie aBoard spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	spaceshipsData := OrderedCollection 
	with: aSpaceship 
	with: anotherSpaceship.
	aBoard := Board of: 6 wormholeBeginsAt: 1 andEndsAt: 2.
	aDie := LoadedDie arrayOf:
		        (OrderedCollection with: 3 with: 3 with: 2).
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.
	aGame playTurn.
	aGame playTurn.

	self assert: (aGame positionOf: anotherSpaceship) equals: 1
]

{ #category : #tests }
GameTest >> test48IfBattleEndsOnADrawThenLastSpaceshipToArriveLoses [

	| aGame aSpaceship anotherSpaceship aDie aBoard spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	spaceshipsData := OrderedCollection 
	with: aSpaceship 
	with: anotherSpaceship.
	aBoard := Board of: 6 wormholeBeginsAt: 1 andEndsAt: 2.
	aDie := LoadedDie of: 3.
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.
	aGame playTurn.
	aGame playTurn.
	self assert: ((aGame positionOf: anotherSpaceship) = 1 and:
			 (aGame positionOf: aSpaceship) = 4)
]

{ #category : #tests }
GameTest >> test49SpaceshipCanSkipTurn [

	| aGame aSpaceship anotherSpaceship aDie aBoard spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	spaceshipsData := OrderedCollection with: aSpaceship with: anotherSpaceship.

	aBoard := Board of: 4 wormholeBeginsAt: 1 andEndsAt: 2.
	aDie := LoadedDie of: 3.

	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.

	aGame skipTurn.

	self assert: aGame nextSpaceshipToPlay equals: anotherSpaceship

]

{ #category : #tests }
GameTest >> test50SkippingATurnRechargesShields [

	| aGame aSpaceship anotherSpaceship aDie aBoard spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	spaceshipsData := OrderedCollection 
	with: aSpaceship 
	with: anotherSpaceship.
	aBoard := Board of: 4 wormholeBeginsAt: 1 andEndsAt: 2.
	aDie := LoadedDie arrayOf: (OrderedCollection with: 1 with: 2).
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.
	aGame battleBetween: aSpaceship and: anotherSpaceship.
	aGame skipTurn.

	self assert: (aGame shieldsOf: aSpaceship) equals: 3
]

{ #category : #tests }
GameTest >> test51FirstSquareIsASafeZone [

	| aGame aSpaceship anotherSpaceship aDie aBoard spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	spaceshipsData := OrderedCollection 
	with: aSpaceship 
	with: anotherSpaceship.
	aBoard := Board of: 4 wormholeBeginsAt: 2 andEndsAt: 3.
	aDie := LoadedDie of: 4.
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 2.
	aGame playTurn.
	aGame playTurn.
	self assert: (aGame shieldsOf: anotherSpaceship) equals: 3
]

{ #category : #tests }
GameTest >> test52IfSpaceshipLosesAllShieldsThenTheirTurnGetsSkipped [

	| aGame aSpaceship anotherSpaceship aDie aBoard spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	spaceshipsData := OrderedCollection 
	with: aSpaceship 
	with: anotherSpaceship.
	aBoard := Board of: 4 wormholeBeginsAt: 2 andEndsAt: 3.
	aDie := LoadedDie arrayOf: (OrderedCollection with: 2 with: 3).
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.
	3 timesRepeat: [
		aGame battleBetween: aSpaceship and: anotherSpaceship ].
	aGame playTurn.
	self assert: (aGame positionOf: aSpaceship) equals: 1
]

{ #category : #tests }
GameTest >> test53AfterLosingAllShieldsSpaceshipCannotPlayForTwoTurns [

	| aGame aSpaceship anotherSpaceship aDie aBoard spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	spaceshipsData := OrderedCollection 
	with: aSpaceship 
	with: anotherSpaceship.
	aBoard := Board of: 4 wormholeBeginsAt: 2 andEndsAt: 3.
	aDie := LoadedDie arrayOf: (OrderedCollection with: 2 with: 3).
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.
	3 timesRepeat: [
		aGame battleBetween: aSpaceship and: anotherSpaceship ].
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.

	self assert: (aGame positionOf: aSpaceship) equals: 1
]

{ #category : #tests }
GameTest >> test54AfterLosingTwoTurnsSpaceshipCanPlayAgain [

	| aGame aSpaceship anotherSpaceship aDie aBoard spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	spaceshipsData := OrderedCollection 
	with: aSpaceship 
	with: anotherSpaceship.

	aBoard := Board of: 8 wormholeBeginsAt: 6 andEndsAt: 7.
	aDie := LoadedDie arrayOf: (OrderedCollection with: 2 with: 3).
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.
	3 timesRepeat: [
		aGame battleBetween: aSpaceship and: anotherSpaceship ].
	5 timesRepeat: [ aGame playTurn ].

	self assert: (aGame positionOf: aSpaceship) equals: 3
]

{ #category : #tests }
GameTest >> test66GameIsWonAfterOneLap [

	| aGame aSpaceship aBoard aDie aNumberOfLaps spaceshipsData |
	aSpaceship := Spaceship launch: ''.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog randomCardsfor: aSpaceship).
	
	aBoard := self
		          createBoardOf: 3
		          distance: (ParsecDistance of: 1)
		          withEffects: (OrderedCollection new)
		          wormholeBeginsAt: 2
		          andEndsAt: 3.
	
	aDie := LoadedDie of: 3.
	aNumberOfLaps := 1.
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: aNumberOfLaps.
	aGame playTurn.

	self assert: aGame winner equals: aSpaceship
]

{ #category : #tests }
GameTest >> test67GameIsWonAfterANumberOfLaps [

	| aGame aSpaceship aBoard aDie aNumberOfLaps spaceshipsData |
	aSpaceship := Spaceship launch: ''.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog randomCardsfor: aSpaceship).
	
	aBoard := self
		          createBoardOf: 3
		          distance: (ParsecDistance of: 1)
		          withEffects: (OrderedCollection new)
		          wormholeBeginsAt: 2
		          andEndsAt: 3.
	aDie := LoadedDie of: 3.
	aNumberOfLaps := 10.
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: aNumberOfLaps.
	aNumberOfLaps timesRepeat: [ aGame playTurn ].

	self assert: aGame winner equals: aSpaceship
]

{ #category : #tests }
GameTest >> test78FirstSquareIsASafeZone [

	| aGame aSpaceship anotherSpaceship aBoard aDie  spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	spaceshipsData := OrderedCollection 
	with: aSpaceship 
	with: anotherSpaceship.

	aBoard := Board of: 10 wormholeBeginsAt: 1 andEndsAt: 3.
	aDie := LoadedDie of: 3.

	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.
	

	self assert: (aGame shieldsOf: aSpaceship ) equals: 3
]
