"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part: When played, deletes one of the active permanent cards

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
	#name : #CancellationCard,
	#superclass : #Object,
	#category : #'IngSoft2-Model'
}

{ #category : #action }
CancellationCard >> from: aSpaceship withTarget: aCard useIn: aGame [ 
	aGame removeActiveCard: aCard.
]

{ #category : #asserting }
CancellationCard >> shouldBeDiscardedAfterPlaying [

	^ true
]

{ #category : #validation }
CancellationCard >> shouldBeRememberedAsLastPlayedCard [

	^ true
]

{ #category : #validation }
CancellationCard >> validateIfCardCanBePlayedBy: aSpaceship in: aGame [

	^ self
]

{ #category : #validation }
CancellationCard >> validateTarget: aCard in: aGame [

	aGame validateActiveCardSelected: aCard
]
