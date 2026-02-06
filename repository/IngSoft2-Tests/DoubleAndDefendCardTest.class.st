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

{ #category : #tests }
DoubleAndDefendCardTest >> test156DoubleDoublesNextBattleRollForTarget [

	| aSpaceship bSpaceship spaceshipsData aBoard aGame aDie doubleCard |

	aSpaceship := Spaceship launch: 'A'.
	bSpaceship := Spaceship launch: 'B'.

	spaceshipsData := OrderedCollection with:
		(SpaceshipLog for: aSpaceship withDeck: (OrderedCollection with: DoubleCard))
		with: (SpaceshipLog for: bSpaceship withDeck: (OrderedCollection new)).

	aBoard := self
		createBoardOf: 4
		distance: (ParsecDistance of: 1)
		withEffects: nil
		wormholeBeginsAt: 3
		andEndsAt: 4.

	"Die siempre da 2"
	aDie := LoadedDie of: 3.




	aGame := Game
		playedBy: spaceshipsData
		on: aBoard
		throwing: (OrderedCollection with: aDie)
		wonAfter: 3.

	doubleCard := DoubleCard new.

	"Se juega sobre A"
	aGame play: doubleCard from: aSpaceship targeting: aSpaceship.

	"Movemos A a la posición de B para forzar batalla"
	aGame make: aSpaceship move: 1.

	"Batalla manual"
	aGame battleBetween: aSpaceship and: bSpaceship.

	"Sin Double: 2 vs 2 → pierde A por empate
	Con Double: A tira 4 vs 2 → pierde B"

	self assert: (aGame shieldsOf: bSpaceship) equals: 2.

]

{ #category : #tests }
DoubleAndDefendCardTest >> test157DoubleIsConsumedAfterFirstBattleOnly [
	| aSpaceship bSpaceship cSpaceship spaceshipsData aBoard aGame aDie doubleCard |

	aSpaceship := Spaceship launch: 'A'.
	bSpaceship := Spaceship launch: 'B'.
	cSpaceship := Spaceship launch: 'C'.

	spaceshipsData := OrderedCollection with:
		(SpaceshipLog for: aSpaceship withDeck: (OrderedCollection with: DoubleCard))
		with: (SpaceshipLog for: bSpaceship withDeck: OrderedCollection new)
		with: (SpaceshipLog for: cSpaceship withDeck: OrderedCollection new).

	aBoard := self
		createBoardOf: 4
		distance: (ParsecDistance of: 1)
		withEffects: nil
		wormholeBeginsAt: 3
		andEndsAt: 4.

	"Die siempre da 2"
	aDie := LoadedDie arrayOf: (OrderedCollection with: 2).



	aGame := Game
		playedBy: spaceshipsData
		on: aBoard
		throwing: (OrderedCollection with: aDie)
		wonAfter: 3.

	doubleCard := DoubleCard new.
	aGame play: doubleCard from: aSpaceship targeting: aSpaceship.

	"Primera batalla: Double activo"
	aGame battleBetween: aSpaceship and: bSpaceship.
	self assert: (aGame shieldsOf: bSpaceship) equals: 2.

	"Segunda batalla: Double ya consumido"
	aGame battleBetween: aSpaceship and: cSpaceship.
	self assert: (aGame shieldsOf: cSpaceship) equals: 3.

]

{ #category : #tests }
DoubleAndDefendCardTest >> test158DoubleDoesNotAffectMovementRoll [

	| aSpaceship bSpaceship spaceshipsData aBoard aGame aDie doubleCard |

	"Arrange"
	aSpaceship := Spaceship launch: 'A'.
	bSpaceship := Spaceship launch: 'B'.

	spaceshipsData := OrderedCollection with:
		(SpaceshipLog for: aSpaceship withDeck: (OrderedCollection with: DoubleCard))
		with: (SpaceshipLog for: bSpaceship withDeck: OrderedCollection new).

	aBoard := self
		createBoardOf: 5
		distance: (ParsecDistance of: 1)
		withEffects: nil
		wormholeBeginsAt: 4
		andEndsAt: 5.

	"El dado siempre devuelve 2"
	aDie := LoadedDie arrayOf: (OrderedCollection with: 2).

	aGame := Game
		playedBy: spaceshipsData
		on: aBoard
		throwing: (OrderedCollection with: aDie)
		wonAfter: 5.

	doubleCard := DoubleCard new.

	"Se juega Double sobre A"
	aGame play: doubleCard from: aSpaceship targeting: aSpaceship.

	"Act: turno normal (movimiento)"
	aGame turn.

	"Assert: A se movió SOLO 2 (no 4)"
	self assert: (aGame positionOf: aSpaceship) equals: 3.

]

{ #category : #tests }
DoubleAndDefendCardTest >> test159DoubleIsConsumedAfterFirstBattleOnly [

	| aSpaceship bSpaceship cSpaceship spaceshipsData aBoard aGame aDie doubleCard |

	"Arrange"
	aSpaceship := Spaceship launch: 'A'.
	bSpaceship := Spaceship launch: 'B'.
	cSpaceship := Spaceship launch: 'C'.

	spaceshipsData := OrderedCollection with:
		(SpaceshipLog for: aSpaceship withDeck: (OrderedCollection with: DoubleCard))
		with: (SpaceshipLog for: bSpaceship withDeck: OrderedCollection new)
		with: (SpaceshipLog for: cSpaceship withDeck: OrderedCollection new).

	"Tablero donde A pelea primero con B y luego con C"
	aBoard := self
		createBoardOf: 3
		distance: (ParsecDistance of: 1)
		withEffects: nil
		wormholeBeginsAt: 2
		andEndsAt: 3.

	"Dado determinístico: siempre 2"
	aDie := LoadedDie arrayOf: (OrderedCollection with: 2).

	aGame := Game
		playedBy: spaceshipsData
		on: aBoard
		throwing: (OrderedCollection with: aDie)
		wonAfter: 5.

	doubleCard := DoubleCard new.

	"Se juega Double sobre A"
	aGame play: doubleCard from: aSpaceship targeting: aSpaceship.

	"Primera batalla: A vs B"
	aGame battleBetween: aSpaceship and: bSpaceship.

	"Segunda batalla: A vs C"
	aGame battleBetween: aSpaceship and: cSpaceship.

	"Assert:
	- En la primera, A duplica (4 vs 2) → pierde B
	- En la segunda, A NO duplica (2 vs 2) → pierde A"

	self assert: (aGame shieldsOf: bSpaceship) equals: 2.
	self assert: (aGame shieldsOf: aSpaceship) equals: 2.


]
