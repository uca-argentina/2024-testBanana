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
