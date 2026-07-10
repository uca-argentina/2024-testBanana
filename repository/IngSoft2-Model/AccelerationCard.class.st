Class {
	#name : #AccelerationCard,
	#superclass : #PermanentCard,
	#category : #'IngSoft2-Model'
}

{ #category : #action }
AccelerationCard >> from: aSpaceship withTarget: anotherSpaceship useIn: aGame [

	self validateIfCardCanBePlayedBy: aSpaceship in: aGame.
	aGame addActiveCard: self.
]

{ #category : #testing }
AccelerationCard >> is: aSpaceship anAllyOf: anotherSpaceship [

^false.
]

{ #category : #'as yet unclassified' }
AccelerationCard >> movementBonusFor: aSpaceship [

	^ 1
]

{ #category : #validation }
AccelerationCard >> validateAllianceBetween: aSpaceship and: anotherSpaceship [
]
