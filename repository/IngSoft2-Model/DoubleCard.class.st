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
