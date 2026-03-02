Class {
	#name : #AccelerationCard,
	#superclass : #PermanentCard,
	#instVars : [
		'owner',
		'affectedSpaceship'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #action }
AccelerationCard >> affectedSpaceship [
	^ affectedSpaceship
]

{ #category : #action }
AccelerationCard >> from: aSpaceship withTarget: anotherSpaceship useIn: aGame [
	self validateIfCardCanBePlayedBy: aSpaceship in: aGame.
	affectedSpaceship := anotherSpaceship.
	aGame addActiveCard: self.
]

{ #category : #testing }
AccelerationCard >> is: aSpaceship anAllyOf: anotherSpaceship [

^false.
]

{ #category : #accessing }
AccelerationCard >> mercenary [
^0
]

{ #category : #action }
AccelerationCard >> owner [
	^ owner
]

{ #category : #playing }
AccelerationCard >> playOn: aSpaceship [
	^ 1

]

{ #category : #action }
AccelerationCard >> reduceShieldsOfAllyOf: aSpaceship in: aGame [


]

{ #category : #action }
AccelerationCard >> reinforce: aSpaceship in: aGame [

^0.
]

{ #category : #validation }
AccelerationCard >> validateAllianceBetween: aSpaceship and: anotherSpaceship [
]

{ #category : #validation }
AccelerationCard >> validateIfCardCanBePlayedBy: aSpaceship in: aGame [
	(aGame nextSpaceshipToPlay == aSpaceship)
		ifFalse: [ Error signal: 'Card cannot be played out of turn' ].
]
