Class {
	#name : #RepeatCardTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
RepeatCardTest >> test207RepeatCardDefinesItsCardPolicies [

	| card |

	card := RepeatCard new.

	self assert: card cardType equals: RepeatCard.
	self assert: RepeatCard cardType equals: RepeatCard.

	self assert: card shouldBeDiscardedAfterPlaying.
	self assert: card shouldBeRememberedAsLastPlayedCard
]

{ #category : #tests }
RepeatCardTest >> test208RepeatCardAcceptsAnyTurnAndTargetValidation [

	| card spaceship target game board |

	card := RepeatCard new.
	spaceship := Spaceship launch: 'One'.
	target := Spaceship launch: 'Target'.

	board := Board
		of: 100
		wormholeBeginsAt: 50
		andEndsAt: 80.

	game := Game
		playedBy:
			(OrderedCollection
				with: spaceship
				with: target)
		on: board
		throwing:
			(OrderedCollection with: (LoadedDie of: 3))
		wonAfter: 1.

	self assert:
		(card
			validateIfCardCanBePlayedBy: target
			in: game) == card.

	self assert:
		(card
			validateTarget: target
			in: game) == card
]

{ #category : #tests }
RepeatCardTest >> test209RepeatCardRepeatsLastEffectOnTargetSpaceship [

	| card owner target game board effect initialPosition |

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
		throwing:
			(OrderedCollection with: (LoadedDie of: 3))
		wonAfter: 1.

	effect := NullEffect isIn: 3.
	game saveLastEffectTriggeredTo: effect.

	initialPosition := game positionOf: target.
	card := RepeatCard new.

	card
		from: owner
		withTarget: target
		useIn: game.

	self assert:
		(game positionOf: target)
		equals: initialPosition
]
