Class {
	#name : #Deck,
	#superclass : #Object,
	#instVars : [
		'cards'
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
        cardClasses add: SpeedCard ].
    ^ self new initializeWithCardClasses: cardClasses.

]

{ #category : #drawing }
Deck >> draw [
    ^ (cards removeFirst) new.

]

{ #category : #initialization }
Deck >> initializeWithCardClasses: someCardClasses [
    cards := someCardClasses.

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
