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
SequenceRandom >> nextInt: anInteger [
    index := index + 1.
    index > values size ifTrue: [ index := values size ].
    ^ values at: index


]

{ #category : #'as yet unclassified' }
SequenceRandom >> nextInteger: anInteger [
    index := index + 1.
    index > values size ifTrue: [ self error: 'SequenceRandom exhausted' ].
    ^ values at: index.


]
