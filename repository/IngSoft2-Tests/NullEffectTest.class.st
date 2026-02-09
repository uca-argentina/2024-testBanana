Class {
	#name : #NullEffectTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
NullEffectTest >> gameWithOnly: aSpaceship [
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
NullEffectTest >> test167NullEffectDoesNothingWhenApplied [
	| game spaceship effect |

	spaceship := Spaceship launch: 'A'.
	game := self gameWithOnly: spaceship.
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
