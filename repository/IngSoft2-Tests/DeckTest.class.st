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
DeckTest >> test147DrawingACardReducesDeckAndAddsToDiscard [
    | deck probabilities rng card |
    probabilities := Dictionary new
        at: SpeedCard put: 100;
        yourself.
    rng := SequenceRandom withAll: (OrderedCollection with: 1).
    deck := Deck ofSize: 3 withProbabilities: probabilities using: rng.
    card := deck draw.
    self assert: deck size equals: 2.
    self assert: deck discardSize equals: 1.

]

{ #category : #tests }
DeckTest >> test148WhenDeckIsEmptyItShufflesDiscardAndContinuesDrawing [
    | deck probabilities rng first second |
    probabilities := Dictionary new
        at: SpeedCard put: 100;
        yourself.
    rng := SequenceRandom withAll: (OrderedCollection with: 1).
    deck := Deck ofSize: 1 withProbabilities: probabilities using: rng.
    first := deck draw.
    second := deck draw.
    self assert: first class equals: SpeedCard.
    self assert: second class equals: SpeedCard.
    self assert: deck discardSize equals: 1.

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
    | deck probabilities rng |

    probabilities := Dictionary new
        at: SpeedCard put: 100;
        yourself.

    rng := SequenceRandom withAll: (OrderedCollection with: 1 with: 1 with: 1).

    deck := Deck ofSize: 3 withProbabilities: probabilities using: rng.

    deck draw.
    self assert: deck size equals: 2.
    self assert: deck discardSize equals: 1.

    deck draw.
    self assert: deck size equals: 1.
    self assert: deck discardSize equals: 2.

]

{ #category : #tests }
DeckTest >> test151WhenDeckIsEmptyItRefillsFromDiscard [
    | deck probabilities rng |

    probabilities := Dictionary new
        at: SpeedCard put: 100;
        yourself.

    rng := SequenceRandom withAll: (OrderedCollection with: 1 with: 1).

    deck := Deck ofSize: 1 withProbabilities: probabilities using: rng.

    deck draw. "deck vacío, discard tiene 1"

    self assert: deck size equals: 0.
    self assert: deck discardSize equals: 1.

    deck draw. "debería refill desde discard"

    self assert: deck size equals: 0.
    self assert: deck discardSize equals: 1.


]

{ #category : #tests }
DeckTest >> test152RefillRespectsInjectedRandomOrder [
    | deck probabilities rng first second third |

    probabilities := Dictionary new
        at: SpeedCard put: 50;
        at: AccelerationCard put: 50;
        yourself.

    "Construcción: Speed luego Acceleration"
    rng := SequenceRandom withAll: (OrderedCollection with: 1 with: 100).

    deck := Deck ofSize: 2 withProbabilities: probabilities using: rng.

    first := deck draw.
    second := deck draw.

    self assert: first class equals: SpeedCard.
    self assert: second class equals: AccelerationCard.

    "Deck vacío, discard tiene [Speed, Acceleration]"

    "Ahora refill: si shuffle usa RNG, el orden debería ser controlable"
    third := deck draw.

    "Queremos que vuelva a salir Speed primero"
    self assert: third class equals: SpeedCard.


]
