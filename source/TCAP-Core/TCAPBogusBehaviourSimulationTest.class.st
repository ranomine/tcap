Class {
	#name : #TCAPBogusBehaviourSimulationTest,
	#superclass : #TCAPTestCase,
	#category : #'TCAP-Core-Tests'
}

{ #category : #tests }
TCAPBogusBehaviourSimulationTest >> shouldNotAbortOnEndWithoutDialoguePortionInAcMode [
	|  env  dialogue abortCalled  |
	abortCalled := false.
	
	"we create a dialogue that has an application context and simulate a broken stack
	that sends a message not containing a dialogue portion while in AC mode.
	The stack should be configured for a specific dialogue to misbehave in a way
	it does not lead to an unexpected behaviour"
	
	env := self given: #shouldCreateTestEnvironment.
	env servicePointB onDialogue: [ : dialog |
		dialog onBegin: [  
			env servicePointB transactionCoordinator postProcessDictionary: [ :msg  |
				msg end removeKey: 'dialoguePortion' ].
			dialog requestTcEnd: false ]].
	
	"installing a quirk state makes the test proceed"
	env servicePointA factory installStateClass: TCAPInitiationSentMissingDialoguePortionQuirkState.
	dialogue := env servicePointA newDialogue.
	dialogue onPAbort: [ abortCalled := true ].
	dialogue
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
	
	self deny: (self messageInspectorOn: env servicePointB sentPackets first) messageHasDialoguePortion.
	self deny: abortCalled 
]
