"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  Parsecs

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them.

Public API and Key Messages

- message one
- message two
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.

Internal Representation and Key Implementation Points.

    Instance Variables
	myPosition:		<Object>
	parsecs:		<Object>


    Implementation Points
"
Class {
	#name : #HyperJumpEffect,
	#superclass : #Object,
	#instVars : [
		'toMove',
		'myPosition'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #testing }
HyperJumpEffect class >> isIn: aSquare movesDistance: someDistances [
	^self new initializeIsIn: aSquare movesDistance: someDistances
]

{ #category : #action }
HyperJumpEffect >> applyIn: aGame for: aSpaceship [

	| currentDistance squaresToMove |
	currentDistance := toMove removeFirst.
	toMove addLast: currentDistance.
	squaresToMove := aGame convertToSquares:  (currentDistance inParsecs) .
	aGame make: aSpaceship  move: squaresToMove .
	

]

{ #category : #initialization }
HyperJumpEffect >> initializeIsIn: aSquare movesDistance: someDistance [

	myPosition := aSquare.
	toMove  := someDistance .
]

{ #category : #accessing }
HyperJumpEffect >> position [

^myPosition 
]

{ #category : #initialization }
HyperJumpEffect >> setPosition: aPosition [
myPosition := aPosition.
]
