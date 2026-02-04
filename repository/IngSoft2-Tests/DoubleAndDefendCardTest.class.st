Class {
	#name : #DoubleAndDefendCardTest,
	#superclass : #CardTest,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
DoubleAndDefendCardTest >> test153DefendIncreasesShieldsByOneWhenNotFull [

	| aGame aSpaceship aBoard aDie defendCard spaceshipsData |

	aSpaceship := Spaceship launch: 'One'.

	spaceshipsData := OrderedCollection with:
		(SpaceshipLog
			for: aSpaceship
			withDeck: (OrderedCollection with: DefendCard)).

	aBoard := self
		createBoardOf: 16
		distance: (ParsecDistance of: 1)
		withEffects: nil
		wormholeBeginsAt: 14
		andEndsAt: 15.

	aDie := LoadedDie of: 3.

	aGame := Game
		playedBy: spaceshipsData
		on: aBoard
		throwing: (OrderedCollection with: aDie)
		wonAfter: 3.

	"Dejamos la nave con 2 shields"
	aGame decreaseShieldByOneOf: aSpaceship.
	self assert: (aGame shieldsOf: aSpaceship) equals: 2.

	defendCard := DefendCard new.

	"Act"
	aGame play: defendCard from: aSpaceship targeting: aSpaceship.

	self assert: (aGame shieldsOf: aSpaceship) equals: 3.


]

{ #category : #tests }
DoubleAndDefendCardTest >> test154DefendIncreasesMaxShieldsWhenFull [

	| aGame aSpaceship aBoard aDie defendCard spaceshipsData |

	aSpaceship := Spaceship launch: 'One'.

	spaceshipsData := OrderedCollection with:
		(SpaceshipLog
			for: aSpaceship
			withDeck: (OrderedCollection with: DefendCard)).

	aBoard := self
		createBoardOf: 16
		distance: (ParsecDistance of: 1)
		withEffects: nil
		wormholeBeginsAt: 14
		andEndsAt: 15.

	aDie := LoadedDie of: 3.

	aGame := Game
		playedBy: spaceshipsData
		on: aBoard
		throwing: (OrderedCollection with: aDie)
		wonAfter: 3.

	"Shields iniciales = 3"
	self assert: (aGame shieldsOf: aSpaceship) equals: 3.

	defendCard := DefendCard new.

	"Act"
	aGame play: defendCard from: aSpaceship targeting: aSpaceship.

	"Assert: ahora tiene 4"
	self assert: (aGame shieldsOf: aSpaceship) equals: 4.

]

{ #category : #tests }
DoubleAndDefendCardTest >> test155DefendMakesRechargeRestoreNewMaximum [

	| aGame aSpaceship aBoard aDie defendCard spaceshipsData |

	aSpaceship := Spaceship launch: 'One'.

	spaceshipsData := OrderedCollection with:
		(SpaceshipLog
			for: aSpaceship
			withDeck: (OrderedCollection with: DefendCard)).

	aBoard := self
		createBoardOf: 16
		distance: (ParsecDistance of: 1)
		withEffects: nil
		wormholeBeginsAt: 14
		andEndsAt: 15.

	aDie := LoadedDie of: 3.

	aGame := Game
		playedBy: spaceshipsData
		on: aBoard
		throwing: (OrderedCollection with: aDie)
		wonAfter: 3.

	"Full shields"
	self assert: (aGame shieldsOf: aSpaceship) equals: 3.

	defendCard := DefendCard new.
	aGame play: defendCard from: aSpaceship targeting: aSpaceship.

	"Ahora debería tener 4"
	self assert: (aGame shieldsOf: aSpaceship) equals: 4.

	"Pierde 1 shield"
	aGame decreaseShieldByOneOf: aSpaceship.
	self assert: (aGame shieldsOf: aSpaceship) equals: 3.

	"Recarga"
	aGame rechargeShieldsOf: aSpaceship.

	"Si max subió, debe volver a 4, no a 3"
	self assert: (aGame shieldsOf: aSpaceship) equals: 4.

]
