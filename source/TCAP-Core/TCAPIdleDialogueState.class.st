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

{ #category : #'as yet unclassified' }
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
