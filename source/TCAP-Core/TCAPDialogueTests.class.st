Class {
	#name : #TCAPDialogueTests,
	#superclass : #ASN1PacketTest,
	#instVars : [
		'tcap',
		'dialogueList',
		'componentLayer',
		'transactionSubLayer',
		'localNetworkService',
		'remoteNetworkService'
	],
	#category : #'TCAP-Core-Tests'
}

{ #category : #'as yet unclassified' }
TCAPDialogueTests >> asn1Model [
	^ TCAPTestModel instance
]

{ #category : #accessing }
TCAPDialogueTests >> packet: aSymbol [
	^ TCAPExamplePackets perform: aSymbol
]

{ #category : #'setup-teardown' }
TCAPDialogueTests >> setUp [
	super setUp.
	localNetworkService := SCCPMockNetworkService new.
	remoteNetworkService := SCCPMockNetworkService new.
	localNetworkService connectTo: remoteNetworkService.

]

{ #category : #'as yet unclassified' }
TCAPDialogueTests >> tcapModule [
	^ self asn1Model moduleNamed: 'TCAPMessages'
]

{ #category : #tests }
TCAPDialogueTests >> testIdPool [
	| pool |
	pool := TCAPIdPool new size: 16rffff.
	self assert: pool nextId = 1.
	self assert: pool nextId = 2
]

{ #category : #tests }
TCAPDialogueTests >> testIdPoolStartValue [
	| pool |
	pool := TCAPIdPool new size: 16rffffffff.
	pool startValue: 1000000.
	self assert: pool nextId = 1000000.
	self assert: pool nextId = 1000001
]

{ #category : #tests }
TCAPDialogueTests >> testOperationLookup [
	| value dialoguePortion components invoke opcode operation applicationContext |
	value := self readResolvedFrom: (self packet: #purgeMS) . 
	dialoguePortion := value begin dialoguePortion "decodeIn: self asn1Model ".
	components := value begin components.
	applicationContext := self asn1Model applicationContextWithOid: (dialoguePortion soleValue at: 'application-context-name').
	self deny: value size = 0.
	invoke := components first invoke.
	opcode := invoke opcode local.
	operation := applicationContext operationWithCode: opcode.
	self assert: operation notNil
]

{ #category : #tests }
TCAPDialogueTests >> testResolveApplicationContexts [
	| operation operationPackages applicationContexts |
	operation := (self asn1Model bindingNamed: 'sendAuthenticationInfoV3') value.
	operationPackages := self asn1Model operationPackages values select: [ :package|
		package includes: operation ].
	applicationContexts := OrderedCollection new.
	operationPackages do: [ :package | 
		self asn1Model applicationContexts do: [ :context|
			(context includes:  package) ifTrue: [ 
				applicationContexts add: context ] ]]
]
