Class {
	#name : #BlackholeEffectTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
BlackholeEffectTest >> test174BlackHoleSendsSpaceshipToBeginning [
	| game spaceship die board squares initialShields deck probabilities |

	spaceship := Spaceship launch: 'A'.
	die := LoadedDie arrayOf: (OrderedCollection with: 1).

	squares := OrderedCollection new.
	1 to: 10 do: [ :i |
		i = 2
			ifTrue: [ squares add: (Square with: (BlackholeEffect isIn: i)) ]
			ifFalse: [ squares add: (Square with: (NullEffect isIn: i)) ] ].

	board := Board
		with: squares
		length: 1
		wormholeBeginsAt: 5
		andEndsAt: 9.

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

	initialShields := game shieldsOf: spaceship.

	game turn.

	self assert: (game positionOf: spaceship) equals: 1.
	self assert: (game shieldsOf: spaceship) equals: initialShields.


]

{ #category : #tests }
BlackholeEffectTest >> test212BlackholeEffectRemembersItsPosition [

	| effect |

	effect := BlackholeEffect isIn: 7.

	self assert: effect position equals: 7
]

{ #category : #tests }
BlackholeEffectTest >> test213BlackholeEffectCanChangeItsPosition [

	| effect |

	effect := BlackholeEffect isIn: 7.

	effect setPosition: 12.

	self assert: effect position equals: 12
]
