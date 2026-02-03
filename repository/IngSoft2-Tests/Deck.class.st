Class {
	#name : #Deck,
	#superclass : #Object,
	#instVars : [
		'cards',
		'discard'
	],
	#classInstVars : [
		'cards'
	],
	#category : #'IngSoft2-Tests'
}

{ #category : #'as yet unclassified' }
Deck class >> initializeWithCardClasses: someCardClasses [
    cards := someCardClasses.

]

{ #category : #'as yet unclassified' }
Deck class >> ofSize: aSize withProbabilities: someProbabilities using: aRandom [
    | cardClasses |
    cardClasses := OrderedCollection new.
    1 to: aSize do: [ :i |
    cardClasses add: (self pickCardClassFrom: someProbabilities using: aRandom) ].
    ^ self new initializeWithCardClasses: cardClasses.

]

{ #category : #'as yet unclassified' }
Deck class >> pickCardClassFrom: someProbabilities using: aRandom [

    | roll cumulative |

    roll := (aRandom respondsTo: #nextInt:)
        ifTrue: [ aRandom nextInt: 100 ]
        ifFalse: [ aRandom nextInteger: 100 ].

    cumulative := 0.

    someProbabilities associationsDo: [:assoc |
        cumulative := cumulative + assoc value.
        (roll <= cumulative) ifTrue: [ ^ assoc key ].
    ].

    Error signal: 'Invalid probabilities'



]

{ #category : #accessing }
Deck >> discardSize [
    ^ discard size

]

{ #category : #drawing }
Deck >> draw [
 	 | cardClass |   
	cards isEmpty ifTrue: [
        discard isEmpty ifTrue: [
            Error signal: 'Deck is empty'
        ].
        cards := discard shuffled.
        discard := OrderedCollection new.
    ].   
    cardClass := cards removeFirst.
    discard add: cardClass.
    ^ cardClass new


]

{ #category : #initialization }
Deck >> initializeWithCardClasses: someCardClasses [
    cards := someCardClasses asOrderedCollection.
    discard := OrderedCollection new.


]

{ #category : #initialization }
Deck >> initializeWithSize: aSize [
    cards := OrderedCollection new.
    1 to: aSize do: [ :i |
        cards add: SpeedCard new ].

]

{ #category : #accessing }
Deck >> size [
    ^ cards size.


]
