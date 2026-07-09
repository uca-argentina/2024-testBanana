Class {
	#name : #DoubleCard,
	#superclass : #Object,
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
DoubleCard >> from: aSpaceship withTarget: anotherSpaceship useIn: aGame [
	(aGame dataFor: anotherSpaceship) activateDoubleForNextBattle.

]

{ #category : #action }
DoubleCard >> reinforce: aSpaceship in: aGame [
	(aGame hasDoubleFor: aSpaceship)
		ifTrue: [
			aGame consumeDouble.
			^ aGame throwDice
		].
	^ 0


]

{ #category : #validation }
DoubleCard >> shouldBeRememberedAsLastPlayedCard [

	^ true
]

{ #category : #validation }
DoubleCard >> validateIfCardCanBePlayedBy: aSpaceship in: aGame [

	^ self
]

{ #category : #validation }
DoubleCard >> validateTarget: aTarget in: aGame [

	^ self
]
