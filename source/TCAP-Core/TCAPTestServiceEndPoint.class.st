Class {
	#name : #TCAPTestServiceEndPoint,
	#superclass : #TCAPServiceEndPoint,
	#instVars : [
		'fakeId'
	],
	#category : #'TCAP-Core-Tests-Model'
}

{ #category : #accessing }
TCAPTestServiceEndPoint >> autoMessageDispatch: aBoolean [
	self networkService autoDispatch: aBoolean
]

{ #category : #'as yet unclassified' }
TCAPTestServiceEndPoint >> connectTo: aServer [
	self networkService connectTo: aServer networkService.
	aServer networkService connectTo: self networkService
]

{ #category : #accessing }
TCAPTestServiceEndPoint >> createNetworkService [
	^ SCCPMockNetworkService new.
]

{ #category : #'as yet unclassified' }
TCAPTestServiceEndPoint >> defaultIdPool [
	^ self idPoolClass new 
		size: 16rFFFFFFFF;
		startValue: 16r1000000 + 100000 atRandom.
]

{ #category : #'as yet unclassified' }
TCAPTestServiceEndPoint >> dialogueHandlerClass [
	^ TCAPTestDialogueHandler 
]

{ #category : #accessing }
TCAPTestServiceEndPoint >> didReceiveMessage [
	^ networkService receivedPackets notEmpty
]

{ #category : #testing }
TCAPTestServiceEndPoint >> didSendMessage [
	^ networkService sentPackets notEmpty
]

{ #category : #'as yet unclassified' }
TCAPTestServiceEndPoint >> fakeDialogueId: aNumber [
	fakeId := aNumber
]

{ #category : #testing }
TCAPTestServiceEndPoint >> hasInitialState [
	^ dialoguesAndTransactions isEmpty and: [ idPool hasIdsAllocated not ]
]

{ #category : #accessing }
TCAPTestServiceEndPoint >> idPoolClass [
	^ TCAPTestIdPool 
]

{ #category : #'as yet unclassified' }
TCAPTestServiceEndPoint >> injectSCCP: aByteArray [ 
	networkService doReceive: aByteArray
	
]

{ #category : #'as yet unclassified' }
TCAPTestServiceEndPoint >> newDialogue [
	^ self newDialogueWithIdString: fakeId 
]

{ #category : #'as yet unclassified' }
TCAPTestServiceEndPoint >> newDialogueWithIdString: aString [
	^ self newDialogueWithId: (aString
		ifNotNil: [  aString asInteger ])
	
]

{ #category : #'as yet unclassified' }
TCAPTestServiceEndPoint >> receiveTCMessage: aMessage forDialogue: aDialogue [ 
	| sender receiver |
	sender := aDialogue transaction remoteAddress.
	receiver := aDialogue transaction address.
	transactionCoordinator 
		withAbortHandlersDo: [ 
			transactionCoordinator 
				receiveTCMessage: aMessage
				from: sender
				to: receiver ] 
		from: sender 
		to: receiver
]

{ #category : #accessing }
TCAPTestServiceEndPoint >> receivedPackets [
	^ networkService receivedPackets 
]

{ #category : #accessing }
TCAPTestServiceEndPoint >> sentPackets [
	^ networkService sentPackets 
]

{ #category : #accessing }
TCAPTestServiceEndPoint >> tcapModule [
	^ self asn1Model moduleNamed: 'TCAPMessages'
]

{ #category : #'as yet unclassified' }
TCAPTestServiceEndPoint >> transactionCoordinatorClass [ 
	^ TCAPTestTransactionCoordinator 
		
]

{ #category : #accessing }
TCAPTestServiceEndPoint >> transactionWithId: aString [
	^ transactionCoordinator transactionWithId: aString
]
