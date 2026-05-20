Class {
	#name : #CardTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #'set up' }
CardTest >> createBoardOf: length distance: aDistance withEffects: someEffects wormholeBeginsAt: startPoint andEndsAt: endPoint [

	| squares |
	squares := OrderedCollection new.
	1 to: length  do: [ :i |
	squares add: (Square with: (NullEffect isIn: i)) ].
	someEffects ifNotNil: [someEffects do: [ :effect |
		squares at: effect position put: (Square with: effect) ]. ]. 
	^ Board
		  with: squares
		  length: aDistance
		  wormholeBeginsAt: startPoint
		  andEndsAt: endPoint
]

{ #category : #asserting }
CardTest >> should: anErrorBlock raise: anError withMessage: errorMessage [ 

	

self 
	should: anErrorBlock 
	raise: anError 
	withExceptionDo: [ :error |
										self assert: error messageText  equals: errorMessage  ]

]

{ #category : #tests }
CardTest >> test083WhenASpaceshipPlaysASpeedCardThenDiceThrowIncreasesByOne [

	| aGame aSpaceship aBoard aDie aCard spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog for: aSpaceship  withDeck: (OrderedCollection with: SpeedCard with: SpeedCard)  ).
	
	aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 14
		          andEndsAt: 15.

	aDie := LoadedDie of: 3.
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := SpeedCard new.
	aGame play: aCard from: aSpaceship targeting: aSpaceship.
	aGame playTurn.
	self assert: (aGame positionOf: aSpaceship) equals: 5
]

{ #category : #tests }
CardTest >> test084SpeedCardOnlyIncreasesDiceThrowOfTheSpaceshipThatPlaysIt [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard yetAnotherSpaceship spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	yetAnotherSpaceship := Spaceship launch: 'Three'.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog for: aSpaceship  withDeck: (OrderedCollection with: SpeedCard  with: SpeedCard )  ) with: (SpaceshipLog randomCardsfor: anotherSpaceship) with: (SpaceshipLog randomCardsfor: yetAnotherSpaceship   ).
	
	aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 14
		          andEndsAt: 15.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 3 with: 2).
	
	
	aGame := Game
		         playedBy: spaceshipsData 
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := SpeedCard new.
	aGame play: aCard from: aSpaceship targeting: anotherSpaceship.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	self assert: ((aGame positionOf: aSpaceship) = 4 and: ((aGame positionOf: anotherSpaceship) = 5 and: ((aGame positionOf: yetAnotherSpaceship) = 3) )  )
	
]

{ #category : #tests }
CardTest >> test085WhenASpaceshipPlaysAnAccelerationCardThenDiceThrowIncreasesByOne [

	| aGame aSpaceship aBoard aDie aCard spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog for: aSpaceship  withDeck: (OrderedCollection with: SpeedCard  with: AccelerationCard )  ) .
	aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 14
		          andEndsAt: 15.

	aDie := LoadedDie of: 3.
	
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := AccelerationCard new.
	aGame play: aCard from: aSpaceship targeting: aSpaceship.
	aGame playTurn.
	self assert: (aGame positionOf: aSpaceship) equals: 5
]

{ #category : #tests }
CardTest >> test086AccelerationCardIncreasesDiceThrowForAllSpaceships [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard yetAnotherSpaceship spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	yetAnotherSpaceship := Spaceship launch: 'Three'.
	spaceshipsData := OrderedCollection
		                  with: (SpaceshipLog
				                   for: aSpaceship
				                   withDeck:
				                   (OrderedCollection
					                    with: SpeedCard
					                    with: AccelerationCard))
		                  with:
		                  (SpaceshipLog randomCardsfor: anotherSpaceship)
		                  with:
		                  (SpaceshipLog randomCardsfor: yetAnotherSpaceship).
	
		aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 14
		          andEndsAt: 15.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 4 with: 2).
	
		
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := AccelerationCard new.
	aGame play: aCard from: aSpaceship targeting: aSpaceship.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	self assert: ((aGame positionOf: aSpaceship) = 5 and:
			 ((aGame positionOf: anotherSpaceship) = 6 and:
				  (aGame positionOf: yetAnotherSpaceship) = 4))
]

{ #category : #tests }
CardTest >> test087MercenaryCardCanRecruitOneMercenaryThatHelpsInBattles [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard yetAnotherSpaceship spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	yetAnotherSpaceship := Spaceship launch: 'Three'.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog for: aSpaceship  withDeck: (OrderedCollection with: MercenaryCard  with: AccelerationCard )  ) with: (SpaceshipLog randomCardsfor: anotherSpaceship ) with: (SpaceshipLog randomCardsfor: yetAnotherSpaceship  ).
		aBoard := self
		          createBoardOf: 8
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 7
		          andEndsAt: 8.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 3 with: 4).
	
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := MercenaryCard new.
	aGame
		play: aCard
		from: aSpaceship
		targeting: yetAnotherSpaceship.
	aGame playTurn.
	aGame playTurn.
	self assert: ((aGame positionOf: aSpaceship) = 4 and: (aGame positionOf: anotherSpaceship ) = 1)
]

{ #category : #tests }
CardTest >> test088IfSpaceshipAndOneMercenaryLoseTheBattleBothLoseShields [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard yetAnotherSpaceship spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	yetAnotherSpaceship := Spaceship launch: 'Three'.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog for: aSpaceship  withDeck: (OrderedCollection with: MercenaryCard  with: AccelerationCard )  ) with: (SpaceshipLog randomCardsfor: anotherSpaceship ) with: (SpaceshipLog randomCardsfor: yetAnotherSpaceship  ).
		aBoard := self
		          createBoardOf: 8
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 7
		          andEndsAt: 8.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 3 with: 8).
	
		
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := MercenaryCard new.
	aGame
		play: aCard
		from: aSpaceship
		targeting: yetAnotherSpaceship.
	aGame playTurn.
	aGame playTurn.
	
	Transcript show: '--- test088 ---'; cr.
