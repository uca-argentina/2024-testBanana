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

{ #category : #accessing }
AccelerationCard >> mercenary [
^0
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
