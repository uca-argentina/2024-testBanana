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
    probabilities := Dictionary new
        at: SpeedCard put: 100;
        yourself.
    rng := Random new.
    deck := Deck ofSize: 5 withProbabilities: probabilities using: rng.
    self assert: deck size equals: 5.

]

{ #category : #tests }
DeckTest >> test145DrawReducesDeckSizeByOne [
	|deck probabilities rng drawn|
	probabilities := Dictionary new
	at: SpeedCard put: 100;
	yourself.
	rng := Random new.
	deck := Deck ofSize: 3 withProbabilities: probabilities using: rng.
	drawn := deck draw.
	self assert: drawn class equals: SpeedCard.
	self assert: deck size equals: 2.
	
]
