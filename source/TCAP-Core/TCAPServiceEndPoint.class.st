Class {
	#name : #TCAPServiceEndPoint,
	#superclass : #TCAPObject,
	#instVars : [
		'networkService',
		'transactionCoordinator',
		'dialogueHandler',
		'dialoguesAndTransactions',
		'idPool',
		'announcer',
		'dialoguesAndTransactionsMutex'
	],
	#category : #'TCAP-Core-Model'
}

{ #category : #accessing }
TCAPServiceEndPoint class >> newForTesting [
	^ self new
		factory: TCAPTestObjectFactory new
]

{ #category : #accessing }
TCAPServiceEndPoint >> addDialogueAndTransaction: aDialogueAndTransaction [ 
	^ dialoguesAndTransactionsMutex critical: [
		dialoguesAndTransactions add: aDialogueAndTransaction ]
]

{ #category : #'as yet unclassified' }
TCAPServiceEndPoint >> addHandler: aHandler [
	aHandler registerAtServicePoint: announcer
]

{ #category : #accessing }
TCAPServiceEndPoint >> asn1Context: aContext [ 
	asn1Context := aContext
]

{ #category : #'as yet unclassified' }
TCAPServiceEndPoint >> basicNewDialogueAndTransaction [

	^ self factory newDialogueAndTransaction 
		container: self
]

{ #category : #accessing }
TCAPServiceEndPoint >> createNetworkService [
	^ SCCPMockNetworkService new.
]

{ #category : #accessing }
TCAPServiceEndPoint >> createTransactionCoordinator [
	^ self factory newTransactionCoordinator
		initializeWith: self networkService;
		container: self
		
]

{ #category : #accessing }
TCAPServiceEndPoint >> dialogueHandler [
	^ dialogueHandler ifNil: [ 
		dialogueHandler := self factory newDialogueHandler
			serviceEndPoint: self   ]
]

{ #category : #accessing }
TCAPServiceEndPoint >> enableMandatoryHandshake [

	self addHandler: TCAPHandshakeHandler new withMandatoryHandshake
]

{ #category : #accessing }
TCAPServiceEndPoint >> enableOptionalHandshake [

	self addHandler: TCAPHandshakeHandler new withOptionalHandshake
]

{ #category : #testing }
TCAPServiceEndPoint >> hasTransactions [
	^ dialoguesAndTransactions notEmpty
]

{ #category : #accessing }
TCAPServiceEndPoint >> idPool [
	^ idPool ifNil: [ 
		idPool := self factory defaultIdPool ]
]

{ #category : #'initialize-release' }
TCAPServiceEndPoint >> initialize [
	super initialize.
	dialoguesAndTransactions := Set new.
	announcer := Announcer new.
	dialoguesAndTransactionsMutex := Mutex new
]

{ #category : #accessing }
TCAPServiceEndPoint >> installStateClass: aClass [
	self factory installStateClass: aClass
]

{ #category : #testing }
TCAPServiceEndPoint >> isIdle [
	"Endpoint is idle when no transactions pending"
	
	^self hasTransactions not
]

{ #category : #testing }
TCAPServiceEndPoint >> isIdleForAllIDs [
	"Here we need to check that none of the dialogs knows an anInvokeID"

	^self dialoguesAndTransactions allSatisfy:   [ :each | each dialogue isIdleForAllIDs  ]
]

{ #category : #testing }
TCAPServiceEndPoint >> isIdleForId: anInvokeID [
	"Here we need to check that none of the dialogs knows anInvokeID"

	^self dialoguesAndTransactions allSatisfy:   [ :each | each dialogue isIdleForId:  anInvokeID  ]
]

{ #category : #accessing }
TCAPServiceEndPoint >> networkService [
	^ networkService ifNil: [ 
		networkService := self createNetworkService.
		self transactionCoordinator initializeWith: networkService.
		networkService  ]
]

{ #category : #accessing }
TCAPServiceEndPoint >> networkService: aService [
	networkService := aService.
	self transactionCoordinator initializeWith: aService
]

{ #category : #'initialize-release' }
TCAPServiceEndPoint >> newDialogue [
	^ self newDialogueWithId: nil
]

{ #category : #accessing }
TCAPServiceEndPoint >> newDialogueAndTransaction [

	^ self newDialogueAndTransactionWithId: nil
]

{ #category : #accessing }
TCAPServiceEndPoint >> newDialogueAndTransactionWithId: aNumber [

	^ self basicNewDialogueAndTransaction
		allocateId: aNumber;
		register
]

{ #category : #'initialize-release' }
TCAPServiceEndPoint >> newDialogueWithId: aNumber [
	| dialogue |
	dialogue := (self newDialogueAndTransactionWithId: aNumber) dialogue.
	self notifyDialogueCreated: dialogue.
	^ dialogue
]

{ #category : #accessing }
TCAPServiceEndPoint >> newTransaction [
	^ self newDialogueAndTransaction transaction
]

{ #category : #'as yet unclassified' }
TCAPServiceEndPoint >> notifyDialogueCreated: aDialogue [
	announcer announce: (TCAPDialogueCreated dialogue: aDialogue)
]

{ #category : #'as yet unclassified' }
TCAPServiceEndPoint >> notifyDialogueReceived: aDialogue [
	announcer  announce: (TCAPDialogueReceived dialogue: aDialogue)
]

{ #category : #accessing }
TCAPServiceEndPoint >> onDialogue: aBlock [
	announcer
		when: TCAPDialogueReceived
		do: aBlock
]

{ #category : #removing }
TCAPServiceEndPoint >> removeDialogueAndTransaction: aDialogueAndTransaction [
	self idPool freeByteArray: aDialogueAndTransaction id.
	"dialogues and transactions can be released independently. As the object
	is shared a double remove is possible"
	dialoguesAndTransactionsMutex critical: [  
		dialoguesAndTransactions remove:aDialogueAndTransaction ifAbsent: [ ] ].
	announcer announce: (TCAPDialogueTerminated dialogue: aDialogueAndTransaction dialogue)
]

{ #category : #accessing }
TCAPServiceEndPoint >> transactionCoordinator [
	^ transactionCoordinator ifNil: [ 
		transactionCoordinator := self createTransactionCoordinator ]
]

{ #category : #accessing }
TCAPServiceEndPoint >> transactionCoordinator: aTCAPTransactionCoordinator [ 
	transactionCoordinator := aTCAPTransactionCoordinator.
	transactionCoordinator container: self
]

{ #category : #accessing }
TCAPServiceEndPoint >> transactionWithId: aString [
	^ dialoguesAndTransactionsMutex critical: [
		(dialoguesAndTransactions 
			detect: [ :each | each transaction id = aString  ]
			ifNone: [ ^ nil ])
				transaction]
]

{ #category : #accessing }
TCAPServiceEndPoint >> transactionWithRemoteId: aString [
	^ dialoguesAndTransactionsMutex critical: [
		(dialoguesAndTransactions 
			detect: [ :each | each transaction remoteTransactionId = aString  ]
			ifNone: [ ^ nil ])
				transaction ]
]
