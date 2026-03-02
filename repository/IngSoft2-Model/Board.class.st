"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  ""A board""

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
	#name : #Board,
	#superclass : #Object,
	#instVars : [
		'boardOfSquares',
		'parsecs'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
Board class >> of: aNumberOfSquares wormholeBeginsAt: startingPoint andEndsAt: endPoint [

	| boardOfSquares |
	boardOfSquares := OrderedCollection new.
	1 to: aNumberOfSquares do: [ :square |
		boardOfSquares add: (Square with: (NullEffect isIn: square)) ].

	self validate: aNumberOfSquares and: endPoint and: startingPoint.

	^ self new
		  initializeWith: boardOfSquares
		  length: 1
		  wormholeBeginsAt: startingPoint
		  andEndsAt: endPoint
]

{ #category : #'argument validation' }
Board class >> validate: aNumberOfSquares and: endPoint and: startingPoint [

	self validateSizeOf: aNumberOfSquares.
	self validate: endPoint isNotEqualTo: startingPoint.
	self
		validateWormholeEndpointsOf: startingPoint
		and: endPoint
		areWithin: aNumberOfSquares
]

{ #category : #'argument validation' }
Board class >> validate: endPoint isNotEqualTo: startingPoint [

	startingPoint = endPoint ifTrue: [
		Error signal: 'Wormhole endpoints cannot be in the same square' ]
]

{ #category : #'argument validation' }
Board class >> validateSizeOf: aNumberOfSquares [
	aNumberOfSquares <= 0 ifTrue: [ Error signal: 'Board must have at least 1 square' ].
	
]

{ #category : #'argument validation' }
Board class >> validateWormholeEndpointsOf: startingPoint and: endPoint areWithin: aNumberOfSquares [

	(startingPoint > 0 and: (endPoint > 0 and:
			  (startingPoint < aNumberOfSquares and:
				   endPoint <= aNumberOfSquares))) ifFalse: [
		Error signal: 'Wormhole out of bounds' ].
	
]

{ #category : #'instance creation' }
Board class >> with: theSquares length: aDistance wormholeBeginsAt: startPoint andEndsAt: endpoint [

	^ self new
		  initializeWith: theSquares
		  length: aDistance
		  wormholeBeginsAt: startPoint
		  andEndsAt: endpoint
]

{ #category : #accessing }
Board >> applyEffectFor: aSpaceship afterMovingTo: aSquare whenPlaying: aGame [

	| effectToApply |

	aSquare isInteger ifFalse: [
		self error: 'NOT INTEGER POSITION: ', aSquare class name
	].

	effectToApply := (boardOfSquares collect: [:sq | sq effect ])
		detect: [:anEffect | anEffect position = aSquare ]
		ifNone: [ NullEffect isIn: aSquare ].

	aGame saveLastEffectTriggeredTo: effectToApply.
	^ effectToApply applyIn: aGame for: aSpaceship


]

{ #category : #converting }
Board >> convertToSquares: aDistance [
	^ (aDistance inParsecs) * self lengthInSquares // (parsecs inParsecs)
]

{ #category : #initialization }
Board >> initializeWith: theSquares length: aDistance wormholeBeginsAt: startingPoint andEndsAt: endPoint [

	boardOfSquares := OrderedCollection  withAll: theSquares.
	parsecs := aDistance.

	boardOfSquares
		at: startingPoint
		put:
		(Square with: (WormholeEffect isIn: startingPoint goesTo: endPoint)).
	boardOfSquares
		at: endPoint
		put:
		(Square with: (WormholeEffect isIn: endPoint goesTo: startingPoint))
]

{ #category : #converting }
Board >> lapsAfterMoving: totalSquaresMoved [
	
	^ totalSquaresMoved // self lengthInSquares
]

{ #category : #accessing }
Board >> lengthInLightYears [
	^ parsecs inParsecs * 3.
]

{ #category : #accessing }
Board >> lengthInParsecs [
	^ parsecs inParsecs.
]

{ #category : #accessing }
Board >> lengthInSquares [ 


^ boardOfSquares size.
]

{ #category : #converting }
Board >> squareNumberAfterMoving: anAmountOfSquares [

	| length result |
	length := self lengthInSquares.
	result := anAmountOfSquares \\ length.
	result < 0 ifTrue: [ result := result + length ].
	^ result + 1



]
