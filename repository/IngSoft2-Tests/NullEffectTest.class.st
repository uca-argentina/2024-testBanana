Class {
	#name : #NullEffectTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
NullEffectTest >> gameWithOnly: aSpaceship [
	| board dice deck probabilities |

	board := Board of: 10 wormholeBeginsAt: 3 andEndsAt: 7.
	dice := { LoadedDie of: 6 }.

	probabilities := OrderedCollection with: (AccelerationCard -> 100).

	deck := Deck
		ofSize: 10
		withProbabilities: probabilities
		using: (SequenceRandom withAll: #(1 2 3 4 5 6 7 8 9 10)).

	^ Game
		playedBy: (OrderedCollection with: aSpaceship)
		on: board
		throwing: dice
		wonAfter: 1
		usingDeck: deck.


]

{ #category : #tests }
NullEffectTest >> test167NullEffectDoesNothingWhenApplied [
	| game spaceship effect deck probabilities board |

	spaceship := Spaceship launch: 'A'.

	board := Board of: 100 wormholeBeginsAt: 50 andEndsAt: 80.

	probabilities := OrderedCollection with: (AccelerationCard -> 100).
	deck := Deck
		ofSize: 10
		withProbabilities: probabilities
		using: (SequenceRandom withAll: #(1 2 3 4 5 6 7 8 9 10)).

	game := Game
		playedBy: (OrderedCollection with: spaceship)
		on: board
		throwing: OrderedCollection new
		wonAfter: 1
		usingDeck: deck.

	effect := NullEffect isIn: 3.
	effect applyIn: game for: spaceship.

	self assert: (game positionOf: spaceship) equals: 1.



]

{ #category : #tests }
NullEffectTest >> test172NullEffectDoesNotChangePosition [
	| game spaceship effect initial |

	spaceship := Spaceship launch: 'A'.
	game := self gameWithOnly: spaceship.

	effect := NullEffect isIn: 3.
	initial := game positionOf: spaceship.

	effect applyIn: game for: spaceship.

	self assert: (game positionOf: spaceship) equals: initial.

]

{ #category : #tests }
NullEffectTest >> test217NullEffectRemembersItsPosition [

	| effect |

	effect := NullEffect isIn: 4.

	self assert: effect position equals: 4
]

{ #category : #tests }
NullEffectTest >> test218NullEffectCanChangeItsPosition [

	| effect |

	effect := NullEffect isIn: 4.

	effect setPosition: 9.

	self assert: effect position equals: 9
]

{ #category : #tests }
NullEffectTest >> test219NullEffectReturnsItselfWhenApplied [

	| effect spaceship game board |

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

	effect := NullEffect isIn: 4.

	self assert: (effect applyIn: game for: spaceship) == effect
]
