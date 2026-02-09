Class {
	#name : #BlackHoleEffect,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
BlackHoleEffect >> test174BlackHoleSendsSpaceshipToBeginning [
	| game spaceship die board squares initialShields |

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
		wormholeBeginsAt: 3
		andEndsAt: 4.

	game := Game
		playedBy: (OrderedCollection with:
			(SpaceshipLog new initializeFor: spaceship withDeck: OrderedCollection new))
		on: board
		throwing: (OrderedCollection with: die)
		wonAfter: 1.

	initialShields := game shieldsOf: spaceship.

	"1 → 2 cae en BlackHole"
	game turn.

	self assert: (game positionOf: spaceship) equals: 1.
	self assert: (game shieldsOf: spaceship) equals: initialShields.

]