Transcript show: 'pos One=' , (aGame positionOf: aSpaceship) printString; cr.
Transcript show: 'pos Two=' , (aGame positionOf: anotherSpaceship) printString; cr.
Transcript show: 'pos Three=' , (aGame positionOf: yetAnotherSpaceship) printString; cr.
Transcript show: 'sh One=' , (aGame shieldsOf: aSpaceship) printString; cr.
Transcript show: 'sh Two=' , (aGame shieldsOf: anotherSpaceship) printString; cr.
Transcript show: 'sh Three=' , (aGame shieldsOf: yetAnotherSpaceship) printString; cr.
	
	self assert: ((aGame shieldsOf: aSpaceship) = 2 and:
			 (aGame shieldsOf: yetAnotherSpaceship) = 2)
]

{ #category : #tests }
CardTest >> test089ASpaceshipCanRecruitMultipleMercenariesThetHelpInBattle [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard yetAnotherSpaceship fourthSpaceship spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	yetAnotherSpaceship := Spaceship launch: 'Three'.
	fourthSpaceship := Spaceship launch: 'Four'.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog for: aSpaceship  withDeck: (OrderedCollection with: MercenaryCard  with: MercenaryCard )  ) with: (SpaceshipLog randomCardsfor: anotherSpaceship ) with: (SpaceshipLog randomCardsfor: yetAnotherSpaceship  ) with: (SpaceshipLog randomCardsfor: fourthSpaceship ).
		aBoard := self
		          createBoardOf: 8
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 7
		          andEndsAt: 8.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 3 with: 8).
	
	aGame := Game
		         playedBy: spaceshipsData 
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := MercenaryCard new.
	aGame
		play: aCard
		from: aSpaceship
		targeting: yetAnotherSpaceship.
	aGame play: aCard from: aSpaceship targeting: fourthSpaceship.
	aGame playTurn.
	aGame playTurn.
	self assert: ((aGame positionOf: aSpaceship) = 4 and:
			 (aGame positionOf: anotherSpaceship) = 1)
]

{ #category : #tests }
CardTest >> test090IfSpaceshipAndMultipleMercenariesLoseTheBattleTheyAllLoseShields [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard yetAnotherSpaceship fourthSpaceship anotherCard spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	yetAnotherSpaceship := Spaceship launch: 'Three'.
	fourthSpaceship := Spaceship launch: 'Four'.
	spaceshipsData := OrderedCollection
		                  with: (SpaceshipLog
				                   for: aSpaceship
				                   withDeck:
				                   (OrderedCollection
					                    with: MercenaryCard
					                    with: MercenaryCard))
		                  with:
		                  (SpaceshipLog randomCardsfor: anotherSpaceship)
		                  with:
		                  (SpaceshipLog randomCardsfor: yetAnotherSpaceship)
		                  with:
		                  (SpaceshipLog randomCardsfor: fourthSpaceship).
			aBoard := self
		          createBoardOf: 8
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 7
		          andEndsAt: 8.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 3 with: 12 with: 3).
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := MercenaryCard new.
	anotherCard := MercenaryCard new.
	aGame
		play: aCard
		from: aSpaceship
		targeting: yetAnotherSpaceship.
	aGame
		play: anotherCard
		from: aSpaceship
		targeting: fourthSpaceship.
	aGame playTurn.
	aGame playTurn.
	
	Transcript show: '--- test090 ---'; cr.
Transcript show: 'pos One=' , (aGame positionOf: aSpaceship) printString; cr.
Transcript show: 'pos Two=' , (aGame positionOf: anotherSpaceship) printString; cr.
Transcript show: 'pos Three=' , (aGame positionOf: yetAnotherSpaceship) printString; cr.
Transcript show: 'pos Four=' , (aGame positionOf: fourthSpaceship) printString; cr.
Transcript show: 'sh One=' , (aGame shieldsOf: aSpaceship) printString; cr.
Transcript show: 'sh Two=' , (aGame shieldsOf: anotherSpaceship) printString; cr.
Transcript show: 'sh Three=' , (aGame shieldsOf: yetAnotherSpaceship) printString; cr.
Transcript show: 'sh Four=' , (aGame shieldsOf: fourthSpaceship) printString; cr.

	self assert: ((aGame shieldsOf: aSpaceship) = 2 and:
			 ((aGame shieldsOf: yetAnotherSpaceship) = 2 and:
				  (aGame shieldsOf: fourthSpaceship) = 2))
]

{ #category : #tests }
CardTest >> test091MultipleSpeedCardsCanBeActiveAtTheSameTime [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard yetAnotherSpaceship anotherCard spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	yetAnotherSpaceship := Spaceship launch: 'Three'.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog for: aSpaceship  withDeck: (OrderedCollection with: SpeedCard  with: SpeedCard )  ) with: (SpaceshipLog randomCardsfor: anotherSpaceship ) with: (SpaceshipLog randomCardsfor: yetAnotherSpaceship  ).
		aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 14
		          andEndsAt: 15.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 3 with: 2).
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := SpeedCard new.
	anotherCard := SpeedCard new.
	aGame play: aCard from: aSpaceship targeting: anotherSpaceship.
	aGame
		play: anotherCard
		from: aSpaceship
		targeting: anotherSpaceship.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	self assert: ((aGame positionOf: aSpaceship) = 7 and: ((aGame positionOf: anotherSpaceship) = 11 and: ((aGame positionOf: yetAnotherSpaceship) = 3) )  )
	

]

{ #category : #tests }
CardTest >> test092MultipleAccelerationCardsCanBeActiveAtTheSameTime [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard yetAnotherSpaceship anotherCard spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	yetAnotherSpaceship := Spaceship launch: 'Three'.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog for: aSpaceship  withDeck: (OrderedCollection with: AccelerationCard  with: AccelerationCard )  ) with: (SpaceshipLog randomCardsfor: anotherSpaceship ) with: (SpaceshipLog randomCardsfor: yetAnotherSpaceship  ) .
		aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 14
		          andEndsAt: 15.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 4 with: 3 with: 2).
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := AccelerationCard new.
	anotherCard := AccelerationCard new.
	aGame play: aCard from: aSpaceship targeting: anotherSpaceship.
	aGame
		play: anotherCard
		from: aSpaceship
		targeting: anotherSpaceship.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	self assert: ((aGame positionOf: aSpaceship) = 7 and: ((aGame positionOf: anotherSpaceship) = 6 and: ((aGame positionOf: yetAnotherSpaceship) = 5) )  )

]

