Class {
	#name : #SequenceRandom,
	#superclass : #Object,
	#instVars : [
		'values',
		'index'
	],
	#category : #'IngSoft2-Tests'
}

{ #category : #'instance creation' }
SequenceRandom class >> withAll: aCollection [
    ^ self new initializeWithAll: aCollection.

]

{ #category : #initialization }
SequenceRandom >> initializeWithAll: aCollection [
    values := aCollection asOrderedCollection.
    index := 0.
    ^ self


]

{ #category : #'as yet unclassified' }
SequenceRandom >> next [
    "Devuelve un número entre 0 y 1 para shuffledBy:"
    ^ (self nextInt: 100) / 100.0


]

{ #category : #'as yet unclassified' }
SequenceRandom >> nextInt: anInteger [
    index := index + 1.
    index > values size ifTrue: [ index := 1 ].
    ^ values at: index


]

{ #category : #'as yet unclassified' }
SequenceRandom >> nextInteger: anInteger [
    ^ self nextInt: anInteger


]
