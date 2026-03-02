"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State after losing all shields

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
	#name : #Turn1RechargeState,
	#superclass : #NoPenaltyState,
	#category : #'IngSoft2-Model'
}

{ #category : #action }
Turn1RechargeState >> playFor: aLog in: aGame [
    aLog changeStateTo: Turn2RechargeState new.


]

{ #category : #action }
Turn1RechargeState >> playIn: aGame [

    | aSpaceship |
    aSpaceship := aGame nextSpaceshipToPlay.
    aGame changeStateOf: aSpaceship to: (Turn2RechargeState new).

]
