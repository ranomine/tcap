Class {
	#name : #MAPTest,
	#superclass : #Phexample,
	#category : #'MAP-Core-Tests'
}

{ #category : #accessing }
MAPTest >> asn1Model [
	^ TCAPTestModel instance
]

{ #category : #'as yet unclassified' }
MAPTest >> expectedFailures [ 
	^ #( shouldHaveOneApplicationContextPerOperation )
]

{ #category : #'as yet unclassified' }
MAPTest >> model [
	^ (MAPExampleModels named: #tcap) 
]

{ #category : #'as yet unclassified' }
MAPTest >> shouldFindAllApplicationContexts [
	| operations  |
	operations := self model allOperations.
	self assert: operations notEmpty.
	operations do: [ :operation| | operationName contexts |
		operationName := operation definingModule fieldAtValue: operation. 
		self shouldnt: [contexts := self model applicationContextsForOperation: operation] raise: Error ].

]

{ #category : #'as yet unclassified' }
MAPTest >> shouldFindApplicationContextForSendAuthenticationBinding [
	| operation  |
	operation := self model applicationContextForOperationNamed: 'sendAuthenticationInfoV3'.
	self assert: operation notNil.
	self assert: (operation clazz = 'APPLICATION-CONTEXT')

]

{ #category : #'as yet unclassified' }
MAPTest >> shouldFindApplicationContextForSendAuthenticationOperation [
	| operation contexts context |
	operation := (self given:#shouldFindSendAuthenticationBinding) value.
	contexts := self model applicationContextsForOperation: operation.
	self assert: contexts notEmpty .
	context := contexts associations first.
	self assert: context value clazz = 'APPLICATION-CONTEXT'.
	self assert: context key = 'infoRetrievalContext-v3'.
	self assert: (context value attributeAt: 'applicationContextName')  value value= '0.4.0.0.1.0.14.3'

]

{ #category : #'as yet unclassified' }
MAPTest >> shouldFindOperationPackageForSendAuthentication [
	| operation packages package |
	operation := (self given:#shouldFindSendAuthenticationBinding) value.
	packages := self model operationPackagesForOperation: operation.
	self assert: packages size = 1.
	package := packages associations first.
	self assert: package key = 'infoRetrievalPackage-v3'.
	^ package

]

{ #category : #'as yet unclassified' }
MAPTest >> shouldFindSendAuthenticationBinding [
	| binding |
	binding := self model bindingNamed: 'sendAuthenticationInfoV3'.
	self assert: binding notNil.
	self assert: binding value isAsn1Object.
	self assert: binding value isOperation.
	^ binding 
	
]

{ #category : #'as yet unclassified' }
MAPTest >> shouldHaveOneApplicationContextPerOperation [
	| operations  |
	operations := self model allOperations.
	self assert: operations notEmpty.
	operations do: [ :operation| | operationName contexts |
		operationName := operation definingModule fieldAtValue: operation. 
		self shouldnt: [contexts := self model applicationContextsForOperation: operation] raise: Error.
		self assert: contexts size = 1 ].

]

{ #category : #'as yet unclassified' }
MAPTest >> tcapModule [
	^ self model moduleNamed: 'TCAPMessages'
]

{ #category : #'as yet unclassified' }
MAPTest >> testApplicationContextWithId [
	| context |
	self shouldnt: [ context := self model applicationContextWithOid:'0.4.0.0.1.0.27.3' ] raise: Error.
	self assert: context notNil.
	self assert: (context attributeAt: 'applicationContextName') value = '0.4.0.0.1.0.27.3'
]

{ #category : #'as yet unclassified' }
MAPTest >> testApplicationContexts [
	| contexts |
	contexts := self model applicationContexts.
	self assert: contexts notEmpty.
	self assert: contexts values first clazz = 'APPLICATION-CONTEXT'
]

{ #category : #'as yet unclassified' }
MAPTest >> testInsertSubscriberDataBitStringAccess [
	| continue operation data |
	continue := (self tcapModule readFrom: TCAPExamplePackets insertSubscriberDataWithBitString readStream inContext: self asn1Model) continue.
	operation := (self model bindingNamed: 'insertSubscriberDataV3') value attributeAt: 'ArgumentType'.

	data := ASN1 read: continue components first invoke argument usingType: operation.
	"TODO: now start inspecting all of it..."
	self assert: data msisdn hex = '91533458001091'.
	self assert: data category asInteger = 10.
	self assert: data subscriberStatus value = 'operatorDeterminedBarring'
]
