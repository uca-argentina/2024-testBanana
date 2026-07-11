Class {
	#name : #GameStateTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #private }
GameStateTest >> gameWith: aSpaceship throwing: aDie [

	| board |

	board := Board
		of: 100
		wormholeBeginsAt: 50
		andEndsAt: 80.

	^ Game
		playedBy: (OrderedCollection with: aSpaceship)
		on: board
		throwing: (OrderedCollection with: aDie)
		wonAfter: 1
]

{ #category : #private }
GameStateTest >> test179Turn1RechargeStateChangesToSecondRechargeTurn [

	| spaceship game spaceshipLog |

	spaceship := Spaceship launch: 'One'.
	game := self
		gameWith: spaceship
		throwing: (LoadedDie of: 3).

	spaceshipLog := game dataFor: spaceship.

	3 timesRepeat: [
		spaceshipLog decreaseShieldsByOne
	].

	spaceshipLog changeStateTo: Turn1RechargeState new.

	spaceshipLog playIn: game.

	self assert: (game shieldsOf: spaceship) equals: 0.

	spaceshipLog playIn: game.

	self assert: (game shieldsOf: spaceship) equals: 3.
	self assert: spaceshipLog isInNoPenaltyState
]

{ #category : #private }
GameStateTest >> test180Turn1RechargeStateCanChangeCurrentSpaceshipStateThroughGame [

	| spaceship game spaceshipLog state |

	spaceship := Spaceship launch: 'One'.
	game := self
		gameWith: spaceship
		throwing: (LoadedDie of: 3).

	spaceshipLog := game dataFor: spaceship.

	3 timesRepeat: [
		spaceshipLog decreaseShieldsByOne
	].

	state := Turn1RechargeState new.
	state playIn: game.

	self assert: (game shieldsOf: spaceship) equals: 0.

	spaceshipLog playIn: game.

	self assert: (game shieldsOf: spaceship) equals: 3.
	self assert: spaceshipLog isInNoPenaltyState
]

{ #category : #private }
GameStateTest >> test181Turn2RechargeStateRechargesCurrentSpaceshipThroughGame [

	| spaceship game spaceshipLog state |

	spaceship := Spaceship launch: 'One'.
	game := self
		gameWith: spaceship
		throwing: (LoadedDie of: 3).

	spaceshipLog := game dataFor: spaceship.

	3 timesRepeat: [
		spaceshipLog decreaseShieldsByOne
	].

	state := Turn2RechargeState new.
	state playIn: game.

	self assert: (game shieldsOf: spaceship) equals: 3.
	self assert: spaceshipLog isInNoPenaltyState
]

{ #category : #private }
GameStateTest >> test182FinishedGameIsNotOngoing [

	| state |

	state := GameFinishedState with: OrderedCollection new.

	self deny: state isOngoing
]

{ #category : #private }
GameStateTest >> test183FinishedGameRejectsAnotherTurn [

	| state |

	state := GameFinishedState with: OrderedCollection new.

	self
		should: [ state validateTurn ]
		raise: Error
]

{ #category : #private }
GameStateTest >> test184FinishedGameRejectsCardPlaying [

	| state |

	state := GameFinishedState with: OrderedCollection new.

	self
		should: [ state validateStateForCards ]
		raise: Error
]

{ #category : #private }
GameStateTest >> test185FinishedGameReturnsSpaceshipThatReachedRequiredLaps [

	| winner loser winnerData loserData state |

	winner := Spaceship launch: 'Winner'.
	loser := Spaceship launch: 'Loser'.

	winnerData := SpaceshipLog randomCardsfor: winner.
	loserData := SpaceshipLog randomCardsfor: loser.

	winnerData beginIn:
		(Board
			of: 10
			wormholeBeginsAt: 5
			andEndsAt: 8).

	loserData beginIn:
		(Board
			of: 10
			wormholeBeginsAt: 5
			andEndsAt: 8).

	winnerData move: 10.

	state := GameFinishedState with:
		(OrderedCollection
			with: winnerData
			with: loserData).

	self
		assert:
			(state
				winnerOf:
					(OrderedCollection
						with: winnerData
						with: loserData)
				after: 1)
		equals: winner
]

{ #category : #private }
GameStateTest >> test186FinishedGameSignalsWhenNoSpaceshipReachedRequiredLaps [

	| spaceship spaceshipData board state |

	spaceship := Spaceship launch: 'One'.

	board := Board
		of: 10
		wormholeBeginsAt: 5
		andEndsAt: 8.

	spaceshipData := SpaceshipLog randomCardsfor: spaceship.
	spaceshipData beginIn: board.

	state := GameFinishedState with:
		(OrderedCollection with: spaceshipData).

	self
		should: [
			state
				winnerOf: (OrderedCollection with: spaceshipData)
				after: 1
		]
		raise: NotFound
]
