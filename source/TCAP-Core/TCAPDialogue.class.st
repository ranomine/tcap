Class {
	#name : #TCAPDialogue,
	#superclass : #TCAPEnvironment,
	#instVars : [
		'applicationContext',
		'componentCoordinator',
		'state',
		'invokeIdPool',
		'localInvocations',
		'remoteInvocations',
		'announcer',
		'userInformation',
		'pendingResponse'
	],
	#category : #'TCAP-Core-Model'
}

{ #category : #adding }
TCAPDialogue >> addComponentsTo: anObject [
	self hasComponents ifTrue: [
		(anObject expandFieldNamed: 'components') addAll: self flushComponents ]
]

{ #category : #registering }
TCAPDialogue >> addHandler: aHandler [
	aHandler registerAtDialogue: announcer
]

{ #category : #'as yet unclassified' }
TCAPDialogue >> addPendingMessagesTo: aMessage [

	pendingResponse ifNotNil: [ 
		aMessage privAt: 'dialoguePortion' put: (self factory dialoguePortionFromApdu: pendingResponse).
		pendingResponse := nil ].
	
	self addComponentsTo: aMessage
]

{ #category : #accessing }
TCAPDialogue >> allocateId [
	container allocateId
]

{ #category : #accessing }
TCAPDialogue >> allocateId: aNumber [
	container allocateId: aNumber
]

{ #category : #'as yet unclassified' }
TCAPDialogue >> allocateInvokeId: aNumber [
	invokeIdPool allocate: aNumber
]

{ #category : #accessing }
TCAPDialogue >> applicationContext [
	^ applicationContext
]

{ #category : #accessing }
TCAPDialogue >> applicationContext: anApplicationContext [
	applicationContext := anApplicationContext 
]

{ #category : #actions }
TCAPDialogue >> applicationContextForOperationCode: aNumber [
	"this method is supposed to be overwritten by subclasses of Dialogue. If no application 
	context is set a specialized dialogue might be able to derive it from the operation code
	that is invoked. In this class we don't know what it might be so we abort the dialogue"
	self requestTcPAbort: TCAPDialoguePAbort unrecognizedMessageType .
	self logNotice: 'no application context present resolvable. aborting dialogue' area: #tcap.
	TCAPProcessingAborted signal.
]

{ #category : #accessing }
TCAPDialogue >> applicationContextName [
	^ applicationContext attributeAt: 'applicationContextName'
]

{ #category : #accessing }
TCAPDialogue >> applicationContextName: anOid [ 
	applicationContext := self asn1Model applicationContextWithOid: anOid
]

{ #category : #accessing }
TCAPDialogue >> applicationContextNameString: aString [ 
	self applicationContextName: aString asAsn1Oid
]

{ #category : #accessing }
TCAPDialogue >> applicationContextNamed: aString [
	^ self asn1Model typeNamed: aString
]

{ #category : #accessing }
TCAPDialogue >> applicationContextOidForOperationNamed: aString [ 
	^ self asn1Model applicationContextOidForOperationNamed: aString
]

{ #category : #accessing }
TCAPDialogue >> defaultOperationSentClass [
	 ^ TCAPReportSuccessAndFailure 
]

{ #category : #accessing }
TCAPDialogue >> flushComponents [
	^ componentCoordinator flushComponents
]

{ #category : #'as yet unclassified' }
TCAPDialogue >> guessAppplicationContextFromOperationCode: aNumber [
	applicationContext := self applicationContextForOperationCode: aNumber
]

{ #category : #testing }
TCAPDialogue >> hasApplicationContext [
	^ applicationContext notNil
]

{ #category : #testing }
TCAPDialogue >> hasComponents [
	^ componentCoordinator hasComponents
]

{ #category : #accessing }
TCAPDialogue >> id [
	^ container id
]

{ #category : #accessing }
TCAPDialogue >> id: aString [ 
	container id: aString
]

{ #category : #indications }
TCAPDialogue >> indicationTcBegin: aMessage [
	self notifyBegin: aMessage
	
]

{ #category : #indications }
TCAPDialogue >> indicationTcContinue: aMessage [
	self notifyContinue: aMessage
]

{ #category : #indications }
TCAPDialogue >> indicationTcEnd: aMessage [
	self notifyEnd: aMessage
]

{ #category : #indications }
TCAPDialogue >> indicationTcInvoke: anInvocation [
	self notifyInvoke: anInvocation
]

{ #category : #indications }
TCAPDialogue >> indicationTcPAbort: aDictionary [
	self notifyPAbort: aDictionary 
]

{ #category : #indications }
TCAPDialogue >> indicationTcReturn: anObject [
	self notifyReturn: anObject
]

{ #category : #indications }
TCAPDialogue >> indicationTcUAbort: aDictionary [
	self notifyUAbort: aDictionary 
]

{ #category : #indications }
TCAPDialogue >> indicationTrBegin: aMessage [
	self state indicationTrBegin: aMessage.

]

{ #category : #indications }
TCAPDialogue >> indicationTrContinue: aMessage [
	self state indicationTrContinue: aMessage
]

{ #category : #indications }
TCAPDialogue >> indicationTrEnd: aMessage [
	 self state indicationTrEnd: aMessage
]

{ #category : #indications }
TCAPDialogue >> indicationTrPAbort: aNumber [ 
	self state indicationTrPAbort: aNumber
]

{ #category : #indications }
TCAPDialogue >> indicationTrUAbort: anObject [ 
	self state indicationTrUAbort: anObject
]

{ #category : #'initialize-release' }
TCAPDialogue >> initialize [
	super initialize.
	announcer := Announcer new.
	componentCoordinator := TCAPComponentCoordinator new
		dialogue: self.
	invokeIdPool := TCAPIdPool new size: 16rFFFF.
	localInvocations := Set new.
	remoteInvocations := Set new.

]

{ #category : #accessing }
TCAPDialogue >> invocationWithId: aNumber [
	^ (self localInvocationWithId: aNumber ) ifNil: [ self remoteInvocationWithId: aNumber ]
]

{ #category : #accessing }
TCAPDialogue >> invoke: invocation withTimeout: aDuration [
	invocation startInvocationTimer: aDuration.
	localInvocations add: invocation.
	componentCoordinator addComponent: (invocation asROS).

]

{ #category : #accessing }
TCAPDialogue >> localInvocationWithId: aNumber [
	^ localInvocations  
		detect: [ :each| each invokeId = aNumber  ]
		ifNone: [  nil  ]
]

{ #category : #creating }
TCAPDialogue >> newAcceptedDialogueResponse: aUserInformation [
	^ (self newDialogueResponse: aUserInformation)  
		serviceUser;
		null;
		accepted 
]

{ #category : #creating }
TCAPDialogue >> newDialoguePortion: aClass userInformation: aUserInformation [
	| dialoguePortion |
	dialoguePortion := self factory newDialogueResponse.
	(dialoguePortion expandFieldNamed: 'application-context-name')
		value: self applicationContextName.
	aUserInformation ifNotNil: [ 
		 dialoguePortion value at: 'user-information' put: aUserInformation ].
	^ dialoguePortion
]

{ #category : #creating }
TCAPDialogue >> newDialogueResponse: aUserInformation [
	^ self newDialoguePortion: TCAPDialogueResponse userInformation: aUserInformation  
]

{ #category : #accessing }
TCAPDialogue >> newInvocationForName: aString parameters: anObject [  
	^ self newInvocationForName: aString parameters:  anObject class: self defaultOperationSentClass
]

{ #category : #accessing }
TCAPDialogue >> newInvocationForName: aString parameters: anObject  class: aClass [
	^ self newInvocationForName: aString parameters:  anObject class: aClass linkedTo: nil
]

{ #category : #accessing }
TCAPDialogue >> newInvocationForName: aString parameters: anObject  class: aClass linkedTo: anotherInvocation [
	| invocation |
	invocation := ((self rosOperationNamed: aString) invokeWithArgument: anObject)
		invokeId: invokeIdPool nextId;
		operationClass: aClass.		
	
	localInvocations add: invocation.
	
	anotherInvocation ifNotNil: [  
		invocation linkedTo: anotherInvocation ].
	
	^ invocation
]

{ #category : #adding }
TCAPDialogue >> newRemoteInvocation: anInvocation [ 
	anInvocation
		onMessage: [:msg|  componentCoordinator addComponent: msg asROS ].
	
	remoteInvocations  
		detect: [ :each| each invokeId = anInvocation invokeId  ]
		ifFound: [  TCAPDuplicateInvocationId signal: 'invocation with id ', anInvocation id, ' alread exists'  ].
	
	remoteInvocations add: anInvocation.
	self indicationTcInvoke: anInvocation 
]

{ #category : #accessing }
TCAPDialogue >> newState: aSymbol [
	^ self factory newDialogueState: aSymbol.
]

{ #category : #actions }
TCAPDialogue >> nextState: aState [
	aState dialogue: self.
	state := aState
]

{ #category : #notifying }
TCAPDialogue >> notifyAfterMessage: aMessage [ 
	announcer announce: (TCAPAfterMessageReceived message: aMessage dialogue: self)
]

{ #category : #notifying }
TCAPDialogue >> notifyBeforeMessage: aMessage [ 
	announcer announce: (TCAPBeforeMessageReceived message: aMessage dialogue: self )
]

{ #category : #notifications }
TCAPDialogue >> notifyBegin: aMessage [
	announcer announce: (TCAPBeginReceived message: aMessage dialogue: self) 
]

{ #category : #notifications }
TCAPDialogue >> notifyContinue: aMessage [
	announcer announce: (
		TCAPContinueReceived 
			message: aMessage
			dialogue: self)
	
]

{ #category : #indications }
TCAPDialogue >> notifyEnd: aMessage [
	announcer announce: (TCAPEndReceived message: aMessage dialogue: self)
]

{ #category : #notifications }
TCAPDialogue >> notifyInvoke: aInvocation [
	announcer announce:  (
		TCAPInvocationReceived new 
			dialogue: self;
			invocation: aInvocation )
]

{ #category : #notifications }
TCAPDialogue >> notifyPAbort: aCause [
	announcer announce: (TCAPProtocolAbortReceived message: aCause dialogue: self )
]

{ #category : #notifications }
TCAPDialogue >> notifyUAbort: aMessage [ 
	announcer announce: (TCAPUserAbortReceived message: aMessage dialogue: self)
]

{ #category : #accessing }
TCAPDialogue >> onBegin: aBlock [
	^ announcer
		when: TCAPBeginReceived 
		do: aBlock
]

{ #category : #accessing }
TCAPDialogue >> onContinue: aBlock [
	^ announcer
		when: TCAPContinueReceived 
		do: aBlock
]

{ #category : #accessing }
TCAPDialogue >> onEnd: aBlock [
	^ announcer
		when: TCAPEndReceived 
		do: aBlock
]

{ #category : #accessing }
TCAPDialogue >> onInvoke: aBlock [
	^ announcer
		when: TCAPInvocationReceived 
		do: aBlock
]

{ #category : #accessing }
TCAPDialogue >> onPAbort: aBlock [
	^ announcer 
		when: TCAPProtocolAbortReceived 
		do: aBlock
]

{ #category : #accessing }
TCAPDialogue >> onUAbort: aBlock [
	^ announcer
		when: TCAPUserAbortReceived 
		do: aBlock
]

{ #category : #'as yet unclassified' }
TCAPDialogue >> operationNamed: aString [
	^ (self asn1TypeNamed: aString) value ifNil: [ 
		NotFound signal: 'cannot find binding for ', aString asString ]
]

{ #category : #accessing }
TCAPDialogue >> operationWithCode: aNumber [
	^ applicationContext ifNotNil: [
		applicationContext findElement: [ :op | 
			op isOperation and: [ (op attributeAt: 'operationCode') = aNumber ] ] ].

]

{ #category : #actions }
TCAPDialogue >> processComponentsOf: aMessage [
	aMessage rosMessages do: [ :message|
		message initializeFromDialogue: self.
		componentCoordinator processComponent: message ]

]

{ #category : #'as yet unclassified' }
TCAPDialogue >> processDialogueRequest: request [

	((request  privAt: 'protocol-version') bitEquals: #( 'version1' ) ) 
		ifFalse: [ 
			"this shouldn't happen because this is a syntax error and should be catched earlier".
			Error signal: 'message should have been checked for protocol-version earlier' ].
		
	request ifNotNil: [
		userInformation := request user_information ].	

	"nothing is wrong we accept as request"

	applicationContext := (self asn1Model applicationContextWithOid: (request privAt: 'application-context-name') value).
	self sendAcceptResponse.
]

{ #category : #notifications }
TCAPDialogue >> receivedError: anError [
	(self localInvocationWithId: anError invokeId)
		receivedError: anError
]

{ #category : #received }
TCAPDialogue >> receivedReject: aReject [
	" we need to be able to reject both local and remove invokations (e.g. reject an error)"
	(self invocationWithId: aReject invokeId) receivedReject: aReject
]

{ #category : #received }
TCAPDialogue >> receivedReturnLast: aResultLast [ 
	(self localInvocationWithId: aResultLast invokeId) receivedReturnLast: aResultLast 
]

{ #category : #accessing }
TCAPDialogue >> remoteInvocationWithId: aNumber [
	^ remoteInvocations 
		detect: [ :each| each invokeId = aNumber  ]
		ifNone: [  nil  ]
]

{ #category : #requests }
TCAPDialogue >> requestTCUCancel: invokeID [
	"To cancel we remove the invokeID from the localInvocations."
	localInvocations removeAllSuchThat: [:inv | invokeID =  inv invokeId ].
]

{ #category : #requests }
TCAPDialogue >> requestTcBeginDestinationAddress: aDestinationAddress originatingAddress: anOriginatingAddress [ 
	self state 
		requestTcBeginDestinationAddress: aDestinationAddress 
		originatingAddress: anOriginatingAddress 

]

{ #category : #requests }
TCAPDialogue >> requestTcBeginDestinationAddress: aDestinationAddress originatingAddress: anOriginatingAddress applicationContextName: anApplicationContextName [ 

	self 
		requestTcBeginDestinationAddress: aDestinationAddress 
		originatingAddress: anOriginatingAddress 
		applicationContextName: anApplicationContextName
		userInformation: nil
]

{ #category : #requests }
TCAPDialogue >> requestTcBeginDestinationAddress: aDestinationAddress originatingAddress: anOriginatingAddress applicationContextName: anApplicationContextName userInformation: anObject [
	self state 
		requestTcBeginDestinationAddress: aDestinationAddress 
		originatingAddress: anOriginatingAddress 
		applicationContextName: anApplicationContextName 
		userInformation: anObject
]

{ #category : #requests }
TCAPDialogue >> requestTcBeginDestinationAddress: aDestinationAddress originatingAddress: anOriginatingAddress userInformation:  anUserInformation [
	self state 
		requestTcBeginDestinationAddress: aDestinationAddress 
		originatingAddress: anOriginatingAddress 
		userInformation: anUserInformation 

]

{ #category : #requests }
TCAPDialogue >> requestTcContinue [
	self state requestTcContinue
]

{ #category : #requests }
TCAPDialogue >> requestTcEnd: aTerminationBoolean [

	self state requestTcEnd: aTerminationBoolean 
]

{ #category : #accessing }
TCAPDialogue >> requestTcInvoke: anOperation parameters: anObject  class: aClass timeout: aTimeout [ 
	^ self 
		requestTcInvoke: anOperation
		parameters: anObject  
		class: aClass 
		timeout: aTimeout 
		linkedTo: nil
]

{ #category : #accessing }
TCAPDialogue >> requestTcInvoke: anOperation parameters: anObject  class: aClass timeout: aTimeout linkedTo: anInvocation [
	| invocation |
	invocation := (anOperation invokeWithArgument: anObject)
		invokeId: invokeIdPool nextId;
		yourself.
	invocation operationClass: aClass.
	invocation startInvocationTimer: aTimeout.
	localInvocations add: invocation.
	
	anInvocation ifNotNil: [ 
		invocation linkedTo: anInvocation ].
	
	invocation onMessage: [ :msg |
        componentCoordinator addComponent: (msg asROS) ].
      invocation sendMessage: invocation.
	^ invocation  
]

{ #category : #accessing }
TCAPDialogue >> requestTcInvokeNamed: aString parameters: anObject  class: aNumber timeout: aTimeout [ 
	^ self  
		requestTcInvokeNamed: aString 
		parameters: anObject
		class: aNumber 
		timeout: aTimeout
		linkedTo: nil
]

{ #category : #accessing }
TCAPDialogue >> requestTcInvokeNamed: aString parameters: anObject  class: aClass timeout: aTimeout linkedTo: anInvocation [
	^ self 
		requestTcInvoke: (componentCoordinator dialogue rosOperationNamed: aString) 
		parameters: anObject  
		class: aClass 
		timeout: aTimeout 
		linkedTo: anInvocation 
	
]

{ #category : #requests }
TCAPDialogue >> requestTcPAbort: aNumber [
	| pAbort |
	pAbort := self factory newDialoguePAbort contents: aNumber.
	self state requestTcPAbort: pAbort 
]

{ #category : #requests }
TCAPDialogue >> requestTcUAbort: anAbortInformation [
	self state requestTcUAbort: anAbortInformation
]

{ #category : #requests }
TCAPDialogue >> requestTrBeginDestinationAddress: aDestinationAddress originatingAddress: aOriginatingAddress userData: aDictionary [
	^  self state requestTrBeginDestinationAddress: aDestinationAddress originatingAddress: aOriginatingAddress userData: aDictionary 
]

{ #category : #accessing }
TCAPDialogue >> rosOperationNamed: aString [ 
	^ ROSOperation on: (self operationNamed: aString)
]

{ #category : #'as yet unclassified' }
TCAPDialogue >> sendAcceptResponse [
	"store response for the next continue or end message to pick up
	and deliver back"
	pendingResponse := self newAcceptedDialogueResponse: nil
]

{ #category : #accessing }
TCAPDialogue >> setupTcError: anInvocation name: aName [ 

	anInvocation onMessage: [ :msg |
        componentCoordinator addComponent: (msg asROS) ].
      anInvocation returnErrorNamed: aName.
	^ anInvocation  
]

{ #category : #accessing }
TCAPDialogue >> setupTcReturn: anInvocation parameters: anObject [ 

	anInvocation onMessage: [ :msg |
        componentCoordinator addComponent: (msg asROS) ].
      anInvocation returnResultLastUsing: [ :result | result add:  anObject].
	^ anInvocation  
]

{ #category : #accessing }
TCAPDialogue >> state [
	^ state ifNil: [ 
		self switchState: #idle ]
]

{ #category : #actions }
TCAPDialogue >> terminate [
	self nextState: TCAPStoppedDialogueState new. 
	container dialogueHandler removeDialogue: self 
]

{ #category : #accessing }
TCAPDialogue >> transaction [
	^ container transaction
]

{ #category : #accessing }
TCAPDialogue >> transactionCoordinator [
	^ container transactionCoordinator
]

{ #category : #accessing }
TCAPDialogue >> userInformation [
	^ userInformation
]

{ #category : #accessing }
TCAPDialogue >> userInformation: anObject [
	userInformation := anObject
]