{ #category : #tests }
CardTest >> test093MultipleSpaceshipsCannotHaveTheSameMercenary [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard yetAnotherSpaceship fourthSpaceship spaceshipsData anotherCard |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	yetAnotherSpaceship := Spaceship launch: 'Three'.
	fourthSpaceship := Spaceship launch: 'Four'.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog for: aSpaceship  withDeck: (OrderedCollection with: MercenaryCard  with: MercenaryCard )  ) with: (SpaceshipLog for: anotherSpaceship withDeck: (OrderedCollection with: MercenaryCard  with: MercenaryCard )) with: (SpaceshipLog randomCardsfor: yetAnotherSpaceship  ) with: (SpaceshipLog randomCardsfor: fourthSpaceship ).
		aBoard := self
		          createBoardOf: 8
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 7
		          andEndsAt: 8.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 3 with: 8).
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := MercenaryCard new.
	anotherCard := MercenaryCard new.
	aGame
		play: aCard
		from: aSpaceship
		targeting: yetAnotherSpaceship.
	aGame playTurn.
	self
		should: [
			aGame
				play: anotherCard
				from: anotherSpaceship
				targeting: yetAnotherSpaceship ]
		raise: Error
		withMessage: 'Selected spaceship is already a mercenary'
]

{ #category : #tests }
CardTest >> test094ASpaceshipDoesNotBattleWithItsMercenary [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog for: aSpaceship  withDeck: (OrderedCollection with: MercenaryCard  with: MercenaryCard )  ) with: (SpaceshipLog randomCardsfor: anotherSpaceship ).
	
	aBoard := self
		          createBoardOf: 8
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 7
		          andEndsAt: 8.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 3).
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := MercenaryCard new.
	aGame play: aCard from: aSpaceship targeting: anotherSpaceship.
	aGame playTurn.
	aGame playTurn.
	self assert: ((aGame positionOf: aSpaceship) = 4 and:
			 (aGame positionOf: anotherSpaceship) = 4)
]

{ #category : #tests }
CardTest >> test095CancellationCardCanRemoveActiveMercenaryCards [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard anotherCard spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog for: aSpaceship  withDeck: (OrderedCollection with: MercenaryCard  with: AccelerationCard )  ) with: (SpaceshipLog for: anotherSpaceship withDeck: (OrderedCollection with: CancellationCard  with: AccelerationCard ) ).
		
	aBoard := self
		          createBoardOf: 8
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 7
		          andEndsAt: 8.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 3 with: 4).
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := MercenaryCard new.
	anotherCard := CancellationCard new.
	aGame play: aCard from: aSpaceship targeting: anotherSpaceship.
	aGame playTurn.
	aGame play: anotherCard from: anotherSpaceship targeting: aCard.
	aGame playTurn.
	self assert: ((aGame positionOf: aSpaceship) = 1 and:
			 (aGame positionOf: anotherSpaceship) = 4)
]

{ #category : #tests }
CardTest >> test096CancellationCardCanRemoveActiveSpeedCards [

	| aGame aSpaceship aBoard aDie aCard anotherCard spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog for: aSpaceship  withDeck: (OrderedCollection with: SpeedCard  with: CancellationCard )  ).
	aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 14
		          andEndsAt: 15.

	aDie := LoadedDie of: 3.

	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := SpeedCard new.
	anotherCard := CancellationCard new.
	aGame play: aCard from: aSpaceship targeting: aSpaceship.
	aGame play: anotherCard from: aSpaceship targeting: aCard.
	aGame playTurn.
	self assert: (aGame positionOf: aSpaceship) equals: 4
]

{ #category : #tests }
CardTest >> test097CancellationCardCanNotBePlayedOnACardThatIsNotActive [

	| aGame aSpaceship aBoard aDie aCard anotherCard spaceshipsData yetAnotherCard |
	aSpaceship := Spaceship launch: 'One'.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog for: aSpaceship  withDeck: (OrderedCollection with: SpeedCard  with: CancellationCard   with: CancellationCard )).
	
	aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 14
		          andEndsAt: 15.

	aDie := LoadedDie of: 3.
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := SpeedCard new.
	anotherCard := CancellationCard new.
	yetAnotherCard:= CancellationCard new.
	aGame play: aCard from: aSpaceship targeting: aSpaceship.
	aGame play: anotherCard from: aSpaceship targeting: aCard.

	self
		should: [
		aGame play: yetAnotherCard from: aSpaceship targeting: aCard ]
		raise: Error
		withMessage: 'Selected card is not active'
]

{ #category : #tests }
CardTest >> test098PermanentCardCannotBePlayedOutOfTurn [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard yetAnotherSpaceship spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	yetAnotherSpaceship := Spaceship launch: 'Three'.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog for: aSpaceship  withDeck: (OrderedCollection with: SpeedCard  with: AccelerationCard )  ) with: (SpaceshipLog for: anotherSpaceship withDeck: (OrderedCollection with: CancellationCard  with: AccelerationCard ) ).
		aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 14
		          andEndsAt: 15.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 3 with: 2).
	
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := SpeedCard new.
	aGame playTurn.
	self
		should: [
		aGame play: aCard from: aSpaceship targeting: anotherSpaceship ]
		raise: Error
		withMessage: 'Card cannot be played out of turn'
]

