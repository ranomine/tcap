Class {
	#name : #Q787ValidationTodo,
	#superclass : #Q787ValidationTest,
	#category : #'Q787-TestSpec'
}

{ #category : #'as yet unclassified' }
Q787ValidationTodo class >> isAbstract [ 
	^ true
]

{ #category : #'tests - inBackLog' }
Q787ValidationTodo >> test1_1_2_5_1 [
	"TC addressing; Register address change page 49"
	self assert: false.
	self flag: #TBD.	
	"CHECK A: WAS THE CALLED ADDRESS IN THE SCCP MESSAGE HEADER FOR THE END THE SAME AS THE 
	                 CALLING ADDRESS IN THE SCCP MESSAGE HEADER FOR THE CONTINUE MESSAGE? "
	
	"Notes:
	
	service end point has #injectSCCP:
		--> need to generate UDT package for adress change."
]

{ #category : #'tests - inBackLog' }
Q787ValidationTodo >> test1_1_3_1_1_1s1 [
	"Encoding Variation Test: CP length encoding. Page 50"
	| env  endCalled  |
	env := self given: #shouldCreateTestEnvironment.
	env servicePointA onDialogue: [ :dialogue|
		dialogue 
			onBegin: [ 
				dialogue requestTcEnd: false ]].

	env servicePointB newDialogue
			onEnd: [ :end |
			endCalled := true];
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
	
	self flag: #TBD.
		
	" CHECK A: WAS THE BEGIN MESSAGE CORRECTLY RECEIVED AT SP A AND PASSED TO THE TR-USER? "
	" CHECK B: WAS AN END MESSAGE CORRECTLY SENT BY SP A? "
	" CHECK C: WAS THE DTID IN THE END MESSAGE THE SAME AS THE OTID IN THE BEGIN MESSAGE? "
	" CHECK D: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?"
]

{ #category : #'tests - inBackLog' }
Q787ValidationTodo >> test1_1_3_1_1_1s2 [
	"Encoding Variation Test: CP length encoding. Page 52"
	self assert: false.
	self flag: #TBD.
	
	" CHECK A: WAS THE BEGIN MESSAGE CORRECTLY RECEIVED AT SP A AND PASSED TO THE TR-USER?"
	" CHECK B: WAS AN END MESSAGE CORRECTLY SENT BY SP A? "
	" CHECK C: WAS THE DTID IN THE END MESSAGE THE SAME AS THE OTID IN THE BE GIN MESSAGE? "
	" CHECK D: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?"
]

{ #category : #'tests - inBackLog' }
Q787ValidationTodo >> test1_1_3_1_1_2s1 [
	"Encoding Variation Test: CP length encoding. Page 54"
	self assert: false.
	self flag: #TBD.
	
	"CHECK A: WAS THE BEGIN MESSAGE CORRECTLY RECEIVED AT SP A AND PASSED TO THE TR-USER? "
	"CHECK B: WAS AN END MESSAGE CORRECTLY SENT BY SP A? "
	"CHECK C: WAS THE DTID IN THE END MESSAGE THE SAME AS THE OTID IN THE BEGIN MESSAGE? "
	"CHECK D: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?"
]

{ #category : #'tests - inBackLog' }
Q787ValidationTodo >> test1_1_3_1_1_3s1 [
	"Encoding Variation Test: CP length encoding. Page 56"
	self assert: false.
	self flag: #TBD.
	
	"CHECK A: WAS THE BEGIN MESSAGE CORRECTLY RECEIVED AT SP A AND PASSED TO THE TR-USER? "
	"CHECK B: WAS AN END MESSAGE CORRECTLY SENT BY SP A? "
	"CHECK C: WAS THE DTID IN THE END MESSAGE THE SAME AS THE OTID IN THE BEGIN MESSAGE? "
	"CHECK D: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?"
]

{ #category : #'tests - inBackLog' }
Q787ValidationTodo >> test1_2_2_1s1 [
	"Unidirectional Message Type: Unknown information element present. Page 73"
	self assert: false.
	self flag: #TBD.	
	
	" CHECK A: VERIFY THAT THE TR-USER WAS NOT INFORMED OF THE UNID IRECTIONAL MESSAGE AT SP A. "
	" CHECK B: VERIFY THAT NO MESSAGES WERE GENERATED IN RESPONSE TO THE UNIDIRECTIONAL MESSAGE. "
	" CHECK C: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A? "

		
	
		

]

{ #category : #'tests - inBackLog' }
Q787ValidationTodo >> test2_1_4_1_2 [
	"Invoke linked components. Page 174. Like test2_1_2_1_1 but with linked invoke uses operation code not linked "
	
	| env dialogue invocation called invokeBcalled invokeAcalled begin componentPortion invokeComponent invokeID opcode parameter continue linkeID invokeIDtoCheck sequence opcodeReturn |
	
	self flag: #TBD. "We need to detec the wrong operation code and reject"
	
	env := self given: #shouldCreateTestEnvironment.
	env servicePointB
		onDialogue: [ :dialog |
			 dialog 
				onInvoke: [ : inv |  | linkedInvoke |
					invokeBcalled := true.
					linkedInvoke := dialog requestTcInvokeNamed: 'sendAuthenticationInfoV2' parameters:  '123456789' class: TCAPReportSuccessAndFailure timeout: 500 linkedTo: inv.
					linkedInvoke  onReturnLast: [ :res |   	
												inv returnResultLastUsing: [ :result | result add: self exampleResult ].
												dialog requestTcContinue ].
					dialog requestTcContinue ]].
			
	dialogue := env servicePointA newDialogue.
	dialogue 
		onInvoke: [ : inv | 
			invokeAcalled := true.
			inv returnResultLastUsing: [ :result | result add: self exampleResult ].
			dialogue requestTcContinue ].
	
	invocation := dialogue requestTcInvokeNamed: 'sendAuthenticationInfoV2' parameters:  '123456789' class: TCAPReportSuccessAndFailure timeout: 500.
	invocation onReturnLast: [ :result |  called := true ].
	
		
	dialogue 
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: '0.4.0.0.1.0.14.2'.
		
	self assert: invokeBcalled = true.
	self assert: invokeAcalled = true.
	
	"CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? "
	
	self assert: env servicePointA didSendMessage.
	begin := self checkBegin: env servicePointA sentPackets first.
	
	componentPortion := begin encodedValue elements third.
	self assert: componentPortion tagByteValue =2r01101100.
	invokeComponent :=  componentPortion elements first.
	self assert:  invokeComponent tagByteValue = 2r10100001.
 	invokeID := invokeComponent elements first.
	self assert: invokeID tagByteValue = 2r00000010.
	self assert: invokeID contents byteSize = 1.
	invokeIDtoCheck := invokeID contents.
	
	opcode := invokeComponent elements second.
	self assert: opcode tagByteValue = 2r00000010.
	self assert: opcode contents asInteger  =  56. "in this case it is 56"
	self assert: opcode contents byteSize = 1.
	parameter := invokeComponent elements third.
	self assert: parameter contents asString = '123456789'.
	
	"CHECK B: WAS A LINKED INVOKE COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? "
	
	continue := self checkContinue: env servicePointA receivedPackets first.
	
	componentPortion := continue encodedValue elements fourth.
	self assert: componentPortion tagByteValue =2r01101100.
	invokeComponent :=  componentPortion elements first.
	self assert:  invokeComponent tagByteValue = 2r10100001.
 	invokeID := invokeComponent elements first.
	self assert: invokeID tagByteValue = 2r00000010.
	self assert: invokeID contents byteSize = 1.
	
	linkeID :=  invokeComponent elements second.
	self assert: linkeID tagByteValue = 2r10000000.
	self assert: linkeID contents byteSize = 1.
	self assert: linkeID contents asInteger  =  1. 
	
	opcode := invokeComponent elements third.
	self assert: opcode tagByteValue = 2r00000010.
	self assert: opcode contents asInteger  =  56. "in this case it is 56"
	self assert: opcode contents byteSize = 1.
	parameter := invokeComponent elements fourth.
	self assert: parameter contents asString = '123456789'.
	
	
	"CHECK C: WAS THE RETURN RESULT-LAST COMPONENT WITH CORRECT INFORMATION SENT BY SP A? "
	continue := self checkContinue: env servicePointA sentPackets second.
	componentPortion := continue encodedValue elements last.
	self assert: componentPortion tagByteValue =2r01101100.
	invokeComponent :=  componentPortion elements first.
	invokeID := invokeComponent elements first.
	self assert: invokeID tagByteValue = 2r00000010.
	self assert: invokeID contents byteSize = 1.
	sequence := invokeComponent elements second.
	self assert: sequence tagByteValue = 2r110000.

	opcodeReturn := (continue message find: 'opcode') encodeToByteArray.
	self assert: opcodeReturn first = 2r00000010.
	self assert: opcodeReturn second = 1.
	self assert: opcodeReturn third = 56.
	
	"CHECK D: WAS THE INVOKE ID IN THE RETURN RESULT-LAST COMPONENT THE SAME AS THE ONE IN THE INVOKE COMPONENT SENT BY SP B ? "
	self assert: invokeIDtoCheck =  linkeID contents.
	
	"CHECK E: WAS THE OPERATION CODE IN THE RETURN RESULT-LAST COMPONENT SENT BY SP A THE SAME AS THE ONE IN THE INVOKE COMPONENT SENT BY SP B ? "
	self assert: opcodeReturn third = opcode contents asInteger.
	
	"CHECK F: WAS THE RETURN RESULT-LAST COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? "
	
	self assert: called == true.
	
	self assert: env servicePointA receivedPackets size = 2.
	continue := self checkContinue: env servicePointA receivedPackets last.
	componentPortion := continue encodedValue elements last.
	self assert: componentPortion tagByteValue =2r01101100.
	invokeComponent :=  componentPortion elements first.
	invokeID := invokeComponent elements first.
	self assert: invokeID tagByteValue = 2r00000010.
	self assert: invokeID contents byteSize = 1.
	sequence := invokeComponent elements second.
	self assert: sequence tagByteValue = 2r110000.

	opcodeReturn := (continue message find: 'opcode') encodeToByteArray.
	self assert: opcodeReturn first = 2r00000010.
	self assert: opcodeReturn second = 1.
	self assert: opcodeReturn third = 56.
	
	"CHECK G: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?"
	env servicePointA isIdle. "when it is idle there are no invocations, either"

	
	
	"CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? "
	"CHECK B: WAS A LINKED INVOKE COMPONENT PASSED TO THE TC-USER BY SP A? "
	"CHECK C: WAS THE REJECT COMPONENT WITH CORRECT INFORMATION SENT BY SP A? "
	"CHECK D: WAS THE INVOKE ID IN THE REJECT COMPONENT THE SAME AS THE INVOKE ID IN THE INVOKE COMPONENT SENT BY SP B? "
	"CHECK E: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?"
]

{ #category : #'tests - inBackLog' }
Q787ValidationTodo >> test2_1_4_1_3 [
	"Invoke linked components. Page 177.  Like test2_1_2_1_1 but with linked invoke contains one parameter not associated with the outcome of the operation (as in 2.1.4.1.4"
	
	| env dialogue invocation called invokeBcalled invokeAcalled begin componentPortion invokeComponent invokeID opcode parameter continue linkeID invokeIDtoCheck sequence opcodeReturn |
	
	self flag: #TBD. "We need to detec the wrong parameter and reject"
	
	env := self given: #shouldCreateTestEnvironment.
	env servicePointB
		onDialogue: [ :dialog |
			 dialog 
				onInvoke: [ : inv |  | linkedInvoke |
					invokeBcalled := true.
					linkedInvoke := dialog requestTcInvokeNamed: 'sendAuthenticationInfoV2' parameters:  '123456789' class: TCAPReportSuccessAndFailure timeout: 500 linkedTo: inv.
					linkedInvoke  onReturnLast: [ :res |   	
												inv returnResultLastUsing: [ :result | result add: self exampleResult ].
												dialog requestTcContinue ].
					dialog requestTcContinue ]].
			
	dialogue := env servicePointA newDialogue.
	dialogue 
		onInvoke: [ : inv | 
			invokeAcalled := true.
			inv returnResultLastUsing: [ :result | result add: self exampleResult ].
			dialogue requestTcContinue ].
	
	invocation := dialogue requestTcInvokeNamed: 'sendAuthenticationInfoV2' parameters:  '123456789' class: TCAPReportSuccessAndFailure timeout: 500.
	invocation onReturnLast: [ :result |  called := true ].
	
		
	dialogue 
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: '0.4.0.0.1.0.14.2'.
		
	self assert: invokeBcalled = true.
	self assert: invokeAcalled = true.
	
	"CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? "
	
	self assert: env servicePointA didSendMessage.
	begin := self checkBegin: env servicePointA sentPackets first.
	
	componentPortion := begin encodedValue elements third.
	self assert: componentPortion tagByteValue =2r01101100.
	invokeComponent :=  componentPortion elements first.
	self assert:  invokeComponent tagByteValue = 2r10100001.
 	invokeID := invokeComponent elements first.
	self assert: invokeID tagByteValue = 2r00000010.
	self assert: invokeID contents byteSize = 1.
	invokeIDtoCheck := invokeID contents.
	
	opcode := invokeComponent elements second.
	self assert: opcode tagByteValue = 2r00000010.
	self assert: opcode contents asInteger  =  56. "in this case it is 56"
	self assert: opcode contents byteSize = 1.
	parameter := invokeComponent elements third.
	self assert: parameter contents asString = '123456789'.
	
	"CHECK B: WAS A LINKED INVOKE COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? "
	
	continue := self checkContinue: env servicePointA receivedPackets first.
	
	componentPortion := continue encodedValue elements fourth.
	self assert: componentPortion tagByteValue =2r01101100.
	invokeComponent :=  componentPortion elements first.
	self assert:  invokeComponent tagByteValue = 2r10100001.
 	invokeID := invokeComponent elements first.
	self assert: invokeID tagByteValue = 2r00000010.
	self assert: invokeID contents byteSize = 1.
	
	linkeID :=  invokeComponent elements second.
	self assert: linkeID tagByteValue = 2r10000000.
	self assert: linkeID contents byteSize = 1.
	self assert: linkeID contents asInteger  =  1. 
	
	opcode := invokeComponent elements third.
	self assert: opcode tagByteValue = 2r00000010.
	self assert: opcode contents asInteger  =  56. "in this case it is 56"
	self assert: opcode contents byteSize = 1.
	parameter := invokeComponent elements fourth.
	self assert: parameter contents asString = '123456789'.
	
	
	"CHECK C: WAS THE RETURN RESULT-LAST COMPONENT WITH CORRECT INFORMATION SENT BY SP A? "
	continue := self checkContinue: env servicePointA sentPackets second.
	componentPortion := continue encodedValue elements last.
	self assert: componentPortion tagByteValue =2r01101100.
	invokeComponent :=  componentPortion elements first.
	invokeID := invokeComponent elements first.
	self assert: invokeID tagByteValue = 2r00000010.
	self assert: invokeID contents byteSize = 1.
	sequence := invokeComponent elements second.
	self assert: sequence tagByteValue = 2r110000.

	opcodeReturn := (continue message find: 'opcode') encodeToByteArray.
	self assert: opcodeReturn first = 2r00000010.
	self assert: opcodeReturn second = 1.
	self assert: opcodeReturn third = 56.
	
	"CHECK D: WAS THE INVOKE ID IN THE RETURN RESULT-LAST COMPONENT THE SAME AS THE ONE IN THE INVOKE COMPONENT SENT BY SP B ? "
	self assert: invokeIDtoCheck =  linkeID contents.
	
	"CHECK E: WAS THE OPERATION CODE IN THE RETURN RESULT-LAST COMPONENT SENT BY SP A THE SAME AS THE ONE IN THE INVOKE COMPONENT SENT BY SP B ? "
	self assert: opcodeReturn third = opcode contents asInteger.
	
	"CHECK F: WAS THE RETURN RESULT-LAST COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? "
	
	self assert: called == true.
	
	self assert: env servicePointA receivedPackets size = 2.
	continue := self checkContinue: env servicePointA receivedPackets last.
	componentPortion := continue encodedValue elements last.
	self assert: componentPortion tagByteValue =2r01101100.
	invokeComponent :=  componentPortion elements first.
	invokeID := invokeComponent elements first.
	self assert: invokeID tagByteValue = 2r00000010.
	self assert: invokeID contents byteSize = 1.
	sequence := invokeComponent elements second.
	self assert: sequence tagByteValue = 2r110000.

	opcodeReturn := (continue message find: 'opcode') encodeToByteArray.
	self assert: opcodeReturn first = 2r00000010.
	self assert: opcodeReturn second = 1.
	self assert: opcodeReturn third = 56.
	
	"CHECK G: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?"
	env servicePointA isIdle. "when it is idle there are no invocations, either"

	
	
	"CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? "
	"CHECK B: WAS A LINKED INVOKE COMPONENT PASSED TO THE TC-USER BY SP A? "
	"CHECK C: WAS THE REJECT COMPONENT WITH CORRECT INFORMATION SENT BY SP A? "
	"CHECK D: WAS THE INVOKE ID IN THE REJECT COMPONENT THE SAME AS THE INVOKE ID IN THE INVOKE COMPONENT SENT BY SP B? "
	"CHECK E: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?"
	
	
	
	
	"CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? "
	"CHECK B: WAS A LINKED INVOKE COMPONENT PASSED TO THE TC-USER BY SP A? "
	"CHECK C: WAS THE REJECT COMPONENT SENT BY SP A? "
	"CHECK D: WAS THE RETURN RESULT-LAST COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? "
	"CHECK E: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?"
]

{ #category : #'tests - inBackLog' }
Q787ValidationTodo >> test2_1_7_1 [
	"To verify that a component portion with a definite short form can be accepted. PP 198"
		self assert: false.
	self flag: #TBD.
	
	"CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? "
	"CHECK B: WAS THE RETURN RESULT-LAST COMPONENT WITH CORRECT INFORMATION SENT BY SP A?"
]

{ #category : #'tests - inBackLog' }
Q787ValidationTodo >> test2_1_7_2 [
	"To verify that a component portion with a definite long form can be accepted. PP 200"
		self assert: false.
	self flag: #TBD.
	
	"CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? "
	"CHECK B: WAS THE RETURN RESULT-LAST COMPONENT WITH CORRECT INFORMATION SENT BY SP A?"
]

{ #category : #'tests - inBackLog' }
Q787ValidationTodo >> test2_1_7_3 [
	"To verify that a component portion with a indefinite form can be accepted. PP 202"
		self assert: false.
	self flag: #TBD.
	
	"CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? "
	"CHECK B: WAS THE RETURN RESULT-LAST COMPONENT WITH CORRECT INFORMATION SENT BY SP A?"
]

{ #category : #tests }
Q787ValidationTodo >> test2_1_8_3 [
		self assert: false
]

{ #category : #tests }
Q787ValidationTodo >> test2_1_9_5_3 [
		self assert: false
]

{ #category : #tests }
Q787ValidationTodo >> test2_1_9_7_3 [
		self assert: false
]

{ #category : #tests }
Q787ValidationTodo >> test2_1_9_7_4 [
		self assert: false
]

{ #category : #tests }
Q787ValidationTodo >> test2_2_1_2 [
		self assert: false
]

{ #category : #tests }
Q787ValidationTodo >> test2_2_2_1_1 [
		self assert: false
]

{ #category : #tests }
Q787ValidationTodo >> test2_2_2_1_2 [
		self assert: false
]

{ #category : #tests }
Q787ValidationTodo >> test2_2_2_2_1 [
		self assert: false
]

{ #category : #tests }
Q787ValidationTodo >> test2_2_2_2_2 [
		self assert: false
]

{ #category : #tests }
Q787ValidationTodo >> test2_2_2_2_3 [
		self assert: false
]

{ #category : #tests }
Q787ValidationTodo >> test2_2_2_3_1 [
		self assert: false
]

{ #category : #tests }
Q787ValidationTodo >> test2_2_2_3_2 [
		self assert: false
]

{ #category : #tests }
Q787ValidationTodo >> test2_2_2_4_1 [
		self assert: false
]

{ #category : #tests }
Q787ValidationTodo >> test2_2_2_4_2 [
		self assert: false
]

{ #category : #tests }
Q787ValidationTodo >> test2_2_2_5_1 [
		self assert: false
]

{ #category : #tests }
Q787ValidationTodo >> test2_2_2_5_3 [
		self assert: false
]

{ #category : #tests }
Q787ValidationTodo >> test2_2_2_5_4 [
		self assert: false
]

{ #category : #tests }
Q787ValidationTodo >> test2_2_2_5_5 [
		self assert: false
]

{ #category : #tests }
Q787ValidationTodo >> test2_2_2_5_6 [
		self assert: false
]

{ #category : #tests }
Q787ValidationTodo >> test2_2_2_5_7 [
		self assert: false
]

{ #category : #tests }
Q787ValidationTodo >> test2_2_2_5_8 [
		self assert: false
]

{ #category : #tests }
Q787ValidationTodo >> test2_2_3_1 [
		self assert: false
]

{ #category : #tests }
Q787ValidationTodo >> test2_2_3_2 [
		self assert: false
]

{ #category : #tests }
Q787ValidationTodo >> test2_2_3_3 [
		self assert: false
]

{ #category : #tests }
Q787ValidationTodo >> test2_3_1_1 [
		self assert: false
]

{ #category : #tests }
Q787ValidationTodo >> test2_3_2_1 [
		self assert: false
]

{ #category : #tests }
Q787ValidationTodo >> test2_3_2_2 [
		self assert: false
]

{ #category : #tests }
Q787ValidationTodo >> test2_3_2_3 [
		self assert: false
]

{ #category : #tests }
Q787ValidationTodo >> test2_3_2_4 [
		self assert: false
]

{ #category : #tests }
Q787ValidationTodo >> test2_3_3_1 [
		self assert: false
]

{ #category : #tests }
Q787ValidationTodo >> test2_3_3_2 [
		self assert: false
]

{ #category : #tests }
Q787ValidationTodo >> test2_3_3_3 [
		self assert: false
]

{ #category : #tests }
Q787ValidationTodo >> test2_3_3_4 [
		self assert: false
]

{ #category : #tests }
Q787ValidationTodo >> test2_3_3_5 [
		self assert: false
]

{ #category : #tests }
Q787ValidationTodo >> test2_3_3_6 [
		self assert: false
]

{ #category : #tests }
Q787ValidationTodo >> test2_3_4_4 [
		self assert: false
]
