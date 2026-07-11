Class {
	#name : #RedoCardTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
RedoCardTest >> test205RedoCardDefinesItsCardPolicies [

	| card |

	card := RedoCard new.

	self assert: card cardType equals: RedoCard.
	self assert: RedoCard cardType equals: RedoCard.

	self assert: card shouldBeDiscardedAfterPlaying.
	self deny: card shouldBeRememberedAsLastPlayedCard
]

{ #category : #tests }
RedoCardTest >> test206RedoCardAcceptsAnyTurnAndTargetValidation [

	| card spaceship target game board |

	card := RedoCard new.
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
		throwing: (OrderedCollection with: (LoadedDie of: 3))
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
