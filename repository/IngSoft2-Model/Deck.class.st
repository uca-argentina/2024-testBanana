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
	#category : #'IngSoft2-Model'
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

	1 to: aSize do: [ :index |
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

	| cardClass |

	(cards isEmpty and: [ discard isEmpty ])
		ifTrue: [ Error signal: 'Deck has no cards available' ].

	cards isEmpty ifTrue: [
		self shuffleDiscardIntoDrawPile
	].

	cardClass := cards removeFirst.
	discard addLast: cardClass.

	(cardClass isBehavior)
		ifTrue: [ ^ cardClass new ].

	^ cardClass



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
	random := aRandom.

	^ self
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
Deck >> nextIndexUpTo: aSize [

	| value integerValue |

	aSize = 0 ifTrue: [ Error signal: 'Deck has no cards available' ].

	random ifNil: [ ^ 1 ].

	value := random next.

	value isInteger
		ifTrue: [
			^ ((value - 1) \\ aSize) + 1
		].

	integerValue := (value * aSize) floor + 1.

	integerValue > aSize ifTrue: [ ^ aSize ].
	integerValue < 1 ifTrue: [ ^ 1 ].

	^ integerValue
]

{ #category : #'as yet unclassified' }
Deck >> nextProbabilityRoll [

	| value |

	random ifNil: [ ^ 1 ].

	value := random next.

	value isInteger
		ifTrue: [ ^ ((value - 1) \\ 100) + 1 ].

	^ ((value * 100) floor) + 1
]

{ #category : #'as yet unclassified' }
Deck >> normalizedProbabilitiesFrom: someProbabilities [
    (someProbabilities respondsTo: #associations)
        ifTrue: [ ^ someProbabilities associations asOrderedCollection ].

    ^ someProbabilities asOrderedCollection

]

{ #category : #'as yet unclassified' }
Deck >> pickCardType [

	| roll cumulative |

	probabilities isEmpty ifTrue: [ Error signal: 'Invalid probabilities' ].

	roll := self nextProbabilityRoll.

	cumulative := 0.
	probabilities do: [ :association |
		cumulative := cumulative + association value.
		roll <= cumulative ifTrue: [ ^ association key ]
	].

	Error signal: 'Invalid probabilities'
]

{ #category : #'as yet unclassified' }
Deck >> shuffleDiscardIntoDeck [
    | temp roll index |

    temp := discard copy.
    cards := OrderedCollection new.
    discard := OrderedCollection new.

    [ temp notEmpty ] whileTrue: [
        roll := (random respondsTo: #nextInt:)
            ifTrue: [ random nextInt: 100 ]
            ifFalse: [ random nextInteger: 100 ].

        index := ((roll - 1) \\ temp size) + 1.
        cards add: (temp removeAt: index).
    ].

]

{ #category : #'as yet unclassified' }
Deck >> shuffleDiscardIntoDrawPile [

	| shuffledCards index |

	discard isEmpty ifTrue: [ ^ self ].

	shuffledCards := OrderedCollection new.

	[ discard isEmpty ] whileFalse: [
		index := self nextIndexUpTo: discard size.
		shuffledCards addLast: (discard removeAt: index)
	].

	cards := shuffledCards.
]

{ #category : #accessing }
Deck >> size [
    ^ cards size.


]
