Class {
	#name : #BoardDistributionCreatorTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
BoardDistributionCreatorTest >> test079BoardDistributionCreatorMakesABoardOfIndicatedLength [

	| aBoardDistributionCreator probabilites |
	aBoardDistributionCreator := BoardDistributionCreator new.
	probabilites := Dictionary
		                newFromKeys: { AtomicBombEffect }
		                andValues: { 100 }.
	self
		assert: (aBoardDistributionCreator
				 createOf: 1
				 with: probabilites
				 withParsecs: 1
				 maximumHyperJumpValues: 1) size
		equals: 1
]

{ #category : #tests }
BoardDistributionCreatorTest >> test080WhenProbabilityIs100ThenEffectIsCreated [

	| aBoardDistributionCreator probabilites |
	aBoardDistributionCreator := BoardDistributionCreator new.
	probabilites := Dictionary
		                newFromKeys: { MysteryCardEffect  }
		                andValues: { 100 }.
	self
		assert: ((aBoardDistributionCreator
				  createOf: 1
				  with: probabilites
				  withParsecs: 1
				  maximumHyperJumpValues: 1) at: 1) effect class
		equals: MysteryCardEffect 
]

{ #category : #tests }
BoardDistributionCreatorTest >> test122BoardDistributionCreatorMakesABoardWithValidEffects [ 

	| aBoardDistributionCreator probabilites  squares effectTypes|
	aBoardDistributionCreator := BoardDistributionCreator new.
	effectTypes := OrderedCollection with: MysteryCardEffect with: AtomicBombEffect with: MoonWalkEffect with: HyperJumpEffect with: HyperSpaceJumpEffect with: BlackholeEffect .
	probabilites := Dictionary
		                newFromKeys: effectTypes 
		                andValues: { 10 . 2 . 10 . 8 . 20 . 20 }.
	squares := aBoardDistributionCreator
				  createOf: 100
				  with: probabilites
				  withParsecs: 1
				  maximumHyperJumpValues: 1.
	effectTypes add: NullEffect .
	self assert:  (squares allSatisfy: [:square | effectTypes includes: (square effect class ) ])
]

{ #category : #tests }
BoardDistributionCreatorTest >> test214BoardDistributionWithoutProbabilitiesCreatesNullEffects [

	| creator squares probabilities |

	creator := BoardDistributionCreator new.
	probabilities := Dictionary new.

	squares := creator
		createOf: 5
		with: probabilities
		withParsecs: 1
		maximumHyperJumpValues: 1.

	self assert: squares size equals: 5.

	squares do: [ :each |
		self assert: each effect class equals: NullEffect
	]
]

{ #category : #tests }
BoardDistributionCreatorTest >> test215BoardDistributionCreatesConfiguredEffectWithFullProbability [

	| creator squares probabilities effect |

	creator := BoardDistributionCreator new.

	probabilities := Dictionary new.
	probabilities
		at: BlackholeEffect
		put: 100.

	squares := creator
		createOf: 1
		with: probabilities
		withParsecs: 1
		maximumHyperJumpValues: 1.

	effect := squares first effect.

	self assert: squares size equals: 1.
	self assert: effect class equals: BlackholeEffect.
	self assert: effect position equals: 1
]

{ #category : #tests }
BoardDistributionCreatorTest >> test216BoardDistributionCreatesHyperJumpWithFullProbability [

	| creator squares probabilities effect |

	creator := BoardDistributionCreator new.

	probabilities := Dictionary new.
	probabilities
		at: HyperJumpEffect
		put: 100.

	squares := creator
		createOf: 1
		with: probabilities
		withParsecs: 1
		maximumHyperJumpValues: 1.

	effect := squares first effect.

	self assert: squares size equals: 1.
	self assert: effect class equals: HyperJumpEffect.
	self assert: effect position equals: 1
]
