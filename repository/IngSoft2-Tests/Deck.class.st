Class {
	#name : #Deck,
	#superclass : #Object,
	#instVars : [
		'cards',
		'discard',
		'rng'
	],
	#classInstVars : [
		'cards'
	],
	#category : #'IngSoft2-Tests'
}

{ #category : #requirements }
Deck class >> empty [
    ^ self new initializeWithCardClasses: OrderedCollection new

]

{ #category : #'as yet unclassified' }
Deck class >> ofSize: aSize withProbabilities: someProbabilities using: aRandom [
    | cardClasses |
    cardClasses := OrderedCollection new.
    1 to: aSize do: [:i |
        cardClasses add: (self pickCardClassFrom: someProbabilities using: aRandom)
    ].
    ^ self new initializeWithCardClasses: cardClasses using: aRandom



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
            Error signal: 'Deck has no cards available'
        ].
        self shuffleDiscardIntoDeck.
    ].

    cardClass := cards removeFirst.
    discard add: cardClass.
    ^ cardClass new


]

{ #category : #initialization }
Deck >> initializeWithCardClasses: someCardClasses [
    cards := someCardClasses.
    discard := OrderedCollection new.
    ^ self

]

{ #category : #initialization }
Deck >> initializeWithCardClasses: someCardClasses using: aRandom [
    cards := someCardClasses asOrderedCollection.
    discard := OrderedCollection new.
    rng := aRandom.


]

{ #category : #initialization }
Deck >> initializeWithSize: aSize [
    cards := OrderedCollection new.
    1 to: aSize do: [ :i |
        cards add: SpeedCard new ].

]

{ #category : #'as yet unclassified' }
Deck >> shuffleDiscardIntoDeck [
	| temp roll index |

	temp := discard copy.
	cards := OrderedCollection new.

	[ temp isEmpty ] whileFalse: [
		roll := (rng respondsTo: #nextInt:)
			ifTrue: [ rng nextInt: 100 ]
			ifFalse: [ rng nextInteger: 100 ].

		index := ((roll - 1) \\ temp size) + 1.

		cards add: (temp removeAt: index).
	].

	discard := OrderedCollection new.

]

{ #category : #accessing }
Deck >> size [
    ^ cards size.


]
