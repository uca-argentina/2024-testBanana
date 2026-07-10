"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  When played, applies the effect of the last square that a spaceship landed on

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
	#name : #RepeatCard,
	#superclass : #Object,
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
RepeatCard class >> cardType [
	^ self
]

{ #category : #'as yet unclassified' }
RepeatCard >> cardType [
	^ RepeatCard
]

{ #category : #action }
RepeatCard >> from: aSpaceship withTarget: anotherSpaceship useIn: aGame [
	aGame repeatLastEffectFor: anotherSpaceship  
]

{ #category : #asserting }
RepeatCard >> shouldBeDiscardedAfterPlaying [

	^ true
]

{ #category : #validation }
RepeatCard >> shouldBeRememberedAsLastPlayedCard [

	^ true
]

{ #category : #validation }
RepeatCard >> validateIfCardCanBePlayedBy: aSpaceship in: aGame [

	^ self
]

{ #category : #validation }
RepeatCard >> validateTarget: aTarget in: aGame [

	^ self
]
