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
	| game spaceship card initialPosition die deck probabilities |

	spaceship := Spaceship launch: 'A'.
	die := LoadedDie arrayOf: (OrderedCollection with: 1).

	probabilities := OrderedCollection with: (AccelerationCard -> 100).
	deck := Deck ofSize: 10 withProbabilities: probabilities using: (SequenceRandom withAll: #(1 2 3 4 5 6 7 8 9 10)).

	game := Game
		playedBy: (OrderedCollection with: (SpaceshipLog new initializeRandomCardsFor: spaceship))
		on: (Board of: 100 wormholeBeginsAt: 50 andEndsAt: 80)
		throwing: (OrderedCollection with: die)
		wonAfter: 1
		usingDeck: deck.

	card := AccelerationCard new.
	(game dataFor: spaceship) addCard: card.

	initialPosition := game positionOf: spaceship.

	game play: card from: spaceship targeting: spaceship.
	game turn.

	self assert: (game positionOf: spaceship)
		equals: initialPosition + 2.





]

{ #category : #tests }
AccelerationCardTest >> test169AccelerationDoesNotAffectBattleRoll [
	| game spaceship card result deck probabilities |

	spaceship := Spaceship launch: 'A'.

	probabilities := OrderedCollection with: (AccelerationCard -> 100).
	deck := Deck ofSize: 10 withProbabilities: probabilities using: (SequenceRandom withAll: #(1 2 3 4 5 6 7 8 9 10)).

	game := Game
		playedBy: (OrderedCollection with: (SpaceshipLog new initializeRandomCardsFor: spaceship))
		on: (Board of: 100 wormholeBeginsAt: 50 andEndsAt: 80)
		throwing: OrderedCollection new
		wonAfter: 1
		usingDeck: deck.

	card := AccelerationCard new.
	(game dataFor: spaceship) addCard: card.

	game play: card from: spaceship targeting: spaceship.

	result := card reinforce: spaceship in: game.

	self assert: result equals: 0.



]

{ #category : #tests }
AccelerationCardTest >> test171AccelerationStacksIfPlayedTwice [
	| game spaceship die card initial deck probabilities |

	spaceship := Spaceship launch: 'A'.
	die := LoadedDie arrayOf: (OrderedCollection with: 1).

	probabilities := OrderedCollection with: (AccelerationCard -> 100).
	deck := Deck ofSize: 10 withProbabilities: probabilities using: (SequenceRandom withAll: #(1 2 3 4 5 6 7 8 9 10)).

	game := Game
		playedBy: (OrderedCollection with: (SpaceshipLog new initializeRandomCardsFor: spaceship))
		on: (Board of: 100 wormholeBeginsAt: 50 andEndsAt: 80)
		throwing: (OrderedCollection with: die)
		wonAfter: 1
		usingDeck: deck.

	card := AccelerationCard new.
	(game dataFor: spaceship) addCard: card.
	(game dataFor: spaceship) addCard: card.

	initial := game positionOf: spaceship.

	game play: card from: spaceship targeting: spaceship.
	game play: card from: spaceship targeting: spaceship.
	game turn.

	self assert: (game positionOf: spaceship)
		equals: initial + 1 + 2.


]

{ #category : #tests }
AccelerationCardTest >> test194AccelerationCardDoesNotCreateAnAlliance [

	| card one another |

	card := AccelerationCard new.
	one := Spaceship launch: 'One'.
	another := Spaceship launch: 'Another'.

	self deny: (card is: one anAllyOf: another).

	self assert:
		(card validateAllianceBetween: one and: another) == card
]

{ #category : #tests }
AccelerationCardTest >> test195AccelerationCardProvidesOneMovementPoint [

	| card one another |

	card := AccelerationCard new.
	one := Spaceship launch: 'One'.
	another := Spaceship launch: 'Another'.

	self assert: (card movementBonusFor: one) equals: 1.
	self assert: (card movementBonusFor: another) equals: 1
]

{ #category : #tests }
AccelerationCardTest >> test196AccelerationCardBecomesActiveWhenPlayed [

	| card owner target game board |

	owner := Spaceship launch: 'Owner'.
	target := Spaceship launch: 'Target'.

	board := Board
		of: 100
		wormholeBeginsAt: 50
		andEndsAt: 80.

	game := Game
		playedBy:
			(OrderedCollection
				with: owner
				with: target)
		on: board
		throwing: (OrderedCollection with: (LoadedDie of: 3))
		wonAfter: 1.

	card := AccelerationCard new.

	card
		from: owner
		withTarget: target
		useIn: game.

	game validateActiveCardSelected: card.

	self assert: (card movementBonusFor: owner) equals: 1.
	self assert: (card movementBonusFor: target) equals: 1
]
