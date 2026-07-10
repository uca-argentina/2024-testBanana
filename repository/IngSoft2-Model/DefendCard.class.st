Class {
	#name : #DefendCard,
	#superclass : #Object,
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
DefendCard >> from: aSpaceship withTarget: anotherSpaceship useIn: aGame [
    aGame increaseShieldByOneOf: anotherSpaceship.

]

{ #category : #asserting }
DefendCard >> shouldBeDiscardedAfterPlaying [

	^ true
]

{ #category : #validation }
DefendCard >> shouldBeRememberedAsLastPlayedCard [

	^ true
]

{ #category : #validation }
DefendCard >> validateIfCardCanBePlayedBy: aSpaceship in: aGame [

	^ self
]

{ #category : #validation }
DefendCard >> validateTarget: aTarget in: aGame [

	^ self
]
