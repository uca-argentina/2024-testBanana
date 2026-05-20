Class {
	#name : #MercenaryCard,
	#superclass : #PermanentCard,
	#instVars : [
		'ally',
		'mercenary'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #accessing }
MercenaryCard >> ally [
	^ ally
]

{ #category : #action }
MercenaryCard >> from: aSpaceship withTarget: anotherSpaceship useIn: aGame [

	self validateIfCardCanBePlayedBy: aSpaceship in: aGame.
	self validateAllianceBetween: aSpaceship and: anotherSpaceship.

	aGame validateMercenaryAvailability: anotherSpaceship asSpaceship.

	ally := aSpaceship asSpaceship.
	mercenary := anotherSpaceship asSpaceship.

	aGame addActiveCard: self.
]

{ #category : #testing }
MercenaryCard >> is: aSpaceship anAllyOf: anotherSpaceship [

	^ ((ally == aSpaceship asSpaceship)
		and: [ mercenary == anotherSpaceship asSpaceship ])
		or: [
			(ally == anotherSpaceship asSpaceship)
				and: [ mercenary == aSpaceship asSpaceship ]
		]
]

{ #category : #validation }
MercenaryCard >> isAlly: aSpaceship [
	^ ally == aSpaceship asSpaceship
]

{ #category : #validation }
MercenaryCard >> isMercenary: aSpaceship [
	^ mercenary == aSpaceship asSpaceship
]

{ #category : #accessing }
MercenaryCard >> mercenary [
	^ mercenary
]

{ #category : #playing }
MercenaryCard >> playOn: aSpaceship [

^0.
]

{ #category : #action }
MercenaryCard >> reduceShieldsOfAllyOf: aSpaceship in: aGame [

aSpaceship =ally ifTrue: [ aGame decreaseShieldByOneOf:  mercenary. ].
]

{ #category : #action }
MercenaryCard >> reinforce: aSpaceship in: aGame [


aSpaceship = ally ifTrue: [ ^aGame throwDice ].
^0.
]

{ #category : #validation }
MercenaryCard >> validateAllianceBetween: aSpaceship and: anotherSpaceship [
	(aSpaceship == anotherSpaceship)
		ifTrue: [ Error signal: 'A spaceship cannot be its own mercenary' ].
]

{ #category : #validation }
MercenaryCard >> validateIfCardCanBePlayedBy: aSpaceship in: aGame [
	(aGame nextSpaceshipToPlay == aSpaceship)
		ifFalse: [ Error signal: 'Card cannot be played out of turn' ].
]
