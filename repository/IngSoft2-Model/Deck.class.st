Class {
	#name : #Deck,
	#superclass : #Object,
	#instVars : [
		'cards',
		'discard',
		'random'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #requirements }
Deck class >> empty [
    ^ self new initializeWithCardClasses: OrderedCollection new

]

{ #category : #'as yet unclassified' }
Deck class >> ofSize: aSize withProbabilities: someProbabilities using: aRandom [

	| cardClasses orderedProbabilities |

	orderedProbabilities := self orderedProbabilitiesFrom: someProbabilities.

	aSize > 0 ifTrue: [
		self validateProbabilities: orderedProbabilities
	].

	cardClasses := OrderedCollection new.

	1 to: aSize do: [ :index |
		cardClasses add: (self pickCardClassFrom: orderedProbabilities using: aRandom)
	].

	^ self new initializeWithCardClasses: cardClasses using: aRandom

]

{ #category : #'as yet unclassified' }
Deck class >> orderedProbabilitiesFrom: someProbabilities [

	someProbabilities class = Dictionary
		ifTrue: [ ^ self orderedProbabilitiesFromDictionary: someProbabilities ].

	^ someProbabilities asOrderedCollection
]

{ #category : #'as yet unclassified' }
Deck class >> orderedProbabilitiesFromDictionary: aDictionary [

	| ordered cardOrder |

	ordered := OrderedCollection new.

	cardOrder := OrderedCollection new.
	cardOrder add: SpeedCard.
	cardOrder add: AccelerationCard.
	cardOrder add: MercenaryCard.
	cardOrder add: RedoCard.
	cardOrder add: RepeatCard.
	cardOrder add: CancellationCard.
	cardOrder add: DoubleCard.
	cardOrder add: DefendCard.

	cardOrder do: [ :cardClass |
		(aDictionary includesKey: cardClass)
			ifTrue: [
				ordered add: (cardClass -> (aDictionary at: cardClass))
			]
	].

	"Por si en algún test aparece una carta nueva que no está en cardOrder,
	no la perdemos."
	aDictionary associations do: [ :association |
		(ordered anySatisfy: [ :existing | existing key = association key ])
			ifFalse: [ ordered add: association ]
	].

	^ ordered
]

{ #category : #'as yet unclassified' }
Deck class >> pickCardClassFrom: orderedProbabilities using: aRandom [

	| roll cumulative |

	orderedProbabilities isEmpty ifTrue: [
		Error signal: 'Invalid probabilities'
	].

	roll := self probabilityRollUsing: aRandom.

	cumulative := 0.

	orderedProbabilities do: [ :association |
		cumulative := cumulative + association value.
		roll <= cumulative ifTrue: [ ^ association key ]
	].

	"Si las probabilidades fueron validadas y suman 100, este fallback
	evita diferencias de borde entre versiones de Pharo/random."
	^ orderedProbabilities last key
]

{ #category : #'as yet unclassified' }
Deck class >> probabilityRollUsing: aRandom [

	| value roll |

	aRandom ifNil: [ ^ 1 ].

	value := aRandom next.

	value isInteger ifTrue: [
		^ ((value - 1) \\ 100) + 1
	].

	roll := ((value * 100) floor) + 1.

	roll < 1 ifTrue: [ ^ 1 ].
	roll > 100 ifTrue: [ ^ 100 ].

	^ roll
]

{ #category : #'as yet unclassified' }
Deck class >> validateProbabilities: orderedProbabilities [

	| total |

	orderedProbabilities isEmpty ifTrue: [
		Error signal: 'Invalid probabilities'
	].

	total := 0.

	orderedProbabilities do: [ :association |
		total := total + association value
	].

	total = 100 ifFalse: [
		Error signal: 'Probabilities must add up to 100'
	]
]

{ #category : #accessing }
Deck >> discard: aCard [

	discard addLast: aCard class.

]

{ #category : #accessing }
Deck >> discardSize [
    ^ discard size

]

{ #category : #drawing }
Deck >> draw [

	cards isEmpty ifTrue: [
		self refillFromDiscard
	].

	^ cards removeFirst new
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

{ #category : #drawing }
Deck >> refillFromDiscard [

	discard isEmpty ifTrue: [
		Error signal: 'Deck has no cards available'
	].

	self shuffleDiscardIntoDrawPile.
]

{ #category : #'as yet unclassified' }
Deck >> shuffleDiscardIntoDrawPile [

	| cardsToShuffle |

	cardsToShuffle := discard copy.
	cards := OrderedCollection new.
	discard := OrderedCollection new.

	[ cardsToShuffle notEmpty ] whileTrue: [
		cards addLast: (
			cardsToShuffle removeAt:
				(self nextIndexUpTo: cardsToShuffle size)
		)
	].
]

{ #category : #accessing }
Deck >> size [
    ^ cards size.


]
