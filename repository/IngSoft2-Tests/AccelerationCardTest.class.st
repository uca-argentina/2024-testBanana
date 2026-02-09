Class {
	#name : #AccelerationCardTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
AccelerationCardTest >> gameWithOnly: aSpaceship [
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
AccelerationCardTest >> gameWithOnly: aSpaceship throwing: someDice [
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
AccelerationCardTest >> test168AccelerationAddsTwoSquaresToMovement [
	| game spaceship card initialPosition die |

	spaceship := Spaceship launch: 'A'.

	die := LoadedDie arrayOf: (OrderedCollection with: 1).
	game := self
		gameWithOnly: spaceship
		throwing: (OrderedCollection with: die).

	card := AccelerationCard new.
	(game dataFor: spaceship) addCardToHand: AccelerationCard.

	initialPosition := game positionOf: spaceship.

	game play: card from: spaceship targeting: spaceship.
	game turn.

	self assert: (game positionOf: spaceship)
		equals: initialPosition + 2.




]

{ #category : #tests }
AccelerationCardTest >> test169AccelerationDoesNotAffectBattleRoll [
	| game spaceship card result |

	spaceship := Spaceship launch: 'A'.
	game := self gameWithOnly: spaceship.

	card := AccelerationCard new.
	(game dataFor: spaceship) addCardToHand: AccelerationCard.

	game play: card from: spaceship targeting: spaceship.

	result := card reinforce: spaceship in: game.

	self assert: result equals: 0.


]
