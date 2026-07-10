Class {
	#name : #MercenaryCard,
	#superclass : #PermanentCard,
	#instVars : [
		'ally',
		'mercenary'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
MercenaryCard >> addMercenariesOf: aSpaceship to: aCollection [

	ally == aSpaceship
		ifTrue: [
			aCollection add: mercenary
		].
]

{ #category : #accessing }
MercenaryCard >> ally [
	^ ally
]

{ #category : #'as yet unclassified' }
MercenaryCard >> createsAllianceBetween: aSpaceship and: anotherSpaceship [

	^ self
		is: aSpaceship
		anAllyOf: anotherSpaceship
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

{ #category : #action }
MercenaryCard >> reinforce: aSpaceship in: aGame [


aSpaceship = ally ifTrue: [ ^aGame throwDice ].
^0.
]

{ #category : #'as yet unclassified' }
MercenaryCard >> shipsAffectedByLossOf: aSpaceship addTo: aCollection [

	(self isAlly: aSpaceship)
		ifTrue: [
			aCollection add: mercenary
		].

	(self isMercenary: aSpaceship)
		ifTrue: [
			aCollection add: ally
		].
]

{ #category : #'as yet unclassified' }
MercenaryCard >> usesAsMercenary: aSpaceship [

	^ mercenary == aSpaceship asSpaceship
]

{ #category : #validation }
MercenaryCard >> validateAllianceBetween: aSpaceship and: anotherSpaceship [
	(aSpaceship == anotherSpaceship)
		ifTrue: [ Error signal: 'A spaceship cannot be its own mercenary' ].
]
