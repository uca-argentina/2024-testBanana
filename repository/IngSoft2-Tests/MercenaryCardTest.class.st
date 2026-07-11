Class {
	#name : #MercenaryCardTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
MercenaryCardTest >> test226MercenaryCardIdentifiesItsAllyAndMercenary [

	| card ally mercenary another game board collection |

	ally := Spaceship launch: 'Ally'.
	mercenary := Spaceship launch: 'Mercenary'.
	another := Spaceship launch: 'Another'.

	board := Board
		of: 100
		wormholeBeginsAt: 50
		andEndsAt: 80.

	game := Game
		playedBy:
			(OrderedCollection
				with: ally
				with: mercenary
				with: another)
		on: board
		throwing:
			(OrderedCollection
				with:
					(LoadedDie arrayOf:
						(OrderedCollection with: 3)))
		wonAfter: 1.

	card := MercenaryCard new.

	card
		from: ally
		withTarget: mercenary
		useIn: game.

	self assert: card ally == ally.
	self assert: card mercenary == mercenary.

	self assert: (card isAlly: ally).
	self assert: (card isMercenary: mercenary).
	self assert: (card usesAsMercenary: mercenary).

	self assert:
		(card
			createsAllianceBetween: ally
			and: mercenary).

	self assert:
		(card
			createsAllianceBetween: mercenary
			and: ally).

	self deny:
		(card
			createsAllianceBetween: ally
			and: another).

	collection := OrderedCollection new.

	card
		addMercenariesOf: ally
		to: collection.

	self assert: collection size equals: 1.
	self assert: collection first == mercenary
]

{ #category : #tests }
MercenaryCardTest >> test227MercenaryCardAddsAlliancePartnerWhenOneShipLoses [

	| card ally mercenary another game board affectedShips |

	ally := Spaceship launch: 'Ally'.
	mercenary := Spaceship launch: 'Mercenary'.
	another := Spaceship launch: 'Another'.

	board := Board
		of: 100
		wormholeBeginsAt: 50
		andEndsAt: 80.

	game := Game
		playedBy:
			(OrderedCollection
				with: ally
				with: mercenary
				with: another)
		on: board
		throwing:
			(OrderedCollection with: (LoadedDie of: 3))
		wonAfter: 1.

	card := MercenaryCard new.

	card
		from: ally
		withTarget: mercenary
		useIn: game.

	affectedShips := OrderedCollection new.

	card
		shipsAffectedByLossOf: ally
		addTo: affectedShips.

	self assert: affectedShips size equals: 1.
	self assert: affectedShips first == mercenary.

	affectedShips removeAll.

	card
		shipsAffectedByLossOf: mercenary
		addTo: affectedShips.

	self assert: affectedShips size equals: 1.
	self assert: affectedShips first == ally.

	affectedShips removeAll.

	card
		shipsAffectedByLossOf: another
		addTo: affectedShips.

	self assert: affectedShips isEmpty
]

{ #category : #tests }
MercenaryCardTest >> test228SpaceshipCannotBeItsOwnMercenary [

	| card spaceship |

	card := MercenaryCard new.
	spaceship := Spaceship launch: 'One'.

	self
		should: [
			card
				validateAllianceBetween: spaceship
				and: spaceship
		]
		raise: Error
]

{ #category : #tests }
MercenaryCardTest >> test229MercenaryCardReinforcesOnlyItsAlly [

	| card ally mercenary another game board |

	ally := Spaceship launch: 'Ally'.
	mercenary := Spaceship launch: 'Mercenary'.
	another := Spaceship launch: 'Another'.

	board := Board
		of: 100
		wormholeBeginsAt: 50
		andEndsAt: 80.

	game := Game
		playedBy:
			(OrderedCollection
				with: ally
				with: mercenary
				with: another)
		on: board
		throwing:
			(OrderedCollection
				with:
					(LoadedDie arrayOf:
						(OrderedCollection with: 3)))
		wonAfter: 1.

	card := MercenaryCard new.

	card
		from: ally
		withTarget: mercenary
		useIn: game.

	self
		assert: (card reinforce: ally in: game)
		equals: 3.

	self
		assert: (card reinforce: another in: game)
		equals: 0
]
