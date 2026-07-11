Class {
	#name : #SquareTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
SquareTest >> test203SquareIsCreatedWithAnEffect [

	| effect square |

	effect := NullEffect isIn: 3.
	square := Square with: effect.

	self assert: square effect == effect
]

{ #category : #tests }
SquareTest >> test204SquareAppliesItsEffectWhenSpaceshipLands [

	| spaceship game board effect square initialPosition |

	spaceship := Spaceship launch: 'One'.

	board := Board
		of: 100
		wormholeBeginsAt: 50
		andEndsAt: 80.

	game := Game
		playedBy: (OrderedCollection with: spaceship)
		on: board
		throwing: (OrderedCollection with: (LoadedDie of: 3))
		wonAfter: 1.

	effect := NullEffect isIn: 3.
	square := Square with: effect.

	initialPosition := game positionOf: spaceship.

	square land: spaceship in: game.

	self assert: (game positionOf: spaceship) equals: initialPosition
]
