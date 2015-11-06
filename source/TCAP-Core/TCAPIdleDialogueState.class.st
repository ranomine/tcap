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
]

{ #category : #'requests - for testing' }
TCAPIdleDialogueState >> requestTcAbortDestinationAddress: aDestinationAddress originatingAddress: anOriginatingAddress applicationContextName: anApplicationContextName userInformation: userInformation [
	|  begin dialoguePortion |
	"for testing: send an abort message from idle state"
	begin := self factory newAbortMessage.
	anApplicationContextName  ifNotNil: [ 
		dialogue applicationContextName: anApplicationContextName asAsn1Oid.
		
		dialoguePortion := (self factory newDialogueRequest)
			applicationContextName: dialogue applicationContextName.

		userInformation ifNotNil: [  
			dialoguePortion userInformation: userInformation ]].
	
	dialogue addComponentsTo: begin.	
	dialogue switchState: #initiationSent.
	dialogue transactionCoordinator requestTrEnd: dialogue transaction destinationAddress: aDestinationAddress originatingAddress: anOriginatingAddress  userData: begin.
	

]

{ #category : #requests }
TCAPIdleDialogueState >> requestTcBeginDestinationAddress: aDestinationAddress originatingAddress: anOriginatingAddress [ 
	
	self requestTcBeginDestinationAddress:  aDestinationAddress originatingAddress: anOriginatingAddress userInformation: nil
]

{ #category : #requests }
TCAPIdleDialogueState >> requestTcBeginDestinationAddress: aDestinationAddress originatingAddress: anOriginatingAddress applicationContextName: anApplicationContextName userInformation: userInformation [

	anApplicationContextName ifNotNil: [  
		dialogue applicationContextName: anApplicationContextName asAsn1Oid ].

	userInformation ifNotNil: [ 
		dialogue userInformation: userInformation ].
	
	self requestTcBeginDestinationAddress: aDestinationAddress originatingAddress: anOriginatingAddress userInformation: userInformation

]

{ #category : #requests }
TCAPIdleDialogueState >> requestTcBeginDestinationAddress: aDestinationAddress originatingAddress: anOriginatingAddress userInformation: userInformation [

	| begin dialogueRequest |
	begin := self factory newBeginMessage.
	dialogue applicationContext ifNotNil: [ :applicationContext |

		dialogueRequest := (self factory newDialogueRequest).
		(dialogueRequest expandFieldNamed: 'application-context-name')
			value: dialogue applicationContextName.

		userInformation ifNotNil: [ 
			(dialogueRequest expandFieldNamed: 'user-information') addAll: (
				userInformation isCollection 
					ifTrue: [ userInformation ]
					ifFalse: [ Array with: userInformation ])].

		begin 
			privAt:  'dialoguePortion' 
			put: (dialogue factory dialoguePortionFromApdu: dialogueRequest) ].
	
	dialogue addComponentsTo: begin.	
	dialogue switchState: #initiationSent.
	dialogue transactionCoordinator 
		requestTrBegin: dialogue transaction 
		destinationAddress: aDestinationAddress 
		originatingAddress: anOriginatingAddress
		userData: begin.
	

]

{ #category : #'requests - for testing' }
TCAPIdleDialogueState >> requestTcContinueDestinationAddress: aDestinationAddress originatingAddress: anOriginatingAddress applicationContextName: anApplicationContextName userInformation: userInformation [
	|  begin dialoguePortion |
	"for testing: send a continue message from idle state"
	begin := self factory newContinueMessage.
	anApplicationContextName  ifNotNil: [ 
		dialogue applicationContextName: anApplicationContextName asAsn1Oid.
		
		dialoguePortion := (self factory newDialogueRequest)
			applicationContextName: dialogue applicationContextName.
			
		userInformation ifNotNil: [  
			dialoguePortion userInformation: userInformation ].

		begin 
			privAt:  'dialoguePortion' 
			put: (dialogue factory dialoguePortionFromApdu: dialoguePortion) ].
	
	dialogue addComponentsTo: begin.	
	dialogue switchState: #initiationSent.
	dialogue transactionCoordinator requestTrContinue: dialogue transaction destinationAddress: aDestinationAddress originatingAddress: anOriginatingAddress  userData: begin.
	

]

{ #category : #'requests - for testing' }
TCAPIdleDialogueState >> requestTcEndDestinationAddress: aDestinationAddress originatingAddress: anOriginatingAddress applicationContextName: anApplicationContextName userInformation: userInformation [
	|  begin dialoguePortion |
	"for testing: send a end message from idle state"
	begin := self factory newEndMessage.
	anApplicationContextName  ifNotNil: [ 
		dialogue applicationContextName: anApplicationContextName asAsn1Oid.
		
		dialoguePortion := (self factory newDialogueRequest)
			applicationContextName: dialogue applicationContextName.
			
		userInformation ifNotNil: [  
			dialoguePortion userInformation: userInformation ].

		begin 
			privAt:  'dialoguePortion' 
			put: (dialogue factory dialoguePortionFromApdu: dialoguePortion ) ].
	
	dialogue addComponentsTo: begin.	
	dialogue switchState: #initiationSent.
	dialogue transactionCoordinator requestTrEnd: dialogue transaction destinationAddress: aDestinationAddress originatingAddress: anOriginatingAddress  userData: begin.
	

]
