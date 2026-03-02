Class {
	#name : #Spaceship,
	#superclass : #Object,
	#instVars : [
		'myName',
		'name'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #initialize }
Spaceship class >> launch: aName [

	^ self new initializeLaunch: aName
]

{ #category : #comparing }
Spaceship >> = anotherObject [
	(self class = anotherObject class) ifFalse: [ ^ false ].
	^ name = anotherObject name


]

{ #category : #converting }
Spaceship >> asSpaceship [
	^ self
]

{ #category : #converting }
Spaceship >> asSpaceshipLogWithDeck: aDeck [
	^ SpaceshipLog new initializeFor: self withDeck: aDeck
]

{ #category : #comparing }
Spaceship >> equals: anotherObject [
	^ self = anotherObject
]

{ #category : #accessing }
Spaceship >> getName [
^ myName.
]

{ #category : #comparing }
Spaceship >> hash [
	^ name hash

]

{ #category : #initialize }
Spaceship >> initializeLaunch: aName [ 

myName := aName.
]

{ #category : #accessing }
Spaceship >> name [
	^ name

]
