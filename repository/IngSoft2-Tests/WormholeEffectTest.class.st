Class {
	#name : #WormholeEffectTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
WormholeEffectTest >> test173WormholeTeleportsSpaceship [
	| game spaceship die |

	spaceship := Spaceship launch: 'A'.
	die := LoadedDie arrayOf: (OrderedCollection with: 1).

	game := Game
		playedBy: (OrderedCollection with:
			(SpaceshipLog new initializeFor: spaceship withDeck: OrderedCollection new))
		on: (Board of: 10 wormholeBeginsAt: 2 andEndsAt: 8)
		throwing: (OrderedCollection with: die)
		wonAfter: 1.

	"Turno 1: 1 → 2 (wormhole)"
	game turn.

	self assert: (game positionOf: spaceship) equals: 8.


]
