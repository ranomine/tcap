Class {
	#name : #TCAPIdleDialogueState,
	#superclass : #TCAPDialogueState,
	#category : #'TCAP-Core-State'
}

{ #category : #accessing }
TCAPIdleDialogueState class >> label [
	^ #idle
]

{ #category : #indications }
TCAPIdleDialogueState >> indicationTrBegin: aMessage [
	self flag: #unchecked.
	"dialogue notifyDialogueCreated."
	
	aMessage hasDialoguePortion ifTrue:[
		dialogue processDialogueRequest: (aMessage dialoguePortion at: 'dialogueRequest')].

	dialogue switchState: #initiationReceived.
	dialogue indicationTcBegin: aMessage.

	aMessage hasComponents 
		ifTrue: [ dialogue processComponentsOf: aMessage  ]
		ifFalse: [ 
			dialogue handshakeEnabled ifTrue: [ dialogue requestTcContinue ] ]
]

{ #category : #requests }
TCAPIdleDialogueState >> requestTcBeginDestinationAddress: aDestinationAddress originatingAddress: anOriginatingAddress applicationContextName: anApplicationContextName userInformation: userInformation [
	|  begin dialoguePortion |
	begin := self factory newBeginMessage.
	anApplicationContextName  ifNotNil: [ 
		dialogue applicationContextName: anApplicationContextName.
		
		dialoguePortion := (self factory newDialogueRequest)
			applicationContextName: dialogue applicationContextName;
			userInformation: userInformation.
			
		begin 
			at:  'dialoguePortion' 
			put: (dialoguePortion asExternalValueIn: dialogue factory) ].
	
	dialogue addComponentsTo: begin.	
	dialogue switchState: #initiationSent.
	dialogue transactionCoordinator requestTrBegin: dialogue transaction destinationAddress: aDestinationAddress originatingAddress: anOriginatingAddress  userData: begin.
	

]

{ #category : #'requests - for testing' }
TCAPIdleDialogueState >> requestTcContinueDestinationAddress: aDestinationAddress originatingAddress: anOriginatingAddress applicationContextName: anApplicationContextName userInformation: userInformation [
	|  begin dialoguePortion |
	"for testing: send a continue message from idle state"
	begin := self factory newContinueMessage.
	anApplicationContextName  ifNotNil: [ 
		dialogue applicationContextName: anApplicationContextName.
		
		dialoguePortion := (self factory newDialogueRequest)
			applicationContextName: dialogue applicationContextName;
			userInformation: userInformation.
			
		begin 
			at:  'dialoguePortion' 
			put: (dialoguePortion asExternalValueIn: dialogue factory) ].
	
	dialogue addComponentsTo: begin.	
	dialogue switchState: #initiationSent.
	dialogue transactionCoordinator requestTrContinue: dialogue transaction destinationAddress: aDestinationAddress originatingAddress: anOriginatingAddress  userData: begin.
	

]

{ #category : #'requests - for testing' }
TCAPIdleDialogueState >> requestTcEndDestinationAddress: aDestinationAddress originatingAddress: anOriginatingAddress applicationContextName: anApplicationContextName userInformation: userInformation [
	|  begin dialoguePortion |
	"for testing: send a continue message from idle state"
	begin := self factory newEndMessage.
	anApplicationContextName  ifNotNil: [ 
		dialogue applicationContextName: anApplicationContextName.
		
		dialoguePortion := (self factory newDialogueRequest)
			applicationContextName: dialogue applicationContextName;
			userInformation: userInformation.
			
		begin 
			at:  'dialoguePortion' 
			put: (dialoguePortion asExternalValueIn: dialogue factory) ].
	
	dialogue addComponentsTo: begin.	
	dialogue switchState: #initiationSent.
	dialogue transactionCoordinator requestTrEnd: dialogue transaction destinationAddress: aDestinationAddress originatingAddress: anOriginatingAddress  userData: begin.
	

]
