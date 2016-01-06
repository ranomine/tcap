Class {
	#name : #TCAPHandlerTest,
	#superclass : #TCAPTestCase,
	#category : #'TCAP-Core-Tests'
}

{ #category : #tests }
TCAPHandlerTest >> shouldAbortMessageContainingComponentsWithMandatoryHandshake [
	| env dialogue invocation   mapsec abortCalled |
	env := self given: #shouldCreateTestEnvironment.
	
	abortCalled := false.
	mapsec := TCAPHandshakeHandler new withMandatoryHandshake.
	env servicePointB addHandler: mapsec.
	env servicePointB onDialogue: [ :dialog | 
		dialog onBegin: [ self fail ] ].
	
	dialogue := env servicePointA newDialogue.	
	invocation :=dialogue requestTcInvokeNamed: 'sendAuthenticationInfoV2' parameters:  '123456789' asByteArray class: TCAPReportSuccessAndFailure timeout: 500.

	dialogue 
		onPAbort: [ : x | abortCalled := true ];
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: '0.4.0.0.1.0.14.2'.
	
	self assert: env servicePointB didSendMessage.
	self assert: (self messageInspectorOn: env servicePointA receivedPackets first) isAbort.
	self assert: abortCalled .
]

{ #category : #'as yet unclassified' }
TCAPHandlerTest >> shouldContinueMessageNoComponentsWithMandatoryHandler [
	| env dialogue    mapsec abortCalled |
	env := self given: #shouldCreateTestEnvironment.
	
	abortCalled := false.
	mapsec := TCAPHandshakeHandler new withMandatoryHandshake.
	env servicePointB addHandler: mapsec.

	dialogue := env servicePointA newDialogue.	
	dialogue 
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: '0.4.0.0.1.0.14.2'.
	
	self assert: env servicePointB didSendMessage.
	self assert: (self messageInspectorOn: env servicePointA receivedPackets first) isContinue.

]

{ #category : #'as yet unclassified' }
TCAPHandlerTest >> shouldContinueMessageNoComponentsWithOptionalHandler [
	| env dialogue mapsec continueCalled |
	env := self given: #shouldCreateTestEnvironment.
	
	continueCalled := false.
	mapsec := TCAPHandshakeHandler new withOptionalHandshake.
	env servicePointB addHandler: mapsec.

	dialogue := env servicePointA newDialogue.	
	dialogue 
		onContinue: [ continueCalled := true ];
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: '0.4.0.0.1.0.14.2'.
	
	self assert: continueCalled.
	self assert: env servicePointB didSendMessage.
	self assert: (self messageInspectorOn: env servicePointA receivedPackets first) isContinue.

]

{ #category : #'as yet unclassified' }
TCAPHandlerTest >> shouldNotContinueMessageWithComponentsWithOptionalHandler [
	| env dialogue    mapsec continueCalled invocation |
	env := self given: #shouldCreateTestEnvironment.
	
	continueCalled := false.
	mapsec := TCAPHandshakeHandler new withOptionalHandshake.
	env servicePointB addHandler: mapsec.

	dialogue := env servicePointA newDialogue.	
	invocation :=dialogue requestTcInvokeNamed: 'sendAuthenticationInfoV2' parameters:  '123456789' asByteArray class: TCAPReportSuccessAndFailure timeout: 500.
	dialogue 
		onContinue: [ continueCalled := true ];
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: '0.4.0.0.1.0.14.2'.
	
	self deny: continueCalled.
	self deny: env servicePointB didSendMessage.

]

{ #category : #tests }
TCAPHandlerTest >> shouldRemoveDialogueAfterTimeout [
	| env dialogue invocation  handler  |
	env := self given: #shouldCreateTestEnvironment.
	(Delay forSeconds: 0.1) wait.
	handler := TCAPDialogueTimeoutHandler new
		timeout: 0.1 second.
	env servicePointB addHandler: handler.
	env servicePointB
		onDialogue: [ :dialog |
			 dialog 
				onInvoke: [ : inv | 
					dialog requestTcContinue ]].
	dialogue := env servicePointA newDialogue.	
	invocation :=dialogue requestTcInvokeNamed: 'sendAuthenticationInfoV2' parameters:  '123456789' asByteArray class: TCAPReportSuccessAndFailure timeout: 500.
	dialogue 
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: '0.4.0.0.1.0.14.2'.
	
	self assert: env servicePointA didSendMessage.
	(Delay forSeconds: 0.2) wait.
	self assert: env servicePointB dialoguesAndTransactions isEmpty.
	self deny: handler hasActiveDialogues
]

{ #category : #tests }
TCAPHandlerTest >> shouldRemoveLocalDialogueAfterTimeout [
	| env dialogue invocation  handler  |
	env := self given: #shouldCreateTestEnvironment.
	(Delay forSeconds: 0.1) wait.
	
	handler := TCAPDialogueTimeoutHandler new
		timeout: 0.1 second.
	env servicePointA addHandler: handler.

	dialogue := env servicePointA newDialogue.	
	invocation :=dialogue requestTcInvokeNamed: 'sendAuthenticationInfoV2' parameters:  '123456789' asByteArray class: TCAPReportSuccessAndFailure timeout: 500.
	dialogue 
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: '0.4.0.0.1.0.14.2'.
	
	self assert: env servicePointA didSendMessage.
	self deny: env servicePointB didSendMessage.
	(Delay forSeconds: 0.2) wait.
	self assert: env servicePointA dialoguesAndTransactions isEmpty.
	self deny: handler hasActiveDialogues
]

{ #category : #tests }
TCAPHandlerTest >> shouldRemoveRemoteDialogueAfterTimeout [
	| env dialogue invocation  handler  |
	env := self given: #shouldCreateTestEnvironment.
	(Delay forSeconds: 0.1) wait.
	self asn1Model.
	handler := TCAPDialogueTimeoutHandler new
		timeout: 0.1 second.
	env servicePointB addHandler: handler.
	env servicePointB
		onDialogue: [ :dialog |
			 dialog 
				onInvoke: [ : inv | 
					dialog requestTcContinue ]].
	dialogue := env servicePointA newDialogue.	
	invocation :=dialogue requestTcInvokeNamed: 'sendAuthenticationInfoV2' parameters:  '123456789' asByteArray class: TCAPReportSuccessAndFailure timeout: 500.
	dialogue 
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: '0.4.0.0.1.0.14.2'.
	
	self assert: env servicePointA didSendMessage.
	(Delay forSeconds: 0.2) wait.
	self assert: env servicePointB dialoguesAndTransactions isEmpty.
	self deny: handler hasActiveDialogues
]
