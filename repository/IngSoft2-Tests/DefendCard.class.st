Class {
	#name : #DefendCard,
	#superclass : #Object,
	#category : #'IngSoft2-Tests'
}

{ #category : #'instance creation' }
DefendCard >> from: aSpaceship withTarget: anotherSpaceship useIn: aGame [
    aGame increaseShieldByOneOf: anotherSpaceship.

]
