"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  I am a square in the board with one or more effects.

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them.

Public API and Key Messages

- message one
- message two
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.

Internal Representation and Key Implementation Points.

    Instance Variables
	effects:		<Object>


    Implementation Points
"
Class {
	#name : #Square,
	#superclass : #Object,
	#instVars : [
		'effect'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
Square class >> with: anEffect [

^ self new initializeWith: anEffect  
]

{ #category : #accessing }
Square >> effect [
	^ effect
]

{ #category : #initialization }
Square >> initializeWith: anEffect [

effect := anEffect.
]

{ #category : #action }
Square >> land: aSpaceship in:aGame [
	aGame saveLastEffectTriggeredTo: effect .
	^ effect applyIn: aGame for: aSpaceship 
]