{ #category : #tests }
CardTest >> test099InstantaneousCardCanBePlayedOutOfTurn [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard anotherCard spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog for: aSpaceship  withDeck: (OrderedCollection with: MercenaryCard  with: AccelerationCard ))  with: (SpaceshipLog for: anotherSpaceship withDeck: (OrderedCollection with: CancellationCard  with: AccelerationCard )).
		aBoard := self
		          createBoardOf: 8
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 7
		          andEndsAt: 8.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 3 with: 4).
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := MercenaryCard new.
	anotherCard := CancellationCard new.
	aGame play: aCard from: aSpaceship targeting: anotherSpaceship.
	aGame play: anotherCard from: anotherSpaceship targeting: aCard.
	aGame playTurn.
	self assert: (aGame positionOf: aSpaceship) equals: 4
]

{ #category : #tests }
CardTest >> test100CardsCannotBePlayedAfterGameIsOver [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog for: aSpaceship  withDeck: (OrderedCollection with: MercenaryCard new with: AccelerationCard new)  ) with: (SpaceshipLog randomCardsfor:  anotherSpaceship ).
		aBoard := self
		          createBoardOf: 8
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 7
		          andEndsAt: 8.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 3 with: 4).
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := MercenaryCard new.

	aGame end.
	self
		should: [
		aGame play: aCard from: aSpaceship targeting: anotherSpaceship ]
		raise: Error
		withMessage: 'Cards cannot be played after game is over'
]

{ #category : #tests }
CardTest >> test101RedoCardCanCopyLastSpeedCardPlayedAndApplyItToADifferentTarget [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard anotherCard spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog for: aSpaceship  withDeck: (OrderedCollection with: SpeedCard  with: AccelerationCard )  ) with: (SpaceshipLog for: anotherSpaceship withDeck: (OrderedCollection with: RedoCard  with: AccelerationCard ) ).
	
		aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 13
		          andEndsAt: 14.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 4 with: 5 with: 3).
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := SpeedCard new.
	anotherCard := RedoCard new.
	aGame play: aCard from: aSpaceship targeting: aSpaceship.
	aGame playTurn.
	aGame
		play: anotherCard
		from: anotherSpaceship
		targeting: anotherSpaceship.
	aGame playTurn.
	self assert: ((aGame positionOf: aSpaceship) = 6 and:
			 (aGame positionOf: anotherSpaceship) = 7)
]

{ #category : #tests }
CardTest >> test102RedoCardCanCopyAnotherRedoCard [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard anotherCard spaceshipsData yetAnotherCard |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog for: aSpaceship  withDeck: (OrderedCollection with: SpeedCard  with: RedoCard )  ) with: (SpaceshipLog for: anotherSpaceship withDeck: (OrderedCollection with: RedoCard  with: AccelerationCard ) ).
		aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 13
		          andEndsAt: 14.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 4 with: 5).
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := SpeedCard new.
	anotherCard := RedoCard new.
	yetAnotherCard:= RedoCard new.
	aGame play: aCard from: aSpaceship targeting: aSpaceship.
	aGame playTurn.
	aGame
		play: anotherCard
		from: anotherSpaceship
		targeting: anotherSpaceship.
	aGame playTurn.
	aGame
		play: yetAnotherCard
		from: aSpaceship 
		targeting: aSpaceship .
	aGame playTurn.
	self assert: ((aGame positionOf: aSpaceship) = 12 and:
			 (aGame positionOf: anotherSpaceship) = 7)
]

{ #category : #tests }
CardTest >> test103RedoCardCannotBePlayedFirst [

	| aGame aSpaceship aBoard aDie anotherSpaceship anotherCard spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog for: aSpaceship  withDeck: (OrderedCollection with: MercenaryCard  with: AccelerationCard )  ) with: (SpaceshipLog for: anotherSpaceship withDeck: (OrderedCollection with: RedoCard  with: AccelerationCard ) ).
	
	
	aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 13
		          andEndsAt: 14.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 4 with: 5).
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	anotherCard := RedoCard new.
	aGame playTurn.

	self
		should: [
			aGame
				play: anotherCard
				from: anotherSpaceship
				targeting: anotherSpaceship ]
		raise: Error
		withMessage: 'There are no cards played to redo'
]

{ #category : #tests }
CardTest >> test104WhenRepeatCardIsPlayedAfterBlackholeEffectThenTargetSpaceshipGoesBackFourSquares [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	spaceshipsData := OrderedCollection
		                  with: (SpaceshipLog randomCardsfor: aSpaceship )
		                  with: (SpaceshipLog
				                   for: anotherSpaceship
				                   withDeck:
				                   (OrderedCollection
					                    with: RepeatCard
					                    with: AccelerationCard)).

	aBoard := self
		          createBoardOf: 10
		          distance: 5
		          withEffects:
		          (OrderedCollection with: (BlackholeEffect isIn: 4))
		          wormholeBeginsAt: 8
		          andEndsAt: 9.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 4 with: 3).
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := RepeatCard new.
	aGame playTurn.
	aGame playTurn.
	aGame play: aCard from: anotherSpaceship targeting: aSpaceship.

	self assert: (aGame positionOf: aSpaceship) equals: 1
]

{ #category : #tests }
CardTest >> test105WhenRepeatCardIsPlayedAfterWormholeEffectThenTargetSpaceshipGoesToTheOtherSide [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	spaceshipsData := OrderedCollection
		                  with: (SpaceshipLog randomCardsfor: aSpaceship )
		                  with: (SpaceshipLog
				                   for: anotherSpaceship
				                   withDeck:
				                   (OrderedCollection
					                    with: RepeatCard
					                    with: AccelerationCard)).
	aBoard := self
		          createBoardOf: 10
		          distance: 5
		          withEffects: OrderedCollection new
		          wormholeBeginsAt: 4
		          andEndsAt: 8.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 4).
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := RepeatCard new.
	aGame playTurn.
	aGame
		play: aCard
		from: anotherSpaceship
		targeting: anotherSpaceship.

	self assert: (aGame positionOf: anotherSpaceship) equals: 8
]

