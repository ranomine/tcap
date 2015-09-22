Class {
	#name : #TCAPTestEnvironment,
	#superclass : #Object,
	#instVars : [
		'serviceEndPointA',
		'serviceEndPointB',
		'localAddress',
		'remoteAddress'
	],
	#category : #'TCAP-Core-Tests-Model'
}

{ #category : #'as yet unclassified' }
TCAPTestEnvironment >> applicationContextFor: aString [
	^ self asn1Model applicationContextOidForOperationNamed: aString
	
]

{ #category : #'as yet unclassified' }
TCAPTestEnvironment >> asn1Context: anASN1Model [
	serviceEndPointA asn1Context: anASN1Model.
	serviceEndPointB asn1Context: anASN1Model
]

{ #category : #accessing }
TCAPTestEnvironment >> connect [
	self servicePointA connectTo: self servicePointB   
]

{ #category : #testing }
TCAPTestEnvironment >> hasInitialState [
	^ serviceEndPointA hasInitialState and: [ serviceEndPointB  hasInitialState ]
]

{ #category : #'as yet unclassified' }
TCAPTestEnvironment >> initialize [
	super initialize.
	serviceEndPointA := self serviceEndPointAClass newForTesting.
	serviceEndPointB := self serviceEndPointBClass newForTesting.

]

{ #category : #injecting }
TCAPTestEnvironment >> injectTcapA: aByteArray [
	"inject an encoded tcap message in serviceEndPoint A using the 
	preconfigured SCCP addresses"
	
	^ self servicePointA injectTcap: aByteArray from: remoteAddress to: localAddress 
]

{ #category : #accessing }
TCAPTestEnvironment >> localAddress [
	^ localAddress
]

{ #category : #accessing }
TCAPTestEnvironment >> localAddress: anAddress [ 
	localAddress := anAddress 
]

{ #category : #accessing }
TCAPTestEnvironment >> localAddressIs: aSymbol [ 
	^ localAddress := SCCPAddress createForSSN: aSymbol
]

{ #category : #accessing }
TCAPTestEnvironment >> remoteAddress [
	^ remoteAddress
]

{ #category : #accessing }
TCAPTestEnvironment >> remoteAddress: anAddress [
	remoteAddress := anAddress
]

{ #category : #accessing }
TCAPTestEnvironment >> remoteAddressIs: aSymbol [ 
	^ remoteAddress := SCCPAddress createForSSN: aSymbol
]

{ #category : #'as yet unclassified' }
TCAPTestEnvironment >> sendAuthenticationInfoTo: anAddress parameters: aDictionaryOrString [
	| operationName dialogue  |
	operationName := 'sendAuthenticationInfoV2'.
	dialogue := self servicePointA  newDialogue.
	dialogue requestTcInvokeNamed: operationName parameters:  aDictionaryOrString class: 1 timeout: 500.
	dialogue
		requestTcBeginDestinationAddress: anAddress
		originatingAddress: localAddress 
		applicationContextName: (dialogue applicationContextOidForOperationNamed: operationName)
	
]

{ #category : #accessing }
TCAPTestEnvironment >> serviceEndPointAClass [
	^ self serviceEndPointClass 
]

{ #category : #accessing }
TCAPTestEnvironment >> serviceEndPointBClass [
	^ self serviceEndPointClass 
]

{ #category : #accessing }
TCAPTestEnvironment >> serviceEndPointClass [
	^ TCAPTestServiceEndPoint 
]

{ #category : #accessing }
TCAPTestEnvironment >> servicePointA [
	^ serviceEndPointA   
]

{ #category : #accessing }
TCAPTestEnvironment >> servicePointB [
	^ serviceEndPointB   
]
