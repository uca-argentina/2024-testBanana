Class {
	#name : #SpaceshipTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
SpaceshipTest >> test026SpaceshipCreatedWithAName [
	
	| aSpaceship |
	aSpaceship := Spaceship launch: 'Millenium Falcon'.
	self assert: aSpaceship getName equals: 'Millenium Falcon'	
]

{ #category : #tests }
SpaceshipTest >> test027SpaceshipCreatedWithAnotherName [

	| aSpaceship |
	aSpaceship := Spaceship launch: 'Death Star'.
	self assert: aSpaceship getName equals: 'Death Star'	
]

{ #category : #tests }
SpaceshipTest >> test120SpaceshipsShieldsCannotBeLessThanZero [

	| aSpaceship |
	aSpaceship :=SpaceshipLog randomCardsfor: ( Spaceship launch: 'Death Star').
	6 timesRepeat: [ aSpaceship decreaseShieldsByOne ].
	self assert: aSpaceship shields  equals: 0
]

{ #category : #tests }
SpaceshipTest >> test199SpaceshipIsLaunchedWithAName [

	| spaceship |

	spaceship := Spaceship launch: 'Apollo'.

	self assert: spaceship getName equals: 'Apollo'.
	self assert: spaceship asSpaceship == spaceship
]

{ #category : #tests }
SpaceshipTest >> test200SpaceshipCanBeConvertedToSpaceshipLog [

	| spaceship spaceshipLog cards |

	spaceship := Spaceship launch: 'Apollo'.

	cards := OrderedCollection
		with: SpeedCard
		with: AccelerationCard.

	spaceshipLog := spaceship asSpaceshipLogWithDeck: cards.

	self assert: spaceshipLog spaceship == spaceship
]

{ #category : #tests }
SpaceshipTest >> test201SpaceshipEqualityAcceptsItselfAndRejectsOtherClasses [

	| spaceship |

	spaceship := Spaceship launch: 'Apollo'.

	self assert: spaceship = spaceship.
	self assert: (spaceship equals: spaceship).
	self deny: spaceship = Object new
]

{ #category : #tests }
SpaceshipTest >> test202SpaceshipHashIsBasedOnItsName [

	| spaceship |

	spaceship := Spaceship launch: 'Apollo'.

	self assert: spaceship hash equals: spaceship name hash
]