{ #category : #tests }
CardTest >> test106WhenRepeatCardIsPlayedAfterHyperJumpThenTargetSpaceshipMovesSameAmountOfSquaresAsTheSpaceshipThatTriggeredIt [

	| aGame aSpaceship aBoard aDie aParsecDistance anotherSpaceship aCard anotherParsecDistance spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	spaceshipsData := OrderedCollection
		                  with: (SpaceshipLog randomCardsfor: aSpaceship)
		                  with: (SpaceshipLog
				                   for: anotherSpaceship
				                   withDeck:
				                   (OrderedCollection
					                    with: RepeatCard
					                    with: AccelerationCard)).
	aParsecDistance := ParsecDistance of: 1.
	anotherParsecDistance := ParsecDistance of: 2.

	aBoard := self
		          createBoardOf: 20
		          distance: (ParsecDistance of: 5)
		          withEffects: (OrderedCollection with: (HyperJumpEffect
					            isIn: 6
					            movesDistance:
					            (OrderedCollection
						             with: aParsecDistance
						             with: anotherParsecDistance)))
		          wormholeBeginsAt: 1
		          andEndsAt: 2.


	aDie := LoadedDie of: 5.
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.
	aCard := RepeatCard new.
	aGame playTurn.
	aGame
		play: aCard
		from: anotherSpaceship
		targeting: anotherSpaceship.

	self assert: (aGame positionOf: anotherSpaceship) equals: 5
]

{ #category : #tests }
CardTest >> test107WhenRepeatCardIsPlayedAfterMoonWalkThenSpaceshipsGoBackTwice [

	| aGame aSpaceship aBoard aDie anotherSpaceship yetAnotherSpaceship aCard  spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	yetAnotherSpaceship := Spaceship launch: 'Three'.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog for: aSpaceship  withDeck: (OrderedCollection with: RepeatCard  with: AccelerationCard )  ) with: (SpaceshipLog randomCardsfor: anotherSpaceship  ) with: (SpaceshipLog randomCardsfor: yetAnotherSpaceship ).
	aBoard := self createBoardOf: 20 distance: 20 withEffects: (OrderedCollection with: (MoonWalkEffect isIn: 6  moves: 2) ) wormholeBeginsAt: 18 andEndsAt: 19.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 5).
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.
	aCard:= RepeatCard new.
	
	aGame playTurn.
	aGame playTurn.
	aGame play: aCard from: aSpaceship  targeting: aSpaceship.

	self assert: (((aGame positionOf: yetAnotherSpaceship) = 1) and: (((aGame positionOf: aSpaceship) = 2) and: ((aGame positionOf: anotherSpaceship ) = 4))   ) 
]

{ #category : #tests }
CardTest >> test108WhenRepeatCardIsPlayedAfterHyperSpaceJumpEffectThenTargetSpaceshipAdvancesFourSquaresAndLosesAShield [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.

	spaceshipsData := OrderedCollection
		                  with: (SpaceshipLog
				                   for: aSpaceship
				                   withDeck:
				                   (OrderedCollection
					                    with: RepeatCard
					                    with: AccelerationCard))
		                  with:  (SpaceshipLog randomCardsfor: anotherSpaceship).

	aBoard := self
		          createBoardOf: 10
		          distance: 5
		          withEffects:
		          (OrderedCollection with: (HyperSpaceJumpEffect isIn: 4))
		          wormholeBeginsAt: 8
		          andEndsAt: 9.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 4 with: 3).
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := RepeatCard new.
	aGame playTurn.
	aGame playTurn.
	aGame play: aCard from: aSpaceship targeting: aSpaceship.

	self assert: ((aGame positionOf: aSpaceship) = 9 and:
			 (aGame shieldsOf: aSpaceship) = 2)
]

{ #category : #tests }
CardTest >> test109WhenRepeatCardIsPlayedAfterAtomicBombEffectThenAllShieldsGetDecreasedTwice [

	| aGame aSpaceship aBoard aDie anotherSpaceship  aCard yetAnotherSpaceship spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	yetAnotherSpaceship := Spaceship launch: 'Three'.
	spaceshipsData := OrderedCollection
		                  with: (SpaceshipLog
				                   for: aSpaceship
				                   withDeck:
				                   (OrderedCollection
					                    with: RepeatCard
					                    with: AccelerationCard))
		                  with: (SpaceshipLog randomCardsfor: anotherSpaceship )
		                  with:
		                  (SpaceshipLog randomCardsfor: yetAnotherSpaceship).
	
	aBoard := self createBoardOf: 10 distance: 5 withEffects: (OrderedCollection with: (AtomicBombEffect isIn: 4) ) wormholeBeginsAt: 8 andEndsAt: 	9.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 5 with: 3).
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := RepeatCard new.
	aGame playTurn.
	aGame playTurn.
	aGame play: aCard from: aSpaceship targeting: aSpaceship.
	self assert: ((aGame shieldsOf: aSpaceship) = 1 and:
			 ((aGame shieldsOf: anotherSpaceship) = 1 and:
				  (aGame shieldsOf: yetAnotherSpaceship) = 1))
]

{ #category : #tests }
CardTest >> test110RepeatCardDoesNothingIfLastSquareHadNoEffect [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard yetAnotherSpaceship spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	yetAnotherSpaceship := Spaceship launch: 'Three'.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog for: aSpaceship  withDeck: (OrderedCollection with: RepeatCard with: AccelerationCard )  ) with: (SpaceshipLog for: anotherSpaceship withDeck: (OrderedCollection with: RepeatCard with: AccelerationCard ) ) with: (SpaceshipLog randomCardsfor: yetAnotherSpaceship).
	aBoard := self
		          createBoardOf: 10
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 9
		          andEndsAt: 10.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 4 with: 3).
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := RepeatCard new.
	aGame playTurn.
	aGame playTurn.
	aGame play: aCard from: aSpaceship targeting: anotherSpaceship  .
	
	self assert: (((aGame shieldsOf: anotherSpaceship )  = 3) and: ((aGame positionOf: anotherSpaceship ) = 4)) .
]

