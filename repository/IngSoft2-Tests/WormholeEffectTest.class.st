Class {
	#name : #WormholeEffectTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
WormholeEffectTest >> test173WormholeTeleportsSpaceship [
	| game spaceship die deck probabilities board |

	spaceship := Spaceship launch: 'A'.
	die := LoadedDie arrayOf: (OrderedCollection with: 1).

	board := Board of: 10 wormholeBeginsAt: 2 andEndsAt: 8.

	probabilities := OrderedCollection with: (AccelerationCard -> 100).
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

	game turn.

	self assert: (game positionOf: spaceship) equals: 8.



]

{ #category : #tests }
WormholeEffectTest >> test230WormholeEffectMovesSpaceshipToItsOtherSide [

	| effect spaceship game board |

	spaceship := Spaceship launch: 'One'.

	board := Board
		of: 20
		wormholeBeginsAt: 5
		andEndsAt: 15.

	game := Game
		playedBy: (OrderedCollection with: spaceship)
		on: board
		throwing: (OrderedCollection with: (LoadedDie of: 3))
		wonAfter: 1.

	effect := WormholeEffect
		isIn: 5
		goesTo: 15.

	self assert: effect position equals: 5.

	effect setPosition: 6.

	self assert: effect position equals: 6.

	effect applyIn: game for: spaceship.

	self assert: (game positionOf: spaceship) equals: 15
]
