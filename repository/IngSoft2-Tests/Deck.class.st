Class {
	#name : #Deck,
	#superclass : #Object,
	#instVars : [
		'cards',
		'discard',
		'probabilities',
		'random'
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
Deck class >> normalizedProbabilitiesFrom: someProbabilities [
    (someProbabilities respondsTo: #associations)
        ifTrue: [ ^ someProbabilities associations asOrderedCollection ].

    ^ someProbabilities asOrderedCollection
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
    | roll cumulative ordered |

    roll := (aRandom respondsTo: #nextInt:)
        ifTrue: [ aRandom nextInt: 100 ]
        ifFalse: [ aRandom nextInteger: 100 ].

    cumulative := 0.
    ordered := self normalizedProbabilitiesFrom: someProbabilities.

    ordered do: [:assoc |
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
    | next |

    (cards isEmpty and: [ discard isEmpty ]) ifTrue: [
        Error signal: 'Deck has no cards available'
    ].

    cards isEmpty ifTrue: [ self shuffleDiscardIntoDrawPile ].

    next := cards removeFirst.
    discard addLast: next.

    "Si guardamos clases, instanciamos; si guardamos instancias, devolvemos"
    (next isBehavior) ifTrue: [ ^ next new ].
    ^ next



]

{ #category : #initialization }
Deck >> initializeOfSize: aSize withProbabilities: someProbabilities using: aRandom [
	random := aRandom.
	cards := OrderedCollection new.
	discard := OrderedCollection new.

	probabilities := someProbabilities asOrderedCollection.

	1 to: aSize do: [ :i |
		cards addLast: self pickCardType
	].

	^ self
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
        cards add: SpeedCard ].
    discard := OrderedCollection new.

]

{ #category : #testing }
Deck >> isEmpty [
    ^ cards isEmpty and: [ discard isEmpty ]
]

{ #category : #'as yet unclassified' }
Deck >> normalizedProbabilitiesFrom: someProbabilities [
    (someProbabilities respondsTo: #associations)
        ifTrue: [ ^ someProbabilities associations asOrderedCollection ].

    ^ someProbabilities asOrderedCollection

]

{ #category : #'as yet unclassified' }
Deck >> pickCardType [
    | roll acc |
    probabilities isEmpty ifTrue: [ ^ nil ].

    roll := random next.
    roll := ((roll - 1) \\ 100) + 1.

    acc := 0.
    probabilities do: [ :assoc |
        acc := acc + assoc value.
        roll <= acc ifTrue: [ ^ assoc key ] ].

    ^ probabilities last key
]

{ #category : #'as yet unclassified' }
Deck >> shuffleDiscardIntoDeck [
    | temp roll index |

    temp := discard copy.
    cards := OrderedCollection new.
    discard := OrderedCollection new.

    [ temp notEmpty ] whileTrue: [
        roll := (rng respondsTo: #nextInt:)
            ifTrue: [ rng nextInt: 100 ]
            ifFalse: [ rng nextInteger: 100 ].

        index := ((roll - 1) \\ temp size) + 1.
        cards add: (temp removeAt: index).
    ].

]

{ #category : #'as yet unclassified' }
Deck >> shuffleDiscardIntoDrawPile [
	| newCards size idx |

	discard isEmpty ifTrue: [ ^ self ].

	newCards := OrderedCollection new.

	[ discard isEmpty ] whileFalse: [
		size := discard size.

		random
			ifNil: [ idx := 1 ]
			ifNotNil: [
				idx := random next.
				idx := ((idx - 1) \\ size) + 1
			].

		newCards addLast: (discard removeAt: idx).
	].

	cards := newCards
]

{ #category : #accessing }
Deck >> size [
    ^ cards size.


]