{ #category : #tests }
CardTest >> test111IfNoSpaceshipHasPlayedYetRepeatCardHasNoEffect [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard yetAnotherSpaceship spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	yetAnotherSpaceship := Spaceship launch: 'Three'.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog for: aSpaceship  withDeck: (OrderedCollection with: RepeatCard with: AccelerationCard )  ) with: (SpaceshipLog for: anotherSpaceship withDeck: (OrderedCollection with: RepeatCard with: AccelerationCard ) ) with: (SpaceshipLog randomCardsfor: yetAnotherSpaceship).
	aBoard := self
		          createBoardOf: 10
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 9
		          andEndsAt: 10.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 4 with: 3).
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := RepeatCard new.
	aGame play: aCard from: aSpaceship targeting: anotherSpaceship  .
	
	self assert: (((aGame shieldsOf: anotherSpaceship )  = 3) and: ((aGame positionOf: anotherSpaceship ) = 1)) .
]

{ #category : #tests }
CardTest >> test112SpaceshipDataCanBeCreatedWithTwoRandomCards [

	|  aSpaceship aSpaceshipData  |
	aSpaceship := Spaceship launch: 'One'.
	aSpaceshipData:= SpaceshipLog randomCardsfor: aSpaceship .
	
	self assert: (aSpaceshipData cards size) equals:2 .
]

{ #category : #tests }
CardTest >> test113SpaceshipDataIsCreatedWithRandomValidCards [

	|  aSpaceship    aSpaceshipData cardTypes |
	aSpaceship := Spaceship launch: 'One'.
	aSpaceshipData:= SpaceshipLog randomCardsfor: aSpaceship .
	cardTypes := OrderedCollection
		             with: AccelerationCard
		             with: SpeedCard
		             with: MercenaryCard
		             with: RedoCard
		             with: RepeatCard.
	
	self assert: (aSpaceshipData cards allSatisfy: [:card | cardTypes includes: (card class) ]) .
]

{ #category : #tests }
CardTest >> test114ASpaceshipCannotPlayACardThatIsNotInItsHand [

	| aGame aSpaceship aBoard aDie aCard spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog for: aSpaceship  withDeck: (OrderedCollection with: AccelerationCard with: AccelerationCard)  ).
	aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 14
		          andEndsAt: 15.

	aDie := LoadedDie of: 3.
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := SpeedCard new.
	
	self should: [ aGame play: aCard from: aSpaceship targeting: aSpaceship ] raise: Error withMessage: 'A Spaceship cannot play a card that is not in its hand'
]

{ #category : #tests }
CardTest >> test115IfASpaceshipPlaysACardItIsRemovedFromItsHand [

	| aGame aSpaceship aBoard aDie aCard spaceshipsData anotherCard |
	aSpaceship := Spaceship launch: 'One'.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog for: aSpaceship  withDeck: (OrderedCollection with: SpeedCard with: AccelerationCard)  ).
	aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 14
		          andEndsAt: 15.

	aDie := LoadedDie of: 3.
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := SpeedCard new.
	anotherCard:= SpeedCard new.
	aGame play: aCard from: aSpaceship targeting: aSpaceship.
	
	self should: [ aGame play: anotherCard from: aSpaceship targeting: aSpaceship ] raise: Error withMessage: 'A Spaceship cannot play a card that is not in its hand'
]

{ #category : #tests }
CardTest >> test116MysteryCardEffectAddsACardToASpaceshipThatLandsInIt [

	| aGame aSpaceship aBoard aDie spaceshipsData mysteryCardEffect |
	aSpaceship := Spaceship launch: 'One'.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog randomCardsfor: aSpaceship  ).
	mysteryCardEffect := (MysteryCardEffect isIn: 4).
	
	
	aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 1)
		          withEffects: (OrderedCollection with: mysteryCardEffect)
		          wormholeBeginsAt: 13
		          andEndsAt: 14.

	aDie := LoadedDie of: 3.
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aGame playTurn .
	
	self assert: (spaceshipsData first cards size) equals: 3
]

{ #category : #tests }
CardTest >> test117MysteryCardEffectAddsValidCardTypesToSpaceships [

	| aGame aSpaceship aBoard aDie spaceshipsData mysteryCardEffect cardTypes |
	aSpaceship := Spaceship launch: 'One'.
	spaceshipsData := OrderedCollection with:
		                  (SpaceshipLog randomCardsfor: aSpaceship).
	mysteryCardEffect := (MysteryCardEffect isIn: 4).
	
	aBoard := self
		          createBoardOf: 20
		          distance: (ParsecDistance of: 1)
		          withEffects: (OrderedCollection with: mysteryCardEffect)
		          wormholeBeginsAt: 13
		          andEndsAt: 14.

	aDie := LoadedDie of: 3.
	
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	cardTypes := OrderedCollection
		             with: AccelerationCard
		             with: SpeedCard
		             with: MercenaryCard
		             with: RedoCard
		             with: RepeatCard.
	aGame playTurn.


	self assert: (spaceshipsData first cards allSatisfy: [ :card |
			 cardTypes includes: card class ])
]

{ #category : #tests }
CardTest >> test118MercenarySpaceshipDoesNotRecieveHelpFromItsAlly [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard yetAnotherSpaceship spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	yetAnotherSpaceship := Spaceship launch: 'Three'.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog for: aSpaceship  withDeck: (OrderedCollection with: MercenaryCard  with: AccelerationCard )  ) with: (SpaceshipLog randomCardsfor: anotherSpaceship ) with: (SpaceshipLog randomCardsfor: yetAnotherSpaceship  ).
	
		aBoard := self
		          createBoardOf: 8
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 6
		          andEndsAt: 7.

	aDie := LoadedDie arrayOf:(OrderedCollection with: 1 with: 4 with: 4).
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := MercenaryCard new.
	aGame
		play: aCard
		from: aSpaceship
		targeting: yetAnotherSpaceship.
	aGame playTurn.
	aGame playTurn.
	self assert: (aGame positionOf: yetAnotherSpaceship ) equals: 1
]

{ #category : #tests }
CardTest >> test119WhenRepeatCardIsPlayedAfterMysteryCardEffectThenTargetSpaceshipGainsACard [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard mysteryCardEffect spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog for: aSpaceship  withDeck: (OrderedCollection with: MercenaryCard  with: AccelerationCard )  ) with: (SpaceshipLog for: anotherSpaceship withDeck: (OrderedCollection with: RepeatCard  with: AccelerationCard ) ).
	mysteryCardEffect := ( MysteryCardEffect isIn: 4).
	
	aBoard := self
		          createBoardOf: 10
		          distance: (ParsecDistance of: 1)
		          withEffects: (OrderedCollection with: mysteryCardEffect)
		          wormholeBeginsAt: 8
		          andEndsAt: 9.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 4 with: 3).
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := RepeatCard new.
	aGame playTurn.
	aGame playTurn.
	aGame play: aCard from: anotherSpaceship targeting: aSpaceship .
	
	self assert: (spaceshipsData first cards size) equals: 3.
]

{ #category : #tests }
CardTest >> test125SpaceshipCannotAppointItselfAsItsMercenary [

	| aGame aSpaceship aBoard aDie aCard spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.

	spaceshipsData := OrderedCollection with: (SpaceshipLog
			                   for: aSpaceship
			                   withDeck:
			                   (OrderedCollection
				                    with: MercenaryCard
				                    with: AccelerationCard)).
	aBoard := self
		          createBoardOf: 10
		          distance: 1
		          withEffects: OrderedCollection new
		          wormholeBeginsAt: 8
		          andEndsAt: 9.
 
	aDie := LoadedDie of: 3.
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := MercenaryCard new.

	self
		should: [
		aGame play: aCard from: aSpaceship targeting: aSpaceship ]
		raise: Error
		withMessage: 'A spaceship cannot be its own mercenary'
]

{ #category : #tests }
CardTest >> test126WhenRedoCardCopiesMercenaryCardThenAlliedSpaceshipsDoNotBattle [

	| aGame aSpaceship anotherSpaceship yetAnotherSpaceship aBoard aDie aCard anotherCard spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	yetAnotherSpaceship := Spaceship launch: 'Three'.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog for: aSpaceship  withDeck: (OrderedCollection with: MercenaryCard  with: AccelerationCard )  ) with: (SpaceshipLog for: anotherSpaceship withDeck: (OrderedCollection with: RedoCard  with: AccelerationCard ) ) with: (SpaceshipLog randomCardsfor: yetAnotherSpaceship ).
	
	aBoard := self createBoardOf: 16 distance: 5 withEffects: (OrderedCollection new) wormholeBeginsAt: 13 andEndsAt: 14.

	aDie := LoadedDie arrayOf:
		        (OrderedCollection with: 3 with: 4 with: 4).
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := MercenaryCard  new.
	anotherCard := RedoCard new.
	aGame play: aCard from: aSpaceship targeting: anotherSpaceship .
	aGame playTurn.
	aGame
		play: anotherCard
		from: anotherSpaceship
		targeting: yetAnotherSpaceship.
	aGame playTurn.
	aGame playTurn .
	self assert: ((aGame positionOf: anotherSpaceship ) = 5 and:
			 (aGame positionOf: yetAnotherSpaceship ) = 5)
]

{ #category : #tests }
CardTest >> test127WhenRedoCardCopiesAccelerationCardThenAllSpaceshipsIncreaseTheirThrowByTwo [

	| aGame aSpaceship anotherSpaceship yetAnotherSpaceship aBoard aDie aCard anotherCard spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	yetAnotherSpaceship := Spaceship launch: 'Three'.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog for: aSpaceship  withDeck: (OrderedCollection with: MercenaryCard  with: AccelerationCard )  ) with: (SpaceshipLog for: anotherSpaceship withDeck: (OrderedCollection with: RedoCard  with: AccelerationCard ) ) with: (SpaceshipLog randomCardsfor: yetAnotherSpaceship ).
	
	aBoard := self createBoardOf: 16 distance: 5 withEffects: (OrderedCollection new) wormholeBeginsAt: 13 andEndsAt: 14.

	aDie := LoadedDie arrayOf:
		        (OrderedCollection with: 1 with: 4 with: 6).
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := AccelerationCard   new.
	anotherCard := RedoCard new.
	aGame play: aCard from: aSpaceship targeting: anotherSpaceship .
	aGame playTurn.
	aGame
		play: anotherCard
		from: anotherSpaceship
		targeting: yetAnotherSpaceship.
	3 timesRepeat: 	[aGame playTurn].

	self assert: (((aGame positionOf: aSpaceship) = 6) and: (((aGame positionOf: anotherSpaceship)  = 7) and: ((aGame positionOf: yetAnotherSpaceship)  = 9) ) )
]

{ #category : #tests }
CardTest >> test128WhenRedoCardCopiesCancellationCardThenThrowIncreaseIsCancelled [

	| aGame aSpaceship anotherSpaceship aBoard aDie aSpeedCard anotherSpeedCard aRedoCard aCancellationCard spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.

	spaceshipsData := OrderedCollection
		                  with: (SpaceshipLog
				                   for: aSpaceship
				                   withDeck:
				                   (OrderedCollection
					                    with: SpeedCard 
					                    with: SpeedCard))
		                  with: (SpaceshipLog
				                   for: anotherSpaceship
				                   withDeck:
				                   (OrderedCollection
					                    with: RedoCard
					                    with: CancellationCard )).

	aBoard := self
		          createBoardOf: 16
		          distance: 5
		          withEffects: OrderedCollection new
		          wormholeBeginsAt: 13
		          andEndsAt: 14.

	aDie := LoadedDie of: 3.
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aSpeedCard  := SpeedCard new.
	anotherSpeedCard  := SpeedCard  new.
	aCancellationCard  := CancellationCard new.
	aRedoCard  := RedoCard new.
	
	aGame play: aSpeedCard   from: aSpaceship  targeting: aSpaceship .
	aGame play: anotherSpeedCard  from: aSpaceship  targeting: aSpaceship .
	aGame play: aCancellationCard  from: anotherSpaceship  targeting: aSpeedCard .
	aGame play: aRedoCard  from: anotherSpaceship  targeting: anotherSpeedCard .
	aGame playTurn .
	
	self assert: (aGame positionOf: aSpaceship ) equals: 4
	
]

{ #category : #tests }
CardTest >> test129WhenRedoCardCopiesRepeatCardThenEffectIsAppliedAgain [

	| aGame aSpaceship anotherSpaceship aBoard aDie aRepeatCard  aRedoCard  spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.

	spaceshipsData := OrderedCollection
		                  with: (SpaceshipLog
				                   for: aSpaceship
				                   withDeck:
				                   (OrderedCollection
					                    with: RedoCard  
					                    with: SpeedCard))
		                  with: (SpaceshipLog
				                   for: anotherSpaceship
				                   withDeck:
				                   (OrderedCollection
					                    with: RepeatCard 
					                    with: CancellationCard )).

	aBoard := self
		          createBoardOf: 16
		          distance: 5
		          withEffects: (OrderedCollection with: (HyperSpaceJumpEffect isIn: 4))
		          wormholeBeginsAt: 13
		          andEndsAt: 14.

	aDie := LoadedDie of: 3.
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aRepeatCard := RepeatCard new.
	aRedoCard  := RedoCard new.
	
	
	aGame playTurn .
	aGame play: aRepeatCard  from: anotherSpaceship  targeting: anotherSpaceship .
	aGame play: aRedoCard  from: aSpaceship  targeting: aSpaceship .
	
	self assert: (aGame positionOf: aSpaceship ) equals: 12
	
]

{ #category : #tests }
CardTest >> test130CancellationCardCanRemoveActiveAccelerationCards [

	| aGame aSpaceship aBoard aDie  aCard anotherCard spaceshipsData anotherSpaceship |
	aSpaceship := Spaceship launch: 'One'.
	anotherSpaceship := Spaceship launch: 'Two'.
	spaceshipsData:= OrderedCollection with: (SpaceshipLog for: aSpaceship  withDeck: (OrderedCollection with: AccelerationCard with: CancellationCard )  ) with: (SpaceshipLog randomCardsfor: anotherSpaceship ).
	
	aBoard := self createBoardOf: 16 distance: 5 withEffects: {  } wormholeBeginsAt: 13 andEndsAt: 14.
	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 4).
	aGame := Game
		         playedBy: spaceshipsData
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := AccelerationCard  new.
	anotherCard := CancellationCard new.
	aGame play: aCard from: aSpaceship targeting: aSpaceship.
	aGame play: anotherCard from: aSpaceship targeting: aCard.
	aGame playTurn.
	aGame playTurn.
	self assert: (((aGame positionOf: aSpaceship) = 4) and: ((aGame positionOf: anotherSpaceship) = 5) )
]

{ #category : #tests }
CardTest >> test131CancellationCardCannotBePlayedOnInstantaneousCards [

	| aGame aSpaceship aBoard aDie aSpeedCard aRedoCard aRepeatCard aCancellationCard spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	spaceshipsData := OrderedCollection with:
					  (SpaceshipLog
						   for: aSpaceship
						   withDeck:
							   (OrderedCollection
								    with: SpeedCard
								    with: RedoCard
								    with: RepeatCard
								    with: CancellationCard)).

	aBoard := self
			  createBoardOf: 16
			  distance: (ParsecDistance of: 1)
			  withEffects: (nil)
			  wormholeBeginsAt: 14
			  andEndsAt: 15.

	aDie := LoadedDie of: 3.
	aGame := Game
			 playedBy: spaceshipsData
			 on: aBoard
			 throwing: (OrderedCollection with: aDie)
			 wonAfter: 3.

	aSpeedCard := SpeedCard new.
	aRedoCard := RedoCard new.
	aRepeatCard := RepeatCard new.
	aCancellationCard := CancellationCard new.

	aGame play: aSpeedCard from: aSpaceship targeting: aSpaceship.
	aGame play: aRedoCard from: aSpaceship targeting: aSpaceship.

	self
		should: [ aGame play: aCancellationCard from: aSpaceship targeting: aRedoCard ]
		raise: Error
		withMessage: 'Selected card is not active'.

	self
		should: [ aGame play: aCancellationCard from: aSpaceship targeting: aRepeatCard ]
		raise: Error
		withMessage: 'Selected card is not active'
]

{ #category : #tests }
CardTest >> test132CancellationCardRemovesOnlyOneOfMultipleActiveSpeedCards [

	| aGame aSpaceship aBoard aDie aFirstSpeedCard aSecondSpeedCard aCancellationCard spaceshipsData |
	aSpaceship := Spaceship launch: 'One'.
	spaceshipsData := OrderedCollection with:
					  (SpaceshipLog
						   for: aSpaceship
						   withDeck:
							   (OrderedCollection
								    with: SpeedCard
								    with: SpeedCard
								    with: CancellationCard)).

	aBoard := self
			  createBoardOf: 16
			  distance: (ParsecDistance of: 1)
			  withEffects: (nil)
			  wormholeBeginsAt: 14
			  andEndsAt: 15.

	aDie := LoadedDie of: 3.
	aGame := Game
			 playedBy: spaceshipsData
			 on: aBoard
			 throwing: (OrderedCollection with: aDie)
			 wonAfter: 3.

	aFirstSpeedCard := SpeedCard new.
	aSecondSpeedCard := SpeedCard new.
	aCancellationCard := CancellationCard new.

	aGame play: aFirstSpeedCard from: aSpaceship targeting: aSpaceship.
	aGame play: aSecondSpeedCard from: aSpaceship targeting: aSpaceship.
	aGame play: aCancellationCard from: aSpaceship targeting: aFirstSpeedCard.
	aGame playTurn.

	self assert: (aGame positionOf: aSpaceship) equals: 5
]
