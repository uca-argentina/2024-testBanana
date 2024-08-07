"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part: Creates the squares with effects

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them.

Public API and Key Messages

- message one
- message two
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.

Internal Representation and Key Implementation Points.


    Implementation Points
"
Class {
	#name : #BoardDistributionCreator,
	#superclass : #Object,
	#category : #'IngSoft2-Model'
}

{ #category : #initialization }
BoardDistributionCreator >> createHyperJumpIn: aSquare withParsecRatio: aRatio maximumAmountOfValues: anAmount [

	| hyperJumpEffect toMove randomAmount |
	toMove := OrderedCollection new.
	randomAmount := anAmount atRandom.
	randomAmount timesRepeat: [
		2 atRandom = 2
			ifTrue: [ toMove add: (LightyearDistance of: aRatio atRandom) ]
			ifFalse: [ toMove add: (ParsecDistance of: aRatio atRandom) ] ].

	hyperJumpEffect := HyperJumpEffect
		                   isIn: aSquare
		                   movesDistance: toMove.

	^ hyperJumpEffect
]

{ #category : #action }
BoardDistributionCreator >> createOf: length with: someProbabilities withParsecs: anAmountOfParsecs maximumHyperJumpValues: anAmount [

	| squares specialEffect random lowerLimit |
	squares := OrderedCollection new.
	lowerLimit := 0.
	1 to: length do: [ :position |
		random := 100 atRandom.
		specialEffect := NullEffect isIn: position.
		someProbabilities keysAndValuesDo: [ :effect :probability |
			(random between: lowerLimit and: lowerLimit + probability) ifTrue: [
				specialEffect := effect = HyperJumpEffect
					                 ifTrue: [
						                 self
							                 createHyperJumpIn: position
							                 withParsecRatio: length / anAmountOfParsecs
							                 maximumAmountOfValues: anAmount ]
					                 ifFalse: [ effect isIn: position ] ].
			lowerLimit := probability + lowerLimit ].

		squares add: (Square with: specialEffect) ].

	^ squares
]
