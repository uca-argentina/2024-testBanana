"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  Squares with this effect do nothing

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


    Implementation Points
"
Class {
	#name : #NullEffect,
	#superclass : #Object,
	#instVars : [
		'myPosition'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
NullEffect class >> isIn: aPosition [

 ^self new initializeIsIn: aPosition 
]

{ #category : #action }
NullEffect >> applyIn: aGame for: aSpaceship [
	^ self

]

{ #category : #initialization }
NullEffect >> initializeIsIn: aPosition [ 

myPosition := aPosition.
]

{ #category : #accessing }
NullEffect >> position [

^myPosition 
]

{ #category : #initialization }
NullEffect >> setPosition: aPosition [
myPosition := aPosition.
]
