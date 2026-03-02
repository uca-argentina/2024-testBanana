Class {
	#name : #SpeedCardTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
SpeedCardTest >> gameWithOnly: aSpaceship [
	| board dice log |

	board := Board of: 10 wormholeBeginsAt: 3 andEndsAt: 7.
	dice := { LoadedDie of: 6 }.

	log := SpaceshipLog new.
	log initializeFor: aSpaceship withDeck: OrderedCollection new.

	^ Game
		playedBy: (OrderedCollection with: log)
		on: board
		throwing: dice
		wonAfter: 1
]

{ #category : #tests }
SpeedCardTest >> gameWithOnly: aSpaceship throwing: someDice [
	| board spaceshipLog |

	board := Board of: 10 wormholeBeginsAt: 2 andEndsAt: 9.
	spaceshipLog := SpaceshipLog new initializeFor: aSpaceship withDeck: OrderedCollection new.

	^ Game
		playedBy: (OrderedCollection with: spaceshipLog)
		on: board
		throwing: someDice
		wonAfter: 1

]

{ #category : #tests }
SpeedCardTest >> test169SpeedDoublesMovementRoll [
	| game spaceship card initialPosition die deck probabilities board |

	spaceship := Spaceship launch: 'A'.
	die := LoadedDie arrayOf: (OrderedCollection with: 2).

	board := Board of: 100 wormholeBeginsAt: 50 andEndsAt: 80.

	probabilities := OrderedCollection with: (SpeedCard -> 100).
	deck := Deck
		ofSize: 10
		withProbabilities: probabilities
		using: (SequenceRandom withAll: #(1 2 3 4 5 6 7 8 9 10)).

	game := Game
		playedBy: (OrderedCollection with: spaceship)
		on: board
		throwing: (OrderedCollection with: die)
		wonAfter: 1
		usingDeck: deck.

	card := SpeedCard new.
	(game dataFor: spaceship) addCard: card.

	initialPosition := game positionOf: spaceship.

	game play: card from: spaceship targeting: spaceship.
	game turn.

	self assert: (game positionOf: spaceship)
		equals: initialPosition + 3.



]

{ #category : #tests }
SpeedCardTest >> test170SpeedDoesNotApplyWhenTargetIsDifferent [
	| game spaceship card die initial deck probabilities board |

	spaceship := Spaceship launch: 'A'.
	die := LoadedDie arrayOf: (OrderedCollection with: 2).

	board := Board of: 100 wormholeBeginsAt: 50 andEndsAt: 80.

	probabilities := OrderedCollection with: (SpeedCard -> 100).
	deck := Deck
		ofSize: 10
		withProbabilities: probabilities
		using: (SequenceRandom withAll: #(1 2 3 4 5 6 7 8 9 10)).

	game := Game
		playedBy: (OrderedCollection with: spaceship)
		on: board
		throwing: (OrderedCollection with: die)
		wonAfter: 1
		usingDeck: deck.

	card := SpeedCard new.
	(game dataFor: spaceship) addCard: card.

	initial := game positionOf: spaceship.

	game play: card from: spaceship targeting: nil.
	game turn.

	self assert: (game positionOf: spaceship)
		equals: initial + 2.



]
