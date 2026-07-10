Class {
	#name : #DeckTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #'as yet unclassified' }
DeckTest class >> ofSize: aSize withProbabilities: someProbabilities using: aRandom [
    ^ self new initializeWithSize: aSize

]

{ #category : #tests }
DeckTest >> test144DeckStartsWithFixedAmountOfCards [
    | deck probabilities rng |
    probabilities := OrderedCollection new
    add: (SpeedCard -> 100);
    yourself.
    rng := Random new.
    deck := Deck ofSize: 5 withProbabilities: probabilities using: rng.
    self assert: deck size equals: 5.

]

{ #category : #tests }
DeckTest >> test145DrawReducesDeckSizeByOne [
	|deck probabilities rng drawn|
	probabilities := OrderedCollection new
    add: (SpeedCard -> 100);
    yourself.
	rng := Random new.
	deck := Deck ofSize: 3 withProbabilities: probabilities using: rng.
	drawn := deck draw.
	self assert: drawn class equals: SpeedCard.
	self assert: deck size equals: 2.
	
]

{ #category : #tests }
DeckTest >> test146DeckBuildsCardsAccordingToProbabilities [
|deck probabilities rng first second|
probabilities := OrderedCollection new
    add: (SpeedCard -> 50);
    add: (AccelerationCard -> 50);
    yourself.
rng := SequenceRandom withAll: (OrderedCollection with: 1 with: 100).
deck := Deck ofSize: 2 withProbabilities: probabilities using: rng.
first := deck draw.
second := deck draw.
self assert: first class equals: SpeedCard.
self assert: second class equals: AccelerationCard.



]

{ #category : #tests }
DeckTest >> test147DrawingACardReducesDeckWithoutDiscardingIt [

	| deck probabilities |

	probabilities := OrderedCollection
		with: SpeedCard -> 100.

	deck := Deck
		ofSize: 3
		withProbabilities: probabilities
		using: (SequenceRandom withAll: #(1 2 3)).

	deck draw.

	self assert: deck size equals: 2.
	self assert: deck discardSize equals: 0.

]

{ #category : #tests }
DeckTest >> test148WhenDeckIsEmptyItShufflesDiscardAndContinuesDrawing [

	| deck probabilities rng first second |

	probabilities := Dictionary new
		at: SpeedCard put: 100;
		yourself.

	rng := SequenceRandom withAll:
		(OrderedCollection
			with: 1
			with: 1).

	deck := Deck
		ofSize: 1
		withProbabilities: probabilities
		using: rng.

	first := deck draw.
	deck discard: first.

	second := deck draw.

	self assert: first class equals: SpeedCard.
	self assert: second class equals: SpeedCard.
	self assert: deck size equals: 0.
	self assert: deck discardSize equals: 0.
]

{ #category : #tests }
DeckTest >> test149DrawingFromCompletelyEmptyDeckRaisesError [
    | deck |

    deck := Deck empty.

    self
        should: [ deck draw ]
        raise: Error.


]

{ #category : #tests }
DeckTest >> test150DeckKeepsTotalCardsBetweenDeckAndDiscard [

	| deck probabilities rng first second |

	probabilities := Dictionary new
		at: SpeedCard put: 100;
		yourself.

	rng := SequenceRandom withAll:
		(OrderedCollection
			with: 1
			with: 1
			with: 1).

	deck := Deck
		ofSize: 3
		withProbabilities: probabilities
		using: rng.

	first := deck draw.

	self assert: deck size equals: 2.
	self assert: deck discardSize equals: 0.

	deck discard: first.

	self assert: deck size equals: 2.
	self assert: deck discardSize equals: 1.

	second := deck draw.

	self assert: deck size equals: 1.
	self assert: deck discardSize equals: 1.

	deck discard: second.

	self assert: deck size equals: 1.
	self assert: deck discardSize equals: 2.
]

{ #category : #tests }
DeckTest >> test151WhenDeckIsEmptyItRefillsFromDiscard [

	| deck probabilities rng first second |

	probabilities := Dictionary new
		at: SpeedCard put: 100;
		yourself.

	rng := SequenceRandom withAll:
		(OrderedCollection
			with: 1
			with: 1).

	deck := Deck
		ofSize: 1
		withProbabilities: probabilities
		using: rng.

	first := deck draw.

	self assert: deck size equals: 0.
	self assert: deck discardSize equals: 0.

	deck discard: first.

	self assert: deck size equals: 0.
	self assert: deck discardSize equals: 1.

	second := deck draw.

	self assert: second class equals: SpeedCard.
	self assert: deck size equals: 0.
	self assert: deck discardSize equals: 0.
]

{ #category : #tests }
DeckTest >> test152RefillRespectsInjectedRandomOrder [

	| deck probabilities rng first second third |

	probabilities := Dictionary new
		at: SpeedCard put: 50;
		at: AccelerationCard put: 50;
		yourself.

	"Los dos primeros valores construyen el mazo.
	Los dos últimos controlan el orden del refill."
	rng := SequenceRandom withAll:
		(OrderedCollection
			with: 1
			with: 100
			with: 1
			with: 1).

	deck := Deck
		ofSize: 2
		withProbabilities: probabilities
		using: rng.

	first := deck draw.
	second := deck draw.

	self assert: first class equals: SpeedCard.
	self assert: second class equals: AccelerationCard.

	deck discard: first.
	deck discard: second.

	self assert: deck size equals: 0.
	self assert: deck discardSize equals: 2.

	third := deck draw.

	self assert: third class equals: SpeedCard.
	self assert: deck size equals: 1.
	self assert: deck discardSize equals: 0.
]

{ #category : #tests }
DeckTest >> test161DrawFailsWhenDeckAndDiscardAreEmpty [
    | deck |

    deck := Deck new initializeWithCardClasses: OrderedCollection new.

    self
        should: [ deck draw ]
        raise: Error.



]

{ #category : #tests }
DeckTest >> test162DrawRefillsDeckFromDiscard [

	| deck probabilities rng first second third |

	probabilities := Dictionary new
		at: SpeedCard put: 100;
		yourself.

	rng := SequenceRandom withAll:
		(OrderedCollection
			with: 1
			with: 1
			with: 1
			with: 1).

	deck := Deck
		ofSize: 2
		withProbabilities: probabilities
		using: rng.

	first := deck draw.
	second := deck draw.

	self assert: deck size equals: 0.
	self assert: deck discardSize equals: 0.

	deck discard: first.
	deck discard: second.

	self assert: deck size equals: 0.
	self assert: deck discardSize equals: 2.

	third := deck draw.

	self assert: third class equals: SpeedCard.
	self assert: deck size equals: 1.
	self assert: deck discardSize equals: 0.
]

{ #category : #tests }
DeckTest >> test177UsedCardIsAddedToDiscard [

	| deck probabilities card |

	probabilities := OrderedCollection
		with: SpeedCard -> 100.

	deck := Deck
		ofSize: 3
		withProbabilities: probabilities
		using: (SequenceRandom withAll: #(1 2 3)).

	card := deck draw.
	deck discard: card.

	self assert: deck size equals: 2.
	self assert: deck discardSize equals: 1.


]
