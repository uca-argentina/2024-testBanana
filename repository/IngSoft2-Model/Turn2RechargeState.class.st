"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State after losing all shields and skipping one turn

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them.

Public API and Key Messages

- message one
- message two
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.

Internal Representation and Key Implementation Points.


    Implementation Points
"
Class {
	#name : #Turn2RechargeState,
	#superclass : #NoPenaltyState,
	#category : #'IngSoft2-Model'
}

{ #category : #action }
Turn2RechargeState >> playFor: aLog in: aGame [
    aLog rechargeShields.
    aLog changeStateTo: NoPenaltyState new.


]

{ #category : #action }
Turn2RechargeState >> playIn: aGame [

    | aSpaceship |
    aSpaceship := aGame nextSpaceshipToPlay.
    aGame rechargeShieldsOf: aSpaceship.
    aGame changeStateOf: aSpaceship to: (NoPenaltyState new).

]
