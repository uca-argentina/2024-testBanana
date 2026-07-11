Class {
	#name : #PermanentCardTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #running }
PermanentCardTest >> gameWithPlayers: someSpaceships [

	| board |

	board := Board
		of: 100
		wormholeBeginsAt: 50
		andEndsAt: 80.

	^ Game
		playedBy: someSpaceships
		on: board
		throwing: (OrderedCollection with: (LoadedDie of: 3))
		wonAfter: 1
]

{ #category : #tests }
PermanentCardTest >> test187PermanentCardProvidesNeutralDefaultBehavior [

	| card spaceship game collection |

	card := PermanentCard new.
	spaceship := Spaceship launch: 'One'.

	game := self gameWithPlayers:
		(OrderedCollection with: spaceship).

	collection := OrderedCollection new.

	self assert: (card movementBonusFor: spaceship) equals: 0.
	self assert: (card speedBonusFor: spaceship) equals: 0.
	self assert: (card reinforce: spaceship in: game) equals: 0.
	self assert: (card playOn: spaceship) equals: 0.

	self deny: (card usesAsMercenary: spaceship).
	self deny:
		(card
			createsAllianceBetween: spaceship
			and: spaceship).

	self deny: card shouldBeDiscardedAfterPlaying.
	self assert: card shouldBeRememberedAsLastPlayedCard.

	self assert:
		(card addMercenariesOf: spaceship to: collection) == card.
	self assert: collection isEmpty.

	self assert:
		(card shipsAffectedByLossOf: spaceship addTo: collection) == card.
	self assert: collection isEmpty.

	self assert:
		(card validateTarget: spaceship in: game) == card
]

{ #category : #tests }
PermanentCardTest >> test188PermanentCardCanBePlayedByCurrentSpaceship [

	| card currentSpaceship anotherSpaceship game |

	card := PermanentCard new.
	currentSpaceship := Spaceship launch: 'Current'.
	anotherSpaceship := Spaceship launch: 'Another'.

	game := self gameWithPlayers:
		(OrderedCollection
			with: currentSpaceship
			with: anotherSpaceship).

	card
		validateIfCardCanBePlayedBy: currentSpaceship
		in: game.

	self assert: game nextSpaceshipToPlay == currentSpaceship
]

{ #category : #tests }
PermanentCardTest >> test189PermanentCardCannotBePlayedOutOfTurn [

	| card currentSpaceship anotherSpaceship game |

	card := PermanentCard new.
	currentSpaceship := Spaceship launch: 'Current'.
	anotherSpaceship := Spaceship launch: 'Another'.

	game := self gameWithPlayers:
		(OrderedCollection
			with: currentSpaceship
			with: anotherSpaceship).

	self
		should: [
			card
				validateIfCardCanBePlayedBy: anotherSpaceship
				in: game
		]
		raise: Error
]

{ #category : #tests }
PermanentCardTest >> test190PermanentCardRequiresSubclassToImplementItsApplication [

	| card spaceship target game |

	card := PermanentCard new.
	spaceship := Spaceship launch: 'One'.
	target := Spaceship launch: 'Target'.

	game := self gameWithPlayers:
		(OrderedCollection
			with: spaceship
			with: target).

	self
		should: [
			card
				from: spaceship
				withTarget: target
				useIn: game
		]
		raise: Error
]
