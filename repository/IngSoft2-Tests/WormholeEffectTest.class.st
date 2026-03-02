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
