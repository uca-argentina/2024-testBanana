"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  Can only be played during the spaceship's turn. The effect continues to apply until removed

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
	#name : #PermanentCard,
	#superclass : #Object,
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
PermanentCard >> addMercenariesOf: aSpaceship to: aCollection [

	^ self
]

{ #category : #'as yet unclassified' }
PermanentCard >> createsAllianceBetween: aSpaceship and: anotherSpaceship [

	^ false
]

{ #category : #action }
PermanentCard >> from: aSpaceship withTarget: anotherSpaceship useIn: aGame [
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
PermanentCard >> movementBonusFor: aSpaceship [

	^ 0
]

{ #category : #action }
PermanentCard >> playOn: aSpaceship [

	^ 0
]

{ #category : #action }
PermanentCard >> reduceShieldsOfAllyOf: aSpaceship in: aGame [

	^ self
]

{ #category : #action }
PermanentCard >> reinforce: aSpaceship in: aGame [

	^ 0
]

{ #category : #'as yet unclassified' }
PermanentCard >> shipsAffectedByLossOf: aSpaceship addTo: aCollection [

	^ self
]

{ #category : #asserting }
PermanentCard >> shouldBeDiscardedAfterPlaying [

	^ false
]

{ #category : #'as yet unclassified' }
PermanentCard >> shouldBeRememberedAsLastPlayedCard [

	^ true
]

{ #category : #action }
PermanentCard >> speedBonusFor: aSpaceship [

	^ 0
]

{ #category : #'as yet unclassified' }
PermanentCard >> usesAsMercenary: aSpaceship [

	^ false
]

{ #category : #validation }
PermanentCard >> validateIfCardCanBePlayedBy: aSpaceship in: aGame [

	(aGame nextSpaceshipToPlay == aSpaceship)
		ifFalse: [
			Error signal: 'Card cannot be played out of turn'
		].
]

{ #category : #'as yet unclassified' }
PermanentCard >> validateTarget: aTarget in: aGame [

	^ self
]
