Class {
	#name : #TCAPTestDialogue,
	#superclass : #TCAPDialogue,
	#category : #'TCAP-Core-Tests-Model'
}

{ #category : #accessing }
TCAPTestDialogue >> addLocalInvocationWithId: aNumber [ 
	 | invocation |
	invocation := ROSInvocation new 
		parent: self;
		type: (self asn1TypeNamed: 'Invoke');
		id: aNumber.
	localInvocations add: invocation.
	^ invocation
]

{ #category : #'requests - for testing' }
TCAPTestDialogue >> requestTcContinueDestinationAddress: aDestinationAddress originatingAddress: anOriginatingAddress applicationContextName: anApplicationContextName [
	self state 
		requestTcContinueDestinationAddress: aDestinationAddress 
		originatingAddress: anOriginatingAddress 
		applicationContextName: anApplicationContextName
		userInformation: nil
]

{ #category : #'requests - for testing' }
TCAPTestDialogue >> requestTcContinueDestinationAddress: aDestinationAddress originatingAddress: anOriginatingAddress applicationContextName: anApplicationContextName userInformation: aUserInformation [
	self state 
		requestTcContinueDestinationAddress: aDestinationAddress 
		originatingAddress: anOriginatingAddress 
		applicationContextName: anApplicationContextName
		userInformation: aUserInformation
]

{ #category : #'requests - for testing' }
TCAPTestDialogue >> requestTcEndDestinationAddress: aDestinationAddress originatingAddress: anOriginatingAddress applicationContextName: anApplicationContextName [
	self state 
		requestTcEndDestinationAddress: aDestinationAddress 
		originatingAddress: anOriginatingAddress 
		applicationContextName: anApplicationContextName
		userInformation: nil
]

{ #category : #'requests - for testing' }
TCAPTestDialogue >> requestTcEndDestinationAddress: aDestinationAddress originatingAddress: anOriginatingAddress applicationContextName: anApplicationContextName userInformation: aUserInformation [
	self state 
		requestTcEndDestinationAddress: aDestinationAddress 
		originatingAddress: anOriginatingAddress 
		applicationContextName: anApplicationContextName
		userInformation: aUserInformation
]
