Class {
	#name : #TCAPSimulationTest,
	#superclass : #TCAPTestCase,
	#category : #'TCAP-Core-Tests'
}

{ #category : #'as yet unclassified' }
TCAPSimulationTest >> exampleResult [
	^ (self typeNamed: 'AuthenticationSet') newValue
		at: 'rand' put: (ByteArray readHexFrom: 'DEADBEEF');
		at: 'sres' put: (ByteArray readHexFrom: 'DEADBEEF');
		at: 'kc' put: (ByteArray readHexFrom: 'DEADBEEF')
]

{ #category : #'as yet unclassified' }
TCAPSimulationTest >> prepare: aDialogue forOperationNamed: aString [
	aDialogue applicationContext: (
		(self asn1Model applicationContextsForOperationNamed: aString) 
			values first).
]

{ #category : #'as yet unclassified' }
TCAPSimulationTest >> sccpSendAuthenticationInfoNoProtocolVersion [
	^#[9 0 3 16 27 13 18 6 0 113 4 83 132 137 0 0 0 16 2 11 18 149 0 18 4 148 97 0 3 145 4 66 98 64 72 4 1 60 7 104 107 26 40 24 6 7 0 17 134 5 1 1 1 160 13 96 11 161 9 6 7 4 0 0 1 0 14 3 108 28 161 26 2 1 227 2 1 56 48 18 128 8 114 4 129 0 0 0 16 242 2 1 5 129 0 131 1 1]
]

{ #category : #'as yet unclassified' }
TCAPSimulationTest >> sccpSendWeirdInvoke [
	^#[9 0 3 16 27 13 18 6 0 113 4 83 132 137 0 0 0 16 2 11 18 149 0 18 4 148 113 6 0 1 34 35 98 33 72 4 0 209 7 14 108 25 161 23 2 1 150 2 1 9 48 15 128 8 114 4 129 0 0 0 16 242 48 3 10 1 1]
]

{ #category : #'as yet unclassified' }
TCAPSimulationTest >> sccpUpdateLocationWithExtension [
	^#[9 128 3 16 27 13 18 6 0 113 4 83 132 137 0 0 0 16 2 11 18 7 0 18 4 148 113 2 16 1 89 115 98 113 72 4 214 203 148 145 107 30 40 28 6 7 0 17 134 5 1 1 1 160 17 96 15 128 2 7 128 161 9 6 7 4 0 0 1 0 1 3 108 73 161 71 2 1 0 2 1 2 48 63 4 8 114 4 129 0 0 0 16 242 129 7 145 148 113 2 16 1 89 4 7 145 148 113 2 16 1 89 166 33 48 23 160 21 48 19 6 9 43 12 2 136 83 3 66 1 1 48 6 10 1 1 2 1 2 132 0 155 2 5 224 137 0]
]

{ #category : #'as yet unclassified' }
TCAPSimulationTest >> sendAuthenticationInfoTo: anAddress parameters: aDictionaryOrString [
	| operationName dialogue  |
	operationName := 'sendAuthenticationInfoV2'.
	dialogue := self newDialogue.
	dialogue requestTcInvokeNamed: operationName parameters:  aDictionaryOrString class: 1 timeout: 500.
	dialogue
		requestTcBeginDestinationAddress: anAddress
		originatingAddress: nil
		applicationContextName: (self applicationContextFor: operationName)
	
]

{ #category : #tests }
TCAPSimulationTest >> shouldAbortNoApplicationContextName [
	|  env |
	env := self newTestEnvironment. 
	env localAddressIs: #HLR.
	env remoteAddressIs: #AUC.
	env connect.
	env servicePointB injectSCCP: self sccpSendWeirdInvoke.
	
	"Check that the first packet is not an abort.."
	self assert: env servicePointB sentPackets size = 1.
	self assert: (self messageInspectorOn: env servicePointB sentPackets first) isAbort.


]

{ #category : #tests }
TCAPSimulationTest >> shouldAbortWithResourceLimitation [
	|  env |
	env := self newTestEnvironment. 
	env localAddressIs: #HLR.
	env remoteAddressIs: #AUC.
	env connect.
	env servicePointB idPool beExhausted.
	env sendAuthenticationInfoTo: env remoteAddress parameters: '0815' asByteArray.
	self assert: env servicePointA dialoguesAndTransactions size = 0.
	self assert: env servicePointB sentPackets size = 1.
	self assert: (self messageInspectorOn: env servicePointB sentPackets first) isAbort.
	^ env
]

{ #category : #tests }
TCAPSimulationTest >> shouldAbortWithoutDialoguePortionOnInitiationSentSpecCompliant [
	|  env dialogueA sccp aborted |

	aborted := false.
	sccp := HexDumpReader readFrom: '0000   09 00 03 0e 1b 0b 12 07 00 12 04 53 34 58 89 99
0010   79 0d 12 06 00 71 04 53 34 58 00 00 40 67 04 83
0020   64 81 80 49 04 01 00 00 0d 6c 78 a2 76 02 01 01
0030   30 71 02 01 38 30 6c 30 22 04 10 0b de 3f 48 7d
0040   ee 03 65 df 60 ec 67 86 2e 13 45 04 04 21 3c ba
0050   3b 04 08 6b 72 08 45 b7 a6 e8 00 30 22 04 10 c8
0060   40 c7 3b 5f 59 0a 33 cd 0d 9c 62 cd 61 a6 05 04
0070   04 48 86 d5 4a 04 08 8f f5 73 0a 5b 89 3c 00 30
0080   22 04 10 36 3b 9a 01 40 46 7a 4e 28 c4 2c 10 ca
0090   a9 21 4e 04 04 4f 86 1f 9f 04 08 1f 63 23 06 20
00a0   df 50 00'.

	env := self given: #shouldCreateTestEnvironment.

	env servicePointB transactionCoordinator postProcessDictionary: [ :dict |
		dict end removeKey: #dialoguePortion ].
	env servicePointB onDialogue: [ :dialogue |
		dialogue onBegin: [ dialogue requestTcEnd: false ]].
	
	dialogueA := env servicePointA newDialogue.
	dialogueA
		onPAbort: [ aborted := true ];
		onEnd: [ self halt ];
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
	
	self assert: env servicePointA sentPackets size = 1.
	self assert: (self messageInspectorOn: env servicePointA receivedPackets first) isEnd.
	self assert: aborted.
	"test if dialogue has been removed on remote end after receiving abort"
	self assert: env servicePointB hasInitialState

]

{ #category : #tests }
TCAPSimulationTest >> shouldContainDialoguePortionOnContinue [
	|  env  |
	env :=env := self given: #shouldCreateTestEnvironment.

	env servicePointB onDialogue: [ :dialogue |
		dialogue onBegin: [  dialogue requestTcContinue ]].
	
	env servicePointA newDialogue
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
	
	self assert: (self messageInspectorOn: env servicePointA sentPackets first) messageHasDialoguePortion.
	self assert: (self messageInspectorOn: env servicePointB sentPackets first) messageHasDialoguePortion.

]

{ #category : #tests }
TCAPSimulationTest >> shouldContainDialoguePortionOnEnd [
	|  env  |
	env :=env := self given: #shouldCreateTestEnvironment.

	env servicePointB onDialogue: [ :dialogue |
		dialogue onBegin: [  dialogue requestTcEnd: false ]].
	
	env servicePointA newDialogue
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
	
	self assert: (self messageInspectorOn: env servicePointA sentPackets first) messageHasDialoguePortion.
	self assert: (self messageInspectorOn: env servicePointB sentPackets first) messageHasDialoguePortion.

]

{ #category : #tests }
TCAPSimulationTest >> shouldHandleNoProtocolVersion [
	|  env |
	env := self newTestEnvironment. 
	env localAddressIs: #HLR.
	env remoteAddressIs: #AUC.
	env connect.
	env servicePointB injectSCCP: self sccpSendAuthenticationInfoNoProtocolVersion.
	
	"Check that the first packet is not an abort.."
	self assert: env servicePointB sentPackets size equals: 0.


]

{ #category : #tests }
TCAPSimulationTest >> shouldHandleUnknownExtension [
	|  env reached |
	env := self newTestEnvironment. 
	env localAddressIs: #HLR.
	env remoteAddressIs: #AUC.
	env connect.

	"The arguments are only decoded when invoke argument is called"
	env servicePointB onDialogue: [ :dialogue |
		dialogue onInvoke: [:invoke | invoke argument. reached := true ]].	

	env servicePointB injectSCCP: self sccpUpdateLocationWithExtension.
	
	"Check that nothing has been sent."
	self assert: env servicePointB sentPackets size = 0.
	self assert: reached.
	


]

{ #category : #tests }
TCAPSimulationTest >> shouldNotAbortWithoutDialoguePortionOnInitiationSentUsingQuirk [
	|  env dialogueA sccp aborted ended |

	aborted := false.
	ended := false.
	sccp := HexDumpReader readFrom: '0000   09 00 03 0e 1b 0b 12 07 00 12 04 53 34 58 89 99
0010   79 0d 12 06 00 71 04 53 34 58 00 00 40 67 04 83
0020   64 81 80 49 04 01 00 00 0d 6c 78 a2 76 02 01 01
0030   30 71 02 01 38 30 6c 30 22 04 10 0b de 3f 48 7d
0040   ee 03 65 df 60 ec 67 86 2e 13 45 04 04 21 3c ba
0050   3b 04 08 6b 72 08 45 b7 a6 e8 00 30 22 04 10 c8
0060   40 c7 3b 5f 59 0a 33 cd 0d 9c 62 cd 61 a6 05 04
0070   04 48 86 d5 4a 04 08 8f f5 73 0a 5b 89 3c 00 30
0080   22 04 10 36 3b 9a 01 40 46 7a 4e 28 c4 2c 10 ca
0090   a9 21 4e 04 04 4f 86 1f 9f 04 08 1f 63 23 06 20
00a0   df 50 00'.

	env := self given: #shouldCreateTestEnvironment.

	env servicePointB transactionCoordinator postProcessDictionary: [ :dict |
		dict end removeKey: #dialoguePortion ].
	env servicePointB onDialogue: [ :dialogue |
		dialogue onBegin: [ dialogue requestTcEnd: false ]].
	
	env servicePointA installStateClass: TCAPInitiationSentMissingDialoguePortionQuirkState.
	dialogueA := env servicePointA newDialogue.
	dialogueA
		onPAbort: [ aborted := true ];
		onEnd: [ ended := true ];
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
	
	self assert: env servicePointA sentPackets size = 1.
	self assert: (self messageInspectorOn: env servicePointA receivedPackets first) isEnd.
	self deny: aborted.
	self assert: ended.
	"test if dialogue has been removed on remote end after receiving abort"
	self assert: env servicePointB hasInitialState

]

{ #category : #tests }
TCAPSimulationTest >> shouldNotContainDialoguePortionOnAbort [
	|  env  |
	env :=env := self given: #shouldCreateTestEnvironment.

	env servicePointB onDialogue: [ :dialogue |
		dialogue onBegin: [  dialogue requestTcPAbort: TCAPDialoguePAbort unrecognizedMessageType ]].
	
	env servicePointA newDialogue
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
	
	self assert: (self messageInspectorOn: env servicePointA sentPackets first) messageHasDialoguePortion.
	self deny: (self messageInspectorOn: env servicePointB sentPackets first) messageHasDialoguePortion.

]

{ #category : #tests }
TCAPSimulationTest >> shouldNotContainDialoguePortionOnEndAfterContinue [
	|  env  |
	env :=env := self given: #shouldCreateTestEnvironment.

	env servicePointB onDialogue: [ :dialogue |
		dialogue
			onBegin: [  dialogue requestTcContinue ];
			onContinue: [ dialogue requestTcEnd: false]].
	
	env servicePointA newDialogue
		onContinue: [ :continue | continue dialogue requestTcContinue ];
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
	
	self assert: (self messageInspectorOn: env servicePointA sentPackets first) messageHasDialoguePortion.
	self assert: (self messageInspectorOn: env servicePointB sentPackets first) messageHasDialoguePortion.
	self deny: (self messageInspectorOn: env servicePointA sentPackets second) messageHasDialoguePortion.
	self deny: (self messageInspectorOn: env servicePointB sentPackets second) messageHasDialoguePortion.
]

{ #category : #tests }
TCAPSimulationTest >> shouldNotContainDialoguePortionOnSecondContinue [
	|  env  |
	env := self given: #shouldCreateTestEnvironment.

	env servicePointB onDialogue: [ :dialogue |
		dialogue onBegin: [  dialogue requestTcContinue ]].
	
	env servicePointA newDialogue
		onContinue: [ :continue | continue dialogue requestTcContinue ];
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
	
	self assert: (self messageInspectorOn: env servicePointA sentPackets first) messageHasDialoguePortion.
	self assert: (self messageInspectorOn: env servicePointB sentPackets first) messageHasDialoguePortion.
	self deny: (self messageInspectorOn: env servicePointA sentPackets second) messageHasDialoguePortion.

]

{ #category : #tests }
TCAPSimulationTest >> shouldNotCreateDialogueOnUnparsableBeginMessage [
	"an incoming bogus begin message should not lead to a dialogue being created"
	| endPoint |
	
	endPoint := TCAPTestServiceEndPoint newForTesting
		asn1Context: self asn1Context.
	
	self assert: endPoint hasInitialState.
	"inject sccp without payload"
	endPoint injectSCCP: #[ 9 0 3 5 7 2 66 6 2 66 7 0 ].
	self assert: endPoint hasInitialState.
	

]

{ #category : #tests }
TCAPSimulationTest >> shouldNotFailOnAbortWithoutReason [
	|  env dialogueA abortMessage |

	abortMessage := (self tcapModule readFrom:  (HexDumpReader readFrom: '67 06 49 04 01 00 09 9a') readStream ) realEntityMessage.
	env := self given: #shouldCreateTestEnvironment.

	env servicePointB onDialogue: [ :dialogue |
		dialogue onBegin: [  dialogue requestTcContinue ]].
	
	dialogueA := env servicePointA newDialogue.
	dialogueA
		onContinue: [
			dialogueA transaction basicAbort: abortMessage ].
	dialogueA
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
	
	self assert: env servicePointA sentPackets size = 2.
	self assert: (self messageInspectorOn: env servicePointB receivedPackets second) isAbort.
	"test if dialogue has been removed on remote end after receiving abort"
	self assert: env servicePointB hasInitialState

]

{ #category : #tests }
TCAPSimulationTest >> shouldReceiveComponentReject [
	| env transaction invocation rejectCalled |
	rejectCalled := false.
	env := self given: #shouldSendAuthenticationInfo.
	transaction := env servicePointA transactionCoordinator newTransaction.
	transaction id: '100000C' byteArrayFromHex.
	transaction switchToState: #active.
	self prepare: transaction dialogue forOperationNamed: 'insertSubscriberDataV2'.
	invocation := transaction dialogue addLocalInvocationWithId: 2.
	invocation onReject: [ :reject | rejectCalled := true ].
"	env servicePointA transactionCoordinator dialogueHandler dialogues anyOne id: -189.
"	self execute: [  	
		env servicePointA transactionCoordinator 
			receive: #[100 16 73 4 1 0 0 12 108 8 164 6 2 1 2 129 1 2]
			from: nil
			to: nil
	].
	"self deny: env servicePointA hasTransactions."
	"we injected a package in servicePointA so servicePointB should still have the initial transaction"
	self assert: env servicePointB dialoguesAndTransactions  size = 1.
	self assert: rejectCalled 
]

{ #category : #tests }
TCAPSimulationTest >> shouldReceiveDialogueEnd [
	| env |
	env := self given: #shouldSendAuthenticationInfo.
	env servicePointA dialoguesAndTransactions anyOne dialogue id: -189.
	self execute: [  	
		env servicePointA injectSCCP: TCAPExamplePackets dialogueEndDtidBFBDBEEF.
	].
	"self deny: env servicePointA hasTransactions."
	"we injected a package in servicePointA so servicePointB should still have the initial transaction"
	self assert: env servicePointB dialoguesAndTransactions  size = 1.
	self assert: env servicePointA sentPackets  size = 1.
	self assert: env servicePointA receivedPackets  size = 1.	

]

{ #category : #tests }
TCAPSimulationTest >> shouldSendAuthenticationInfo [
	|  env |
	env := self newTestEnvironment. 
	env localAddressIs: #HLR.
	env remoteAddressIs: #AUC.
	env connect.
	env servicePointA fakeDialogueId: 'BFBDBEEF' byteArrayFromHex.
	env sendAuthenticationInfoTo: env remoteAddress parameters: '0815'.
	self assert: env servicePointA dialoguesAndTransactions size = 1.
	self assert: env servicePointB dialoguesAndTransactions size = 1.
	self assert: env servicePointA  dialoguesAndTransactions anyOne transaction id hex asUppercase = 'BFBDBEEF'.
	^ env
]

{ #category : #tests }
TCAPSimulationTest >> shouldTransmitUserInformation [
	|  env mapPdu external |
	env := self given: #shouldCreateTestEnvironment.

	mapPdu := (self asn1Model typeNamed: 'MAP-DialoguePDU') newValue beSelfExpanding.
	mapPdu map_open
		destinationReference: '0816';
		originationReference: '0815'.
	external := mapPdu asExternalValue: '0.4.0.0.1.1.1.1'.
		
	env servicePointA newDialogue
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId
		userInformation: { external }.
	
	self assert: (self messageInspectorOn: env servicePointA sentPackets first) isBegin.
	self assert: ((self messageInspectorOn: env servicePointA sentPackets first) findKey: 'map-open') notNil.
	self assert: ((self messageInspectorOn: env servicePointA sentPackets first) findKey: 'originationReference') notNil
]

{ #category : #tests }
TCAPSimulationTest >> shouldTransmitUserInformationWithDynamicValue [
	|  env  userInfo |
	env := self given: #shouldCreateTestEnvironment.

	userInfo := 'MAP-DialoguePDU' asAsn1ValueTypedIn: self asn1Model.
	userInfo beSelfExpanding 
		map_open
			originationReference: '0815';
			destinationReference: '0816'.

	env servicePointA newDialogue
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId
		userInformation: (userInfo asExternalValue: '0.4.0.0.1.1.1.1' ).
					
	
	self assert: (self messageInspectorOn: env servicePointA sentPackets first) isBegin.
	self assert: ((self messageInspectorOn: env servicePointA sentPackets first) findKey: 'map-open') notNil.
	self assert: ((self messageInspectorOn: env servicePointA sentPackets first) findKey: 'originationReference') notNil
]

{ #category : #tests }
TCAPSimulationTest >> testCleanupRequestTcEndInActiveState [
	|  env  localDialogue |
	env := self newTestEnvironment. 
	env localAddressIs: #HLR.
	env remoteAddressIs: #AUC.
	env connect.

	"The arguments are only decoded when invoke argument is called"
	env servicePointB onDialogue: [ :dialogue |
		dialogue onBegin: [
			dialogue requestTcContinue ]].	
	
	localDialogue := env servicePointA newDialogue.
	localDialogue onContinue: [ 
		self assert: localDialogue state class = TCAPActiveDialogueState.
		localDialogue requestTcEnd: true ] .
	localDialogue
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
	

	"Check that nothing has been sent."
	self assert: env servicePointA hasInitialState 
]

{ #category : #tests }
TCAPSimulationTest >> testCleanupRequestTcEndInInitReceivedState [
	|  env  localDialogue |
	env := self newTestEnvironment. 
	env localAddressIs: #HLR.
	env remoteAddressIs: #AUC.
	env connect.

	"The arguments are only decoded when invoke argument is called"
	env servicePointB onDialogue: [ :dialogue |
		dialogue onBegin: [
			self assert: dialogue state class = TCAPInitiationReceivedDialogueState.
			dialogue requestTcEnd: true ]].	
	
	localDialogue := env servicePointA newDialogue.
	localDialogue
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
	

	"Check that nothing has been sent."
	self assert: env servicePointB hasInitialState 
]

{ #category : #tests }
TCAPSimulationTest >> testCleanupRequestTcEndInInitSendState [
	|  env  localDialogue |
	env := self newTestEnvironment. 
	env localAddressIs: #HLR.
	env remoteAddressIs: #AUC.
	env connect.

	localDialogue := env servicePointA newDialogue.
	localDialogue
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
	self assert: localDialogue state class = TCAPInitiationSentDialogueState.
	localDialogue requestTcEnd: true.

	"Check that nothing has been sent."
	self assert: env servicePointA hasInitialState 
]
