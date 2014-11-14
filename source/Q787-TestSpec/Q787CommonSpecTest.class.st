Class {
	#name : #Q787CommonSpecTest,
	#superclass : #TCAPTestCase,
	#category : #'Q787-TestSpec'
}

{ #category : #'as yet unclassified' }
Q787CommonSpecTest class >> isAbstract [
	^ true
]

{ #category : #'as yet unclassified' }
Q787CommonSpecTest >> asn1Model [
	^ TestTCAP model
]

{ #category : #'as yet unclassified' }
Q787CommonSpecTest >> checkAbort: aByteArray [ 
	| abort |
	abort := self messageInspectorOn: aByteArray.
	self assert: abort isAbort.

	"message tag"
	self assert: abort taggedValue tagByteValue = 2r01100111.
	
	"otid tag"
	self assert: (abort findTaggedValue: 'dtid') tagByteValue = 2r01001001.
	self assert: (abort message abort dtid size between: 1 and: 8).
	
	^ abort
]

{ #category : #'as yet unclassified' }
Q787CommonSpecTest >> checkBegin: aByteArray [ 
	| begin |
	begin := self messageInspectorOn: aByteArray.
	self assert: begin isBegin.

	"message tag"
	self assert: begin taggedValue tagByteValue = 2r01100010.

	"otid tag"
	self assert: (begin findTaggedValue: 'otid') tagByteValue = 2r01001000.
	self assert: ((begin findKey: 'otid') size between: 1 and: 8).
	
	"component portion tag"
	"self assert: taggedValue contents second tagByteValue = 2r01101100. "
	
	^ begin
]

{ #category : #'as yet unclassified' }
Q787CommonSpecTest >> checkContinue: aByteArray [ 
	| continue |
	continue := self messageInspectorOn: aByteArray.
	self assert: continue isContinue.

	"message tag"
	self assert: continue taggedValue tagByteValue = 2r01100101.
	
	"otid tag"
	self assert: (continue findTaggedValue: 'otid') tagByteValue = 2r01001000.
	self assert: (continue message continue otid size between: 1 and: 8).

	"dtid tag"
	self assert: (continue findTaggedValue: 'dtid') tagByteValue = 2r01001001.
	self assert: (continue message continue dtid size between: 1 and: 8).
	
	^ continue
]

{ #category : #'as yet unclassified' }
Q787CommonSpecTest >> checkEnd: aByteArray [ 
	| end |
	end := self messageInspectorOn: aByteArray.
	self assert: end isEnd.

	"message tag"
	self assert: end taggedValue tagByteValue = 2r01100100.

	"otid tag"
	self assert: (end findTaggedValue: 'dtid') tagByteValue = 2r01001001.
	self assert: ((end findKey: 'dtid') size between: 1 and: 8).
	
	"component portion tag"
	"self assert: taggedValue contents second tagByteValue = 2r01101100. "
	
	^ end
]

{ #category : #'as yet unclassified' }
Q787CommonSpecTest >> checkPAbort: aByteArray [ 
	| abort |
	abort := self checkAbort: aByteArray.
	
	self assert: (abort findTaggedValue: 'p-abortCause') tagByteValue = 2r01001010.
	
	^ abort
]

{ #category : #'as yet unclassified' }
Q787CommonSpecTest >> checkUAbort: aByteArray [ 
	| abort |
	abort := self checkAbort: aByteArray.
	
	self assert: (abort findTaggedValue: 'u-abortCause') tagByteValue = 2r01101011.
	
	^ abort
]

{ #category : #'as yet unclassified' }
Q787CommonSpecTest >> createDialogueResponse [
	^ { 
		'dialoguePortion' -> {  
			'dialogueResponse' -> { 
				'protocol-version' -> '1'.
				'application-context-name' -> '0.8.15'.
				'result' -> 1.
				'result-source-diagnostic' -> { 'dialogue-service-user' -> 1 } asAsn1Dictionary 
			} asAsn1Dictionary.  
			'oid' -> (self asn1Model bindingNamed:'dialogue-as-id') value value 
		} asAsn1Dictionary  
	} asAsn1Dictionary 
]

{ #category : #'as yet unclassified' }
Q787CommonSpecTest >> exampleResult [
	^ ASN1Array new
		add: (ASN1Dictionary new
			at: 'rand' put: (ByteArray readHexFrom: 'DEADBEEF');
			at: 'sres' put: (ByteArray readHexFrom: 'DEADBEEF');
			at: 'kc' put: (ByteArray readHexFrom: 'DEADBEEF');
		yourself);
	yourself
]

{ #category : #'as yet unclassified' }
Q787CommonSpecTest >> readTcapFrom: aByteArray [
	^ self asn1Model 
		readFrom: aByteArray readStream 
		usingModuleNamed: 'TCAPMessages'
]

{ #category : #'as yet unclassified' }
Q787CommonSpecTest >> sendTrBegin: aTestEnvironment userData: aDictionary [ 
	^ aTestEnvironment servicePointA transactionCoordinator 
		requestTrBegin: aTestEnvironment servicePointA dialogueHandler newDialogue transaction
		destinationAddress: (aTestEnvironment remoteAddressIs: #HLR)
		originatingAddress:  (aTestEnvironment  localAddressIs: #AUC)
		userData: aDictionary  
]

{ #category : #spec }
Q787CommonSpecTest >> spec1_1_1_1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.1.1.1 REFERENCE: 3.3.3.1.1/Q.774 TITLE: Valid function; Unstructured dialogue SUBTITLE: Tested side sending PURPOSE:

Sheet: 1 of 1

To verify that signalling point A is able to correctly send a Unidirectional message SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (TSL) TR-UNI req. ============> UNIDIRECTIONAL  SP B (TSL)

TEST DESCRIPTION 1. 2. 3. Send a Unidirectional message from SP A to SP B. CHECK A: WAS THE UNIDIRECTIONAL MESSAGE CORRECTLY SENT FROM SP A? CHECK B: WAS THE TSL STATE MACHINE ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES UNIDIRECTIONAL Message type tag: 01100001 Message type length: correct number of octets Component portion tag: 01101100 Component portion length: correct number of octets

6

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec1_1_1_2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.1.1.2 REFERENCE: 3.3.3.1.2/Q.774 TITLE: Valid function; Unstructured dialogue SUBTITLE: Tested side receiving PURPOSE:

Sheet: 1 of 1

To verify that signalling point A is able to correctly receive a Unidirectional message SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (TSL)  TR-UNI ind. <============ SP B (TSL)

UNIDIRECTIONAL

TEST DESCRIPTION 1. 2. 3. Send a Unidirectional message from SP B to SP A. CHECK A: WAS THE UNIDIRECTIONAL MESSAGE CORRECTLY RECEIVED AT SP A? CHECK B: WAS THE TSL STATE MACHINE ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES UNIDIRECTIONAL Message type tag: 01100001 Message type length: correct number of octets Component portion tag: 01101100 Component portion length: correct number of octets

Recommendation Q.787 (09/97)

7

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec1_1_2_1_1s1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.1.2.1.1 1) REFERENCE: 3.3.3.2.1/Q.774 and 3.3.3.2.3/Q.774 TITLE: Valid function; Structured dialogue

Sheet: 1 of 1

SUBTITLE: Clearing before subsequent Message; Valid clearing from initiating side; Prearranged ending PURPOSE: To verify that signalling point A is able to correctly send a Begin message and then terminate the transaction locally by the "prearranged end" method SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (TSL) TR-BEGIN req. ============> BEGIN TR-END req. ============> (Prearranged) TEST DESCRIPTION 1. 2. 3. 4. 5. Send a Begin message from SP A to SP B. Before a reply is received from SP B, arrange for a TR-END request primitive (prearranged) to be passed to the TSL at SP A. CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? CHECK B: VERIFY THAT AN END MESSAGE WAS NOT SENT BY SP A. CHECK C: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?  SP B (TSL)

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets

8

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec1_1_2_1_1s2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.1.2.1.1 2) REFERENCE: 3.3.3.2.1/Q.774 and 3.3.3.2.4/Q.774 TITLE: Valid function; Structured dialogue

Sheet: 1 of 1

SUBTITLE: Clearing before subsequent Message; Valid clearing from initiating side; Abort by the TR-User PURPOSE: To verify that signalling point A is able to correctly generate a Begin message and then terminate the transaction locally by the "abort" method SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (TSL) TR-BEGIN req. ============> BEGIN TR-U-ABORT req. ============> TEST DESCRIPTION 1. 2. 3. 4. 5. 6. Send a Begin message from SP A to SP B. Before a reply is received from SP B, arrange for a TR-U-ABORT request primitive to be passed to the TSL at SP A. CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? CHECK B: WAS THE TR-U-ABORT REQUEST PURELY LOCAL AT SP A? CHECK C: VERIFY THAT NO ABORT MESSAGE WAS SENT FROM SP A. CHECK D: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?  SP B (TSL)

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets

Recommendation Q.787 (09/97)

9

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec1_1_2_1_2_1s1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.1.2.1.2.1 1) REFERENCE: 3.3.3.2.1/Q.774 and 3.3.3.2.3/Q.774 TITLE: Valid function; Structured dialogue

Sheet: 1 of 2

SUBTITLE: Clearing before subsequent Message; Valid clearing from responding side; IUT Sending; Basic ending PURPOSE: To verify that signalling point A is able to receive a Begin message and then terminate the transaction by the "basic end" method SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (TSL)  TR-BEGIN ind. <============ TR-END req. ============> (Basic) END  SP B (TSL) BEGIN

TEST DESCRIPTION 1. 2. 3. 4. 5. 6. Send a Begin message from SP B to SP A. On receipt of BEGIN indication arrange for a TR-END request primitive (basic) to be passed to the TSL at SP A. CHECK A: WAS THE BEGIN MESSAGE CORRECTLY RECEIVED AT SP A AND PASSED TO THE TR-USER? CHECK B: WAS AN END MESSAGE CORRECTLY SENT BY SP A? CHECK C: WAS THE DTID IN THE END MESSAGE THE SAME AS THE OTID IN THE BEGIN MESSAGE? CHECK C: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?

10

Recommendation Q.787 (09/97)

TEST NUMBER: 1.1.2.1.2.1 1) CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets END Message type tag: 01100100 Message type length: correct number of octets Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets

Sheet: 2 of 2

Recommendation Q.787 (09/97)

11

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec1_1_2_1_2_1s2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.1.2.1.2.1 2) REFERENCE: 3.3.3.2.1/Q.774 and 3.3.3.2.3/Q.774 TITLE: Valid function; Structured dialogue

Sheet: 1 of 1

SUBTITLE: Clearing before subsequent Message; Valid clearing from responding side; IUT sending; Prearranged ending PURPOSE: To verify that the signalling point A is able to receive a Begin message and then terminate the transaction by the "prearranged end" method SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (TSL)  TR-BEGIN ind. <============ TR-END req. ============> (Prearranged) TEST DESCRIPTION 1. 2. 3. 4. 5. Send a Begin message from SP B to SP A. On receipt of the BEGIN indication arrange for a TR-END request primitive (prearranged) to be passed to the TSL at SP A. CHECK A: WAS THE BEGIN MESSAGE CORRECTLY RECEIVED AT SP A? CHECK B: VERIFY THAT AN END MESSAGE WAS NOT SENT BY SP A. CHECK C: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A? SP B (TSL)

BEGIN

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets

12

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec1_1_2_1_2_1s3 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.1.2.1.2.1 3) REFERENCE: 3.3.3.2.1/Q.774 and 3.3.3.2.4/Q.774 TITLE: Valid function; Structured dialogue

Sheet: 1 of 1

SUBTITLE: Clearing before subsequent Message; Valid clearing from responding side; IUT sending; Abort by the TR-User PURPOSE: To verify that the signalling point A is able to receive a Begin message and then terminate the transaction by the "abort" method SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (TSL)  TR-BEGIN ind. <============ TR-U-ABORT req. ============> ABORT (U) TEST DESCRIPTION 1. 2. 3. 4. 5. 6. Send a Begin message from SP B to SP A. On receipt of the BEGIN indication arrange for a TR-U-ABORT request primitive to be passed to the TSL at SP A. CHECK A: WAS THE BEGIN MESSAGE CORRECTLY RECEIVED AT SP A? CHECK B: WAS AN ABORT MESSAGE CORRECTLY SENT BY SP A? CHECK C: WAS THE DTID IN THE ABORT MESSAGE THE SAME AS THE OTID IN THE BE GIN MESSAGE? CHECK D: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?  SP B (TSL) BEGIN

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets ABORT (U) Message type tag: 01100111 Message type length: correct number of octets Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) User abort information tag: 01101011 User abort information length: correct number of octets

Recommendation Q.787 (09/97)

13

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec1_1_2_1_2_2s1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.1.2.1.2.2 1) REFERENCE: 3.3.3.2.1/Q.774 and 3.3.3.2.4/Q.774 TITLE: Valid function; Structured dialogue

Sheet: 1 of 1

SUBTITLE: Clearing before subsequent Message; Valid clearing from responding side; IUT receiving; Abort by the TR-User PURPOSE: To verify that the signalling point A is able to terminate a transaction on reception of an Abort (U) message SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (TSL) TR-BEGIN req. ============> BEGIN   TR-U-ABORT ind. <============ TEST DESCRIPTION 1. 2. 3. 4. 5. Send a Begin message from SP A to SP B. Arrange for SP B to send an U-Abort message to SP A. CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? CHECK B: WAS THE ABORT MESSAGE CORRECTLY RECEIVED AT SP A? CHECK C: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A? ABORT (U) SP B (TSL)

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets ABORT (U) Message type tag: 01100111 Message type length: correct number of octets Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) User abort information tag: 01101011 User abort information length: correct number of octets

14

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec1_1_2_1_2_2s3 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.1.2.1.2.2 3) REFERENCE: 3.3.3.2.1/Q.774 and 3.3.3.2.3/Q.774 TITLE: Valid function; Structured dialogue

Sheet: 1 of 1

SUBTITLE: Clearing before subsequent Message; Valid clearing from responding side; IUT receiving; Basic ending PURPOSE: To verify that the signalling point A is able to terminate a transaction on reception of an END message SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (TSL) TR-BEGIN req. ============> BEGIN   TR-END ind. <============ TEST DESCRIPTION 1. 2. 3. 4. 5. Send a Begin message from SP A to SP B. Arrange for SP B to send an End message to SP A. CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? CHECK B: WAS THE ABORT MESSAGE CORRECTLY RECEIVED AT SP A? CHECK C: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A? END SP B (TSL)

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets END Message type tag: 01100100 Message type length: correct number of octets Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets

16

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec1_1_2_2_1_1s1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.1.2.2.1.1 1) REFERENCE: 3.3.3.2.1/Q.774, 3.3.3.2.2/Q.774 and 3.3.3.2.3/Q.774 TITLE: Valid function; Structured dialogue

Sheet: 1 of 2

SUBTITLE: Clearing after continue Message; Valid clearing from initiating side; IUT sending; Basic ending PURPOSE: To verify that the signalling point A is able to terminate the transaction by the "basic end" method SP A (TSL) and SP B (TSL) are to be in the idle state. SP B to respond with a Continue message on receipt of the Begin message TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1 EXPECTED MESSAGE SEQUENCE: SP A (TSL) TR-BEGIN req. ============> BEGIN

SP

B

(TSL)

  CONTINUE

TR-CONTINUE ind. <============ TR-END req. ============> (Basic) END 

TEST DESCRIPTION 1. 2. 3. 4. 5. 6. 7. Send a Begin message from SP A to SP B. Arrange for SP B to respond with a Continue message On receipt of the CONTINUE indication arrange for a TR-END request primitive (basic) to be passed to the TSL at SP A. CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? CHECK B: WAS THE CONTINUE MESSAGE CORRECTLY RECEIVED BY THE TSL AT SP A? CHECK C: WAS THE END MESSAGE CORRECTLY SENT BY SP A? CHECK D: WAS THE DTID IN THE END MESSAGE THE SAME AS THE OTID IN THE CONTINUE MESSAGE? CHECK E: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?

Recommendation Q.787 (09/97)

17

TEST NUMBER: 1.1.2.2.1.1 1) CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets CONTINUE Message type tag: 01100101 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets END Message type tag: 01100100 Message type length: correct number of octets

Sheet: 2 of 2

Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in CONTINUE message) Component portion tag: 01101100 Component portion length: correct number of octets

18

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec1_1_2_2_1_1s2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.1.2.2.1.1 2) REFERENCE: 3.3.3.2.1/Q.774, 3.3.3.2.2/Q.774 and 3.3.3.2.3/Q.774 TITLE: Valid function; Structured dialogue

Sheet: 1 of 2

SUBTITLE: Clearing after continue Message; Valid clearing from initiating side; IUT sending; Prearranged ending PURPOSE: To verify that signalling point A is able to terminate the transaction by the "prearranged end" method SP A (TSL) and SP B (TSL) are to be in the idle state. SP B to respond with a Continue message on receipt of the Begin message TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1 EXPECTED MESSAGE SEQUENCE: SP A (TSL) TR-BEGIN req. ============> BEGIN

SP

B

(TSL)

  CONTINUE

TR-CONTINUE ind. <============ TR-END req. ============> (Prearranged)

TEST DESCRIPTION 1. 2. 3. 4. 5. 6. Send a Begin message from SP A to SP B. Arrange for SP B to respond with a Continue message On receipt of the CONTINUE indication arrange for a TR-END request primitive (prearranged) to be passed to the TSL at SP A. CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? CHECK B: WAS THE CONTINUE MESSAGE CORRECTLY RECEIVED AT SP A? CHECK C: VERIFY THAT THE TR-END REQUEST PRIMITIVE WAS PURELY LOCAL AND THAT AN END MESSAGE WAS NOT GENERATED AND SENT BY SP A. CHECK D: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?

Recommendation Q.787 (09/97)

19

TEST NUMBER: 1.1.2.2.1.1 2) CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets CONTINUE Message type tag: 01100101 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets

Sheet: 2 of 2

20

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec1_1_2_2_1_1s3 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.1.2.2.1.1 3) REFERENCE: 3.3.3.2.1/Q.774, 3.3.3.2.2/Q.774 and 3.3.3.2.4/Q.774 TITLE: Valid function; Structured dialogue

Sheet: 1 of 2

SUBTITLE: Clearing after continue Message; Valid clearing from initiating side; IUT sending; Abort by the TR-User PURPOSE: To verify that the signalling point A is able to terminate the transaction by the "abort" method SP A (TSL) and SP B (TSL) are to be in the idle state. SP B to respond with a Continue message on receipt of the Begin message TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1 EXPECTED MESSAGE SEQUENCE: SP A (TSL) TR-BEGIN req. ============> BEGIN

SP

B

(TSL)

  CONTINUE

TR-CONTINUE ind. <============ TR-U-ABORT req. ============> ABORT (U) 

TEST DESCRIPTION 1. 2. 3. 4. 5. 6. 7. Send a Begin message from SP A to SP B. Arrange for SP B to respond with a Continue message On receipt of the CONTINUE indication arrange for a TR-U-ABORT request primitive to be passed to TSL at SP A. CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? CHECK B: WAS THE CONTINUE MESSAGE CORRECTLY RECEIVED AT SP A? CHECK C: WAS THE ABORT MESSAGE CORRECTLY SENT BY SP A? CHECK D: WAS THE DTID IN THE ABORT MESSAGE THE SAME AS THE OTID IN THE CONTINUE MESSAGE? CHECK E: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?

Recommendation Q.787 (09/97)

21

TEST NUMBER: 1.1.2.2.1.1 3) CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets CONTINUE Message type tag: 01100101 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets ABORT Message type tag: 01100111 Message type length: correct number of octets

Sheet: 2 of 2

Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in CONTINUE message) User abort information tag: 01101011 User abort information length: correct number of octets

22

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec1_1_2_2_1_2s1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.1.2.2.1.2 1) REFERENCE: 3.3.3.2.1.2/Q.774, 3.3.3.2.2/Q.774 and 3.3.3.2.3/Q.774 TITLE: Valid function; Structured dialogue

Sheet: 1 of 2

SUBTITLE: Clearing after continue Message; Valid clearing from initiating side; IUT receiving; Basic ending PURPOSE: To verify that signalling point A is able to generate a Continue message and then terminate the transaction on reception of an End message SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (TSL)  TR-BEGIN ind. <============ TR-CONTINUE req. ============> CONTINUE   TR-END ind. <============ END SP B (TSL) BEGIN

TEST DESCRIPTION 1. 2. 3. 4. 5. 6. 7. Arrange for SP B to send a Begin message to SP A. Arrange for SP A to respond with a Continue message. Arrange for SP B to respond with an End message. CHECK A: WAS THE BEGIN MESSAGE CORRECTLY RECEIVED AT SP A? CHECK B: WAS THE CONTINUE MESSAGE CORRECTLY SENT FROM SP A? CHECK C: WAS THE END MESSAGE CORRECTLY RECEIVED AT SP A? CHECK D: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?

Recommendation Q.787 (09/97)

23

TEST NUMBER: 1.1.2.2.1.2 1) CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets CONTINUE Message type tag: 01100101 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets END Message type tag: 01100100 Message type length: correct number of octets

Sheet: 2 of 2

Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in CONTINUE message) Component portion tag: 01101100 Component portion length: correct number of octets

24

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec1_1_2_2_1_2s2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.1.2.2.1.2 2) REFERENCE: 3.3.3.2.1.2/Q.774 and 3.3.4/Q.774 TITLE: Valid function; Structured dialogue

Sheet: 1 of 2

SUBTITLE: Clearing after continue Message; Valid clearing from initiating side; IUT receiving; Abort by the transaction sublayer PURPOSE: To verify that signalling point A is able to generate a Continue message and then terminate the transaction on reception of an Abort message by the peer TSL SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (TSL)  TR-BEGIN ind. <============ TR-CONTINUE req. ============> CONTINUE   TR-P-ABORT ind. <============ ABORT (P) SP B (TSL) BEGIN

TEST DESCRIPTION 1. 2. 3. 4. 5. 6. 7. Arrange for SP B to send a Begin message to SP A. Arrange for SP A to respond with a Continue message. Arrange for SP B to respond with an Abort (P) message. CHECK A: WAS THE BEGIN MESSAGE CORRECTLY RECEIVED AT SP A? CHECK B: WAS THE CONTINUE MESSAGE CORRECTLY SENT FROM SP A? CHECK C: WAS THE ABORT MESSAGE CORRECTLY RECEIVED AT SP A? CHECK D: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?

Recommendation Q.787 (09/97)

25

TEST NUMBER: 1.1.2.2.1.2 2) CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets CONTINUE Message type tag: 01100101 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets ABORT (P) Message type tag: 01100111 Message type length: correct number of octets

Sheet: 2 of 2

Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in CONTINUE message) P-Abort cause tag: 01001010 P-Abort cause length: one octet P-Abort cause value: INTEGER (0 .. 4)

26

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec1_1_2_2_1_2s3 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.1.2.2.1.2 3) REFERENCE: 3.3.3.2.1.2/Q.774 and 3.3.3.2.4/Q.774 TITLE: Valid function; Structured dialogue

Sheet: 1 of 2

SUBTITLE: Clearing after continue Message; Valid clearing from initiating side; IUT receiving; Abort by the TR-User PURPOSE: To verify that signalling point A is able to generate a Continue message and then terminate the transaction on reception of an Abort message by the peer TR-User SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (TSL)  TR-BEGIN ind. <============ TR-CONTINUE req. ============> CONTINUE   TR-U-ABORT ind. <============ ABORT (U) SP B (TSL) BEGIN

TEST DESCRIPTION 1. 2. 3. 4. 5. 6. 7. Arrange for SP B to send a Begin message to SP A. Arrange for SP A to respond with a Continue message. Arrange for SP B to respond with an Abort (U) message. CHECK A: WAS THE BEGIN MESSAGE CORRECTLY RECEIVED AT SP A? CHECK B: WAS THE CONTINUE MESSAGE CORRECTLY SENT FROM SP A? CHECK C: WAS THE ABORT MESSAGE CORRECTLY RECEIVED AT SP A? CHECK D: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?

Recommendation Q.787 (09/97)

27

TEST NUMBER: 1.1.2.2.1.2 3) CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets CONTINUE Message type tag: 01100101 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets ABORT (U) Message type tag: 01100111 Message type length: correct number of octets

Sheet: 2 of 2

Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in CONTINUE message) User abort information tag: 01101011 User abort information length: correct number of octets

28

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec1_1_2_2_2_1s1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.1.2.2.2.1 1) REFERENCE: 3.3.3.2.1/Q.774, 3.3.3.2.2/Q.774 and 3.3.3.2.3/Q.774 TITLE: Valid function; Structured dialogue

Sheet: 1 of 2

SUBTITLE: Clearing after continue Message; Valid clearing from responding side; IUT sending; Basic ending PURPOSE: To verify that signalling point A is able to generate a Continue message and then terminate the transaction by the "basic end" method SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (TSL)  TR-BEGIN ind. <============ TR-CONTINUE req. ============> CONTINUE TR-END req. ============> (Basic) END   SP B (TSL) BEGIN

TEST DESCRIPTION 1. 2. 3. 4. 5. 6. 7. 8. Arrange for SP B to send a Begin message to SP A. Arrange for SP A to respond with a Continue message. Terminate the transaction with an End (Basic) message from SP A. CHECK A: WAS THE BEGIN MESSAGE CORRECTLY RECEIVED AT SP A? CHECK B: WAS THE CONTINUE MESSAGE CORRECTLY SENT BY THE TSL AT SP A? CHECK C: WAS AN END MESSAGE CORRECTLY SENT BY SP A? CHECK D: WAS THE DTID IN THE CONTINUE AND END MESSAGES THE SAME AS THE OTID IN THE BEGIN MESSAGE. CHECK E: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?

Recommendation Q.787 (09/97)

29

TEST NUMBER: 1.1.2.2.2.1 1) CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets CONTINUE Message type tag: 01100101 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets END Message type tag: 01100100 Message type length: correct number of octets

Sheet: 2 of 2

Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in CONTINUE message) Component portion tag: 01101100 Component portion length: correct number of octets

30

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec1_1_2_2_2_1s2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.1.2.2.2.1 2) REFERENCE: 3.3.3.2.1/Q.774, 3.3.3.2.2/Q.774 and 3.3.3.2.3/Q.774 TITLE: Valid function; Structured dialogue

Sheet: 1 of 2

SUBTITLE: Clearing after continue Message; Valid clearing from responding side; IUT sending; Prearranged ending PURPOSE: To verify that signalling point A is able to generate a Continue message and then terminate the transaction by the "prearranged end" method SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (TSL)  TR-BEGIN ind. <============ TR-CONTINUE req. ============> CONTINUE TR-END req. ============> (Prearranged)  SP B (TSL) BEGIN

TEST DESCRIPTION 1. 2. 3. 4. 5. 6. 7. 8. Arrange for SP B to send a Begin message to SP A. Arrange for SP A to respond with a Continue message. Terminate the transaction with a TR-END request primitive (prearranged) from SP A. CHECK A: WAS THE BEGIN MESSAGE CORRECTLY RECEIVED AT SP A? CHECK B: WAS THE CONTINUE MESSAGE CORRECTLY SENT BY THE TSL AT SP A? CHECK C: VERIFY THAT THE TR-END REQUEST PRIMITIVE WAS PURELY LOCAL AND THAT AN END MESSAGE WAS NOT GENERATED AND SENT BY SP A. CHECK D: WAS THE DTID IN THE CONTINUE MESSAGE THE SAME AS THE OTID IN THE BEGIN? CHECK D: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?

Recommendation Q.787 (09/97)

31

TEST NUMBER: 1.1.2.2.2.1 2) CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets CONTINUE Message type tag: 01100101 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets

Sheet: 2 of 2

32

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec1_1_2_2_2_1s3 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.1.2.2.2.1 3) REFERENCE: 3.3.3.2.1/Q.774, 3.3.3.2.2/Q.774 and 3.3.3.2.4/Q.774 TITLE: Valid function; Structured dialogue

Sheet: 1 of 2

SUBTITLE: Clearing after continue Message; Valid clearing from initiating side; IUT sending; Abort by the TR-User PURPOSE: To verify that signalling point A is able to generate a Continue message and then terminate the transaction by the "abort" method SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (TSL)  TR-BEGIN ind. <============ TR-CONTINUE req. ============> CONTINUE TR-U-ABORT req. ============> ABORT (U)   SP B (TSL) BEGIN

TEST DESCRIPTION 1. 2. 3. 4. 5. 6. 7. Arrange for a Begin message to be sent from SP B to SP A. Arrange for SP A to respond with a Continue message, then abort the transaction by passing a TR-U-ABORT request primitive to the TSL at SP B. CHECK A: WAS THE BEGIN MESSAGE CORRECTLY RECEIVED AT SP A? CHECK B: WAS THE CONTINUE MESSAGE CORRECTLY SENT FROM SP A? CHECK C: WAS THE ABORT MESSAGE CORRECTLY SENT FROM SP A? CHECK D: WAS THE DTID IN THE CONTINUE AND ABORT MESSAGES THE SAME AS THE OTID IN THE BEGIN MESSAGE? CHECK E: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?

Recommendation Q.787 (09/97)

33

TEST NUMBER: 1.1.2.2.2.1 3) CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets CONTINUE Message type tag: 01100101 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets ABORT Message type tag: 01100111 Message type length: correct number of octets

Sheet: 2 of 2

Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in CONTINUE message) User abort information tag: 01101011 User abort information length: correct number of octets

34

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec1_1_2_2_2_2s1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.1.2.2.2.2 1) REFERENCE: 3.3.3.2.1/Q.774 and 3.3.3.2.3/Q.774 TITLE: Valid function; Structured dialogue

Sheet: 1 of 2

SUBTITLE: Clearing after continue Message; Valid clearing from responding side; IUT receiving; Basic ending PURPOSE: To verify that the signalling point A is able to terminate the transaction on reception of an End message following a Continue message SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (TSL) TR-BEGIN req. ============> BEGIN   TR-CONTINUE ind. <============  TR-END ind. <============ END CONTINUE SP B (TSL)

TEST DESCRIPTION 1. 2. 3. 4. 5. 6. 7. Arrange for SP A to send a Begin message to SP B. Arrange for SP B to respond with a Continue message. Terminate the transaction with an End (basic) message from SP B. CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? CHECK B: WAS THE CONTINUE MESSAGE CORRECTLY RECEIVED AT SP A? CHECK C: WAS THE END MESSAGE CORRECTLY RECEIVED AT SP A? CHECK D: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?

Recommendation Q.787 (09/97)

35

TEST NUMBER: 1.1.2.2.2.2 1) CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets CONTINUE Message type tag: 01100101 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets END Message type tag: 01100100 Message type length: correct number of octets Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets

Sheet: 2 of 2

36

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec1_1_2_2_2_2s3 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.1.2.2.2.2 3) REFERENCE: 3.3.3.2.1/Q.774 and 3.3.3.2.4/Q.774 TITLE: Valid function; Structured dialogue

Sheet: 1 of 2

SUBTITLE: Clearing after continue Message; Valid clearing from responding side; IUT receiving; Abort by the TR-User PURPOSE: To verify that the signalling point A is able to terminate the transaction on reception of an Abort (U) message following a Continue message SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (TSL) TR-BEGIN req. ============> BEGIN   TR-CONTINUE ind. <============  TR-U-ABORT ind. <============ ABORT (U) CONTINUE SP B (TSL)

TEST DESCRIPTION 1. 2. 3. 4. 5. 6. 7. Arrange for SP A to send a Begin message to SP B. Arrange for SP B to respond with a Continue message. Terminate the transaction with an Abort (U) message from SP B. CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? CHECK B: WAS THE CONTINUE MESSAGE CORRECTLY RECEIVED AT SP A? CHECK C: WAS THE ABORT MESSAGE CORRECTLY RECEIVED AT SP A? CHECK D: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?

Recommendation Q.787 (09/97)

39

TEST NUMBER: 1.1.2.2.2.2 3) CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets CONTINUE Message type tag: 01100101 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets ABORT (U) Message type tag: 01100111 Message type length: correct number of octets Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) User abort information tag: 01101011 User abort information length: correct number of octets

Sheet: 2 of 2

40

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec1_1_2_4_1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.1.2.4.1 REFERENCE: 3.2.1.3/Q.774 TITLE: Valid function; Structured dialogue SUBTITLE: Message exchange after transaction established; IUT initiating PURPOSE:

Sheet: 1 of 2

To verify the correct message flow between SP A and SP B, after transaction established (IUT initiating) SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (TSL) TR-BEGIN req. ============> BEGIN   TR-CONTINUE ind. <============ TR-CONTINUE req. ============> CONTINUE   TR-END ind. <============ END CONTINUE SP B (TSL)

TEST DESCRIPTION 1. 2. 3. 4. 5. 6. 7. 8. 9. Arrange for SP A to send a Begin message to SP B. Arrange for SP B to send a Continue message to SP A. Arrange for SP A to send a Continue message to SP B. Arrange for SP B to send an END message to SP A. CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? CHECK B: WAS THE CONTINUE MESSAGE CORRECTLY RECEIVED AT SP A? CHECK C: WAS THE CONTINUE MESSAGE CORRECTLY SENT FROM SP A? CHECK D: WAS THE END MESSAGE CORRECTLY RECEIVED AT SP A? CHECK E: WAS THE TSL STATE MACHINE LEFT IN THE IDLE STATE AT SP A?

Recommendation Q.787 (09/97)

45

TEST NUMBER: 1.1.2.4.1 CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets (range 1-4) Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets CONTINUE Message type tag: 01100101 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets (range 1-4) Originating transaction ID value: OCTET STRING (1-4 octets long) Destination transaction ID tag: 01001001 Destination transaction ID length: 0 (invalid length) Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID received in BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets CONTINUE Message type tag: 01100101 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets (range 1-4) Originating transaction ID value: OCTET STRING (1-4 octets long)

Sheet: 2 of 2

Destination transaction ID tag: 01001001 Destination transaction ID length: 0 (invalid length) Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in CONTINUE message) Component portion tag: 01101100 Component portion length: correct number of octets END Message type tag: 01100101 Message type length: correct number of octets Destination transaction ID tag: 01001001 Destination transaction ID length: 0 (invalid length) Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets

46

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec1_1_2_4_2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.1.2.4.2 REFERENCE: 3.2.1.3/Q.774 TITLE: Valid function; Structured dialogue SUBTITLE: Message exchange after transaction established; IUT receiving PURPOSE:

Sheet: 1 of 2

To verify the correct message flow between SP A and SP B, after transaction established (IUT receiving) SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (TSL)  TR-BEGIN ind. <============ TR-CONTINUE req. ============> CONTINUE   TR-CONTINUE ind. <============ TR-END req. ============> END  CONTINUE SP B (TSL) BEGIN

TEST DESCRIPTION 1. 2. 3. 4. 5. 6. 7. 8. 9. Arrange for SP B to send a Begin message to SP A. Arrange for SP A to send a Continue message to SP B. Arrange for SP B to send a Continue message to SP A. Arrange for SP A to send an END message to SP B. CHECK A: WAS THE BEGIN MESSAGE CORRECTLY RECEIVED AT SP A? CHECK B: WAS THE CONTINUE MESSAGE CORRECTLY SENT FROM SP A? CHECK C: WAS THE CONTINUE MESSAGE CORRECTLY RECEIVED AT SP A? CHECK D: WAS THE END MESSAGE CORRECTLY SENT FROM SP A? CHECK E: WAS THE TSL STATE MACHINE LEFT IN THE IDLE STATE AT SP A?

Recommendation Q.787 (09/97)

47

TEST NUMBER: 1.1.2.4.2 CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets (range 1-4) Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets CONTINUE Message type tag: 01100101 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets (range 1-4) Originating transaction ID value: OCTET STRING (1-4 octets long) Destination transaction ID tag: 01001001 Destination transaction ID length: 0 (invalid length) Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets CONTINUE Message type tag: 01100101 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets (range 1-4) Originating transaction ID value: OCTET STRING (1-4 octets long)

Sheet: 2 of 2

Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets (range 1-4) Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in CONTINUE message) Component portion tag: 01101100 Component portion length: correct number of octets END Message type tag: 01100101 Message type length: correct number of octets Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets (range 1-4) Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets

48

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec1_1_3_2_1s1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.1.3.2.1 1) REFERENCE: 5.3/Q.774 TITLE: Valid function; Encoding and value variations SUBTITLE: Value variations; Transaction ID; Length is one octet PURPOSE:

Sheet: 1 of 2

To verify that signalling point A is able to deal with correct encoding of OTID information element (1 octet long) SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (TSL)  TR-BEGIN ind. <============ TR-END req. ============> (Basic) END  SP B (TSL) BEGIN

TEST DESCRIPTION 1. 2. 3. 4. 5. 6. Arrange for SP B to send a Begin message to SP A with an OTID 1 octet long. Arrange for SP A to respond with an End message. CHECK A: WAS THE BEGIN MESSAGE CORRECTLY RECEIVED AT SP A AND PASSED TO THE TR-USER? CHECK B: WAS AN END MESSAGE CORRECTLY SENT BY SP A? CHECK C: WAS THE DTID IN THE END MESSAGE THE SAME AS THE OTID IN THE BEGIN MESSAGE? CHECK D: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?

58

Recommendation Q.787 (09/97)

TEST NUMBER: 1.1.3.2.1 1) CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: one octet Originating transaction ID value: OCTET STRING (1 octet) Component portion tag: 01101100 Component portion length: correct number of octets END Message type tag: 01100100 Message type length: correct number of octets Destination transaction ID tag: 01001001 Destination transaction ID length: one octet Destination transaction ID value: OCTET STRING (1 octet) (OTID value received in BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets

Sheet: 2 of 2

Recommendation Q.787 (09/97)

59

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec1_1_3_2_1s2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.1.3.2.1 2) REFERENCE: 5.3/Q.774 TITLE: Valid function; Encoding and value variations SUBTITLE: Value variations; Transaction ID; Length is four octets PURPOSE:

Sheet: 1 of 2

To verify that signalling point A is able to deal with correct encoding of OTID information element (4 octets long) SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (TSL)  TR-BEGIN ind. <============ TR-END req. ============> (Basic) END  SP B (TSL) BEGIN

TEST DESCRIPTION 1. 2. 3. 4. 5. 6. Arrange for SP B to send a Begin message to SP A with an OTID four octets long. Arrange for SP A to respond with an End message. CHECK A: WAS THE BEGIN MESSAGE CORRECTLY RECEIVED AT SP A AND PASSED TO THE TR-USER? CHECK B: WAS AN END MESSAGE CORRECTLY SENT BY SP A? CHECK C: WAS THE DTID IN THE END MESSAGE THE SAME AS THE OTID IN THE BEGIN MESSAGE? CHECK D: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?

60

Recommendation Q.787 (09/97)

TEST NUMBER: 1.1.3.2.1 2) CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: four octets Originating transaction ID value: OCTET STRING (4 octets) Component portion tag: 01101100 Component portion length: correct number of octets END Message type tag: 01100100 Message type length: correct number of octets Destination transaction ID tag: 01001001 Destination transaction ID length: four octets Destination transaction ID value: OCTET STRING (4 octets) (OTID value received in BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets

Sheet: 2 of 2

Recommendation Q.787 (09/97)

61

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_1_1_1_1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.1.1.1 REFERENCE: 3.2.1/Q.774 TITLE: Valid functions; Invoke component, unlinked operations SUBTITLE: Class 1 single operation invocation; IUT as sender: receive result PURPOSE:

Sheet: 1 of 2

To verify that a single Class 1 operation can be successfully invoked and the successful completion of the operation can be received and delivered to the TC-User

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains an Invoke component 2) Arrange the data at SP B such that a Return Result-Last component can be generated CONFIGURATION: 1 TYPE OF TEST: VAT and CPT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i)   TC-RESULT-L ind. <============ RETURN RESULT-LAST (i) SP B (CSL)

TEST DESCRIPTION 1. 2. 3. 4. Initiate a single operation invocation from SP A to SP B. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE RETURN RESULT-LAST COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? CHECK C: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

118

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.1.1.1 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-user) RETURN RESULT-LAST component in TSL messages from SP B to SP A Component type tag: 10100010 (RETURN RESULT-LAST) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Sequence tag: 00110000 (see Note) Sequence length: correct number of octets (see Note) Operation code tag: 00000010 (local) or 00000110 (global) (see Note) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) (see Note) Operation code: x (see Note) parameters (provided by the TC-User) NOTE ­ Omitted when no parameter is present.

Recommendation Q.787 (09/97)

119

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_1_1_1_2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.1.1.2 REFERENCE: 3.2.1/Q.774 TITLE: Valid functions; Invoke component, unlinked operations SUBTITLE: Class 1 single operation invocation; IUT as receiver: report result PURPOSE:

Sheet: 1 of 2

To verify that a Class 1 operation can be successfully invoked and the successful completion of the operation can be sent Arrange the TC-User stimulus such that an appropriate TSL message generated at SP B contains an Invoke component TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL)  TC-INVOKE ind. <============ TC-RESULT-L req. ============> RETURN-RESULT-LAST (i)  SP B (CSL) INVOKE (i)

TEST DESCRIPTION 1. 2. 3. 4. 5. Initiate a single operation invocation from SP B to SP A. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? CHECK B: WAS THE RETURN RESULT-LAST COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK C: WAS THE INVOKE ID IN THE RETURN RESULT-LAST COMPONENT THE SAME AS THE ONE IN THE INVOKE COMPONENT? CHECK D: WAS THE OPERATION CODE IN THE RETURN RESULT-LAST COMPONENT THE SAME AS THE ONE IN THE INVOKE COMPONENT?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP B to SP A Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

120

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.1.1.2 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) RETURN RESULT-LAST component in TSL messages from SP A to SP B Component type tag: 10100010 (RETURN RESULT-LAST) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Sequence tag: 00110000 (see Note) Sequence length: correct number of octets (see Note) Operation code tag: 00000010 (local) or 00000110 (global) (see Note) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) (see Note) Operation code: x (see Note) parameters (provided by the TC-User) NOTE ­ Omitted when no parameter is present.

Recommendation Q.787 (09/97)

121

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_1_1_1_3 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.1.1.3 REFERENCE: 3.2.1/Q.774 TITLE: Valid functions; Invoke component, unlinked operations SUBTITLE: Class 1 single operation invocation; IUT as sender: receive error PURPOSE:

Sheet: 1 of 2

To verify that a Class 1 operation can be successfully invoked and the unsuccessful completion of the operation can be received and delivered to the TC-User

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains an Invoke component 2) Arrange the data at SP B such that a Return Error component can be generated CONFIGURATION: 1 TYPE OF TEST: VAT and CPT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i)   TC-U-ERROR ind. <============ RETURN ERROR (i) SP B (CSL)

TEST DESCRIPTION 1. 2. 3. 4. Initiate a single operation invocation from SP A to SP B. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE RETURN ERROR COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? CHECK C: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

122

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.1.1.3 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) RETURN ERROR component in TSL messages from SP B to SP A Component type tag: 10100011 (RETURN ERROR) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Error code tag: 00000010 (local) or 00000110 (global) Error code length: correct number of octets (e.g. 00000001 if y is one octet long) Error code: y (y is a valid error code) parameters (provided by the TC-User)

Recommendation Q.787 (09/97)

123

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_1_1_1_4 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.1.1.4 REFERENCE: 3.2.1/Q.774 TITLE: Valid functions; Invoke component, unlinked operations SUBTITLE: Class 1 single operation invocation; IUT as receiver: report error PURPOSE:

Sheet: 1 of 2

To verify that a Class 1 operation can be successfully invoked and the unsuccessful completion of the operation can be sent

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP B contains an Invoke component 2) Arrange the TC-User at SP A such that a Return-Error component can be generated CONFIGURATION: 1 TYPE OF TEST: VAT and CPT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL)  TC-U-ERROR ind. <============ TC-RESULT-L req. ============> RETURN-ERROR (i)  SP B (CSL)

INVOKE (i)

TEST DESCRIPTION 1. 2. 3. 4. 5. Initiate a single operation invocation from SP B to SP A. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? CHECK B: WAS THE RETURN ERROR COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK C: WAS THE INVOKE ID IN THE RETURN ERROR COMPONENT THE SAME AS THE ONE IN THE INVOKE COMPONENT? CHECK D: WAS THE ERROR CODE IN THE RETURN ERROR COMPONENT VALID?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP B to SP A Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

124

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.1.1.4 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) RETURN ERROR COMPONENT in TSL message from SP A to SP B Component type tag: 10100011 (RETURN ERROR) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Error code tag: 00000010 (local) or 00000110 (global) Error code length: correct number of octets (e.g. 00000001 if y is one octet long) Error code: y parameters (provided by the TC-User)

Recommendation Q.787 (09/97)

125

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_1_1_1_5 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.1.1.5 REFERENCE: 3.2.1/Q.774 TITLE: Valid functions; Invoke component, unlinked operations SUBTITLE: Class 1 single operation invocation; IUT as sender: timer expiry PURPOSE:

Sheet: 1 of 1

To verify that a Class 1 operation can be successfully invoked and the timer expiry indication can be delivered to the TC-User

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains an Invoke component 2) Arrange the data at SP B such that no component can be generated CONFIGURATION: 1 TYPE OF TEST: VAT and CPT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i) timer expiry for invocation (i) TC-L-CANCEL ind. (i) <============  SP B (CSL)

TEST DESCRIPTION 1. 2. 3. 4. Initiate a single operation invocation from SP A to SP B. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE COMPONENT FLOW AS SHOWN ABOVE? CHECK C: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer) Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User)

126

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_1_1_2_1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.1.2.1 REFERENCE: 3.2.1/Q.774 TITLE: Valid functions; Invoke component, unlinked operations SUBTITLE: Class 2 single operation invocation; IUT as sender: receive error PURPOSE:

Sheet: 1 of 2

To verify that a Class 2 operation can be successfully invoked and the failure report can be received and delivered to the TC-User

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains an Invoke component 2) Arrange the data at SP B such that a Return Error component can be generated CONFIGURATION: 1 TYPE OF TEST: VAT and CPT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i)   TC-U-ERROR ind. <============ RETURN ERROR (i) SP B (CSL)

TEST DESCRIPTION 1. 2. 3. 4. Initiate a single Class 2 operation invocation from SP A to SP B. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE RETURN ERROR COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? CHECK C: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

Recommendation Q.787 (09/97)

127

TEST NUMBER: 2.1.1.2.1 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) RETURN ERROR COMPONENT in TSL message from SP B to SP A Component type tag: 10100011 (RETURN ERROR) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Error code tag: 00000010 (local) or 00000110 (global) Error code length: correct number of octets (e.g. 00000001 if y is one octet long) Error code: y parameters (provided by the TC-User)

128

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_1_1_2_2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.1.2.2 REFERENCE: 3.2.1/Q.774 TITLE: Valid functions; Invoke component, unlinked operations SUBTITLE: Class 2 single operation invocation; IUT as sender: timer expiry PURPOSE:

Sheet: 1 of 1

To verify that a Class 2 operation can be successfully invoked and the timer expiry indication can be delivered to the TC-User

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains an Invoke component 2) Arrange the data at SP B such that no component will be generated CONFIGURATION: 1 TYPE OF TEST: VAT and CPT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i) timer expiry for invocation (i) TC-L-CANCEL ind. <============ TEST DESCRIPTION 1. 2. 3. 4. 5. Initiate a single Class 2 operation invocation from SP A to SP B. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE COMPONENT FLOW AS SHOWN ABOVE? CHECK C: WAS THE TC-USER AT SP A INFORMED OF TIMER EXPIRY? CHECK D: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?  SP B (CSL)

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer) Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User)

Recommendation Q.787 (09/97)

129

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_1_1_3_1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.1.3.1 REFERENCE: 3.2.1/Q.774 TITLE: Valid functions; Invoke component, unlinked operations SUBTITLE: Class 3 single operation invocation; IUT as sender: receive result PURPOSE:

Sheet: 1 of 2

To verify that a single Class 3 operation can be successfully invoked and the successful report of the operation can be received and delivered to the TC-User

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains an Invoke component 2) Arrange the data at SP B such that a Return Result-Last component can be generated CONFIGURATION: 1 TYPE OF TEST: VAT and CPT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i)   TC-RESULT-L ind. <============ RETURN RESULT-LAST (i) SP B (CSL)

TEST DESCRIPTION 1. 2. 3. 4. Initiate a single Class 3 operation invocation from SP A to SP B. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE RETURN RESULT-LAST COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? CHECK C: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

130

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.1.3.1 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) RETURN RESULT-LAST component in TSL message from SP B to SP A Component type tag: 10100011 (RETURN RESULT-LAST) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Sequence tag: 00110000 (see Note) Sequence length: correct number of octets (see Note) Operation code tag: 00000010 (local) or 00000110 (global) (see Note) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) (see Note) Operation code: x (see Note) parameters (provided by the TC-User) NOTE ­ Omitted when no parameter is present.

Recommendation Q.787 (09/97)

131

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_1_1_3_2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.1.3.2 REFERENCE: 3.2.1/Q.774 TITLE: Valid functions; Invoke component, unlinked operations SUBTITLE: Class 3 single operation invocation; IUT as sender: timer expiry PURPOSE:

Sheet: 1 of 1

To verify that a Class 3 operation can be successfully invoked and the timer expiry indication can be delivered to the TC-User

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains an Invoke component 2) Arrange the data at SP B such that no component will be generated CONFIGURATION: 1 TYPE OF TEST: VAT and CPT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i) timer expiry for invocation (i) TC-L-CANCEL ind. <============ TEST DESCRIPTION 1. 2. 3. 4. 5. Initiate a Class 3 operation invocation from SP A to SP B. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE COMPONENT FLOW AS SHOWN ABOVE? CHECK C: WAS THE TC-USER AT SP A INFORMED OF TIMER EXPIRY? CHECK D: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?  SP B (CSL)

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer) Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User)

132

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_1_1_4_1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.1.4.1 REFERENCE: 3.2.1/Q.774 TITLE: Valid functions; Invoke component, unlinked operations SUBTITLE: Class 4 single operation invocation; IUT as sender PURPOSE:

Sheet: 1 of 1

To verify that a Class 4 operation can be successfully initiated and no response is received. Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains an Invoke component TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i) timer expiry for invocation (i) TC-L-CANCEL ind. <============ TEST DESCRIPTION 1. 2. 3. 4. Initiate a single Class 4 operation invocation from SP A to SP B. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE TC-USER AT SP A INFORMED OF TIMER EXPIRY? CHECK C: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?  SP B (CSL)

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer) Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User)

Recommendation Q.787 (09/97)

133

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_1_2_1_1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.2.1.1 REFERENCE: 3.2.1/Q.774 TITLE: Valid functions; Invoke component, Linked operations

Sheet: 1 of 3

SUBTITLE: Class 1 original operation invocation; IUT as sender: receive a linked Class 1 operation invocation, report result PURPOSE: To verify that a linked Class 1 operation can be successfully received and the successful completion of the original operation can be performed

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains an Invoke component 2) Arrange the data at SP B such that a linked Invoke component can be generated CONFIGURATION: 1 TYPE OF TEST: VAT and CPT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i)   TC-INVOKE ind. <============ TC-RESULT-L req. ============> RETURN-RESULT-LAST (j)   TC-RESULT-L ind. <============ RETURN-RESULT-LAST (i) INVOKE (j, i) SP B (CSL)

TEST DESCRIPTION 1. 2. 3. 4. 5. 6. 7. 8. Initiate a linked operation invocation from SP A to SP B. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS A LINKED INVOKE COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? CHECK C: WAS THE RETURN RESULT-LAST COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK D: WAS THE INVOKE ID IN THE RETURN RESULT-LAST COMPONENT THE SAME AS THE ONE IN THE INVOKE COMPONENT SENT BY SP B ? CHECK E: WAS THE OPERATION CODE IN THE RETURN RESULT-LAST COMPONENT SENT BY SP A THE SAME AS THE ONE IN THE INVOKE COMPONENT SENT BY SP B ? CHECK F: WAS THE RETURN RESULT-LAST COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? CHECK G: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?

134

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.2.1.1 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

Sheet: 2 of 3

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) INVOKE component in TSL message sent by SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: j (j represents an integer) Linked ID tag: 10000000 Linked ID length: 00000001 (one octet) Linked ID: i Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if y is one octet long) Operation code: y (y represents a valid operation code) parameters (provided by the TC-User) RETURN RESULT-LAST component in 2nd TSL message sent by SP A Component type tag: 10100010 (RETURN RESULT-LAST) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: j

Recommendation Q.787 (09/97)

135

TEST NUMBER: 2.1.2.1.1 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Sequence tag: 00110000 (see Note) Sequence length: correct number of octets (see Note)

Sheet: 3 of 3

Operation code tag: 00000010 (local) or 00000110 (global) (see Note) Operation code length: correct number of octets (e.g. 00000001 if y is one octet long) (see Note) Operation code: y (see Note) parameters (provided by the TC-User) RETURN RESULT-LAST component in TSL message from SP B to SP A Component type tag: 10100010 (RETURN RESULT-LAST) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Sequence tag: 00110000 (see Note) Sequence length: correct number of octets (see Note) Operation code tag: 00000010 (local) or 00000110 (global) (see Note) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) (see Note) Operation code: x (see Note) parameters (provided by the TC-User) NOTE ­ Omitted when no parameter is present.

136

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_1_2_1_2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.2.1.2 REFERENCE: 3.2.1/Q.774 TITLE: Valid functions; Invoke component, Linked operations

Sheet: 1 of 3

SUBTITLE: Class 1 original operation invocation; IUT as receiver: send a linked Class 1 operation invocation, receive result PURPOSE: To verify that a linked Class 1 operation can be successfully invoked and the successful completion of the original operation can be performed Arrange the TC-User stimulus such that an appropriate TSL message generated at SP B contains an Invoke component which will invoke a linked operation TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL)  TC-INVOKE ind. <============ TC-INVOKE req. ============> INVOKE (j, i)   TC-RESULT-L ind. <============ TC-RESULT-L req. ============> RETURN-RESULT-LAST (i)  RETURN RESULT-LAST (j) SP B (CSL) INVOKE (i)

TEST DESCRIPTION 1. 2. 3. 4. 5. 6. 7. 8. 9. Initiate a linked operation invocation from SP B to SP A. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? CHECK B: WAS A LINKED INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK C: WAS THE LINKED ID THE SAME AS THE ORIGINAL INVOKE ID SENT BY SP B? CHECK D: WAS THE RETURN RESULT-LAST COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? CHECK E: WAS THE SECOND RETURN RESULT-LAST COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK F: WAS THE INVOKE ID IN THE SECOND RETURN RESULT-LAST COMPONENT THE SAME AS THE ONE IN THE ORIGINAL INVOKE COMPONENT SENT BY SP B? CHECK G: WAS THE OPERATION CODE IN THE SECOND RETURN RESULT-LAST COMPONENT THE SAME AS THE ONE IN THE ORIGINAL INVOKE COMPONENT ? CHECK H: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?

Recommendation Q.787 (09/97)

137

TEST NUMBER: 2.1.2.1.2 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in initial TSL message from SP B to SP A Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

Sheet: 2 of 3

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) INVOKE component in TSL message sent from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: j (j represents an integer) Linked ID tag: 10000000 Linked ID length: 00000001 (one octet) Linked ID: i Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if y is one octet long) Operation code: y (y represents a valid operation code) parameters (provided by the TC-User) RETURN RESULT-LAST component in TSL message sent by SP B Component type tag: 10100010 (RETURN RESULT-LAST) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: j

138

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.2.1.2 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Sequence tag: 00110000 (see Note) Sequence length: correct number of octets (see Note)

Sheet: 3 of 3

Operation code tag: 00000010 (local) or 00000110 (global) (see Note) Operation code length: correct number of octets (e.g. 00000001 if y is one octet long) (see Note) Operation code: y (see Note) parameters (provided by the TC-User) RETURN RESULT-LAST component in TSL message sent by SP A Component type tag: 10100010 (RETURN RESULT-LAST) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Sequence tag: 00110000 (see Note) Sequence length: correct number of octets (see Note) Operation code tag: 00000010 (local) or 00000110 (global) (see Note) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) (see Note) Operation code: x (see Note) parameters (provided by the TC-User) NOTE ­ Omitted when no parameter is present.

Recommendation Q.787 (09/97)

139

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_1_2_1_3 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.2.1.3 REFERENCE: 3.2.1/Q.774 TITLE: Valid functions; Invoke component, Linked operations

Sheet: 1 of 3

SUBTITLE: Class 1 original operation invocation; IUT as sender: receive a linked Class 1 operation invocation, report error PURPOSE: To verify that a linked Class 1 operation can be successfully received and the reporting error will not impact the completion of the original operation

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains an Invoke component 2) Arrange the data at SP B such that a linked invocation can be generated CONFIGURATION: 1 TYPE OF TEST: VAT and CPT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i)   TC-INVOKE ind. <============ TC-U-ERROR req. ============> RETURN-ERROR (j)   TC-RESULT-L ind. <============ TEST DESCRIPTION 1. 2. 3. 4. 5. 6. 7. Initiate a linked operation invocation from SP A to SP B. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS A LINKED INVOKE COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? CHECK C: WAS THE RETURN ERROR COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK D: WAS THE INVOKE ID IN THE RETURN ERROR COMPONENT THE SAME AS THE ONE IN THE INVOKE COMPONENT SENT BY SP B ? CHECK E: WAS THE RETURN RESULT-LAST COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? CHECK F: WAS THE INVOCATION STATE MACHINE IDLE AT SP A? RETURN-RESULT-LAST (i) INVOKE (j, i) SP B (CSL)

140

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.2.1.3 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

Sheet: 2 of 3

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) INVOKE component in the TSL messages sent by SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: j (j represents an integer) Linked ID tag: 10000000 Linked ID length: 00000001 (one octet) Linked ID: i Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if y is one octet long) Operation code: y (y represents a valid operation code) parameters (provided by the TC-User) RETURN ERROR component in the TSL message sent by SP A Component type tag: 10100010 (RETURN ERROR) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: j

Recommendation Q.787 (09/97)

141

TEST NUMBER: 2.1.2.1.3 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 3 of 3

Error code tag: 00000010 (local) or 00000110 (global) (see Note) Error code length: correct number of octets (e.g. 00000001 if z is one octet long) (see Note) Error code: z (see Note) parameters (provided by the TC-User) RETURN RESULT-LAST component in the TSL message sent by SP B Component type tag: 10100010 (RETURN RESULT-LAST) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Sequence tag: 00110000 (see Note) Sequence length: correct number of octets (see Note) Operation code tag: 00000010 (local) or 00000110 (global) (see Note) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) (see Note) Operation code: x (see Note) parameters (provided by the TC-User) NOTE ­ Omitted when no parameter is present.

142

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_1_2_1_4 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.2.1.4 REFERENCE: 3.2.1/Q.774 TITLE: Valid functions; Invoke component, Linked operations

Sheet: 1 of 3

SUBTITLE: Class 1 original operation invocation; IUT as receiver: send a linked Class 1 operation invocation, receive error PURPOSE: To verify that a linked Class 1 operation can be successfully invoked and the receiving error will not impact the completion of the original operation Arrange the TC-User stimulus such that an appropriate TSL message generated at SP B contains an Invoke component TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1

EXPECTED MESSAGE AND COMPONENT FLOW SP A (CSL)  TC-INVOKE ind. <============ TC-INVOKE req. ============> INVOKE (j, i)   TC-U-ERROR ind. <============ TC-RESULT-L req. ============> RETURN-RESULT-LAST (i) TEST DESCRIPTION 1. 2. 3. 4. 5. 6. 7. 8. Initiate a linked operation invocation from SP B to SP A. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFOR MATION PASSED TO TC-USER BY SP A? CHECK B: WAS A LINKED INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK C: WAS THE LINKED ID THE SAME AS THE ORIGINAL INVOKE ID SENT BY SP B? CHECK D: WAS THE RETURN ERROR COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? CHECK E: WAS THE RETURN RESULT-LAST COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK F: WAS THE INVOKE ID IN THE RETURN RESULT-LAST COMPONENT THE SAME AS THE ONE IN THE ORIGINAL INVOKE COMPONENT SENT BY SP B ? CHECK G: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?  RETURN ERROR (j) SP B (CSL) INVOKE (i)

Recommendation Q.787 (09/97)

143

TEST NUMBER: 2.1.2.1.4 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP B to SP A Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

Sheet: 2 of 3

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) INVOKE component in TSL messages by SP A Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: j (j represents an integer) Linked ID tag: 10000000 Linked ID length: 00000001 (one octet) Linked ID: i Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if y is one octet long) Operation code: y (y represents a valid operation code) parameters (provided by the TC-User) RETURN ERROR component in TSL message sent by SP B Component type tag: 10100011 (RETURN ERROR) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: j

144

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.2.1.4 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 3 of 3

Error code tag: 00000010 (local) or 00000110 (global) Error code length: correct number of octets (e.g. 00000001 if z is one octet long) Error code: z parameters (provided by the TC-User) RETURN RESULT-LAST component in TSL message sent by SP A Component type tag: 10100010 (RETURN RESULT-LAST) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Sequence tag: 00110000 (see Note) Sequence length: correct number of octets (see Note) Operation code tag: 00000010 (local) or 00000110 (global) (see Note) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) (see Note) Operation code: x (see Note) parameters (provided by the TC-User) NOTE ­ Omitted when no parameter is present.

Recommendation Q.787 (09/97)

145

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_1_2_2_1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.2.2.1 REFERENCE: 3.2.1/Q.774 TITLE: Valid functions; Invoke component, Linked operations

Sheet: 1 of 2

SUBTITLE: Class 4 original operation invocation; IUT as sender: receive a linked Class 2 operation invocation, no outcome PURPOSE: To verify that a linked Class 2 operation can be successfully received and the successful completion of the original Class 4 operation can be performed

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains a Class 4 Invoke component 2) Arrange the data at SP B such that a linked Class 2 Invoke component can be generated CONFIGURATION: 1 TYPE OF TEST: VAT and CPT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i)   TC-INVOKE ind. <============ timer expiry for invocation (i) TC-L-CANCEL ind. <============ INVOKE (j, i) SP B (CSL)

TEST DESCRIPTION 1. 2. 3. 4. Initiate a linked operation invocation from SP A to SP B. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS A LINKED INVOKE COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? CHECK C: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

146

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.2.2.1 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) INVOKE component in TSL message sent by SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: j (j represents an integer) Linked ID tag: 10000000 Linked ID length: 00000001 (one octet) Linked ID: i Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if y is one octet long) Operation code: y (y represents a valid operation code) parameters (provided by the TC-User)

Recommendation Q.787 (09/97)

147

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_1_2_2_2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.2.2.2 REFERENCE: 3.2.1/Q.774 TITLE: Valid functions; Invoke component, Linked operations

Sheet: 1 of 2

SUBTITLE: Class 4 original operation invocation; IUT as receiver: send a linked Class 2 operation invocation, timer expiry PURPOSE: To verify that a linked Class 2 operation can be successfully invoked and the successful completion of the original Class 4 operation can be performed Arrange the TC-User stimulus such that an appropriate TSL message generated at SP B contains an Invoke component which will invoke a Class 2 linked operation TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL)  TC-INVOKE ind. <============ TC-INVOKE req. ============> INVOKE (j, i) timer expiry for invocation (j) TC-L-CANCEL ind. <============  SP B (CSL) INVOKE (i)

TEST DESCRIPTION 1. 2. 3. 4. 5. Initiate a linked operation invocation from SP B to SP A. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? CHECK B: WAS A LINKED INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK C: WAS THE LINKED ID THE SAME AS THE ORIGINAL INVOKE ID SENT BY SP B? CHECK D: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in initial TSL message from SP B to SP A Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

148

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.2.2.2 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) INVOKE component in TSL message sent from SP A to SP B Component type tag: 10100010 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: j (j represents) Linked ID tag: 10000000 Linked ID length: 00000001 (one octet) Linked ID: i Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if y is one octet long) Operation code: y (y represents a valid operation code) parameters (provided by the TC-User)

Recommendation Q.787 (09/97)

149

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_1_5_1_1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.5.1.1 REFERENCE: 3.2.1/Q.774 TITLE: Valid functions; Segmentation for Return Result

Sheet: 1 of 2

SUBTITLE: Class 1 single operation invocation; IUT as sender: receive segmented components PURPOSE: To verify that a single Class 1 operation can be completed by receiving segmented Return Result components

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains an Invoke component 2) Arrange the data at SP B such that a Return Result Not-Last component can be generated CONFIGURATION: 1 TYPE OF TEST: VAT and CPT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i)   TC-RESULT-NL ind. <============  TC-RESULT-L ind. <============ TEST DESCRIPTION 1. 2. 3. 4. Initiate a single operation invocation from SP A to SP B. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE RETURN RESULT NOT-LAST COMPONENT WITH CORRECT INFORM ATION PASSED TO TC-USER BY SP A? CHECK C: WAS THE INVOCATION STATE MACHINE IDLE AT SP A? RETURN RESULT-LAST (i) RETURN RESULT NOTLAST (i) SP B (CSL)

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

190

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.5.1.1 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) RETURN RESULT NOT-LAST component in TSL message from SP B to SP A Component type tag: 10100111 (RETURN RESULT NOT-LAST) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Sequence tag: 00110000 (see Note) Sequence length: correct number of octets (see Note) Operation code tag: 00000010 (local) or 00000110 (global) (see Note) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) (see Note) Operation code: x (see Note) parameters (provided by the TC-User) RETURN RESULT-LAST component in TSL message from SP B to SP A Component type tag: 10100010 (RETURN RESULT-LAST) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Sequence tag: 00110000 (see Note) Sequence length: correct number of octets (see Note) Operation code tag: 00000010 (local) or 00000110 (global) (see Note) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) (see Note) Operation code: x (see Note) parameters (provided by the TC-User) NOTE ­ Omitted when no parameter is present.

Recommendation Q.787 (09/97)

191

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_1_5_1_2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.5.1.2 REFERENCE: 3.2.1/Q.774 TITLE: Valid functions; Segmentation for Return Result

Sheet: 1 of 2

SUBTITLE: Class 1 single operation invocation; IUT as receiver: send segmented components PURPOSE: To verify that a single Class 1 operation can be completed by sending segmented Return Result components

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP B contains an Invoke component 2) Arrange the TC-User stimulus at SP A such that a Return Result Not-Last component can be generated CONFIGURATION: 1 TYPE OF TEST: VAT and CPT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE ind. <============ TC-RESULT-NL req. ============> RETURN RESULT NOT-LAST (i) TC-RESULT-L req. ============> RETURN RESULT-LAST (i) TEST DESCRIPTION 1. 2. 3. Initiate a single operation invocation from SP B to SP A. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? CHECK B: WAS THE RETURN RESULT NOT-LAST COMPONENT WITH CORRECT INFORMATION SENT BY SP A?    SP B (CSL)

INVOKE (i)

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

192

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.5.1.2 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) RETURN RESULT NOT-LAST component in TSL message from SP B to SP A Component type tag: 10100111 (RETURN RESULT NOT-LAST) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Sequence tag: 00110000 (see Note) Sequence length: correct number of octets (see Note) Operation code tag: 00000010 (local) or 00000110 (global) (see Note) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) (see Note) Operation code: x (see Note) parameters (provided by the TC-User) RETURN RESULT LAST component in TSL message from SP B to SP A Component type tag: 10100010 (RETURN RESULT-LAST) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Sequence tag: 00110000 (see Note) Sequence length: correct number of octets (see Note) Operation code tag: 00000010 (local) or 00000110 (global) (see Note) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) (see Note) Operation code: x (see Note) parameters (provided by the TC-User) NOTE ­ Omitted when no parameter is present.

Recommendation Q.787 (09/97)

193

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_1_5_2_1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.5.2.1 REFERENCE: 3.2.1/Q.774 TITLE: Valid functions; Segmentation for Return Result

Sheet: 1 of 2

SUBTITLE: Class 3 single operation invocation; IUT as sender: Receive segmented components PURPOSE: To verify that a single Class 3 operation can be completed by receiving segmented Return Result components

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains an Invoke component 2) Arrange the data at SP B such that a Return Result Not-Last component can be generated CONFIGURATION: 1 TYPE OF TEST: VAT and CPT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i)   TC-RESULT-NL ind. <============  TC-RESULT-L ind. <============ RETURN RESULT-LAST (i) RETURN RESULT NOT-LAST (i) SP B (CSL)

TEST DESCRIPTION 1. 2. 3. 4. Initiate a single Class 3 operation invocation from SP A to SP B. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE RETURN RESULT NOT-LAST COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? CHECK C: WAS THE INVOCATION STATE MACHINE IDLE AT SP A ?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

194

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.5.2.1 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) RETURN RESULT NOT-LAST component in TSL message from SP B to SP A Component type tag: 10100111 (RETURN RESULT NOT-LAST) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Sequence tag: 00110000 (see Note) Sequence length: correct number of octets (see Note) Operation code tag: 00000010 (local) or 00000110 (global) (see Note) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) (see Note) Operation code: x (see Note) parameters (provided by the TC-User) RETURN RESULT-LAST component in TSL message from SP B to SP A Component type tag: 10100010 (RETURN RESULT-LAST) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Sequence tag: 00110000 (see Note) Sequence length: correct number of octets (see Note) Operation code tag: 00000010 (local) or 00000110 (global) (see Note) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) (see Note) Operation code: x (see Note) parameters (provided by the TC-User) NOTE ­ Omitted when no parameter is present.

Recommendation Q.787 (09/97)

195

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_1_6 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.6 REFERENCE: 3.2.1/Q.774 TITLE: Valid functions SUBTITLE: User Cancel PURPOSE: To verify that an operation invocation can be canceled by TC-User

Sheet: 1 of 2

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains an Invoke component 2) Arrange the data at SP B such that a Return Result-Last component can be generated CONFIGURATION: 1 TYPE OF TEST: VAT and CPT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i) TC-U-CANCEL req. ============>  TC-L-REJECT ind. <============ REJECT (i)  RETURN-RESULT-LAST (i)  SP B (CSL)

TEST DESCRIPTION 1. 2. 3. 4. 5. Initiate a single Class 1 operation invocation from SP A to SP B. Arrange TC-User to cancel the operation immediately after the Invoke component is sent. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE REJECT COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK C: WAS THE COMPONENT FLOW AS SHOWN ABOVE? CHECK D: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

196

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.6 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) RETURN RESULT-LAST component in TSL message from SP B to SP A Component type tag: 10100010 (RETURN RESULT-LAST) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Sequence tag: 00110000 (see Note) Sequence length: correct number of octets (see Note) Operation code tag: 00000010 (local) or 00000110 (global) (see Note) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) (see Note) Operation code: x (see Note) parameters (provided by the TC-User) REJECT component in TSL message from SP A to SP B Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Problem code tag: 10000010 (RETURN RESULT) Problem code length: 00000001 Problem code: 00000000 (unrecognized invoke ID) NOTE ­ Omitted when no parameter is present.

Recommendation Q.787 (09/97)

197

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_1_9_1_1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.9.1.1 REFERENCE: 3.2.1.2/Q.774 TITLE: Valid functions; Dialogue Portion SUBTITLE: Accept application context proposal; Send AARQ in Begin message PURPOSE:

Sheet: 1 of 1

To verify that an IUT can generate and send the dialogue control APDU AARQ within the dialogue portion in a Begin message SP A ( TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (CSL) TR-BEGIN req. ============> BEGIN (AARQ) TEST DESCRIPTION 1. 2. Arrange for SP A to send a Begin message containing a dialogue portion. CHECK A: DOES THE DIALOGUE PORTION IN THE BEGIN MESSAGE CONTAIN THE APDU AARQ? Also arrange an END message to be sent by IUT or by the Tester. When the last message has been sent by Tester, the END message sent by IUT can be used to check that the last message has been correctly received. CHECK TABLE FOR INFORMATION ELEMENTS WITHIN DIALOGUE PORTION Dialogue portion in Begin message Dialogue portion tag: 01101011 Dialogue portion length: correct number of octets External data type in dialogue portion External type tag: 00101000 External length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: 00000111 direct reference: H''00118605010101 (structured dialogue abstract syntax) single ASN.1 type tag: 10100000 single ASN.1 type length: correct number of octets Dialogue PDU Dialogue Request tag: 01100000 Dialogue Request length: correct number of octets Application context tag: 10100001 Application context length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: correct number of octets direct reference: any object identifier  SP B (CSL)

Recommendation Q.787 (09/97)

217

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_1_9_1_2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.9.1.2 REFERENCE: 3.2.1.2/Q.774 TITLE: Valid functions; Dialogue Portion

Sheet: 1 of 3

SUBTITLE: Accept application context proposal; accept AARQ and continue dialogue PURPOSE: To verify that an IUT can receive a Begin message with APDU ''AARQ'' and then can generate and send the dialogue control APDU ''AARE'' within the dialogue portion of a Continue message SP A ( TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (CSL)  TR-BEGIN ind. <============ TR-CONTINUE req. ============> CONTINUE (AARE)  SP B (CSL)

BEGIN (AARQ)

TEST DESCRIPTION 1. 2. Arrange for SP B to send a Begin message containing a dialogue request. CHECK A: DOES THE DIALOGUE PORTION IN THE CONTINUE MESSAGE CONTAIN THE APDU AARE AND IS THE APPLICATION CONTEXT THE SAME AS IN THE RECEIVED AARQ? Also arrange an END message to be sent by IUT or by the Tester. When the last message has been sent by Tester, the END message sent by IUT can be used to check that the last message has been correctly received.

218

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.9.1.2

Sheet: 2 of 3

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN DIALOGUE PORTION Dialogue portion in Begin message Dialogue portion tag: 01101011 Dialogue portion length: correct number of octets External data type in dialogue portion External type tag: 00101000 External length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: 00000111 Direct reference: H''00118605010101 Single ASN.1 type tag: 10100000 (see Note) Single ASN.1 type length: correct number of octets Dialogue PDU Dialogue Request tag: 01100000 Dialogue Request length: correct number of octets Protocol Version tag: 10000000 Protocol Version length: 00000010 Protocol Version value: 00000111 10000000 Application context tag: 10100001 Application context length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: correct number of octets Direct reference: any object identifier NOTE ­ Instead of the encoding option Single ASN.1 type, this test can also be done with the 2 other options ­ octet aligned and arbitrary.

Recommendation Q.787 (09/97)

219

TEST NUMBER: 2.1.9.1.2

Sheet: 3 of 3

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN DIALOGUE PORTION Dialogue portion in Continue message Dialogue portion tag: 01101011 Dialogue portion length: correct number of octets External data type in dialogue portion External type tag: 00101000 External length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: 00000111 Direct reference: H''00118605010101 Single ASN.1 type tag: 10100000 Single ASN.1 type length: correct number of octets Dialogue PDU Dialogue Response tag: 01100001 Dialogue Response length: correct number of octets Application context tag: 10100001 Application context length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: correct number of octets Direct reference: same octets as in AARQ Result tag: 10100010 Result length: 00000011 INTEGER type tag: 00000010 INTEGER length: 00000001 Result value: 00000000 (Accepted) Result source diagnostic tag: 10100011 Result source diag. length: 00000101 Dialogue Service User tag: 10100001 Dialogue Service User length: 00000011 INTEGER type tag: 00000010 INTEGER length: 00000001 Dialogue service user value: 00000000 (NULL)

220

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_1_9_1_3 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.9.1.3 REFERENCE: 3.2.1.2/Q.774 TITLE: Valid functions; Dialogue Portion

Sheet: 1 of 2

SUBTITLE: Accept application context proposal; accept AARQ and end dialogue PURPOSE: To verify that an IUT can receive a Begin message with APDU AARQ and then can generate and send the dialogue control APDU ''AARE'' within the dialogue portion of an End message SP A ( TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (CSL)  TR-BEGIN ind. <============ TR-END req. ============> END (AARE)  SP B (CSL)

BEGIN (AARQ)

TEST DESCRIPTION 1. 2. Arrange for SP B to send a Begin message containing a dialogue request CHECK A: DOES THE DIALOGUE PORTION IN THE END MESSAGE CONTAIN THE APDU AARE AND IS THE APPLICATION CONTEXT THE SAME AS IN THE RECEIVED AARQ?

Recommendation Q.787 (09/97)

221

TEST NUMBER: 2.1.9.1.3

Sheet: 2 of 2

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN DIALOGUE PORTION Dialogue portion in End message Dialogue portion tag: 01101011 Dialogue portion length: correct number of octets External data type in dialogue portion External type tag: 00101000 External length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: 00000111 Direct reference: H''00118605010101 (structured dialogue abstract syntax) Single ASN.1 type tag: 10100000 Single ASN.1 type length: correct number of octets Dialogue PDU Dialogue Response tag: 01100001 Dialogue Response length: correct number of octets Application context tag: 10100001 Application context length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: correct number of octets Direct reference: same octets as in AARQ Result tag: 10100010 Result length: 00000011 INTEGER type tag: 00000010 INTEGER length: 00000001 Result value: 00000000 (Accepted) Result source diagnostic tag: 10100011 Result source diag. length: 00000101 Dialogue Service User tag: 10100001 Dialogue Service User length: 00000011 INTEGER type tag: 00000010 INTEGER length: 00000001 Dialogue service user value: 00000000 (NULL)

222

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_1_9_2_1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.9.2.1 REFERENCE: 3.2.1.2/Q.774 TITLE: Valid functions; Dialogue Portion

Sheet: 1 of 2

SUBTITLE: Propose alternative application context; Send AARE with alternative PURPOSE: To verify that an IUT can generate and send dialogue control APDU ''AARE'' with an alternative application context within the dialogue portion of a Continue message SP A ( TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP SP  TR-BEGIN ind. <============ TR-CONTINUE req. ============> CONTINUE (AARE)  B (CSL)

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (CSL)

BEGIN (AARQ)

TEST DESCRIPTION 1. 2. 3. Arrange for SP B to send a Begin message containing a dialogue request. Arrange for SP A to propose an alternative application context. CHECK A: DOES THE DIALOGUE PORTION IN THE CONTINUE MESSAGE CONTAIN THE APDU AARE AND IS THE APPLICATION CONTEXT DIFFERENT THAN THE ONE IN THE RECEIVED AARQ? Also arrange an END message to be sent by IUT or by the Tester. When the last message has been sent by Tester, the END message sent by IUT can be used to check that the last message has been correctly received.

Recommendation Q.787 (09/97)

223

TEST NUMBER: 2.1.9.2.1

Sheet: 2 of 2

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN DIALOGUE PORTION Dialogue portion in Continue message Dialogue portion tag: 01101011 Dialogue portion length: correct number of octets External data type in dialogue portion External type tag: 00101000 External length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: 00000111 Direct reference: H''00118605010101 (structured dialogue abstract syntax) Single ASN.1 type tag: 10100000 Single ASN.1 type length: correct number of octets Dialogue PDU Dialogue Response tag: 01100001 Dialogue Response length: correct number of octets Application context tag: 10100001 Application context length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: correct number of octets Direct reference: correct number of octets different than those in AARQ Result tag: 10100010 Result length: 00000011 INTEGER type tag: 00000010 INTEGER length: 00000001 Result value: 00000000 (Accepted) Result source diagnostic tag: 10100011 Result source diag. Length: 00000101 Dialogue Service User tag: 10100001 Dialogue Service User length: 00000011 INTEGER type tag: 00000010 INTEGER length: 00000001 Dialogue service user value: 00000000 (NULL)

224

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_1_9_2_2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.9.2.2 REFERENCE: 3.2.1.2/Q.774 TITLE: Valid functions; Dialogue Portion

Sheet: 1 of 2

SUBTITLE: Propose alternative application context; receive AARE with alternative PURPOSE: To verify that an IUT can accept the dialogue control APDU ''AARE'' with an alternative application context within the dialogue portion of a Continue message SP A ( TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (CSL) TR-BEGIN req. ============> BEGIN (AARQ)   TR-CONTINUE ind. <============ CONTINUE (AARE) SP B (CSL)

TEST DESCRIPTION 1. 2. 3. Arrange for SP A to send a Begin message containing a dialogue portion Arrange for SP B to confirm the dialogue proposing an alternative application context CHECK A: DOES THE IUT ACCEPT THE APDU ''AARE'' WITH THE ALTERNATIVE APPLICATION CONTEXT? Also arrange an END message to be sent by IUT or by the Tester. When the last message has been sent by Tester, the END message sent by IUT can be used to check that the last message has been correctly received.

Recommendation Q.787 (09/97)

225

TEST NUMBER: 2.1.9.2.2

Sheet: 2 of 2

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN DIALOGUE PORTION Dialogue portion in Continue message Dialogue portion tag: 01101011 Dialogue portion length: correct number of octets External data type in dialogue portion External type tag: 00101000 External length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: 00000111 Direct reference: H''00118605010101 (structured dialogue abstract syntax) Single ASN.1 type tag: 10100000 Single ASN.1 type length: correct number of octets Dialogue PDU Dialogue Response tag: 01100001 Dialogue Response length: correct number of octets Application context tag: 10100001 Application context length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: correct number of octets Direct reference: correct number of octets different than those in AARQ Result tag: 10100010 Result length: 00000011 INTEGER type tag: 00000010 INTEGER length: 00000001 Result value: 00000000 (Accepted) Result source diagnostic tag: 10100011 Result source diag. Length: 00000101 Dialogue Service User tag: 10100001 Dialogue Service User length: 00000011 INTEGER type tag: 00000010 INTEGER length: 00000001 Dialogue service user value: 00000000 (NULL)

226

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_1_9_3 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.9.3 REFERENCE: 3.2.1.2/Q.774 TITLE: Valid functions; Dialogue Portion SUBTITLE: Dialogue refused PURPOSE:

Sheet: 1 of 2

To verify that an IUT can generate and send dialogue control APDU ''AARE'' within the dialogue portion in an Abort message to indicate that the application context is not supported SP A ( TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (CSL)  TR-BEGIN ind. <============ TR- U - ABORT req. ============> ABORT (AARE)  SP B (CSL)

BEGIN (AARQ)

TEST DESCRIPTION 1. 2. 3. Arrange for SP B to send a Begin message containing a dialogue request. Arrange for SP A to refuse the dialogue because of application context not supported. CHECK A: DOES SP A TRANSMIT THE EXPECTED ABORT MESSAGE WITH APDU ''AARE''?

Recommendation Q.787 (09/97)

227

TEST NUMBER: 2.1.9.3

Sheet: 2 of 2

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN DIALOGUE PORTION Dialogue portion in Abort message Dialogue portion tag: 01101011 Dialogue portion length: correct number of octets External data type in dialogue portion External type tag: 00101000 External length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: 00000111 Direct reference: H''00118605010101 (structured dialogue abstract syntax ) Single ASN.1 type tag: 10100000 Single ASN.1 type length: correct number of octets Dialogue PDU Dialogue Response tag: 01100001 Dialogue Response length: correct number of octets Application context tag: 10100001 Application context length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: correct number of octets Direct reference: same octets as in dialogue request Result tag: 10100010 Result length: 00000011 INTEGER type tag: 00000010 INTEGER length: 00000001 Result value: 00000001 (Reject -Permanent) Result source diagnostic tag: 10100011 Result source length: 00000101 Dialogue Service User tag: 10100001 Dialogue Service User length: 00000011 INTEGER type tag: 00000010 INTEGER length: 00000001 Dialogue service user value: 00000010 (Application Context Not Supported)

228

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_1_9_4 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.9.4 REFERENCE: 3.2.1.2/Q.774 TITLE: Valid functions; Dialogue Portion SUBTITLE: Dialogue abort PURPOSE:

Sheet: 1 of 2

To verify that an IUT can generate and send the dialogue control APDU ''ABRT'' within the dialogue portion in an Abort message after the dialogue has been established SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (CSL) TR-BEGIN req. ============> BEGIN (AARQ)   TR-CONTINUE ind. <============ TR-U-ABORT req. ============> ABORT (U) (ABRT)  CONTINUE (AARE) SP B (CSL)

TEST DESCRIPTION 1. 2. 3. 4. Arrange for SP A to send a Begin message containing a dialogue portion Arrange for SP B to confirm the dialogue Arrange for SP A to Abort the dialogue for some reason. CHECK A: DOES THE DIALOGUE PORTION IN THE ABORT MESSAGE CONTAIN APDU ''ABRT''?

Recommendation Q.787 (09/97)

229

TEST NUMBER: 2.1.9.4

Sheet: 2 of 2

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN DIALOGUE PORTION Dialogue portion in Abort message Dialogue portion tag: 01101011 Dialogue portion length: correct number of octets External data type in dialogue portion External type tag: 00101000 External length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: 00000111 Direct reference: H''00118605010101 (structured dialogue abstract syntax ) Single ASN.1 type tag: 10100000 Single ASN.1 type length: correct number of octets Dialogue PDU Dialogue Abort tag: 01100100 Dialogue Abort length: 00000011 Abort Source tag: 10000000 Abort source length: 00000001 Abort source: 00000000 (dialogue service user)

230

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_1_9_5_1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.9.5.1 REFERENCE: 3.2.1.2/Q.774 TITLE: Valid functions; Dialogue Portion

Sheet: 1 of 2

SUBTITLE: Transport of User information; accept user information in Begin message PURPOSE: To verify that an IUT can receive a Begin message with APDU AARQ including an user information element SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (CSL)  TR-BEGIN ind. <============ SP B (CSL)

BEGIN (AARQ)

TEST DESCRIPTION 1. 2. Arrange for SP B to send a Begin message containing a dialogue request containing user information. CHECK A: DOES THE IUT ACCEPT USER INFORMATION IN THE RECEIVED DIALOGUE REQUEST? Also arrange an END message to be sent by IUT. The END message sent by IUT can be used to check that the last message has been correctly received.

Recommendation Q.787 (09/97)

231

TEST NUMBER: 2.1.9.5.1

Sheet: 2 of 2

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN DIALOGUE PORTION Dialogue portion in Begin message Dialogue portion tag: 01101011 Dialogue portion length: correct number of octets External data type in dialogue portion External type tag: 00101000 External length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: 00000111 Direct reference: H''00118605010101 (structured dialogue abstract syntax ) Single ASN.1 type tag: 10100000 Single ASN.1 type length: correct number of octets Dialogue PDU Dialogue Request tag: 01100000 Dialogue Request length: correct number of octets Application context tag: 10100001 Application context length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: correct number of octets Direct reference: any object identifier User information in dialogue PDU User Information tag: 10111110 User information length: correct number of octets External type tag: 00101000 External length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: correct number of octets Direct reference: any object identifier Single ASN.1 type tag: 10100000 (see Note) Single ASN.1 type length: correct number of octets Some bytes of user data in the user defined abstract syntax NOTE ­ This test can also be done with the 2 other encoding options ­ octet aligned and arbitrary.

232

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_1_9_5_2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.9.5.2 REFERENCE: 3.2.1.2/Q.774 TITLE: Valid functions; Dialogue Portion

Sheet: 1 of 2

SUBTITLE: Transport of User information; accept user information in first Continue message PURPOSE: To verify that an IUT can accept a Continue message with APDU ''AARE'' including a user information element SP A ( TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (CSL) TR-BEGIN req. ============> BEGIN (AARQ)   TR-CONTINUE ind. <============ CONTINUE (AARE) SP B (CSL)

TEST DESCRIPTION 1. 2. 3. Arrange for SP A to send a Begin message containing a dialogue portion. Arrange for SP B to confirm the dialogue including user information in the dialogue portion. CHECK A: DOES THE IUT ACCEPT USER INFORMATION IN THE RECEIVED DIALOGUE RESPONSE? Also arrange an END message to be sent by IUT or by the tester. When the last message has been sent by the tester, the END message sent by IUT can be used to check that the last message has been correctly received.

Recommendation Q.787 (09/97)

233

TEST NUMBER: 2.1.9.5.2

Sheet: 2 of 2

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN DIALOGUE PORTION Dialogue portion in Continue message Dialogue portion tag: 01101011 Dialogue portion length: correct number of octets External data type in dialogue portion External type tag: 00101000 External length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: 00000111 Direct reference: H''00118605010101 (structured dialogue abstract syntax ) Single ASN.1 type tag: 10100000 Single ASN.1 type length: correct number of octets Dialogue PDU Dialogue Response tag: 01100001 Dialogue Response length: correct number of octets Application context tag: 10100001 Application context length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: correct number of octets Direct reference: any object identifier Result tag: 10100010 Result length: 00000011 INTEGER type tag: 00000010 INTEGER length: 00000001 Result value: 00000000 (Accepted) Result source diagnostic tag: 10100011 Result source diag. Length: 00000101 Dialogue Service User tag: 10100001 Dialogue Service User length: 00000011 INTEGER type tag: 00000010 INTEGER length: 00000001 Dialogue service user value: 00000000 (NULL) User information in dialogue PDU User Information tag: 10111110 User information length: correct number of octets External type tag: 00101000 External length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: correct number of octets Direct reference: any object identifier Single ASN.1 type tag: 10100000 Single ASN.1 type length: correct number of octets Some bytes of user data in the user defined abstract syntax

234

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_1_9_5_4 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.9.5.4 REFERENCE: 3.2.1.2/Q.774 TITLE: Valid functions; Dialogue Portion

Sheet: 1 of 2

SUBTITLE: Transport of User information, accept several user information elements in Continue message PURPOSE: To verify that an IUT can accept a Continue message with APDU ''AARE'' including several user information elements SP A ( TSL) and SP B (TSL) are to be in the idle state and test cases 2.1.9.5.2 has to be executed successfully TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1 EXPECTED MESSAGE SEQUENCE: SP A (CSL) TR-BEGIN req. ============> BEGIN (AARQ)

SP

B

(CSL)

  CONTINUE (AARE)

TR-CONTINUE ind. <============

TEST DESCRIPTION 1. 2. 3. Arrange for SP A to send a Begin message containing a dialogue portion. Arrange for SP B to confirm the dialogue including user information elements in the dialogue portion. CHECK A: DOES THE IUT ACCEPT USER INFORMATION IN THE RECEIVED DIALOGUE RESPONSE? Also arrange an END message to be sent by IUT or by the Tester. When the last message has been sent by Tester, the END message sent by IUT can be used to check that the last message has been correctly received.

236

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.9.5.4

Sheet: 2 of 2

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN DIALOGUE PORTION Dialogue portion in Continue message Dialogue portion tag: 01101011 Dialogue portion length: correct number of octets External data type in dialogue portion External type tag: 00101000 External length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: 00000111 Direct reference: H''00118605010101 Single ASN.1 type tag: 10100000 Single ASN.1 type length: correct number of octets Dialogue PDU Dialogue Response tag: 01100001 Dialogue Response length: correct number of octets Application context tag: 10100001 Application context length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: correct number of octets Direct reference: any object identifier Result tag: 10100010 Result length: 00000011 INTEGER type tag: 00000010 INTEGER length: 00000001 Result value: 00000000 (Accepted) Result source diagnostic tag: 10100011 Result source diag. Length: 00000101 Dialogue Service User tag: 10100001 Dialogue Service User length: 00000011 INTEGER type tag: 00000010 INTEGER length: 00000001 Dialogue service user value: 00000000 (NULL) User information in dialogue PDU User Information tag: 10111110 User information length: correct number of octets External type tag: 00101000 (external number 1) External length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: correct number of octets Direct reference: any user defined abstract syntax Single ASN.1 type tag: 10100000 Single ASN.1 type length: correct number of octets Some bytes representing element 1 External type tag: 00101000 (external number 2) External length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: correct number of octets Direct reference: any user defined abstract syntax Single ASN.1 type tag: 10100000 Single ASN.1 type length: correct number of octets Some bytes of user data in user information element number 2

Recommendation Q.787 (09/97)

237

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_1_9_6 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.9.6 REFERENCE: 3.2.1.2/Q.774 TITLE: Valid functions; Dialogue Portion SUBTITLE: Unstructured dialogue PURPOSE:

Sheet: 1 of 1

To verify that the IUT can accept the dialogue control APDU ''AUDT'' in an Unidirectional message SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (CSL)  TR-UNI ind. <============ TEST DESCRIPTION 1. 2. Arrange SP B to send an Unidirectional message containing a dialogue portion to SP A. CHECK A: WAS THE UNIDIRECTIONAL MESSAGE WITH APDU ''AUDT'' CORRECTLY RECEIVED AT SP A? SP B (CSL)

UNIDIRECTIONAL (AUDT)

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES Dialogue portion in Unidirectional message Dialogue portion tag: 01101011 Dialogue portion length: correct number of octets External data type in dialogue portion External type tag: 00101000 External length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: 00000111 Direct reference: H''00118605010201 Single ASN.1 type tag: 10100000 Single ASN.1 type length: correct number of octets Dialogue PDU Dialogue Request tag: 01100000 Dialogue Request length: correct number of octets Application context tag: 10100001 Application context length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: correct number of octets Direct reference: any object identifier

238

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_1_9_7_1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.9.7.1 REFERENCE: 3.2.3/Q.774 TITLE: Valid functions; Dialogue Portion SUBTITLE: Dialogue control APDU Version Structured dialogue; Version not 1 PURPOSE:

Sheet: 1 of 2

To verify that an IUT can abort the dialogue if the first bit of the protocol version field in the dialogue request, is not set to 1. The dialogue has to be aborted with APDU ''AARE'' (reject permanent, no common dialogue) SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (CSL)  SP B (CSL)

BEGIN (AARQ)

TR-U-ABORT req. ============> ABORT (AARE) TEST DESCRIPTION 1. 2. Arrange for SP B to send a Begin message containing a dialogue request indicating that Version 1 is not supported CHECK A: DOES SP A TRANSMIT THE EXPECTED ABORT MESSAGE WITH APDU ''AARE'' INDICATING NO COMMON DIALOGUE PORTION? 

Recommendation Q.787 (09/97)

239

TEST NUMBER: 2.1.9.7.1

Sheet: 2 of 2

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN DIALOGUE PORTION Dialogue portion in Abort message Dialogue portion tag: 01101011 Dialogue portion length: correct number of octets External data type in dialogue portion External type tag: 00101000 External length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: 00000111 Direct reference: H''00118605010101 Single ASN.1 type tag: 10100000 Single ASN.1 type length: correct number of octets Dialogue PDU Dialogue Response tag: 01100001 Dialogue Response length: correct number of octets Application context tag: 10100001 Application context length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: correct number of octets Direct reference: same octets as in dialogue request Result tag: 10100010 Result length: 00000011 INTEGER type tag: 00000010 INTEGER length: 00000001 Result value: 00000001 (Reject-Permanent) Result source diagnostic tag: 10100011 Result source length: 00000101 Dialogue Service Provider tag: 10100010 Dialogue Service Provider length: 00000011 INTEGER type tag: 00000010 INTEGER length: 00000001 Dialogue service provider value: 00000010 (No common dialogue portion)

240

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_1_9_7_2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.9.7.2 REFERENCE: 3.2.3/Q.774 TITLE: Valid functions; Dialogue Portion SUBTITLE: Dialogue control APDU Version Structured dialogue; Version 1 PURPOSE:

Sheet: 1 of 1

To verify that an IUT can accept a dialogue request offering several versions including version 1. The IUT response must be of version 1 SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (CSL)  TR-BEGIN ind. <============ TR-CONTINUE req. ============> CONTINUE (AARE-V1) TEST DESCRIPTION 1. 2. Arrange for SP B to send a Begin message containing a dialogue request offering several versions including Version 1. CHECK A: DOES THE DIALOGUE PORTION IN THE CONTINUE MESSAGE CONTAIN THE APDU AARE AND IS IT OF VERSION 1?  SP B (CSL)

BEGIN (AARQ-Vx)

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN DIALOGUE PORTION Dialogue portion in Begin message Dialogue portion tag: 01101011 Dialogue portion length: correct number of octets External data type in dialogue portion External type tag: 00101000 External length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: 00000111 Direct reference: H''00118605010101 Single ASN.1 type tag: 10100000 Single ASN.1 type length: correct number of octets Dialogue PDU Dialogue Request tag: 01100000 Dialogue Request length: correct number of octets Protocol Version tag: 10000000 Protocol Version length: 00000010 Protocol Version: 00000110 11000000 (versions 1 and 2 supported) Application context tag: 10100001 Application context length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: correct number of octets Direct reference: any object identifier

Recommendation Q.787 (09/97)

241

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_2_2_5_2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.2.2.5.2 REFERENCE: 3.2.2.1/Q.774 TITLE: Syntactically invalid behaviour; Invalid structure SUBTITLE: Dialogue Portion; Incorrect length PURPOSE:

Sheet: 1 of 2

To verify that the IUT aborts the transaction upon reception of a Continue message containing an APDU ''AARE'' with an incorrect AARE length indicator SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (CSL) TR-BEGIN req. ============> BEGIN (AARQ) Detect syntax error TR-P-ABORT ind. <============ TR-U-ABORT req. ============> ABORT (ABRT)    CONTINUE (AARE) SP B (CSL)

TEST DESCRIPTION 1. 2. 3. 4. Arrange for SP A to send a Begin message containing a dialogue portion Arrange for SP B to confirm the dialogue with an incorrect AARE length indicator in the APDU AARE. CHECK A: DOES THE DIALOGUE PORTION IN THE ABORT MESSAGE CONTAIN APDU ''ABRT''? CHECK B: VERIFY THAT THE DIALOGUE AT SP A HAS BEEN TERMINATED.

264

Recommendation Q.787 (09/97)

TEST NUMBER: 2.2.2.5.2

Sheet: 2 of 2

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN DIALOGUE PORTION Dialogue portion in Continue message Dialogue portion tag: 01101011 Dialogue portion length: correct number of octets External data type in dialogue portion External type tag: 00101000 External length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: 00000111 Direct reference: H''00118605010101 Single ASN.1 type tag: 10100000 Single ASN.1 type length: correct number of octets Dialogue PDU Dialogue Response tag: 01100001 Dialogue Response length: 01111111 ( incorrect) Application context tag: 10100001 Application context length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: correct number of octets Direct reference: same octets as in dialogue request Result tag: 10100010 Result length: 00000011 INTEGER type tag: 00000010 INTEGER length: 00000001 Result value: 00000000 (Accepted) Result source diagnostic tag: 10100011 Result source length: 00000101 Dialogue Service User tag: 10100001 Dialogue Service User length: 00000011 INTEGER type tag: 00000010 INTEGER length: 00000001 Dialogue service user value: 00000000 ( Null)

Recommendation Q.787 (09/97)

265

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_3_4_1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.3.4.1 REFERENCE: 3.2.1.2/Q.774 TITLE: Inopportune Behaviour; Dialogue Portion SUBTITLE: Begin message with APDU AARE PURPOSE:

Sheet: 1 of 2

To verify that an IUT aborts the transaction on reception of a Begin message containing a dialogue portion that carries an APDU ''AARE'' SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (CSL) Detect semantic error TR-U-ABORT req ============> ABORT (U) (ABRT)   SP B (CSL)

BEGIN (AARE)

TEST DESCRIPTION 1. 2. Arrange for SP B to send a Begin message containing a dialogue response. CHECK A: DOES SP A TRANSMIT THE EXPECTED ABORT MESSAGE WITH APDU ''ABRT''?

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN DIALOGUE PORTION Dialogue portion in Abort message Dialogue portion tag: 01101011 Dialogue portion length: correct number of octets External data type in dialogue portion External type tag: 00101000 External length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: 00000111 Direct reference: H''00118605010101 Single ASN.1 type tag: 10100000 Single ASN.1 type length: correct number of octets Dialogue PDU Dialogue Abort tag: 01100100 Dialogue Abort length: 00000011 Abort Source tag: 10000000 Abort source length: 00000001 Abort source: 00000001 (dialogue service provider)

304

Recommendation Q.787 (09/97)

TEST NUMBER: 2.3.4.1

Sheet: 2 of 2

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN DIALOGUE PORTION Dialogue portion in Begin Dialogue portion tag: 01101011 Dialogue portion length: correct number of octets External data type in dialogue portion External type tag: 00101000 External length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: 00000111 Direct reference: H''00118605010101 Single ASN.1 type tag: 10100000 Single ASN.1 type length: 00011001 Dialogue PDU Dialogue Response tag: 01100001 Dialogue Response length: correct number of octets Application context tag: 10100001 Application context length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: correct number of octets Direct reference: any object identifier Result tag: 10100010 Result length: 00000011 INTEGER type tag: 00000010 INTEGER length: 00000001 Result value: 00000000 (Accepted) Result source diagnostic tag: 10100011 Result source diag. length: 00000101 Dialogue Service User tag: 10100001 Dialogue Service User length: 00000011 INTEGER type tag: 00000010 INTEGER length: 00000001 Dialogue service user value: 00000000 (NULL)

Recommendation Q.787 (09/97)

305

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_3_4_2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.3.4.2 REFERENCE: 3.2.2.1/Q.774 TITLE: Inopportune Behaviour; Dialogue Portion SUBTITLE: Dialogue confirmation with any APDU other than AARE PURPOSE:

Sheet: 1 of 2

To verify that an IUT aborts the transaction on reception of a Continue message containing a dialogue portion that carries an APDU ''AARQ'' SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (CSL) TR-BEGIN req. ============> BEGIN (AARQ) Detect semantic error TR-P-ABORT ind. <============ TR-U-ABORT req. ============> ABORT (U) (ABRT)    CONTINUE (AARQ) SP B (CSL)

TEST DESCRIPTION 1. 2. 3. 4. Arrange for SP A to send a Begin message containing a dialogue portion. Arrange for SP B to confirm the dialogue with a dialogue portion containing an AARQ APDU. CHECK A: DOES THE DIALOGUE PORTION IN THE ABORT MESSAGE CONTAIN APDU ''ABRT''? CHECK B: VERIFY THAT THE DIALOGUE AT SP A HAS BEEN TERMINATED.

306

Recommendation Q.787 (09/97)

TEST NUMBER: 2.3.4.2

Sheet: 2 of 2

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN DIALOGUE PORTION Dialogue portion in Continue message Dialogue portion tag: 01101011 Dialogue portion length: correct number of octets External data type in dialogue portion External type tag: 00101000 External length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: 00000111 Direct reference: H''00118605010101 Single ASN.1 type tag: 10100000 Single ASN.1 type length: correct number of octets Dialogue PDU Dialogue Request tag: 01100000 Dialogue Request length: correct number of octets Application context tag: 10100001 Application context length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: correct number of octets Direct reference: any object identifier Dialogue portion in Abort message Dialogue portion tag: 01101011 Dialogue portion length: 00010010 External data type in dialogue portion External type tag: 00101000 External length: 00010000 Object Identifier tag: 00000110 Object Identifier length: 00000111 Direct reference: H''00118605010101 Single ASN.1 type tag: 10100000 Single ASN.1 type length: 00000101 Dialogue PDU Dialogue Abort tag: 01100100 Dialogue Abort length: 00000011 Abort Source tag: 10000000 Abort source length: 00000001 Abort source: 00000001 (dialogue service provider)

Recommendation Q.787 (09/97)

307

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_3_4_3 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.3.4.3 REFERENCE: 3.2.2.1/Q.774 TITLE: Inopportune Behaviour; Dialogue Portion SUBTITLE: Dialogue confirmation with APDU ABRT PURPOSE:

Sheet: 1 of 2

To verify that an IUT aborts the transaction on reception of a Continue message containing a dialogue portion that carries an ''ABRT'' APDU SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (CSL) TR-BEGIN req. ============> BEGIN (AARQ) Detect semantic error TR-P-ABORT ind. <============ TR-U-ABORT req. ============> ABORT (U) (ABRT)    CONTINUE (ABRT) SP B (CSL)

TEST DESCRIPTION 1. 2. 3. 4. Arrange for SP A to send a Begin message containing a dialogue portion. Arrange for SP B to confirm the dialogue with a dialogue portion containing a ABRT APDU. CHECK A: DOES THE DIALOGUE PORTION IN THE ABORT MESSAGE CONTAIN APDU ''ABRT''? (refer to test number 2.3.4.2 check table for ABRT). CHECK B: VERIFY THAT THE DIALOGUE AT SP A HAS BEEN TERMINATED.

308

Recommendation Q.787 (09/97)

TEST NUMBER: 2.3.4.3

Sheet: 2 of 2

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN DIALOGUE PORTION Dialogue portion in Continue message Dialogue portion tag: 01101011 Dialogue portion length: 00010010 External data type in dialogue portion External type tag: 00101000 External length: 00010000 Object Identifier tag: 00000110 Object Identifier length: 00000111 direct reference: H''00118605010101 Single ASN.1 type tag: 10100000 Single ASN.1 type length: 00000101 Dialogue PDU Dialogue Abort tag: 01100100 Dialogue Abort length: 00000011 Abort Source tag: 10000000 Abort source length: 00000001 Abort source: 00000001 (dialogue service provider)

Recommendation Q.787 (09/97)

309

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_3_4_5 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.3.4.5 REFERENCE: 3.2.2.1/Q.774 TITLE: Inopportune Behaviour; Dialogue Portion SUBTITLE: Unidirectional message with unexpected abstract syntax PURPOSE:

Sheet: 1 of 1

To verify that an IUT discards an UNIDIRECTIONAL message containing a dialogue portion that is referring to an unexpected abstract syntax SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (CSL) Detect error  SP B (CSL)

UNIDIRECTIONAL (AARQ)

TEST DESCRIPTION 1. 2. Arrange for SP B to send a Unidirectional message containing a dialogue portion but referring to the structured dialogue abstract syntax. CHECK A: DOES SP A DISCARD THE MESSAGE?

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES Dialogue portion in Unidirectional message Dialogue portion tag: 01101011 Dialogue portion length: correct number of octets External data type in dialogue portion External type tag: 00101000 External length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: 00000111 Direct reference: H''00118605010101 (structured dialogue abstract syntax) Single ASN.1 type tag: 10100000 Single ASN.1 type length: correct number of octets Dialogue PDU Dialogue Request tag: 01100000 Dialogue Request length: correct number of octets Application context tag: 10100001 Application context length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: correct number of octets Direct reference: any object identifier

312

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_3_4_6 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.3.4.6 REFERENCE: 3.2.2.1/Q.774 TITLE: Inopportune Behaviour; Dialogue Portion SUBTITLE: Unexpected dialogue portion in Continue message PURPOSE:

Sheet: 1 of 1

To verify that an IUT aborts the transaction on reception of a Continue message which includes a dialogue portion while no dialogue portion was sent in the Begin message SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (CSL) TR-BEGIN req. ============> BEGIN Detect error TR-P-ABORT ind. <============ TR-U-ABORT req ============> ABORT (U) (ABRT)    CONTINUE (AARE) SP B (CSL)

TEST DESCRIPTION 1. 2. 3. 4. Arrange for SP A to send a Begin message (without dialogue portion) Arrange for SP B to confirm the dialogue with a dialogue portion containing an AARE APDU. (Refer to check table of test number 2.3.4.4.) CHECK A: DOES THE DIALOGUE PORTION IN THE ABORT MESSAGE CONTAIN APDU ''ABRT''? (Refer to check table of test number 2.3.4.2.) CHECK B: VERIFY THAT THE DIALOGUE AT SP A HAS BEEN TERMINATED.

Recommendation Q.787 (09/97)

313

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_3_4_7 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.3.4.7 REFERENCE: 3.2.2.1/Q.774 TITLE: Inopportune Behaviour; Dialogue Portion SUBTITLE: Missing dialogue portion in Continue message PURPOSE:

Sheet: 1 of 1

To verify that an IUT aborts the transaction on reception of a Continue message without dialogue portion while a dialogue portion was sent in the Begin message SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (CSL) TR-BEGIN req. ============> BEGIN (AARQ) Detect error TR-P-ABORT ind. <============ TR-U-ABORT req ============> ABORT (U) (ABRT)    CONTINUE SP B (CSL)

TEST DESCRIPTION 1. 2. 3. Arrange for SP A to send a Begin message containing a dialogue portion. Arrange for SP B to confirm the dialogue with a Continue without a dialogue portion. CHECK A: VERIFY THAT THE DIALOGUE AT SP A HAS BEEN TERMINATED.

314

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787CommonSpecTest >> spec2_3_4_8 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.3.4.8 REFERENCE: 3.2.2.1/Q.774 TITLE: Inopportune Behaviour; Dialogue Portion SUBTITLE: Begin message with unexpected abstract syntax PURPOSE:

Sheet: 1 of 1

To verify that an IUT aborts the transaction on reception of a Begin message containing a dialogue portion referring to an unexpected abstract syntax SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT and CPT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (CSL) Detect error TR-U-ABORT req ============> ABORT (U) (ABRT) TEST DESCRIPTION 1. 2. Arrange for SP B to send a Begin message containing a dialogue portion referring to an unknown abstract syntax. CHECK A: DOES SP A TERMINATE THE TRANSACTION?   SP B (CSL)

BEGIN (AUDT)

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN DIALOGUE PORTION Dialogue portion in Begin Dialogue portion tag: 01101011 Dialogue portion length: correct number of octets External data type in dialogue portion External type tag: 00101000 External length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: 00000111 Direct reference: H''00118605010201 ( unstructured abstract syntax ) Single ASN.1 type tag: 10100000 Single ASN.1 type length: correct number of octets Dialogue PDU Dialogue Request tag: 01100000 Dialogue Request length: correct number of octets Application context tag: 10100001 Application context length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: correct number of octets Direct reference: any object identifier

Recommendation Q.787 (09/97)

315

'
]

{ #category : #tests }
Q787CommonSpecTest >> test1_1_2_1_1s1 [
	| env  transaction |
	env := self given: #shouldCreateTestEnvironment.
	env servicePointB autoMessageDispatch: false.
	
	transaction := self sendTrBegin: env userData: ASN1Dictionary new.
	transaction requestPreArrangedEndWithUserData: nil.

	"CHECK A"
	self flag:#needsToBeExtended.
	self assert: env servicePointA didSendMessage.
	"CHECK B"
	self assert:env servicePointA sentPackets size = 1.
	"CHECK C"
	self assert: env servicePointA isIdle.
	self assert: env servicePointA didSendMessage.

	"CHECK information elements"
	self checkBegin: env servicePointA sentPackets first.
]

{ #category : #tests }
Q787CommonSpecTest >> test1_1_2_1_1s2 [
	| env transaction |
	env := self given: #shouldCreateTestEnvironment.
	env servicePointB autoMessageDispatch: false.
	transaction := self sendTrBegin: env userData: ASN1Dictionary new.
	env servicePointA transactionCoordinator 
		requestTrUAbort: nil
		transaction: transaction.
		
	"CHECK A"
	self flag:#needsToBeExtended.
	self assert: env servicePointA didSendMessage.
	"CHECK B"
	self assert: env servicePointA didSendMessage.
	"CHECK C"
	self assert: env servicePointA isIdle.

	"CHECK information elements"
	self checkBegin: env servicePointA sentPackets first.

]

{ #category : #tests }
Q787CommonSpecTest >> test1_1_2_1_2_1s1 [
	| env  begin end endCalled |
	env := self given: #shouldCreateTestEnvironment.
	
	env servicePointA onDialogue: [ :dialogue|
		dialogue onBegin: [ 
			env servicePointA transactionCoordinator  
				requestTrEnd: self createDialogueResponse  
				transaction: dialogue transaction ] ].
	
	env servicePointB newDialogue
		onEnd: [ endCalled := true ];
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
		
	"SP A received the message" 
	self assert: env servicePointA didReceiveMessage.
	begin := self checkBegin: env servicePointA receivedPackets first.

	"SP A sent abort message"
	self assert: env servicePointA didSendMessage.
	end := self checkEnd: env servicePointA sentPackets first.
	
	"ids are corresponding"
	self assert:  (end findKey: 'dtid') = (begin findKey: 'otid').
	self assert: env servicePointA isIdle.	
	
	self assert: endCalled notNil
]

{ #category : #tests }
Q787CommonSpecTest >> test1_1_2_1_2_1s2 [
	| env  endCalled |
	env := self given: #shouldCreateTestEnvironment.
	
	env servicePointA onDialogue: [ :dialogue|
		dialogue onBegin: [ 
			env servicePointA transactionCoordinator  
				requestTrEnd: nil
				transaction: dialogue transaction ] ].
	
	env servicePointB newDialogue
		onEnd: [ endCalled := true ];
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
		
	"SP A received the message" 
	self assert: env servicePointA didReceiveMessage.
	self checkBegin: env servicePointA receivedPackets first.

	"SP A sent abort message"
	self deny: env servicePointA didSendMessage.
	
	self assert: env servicePointA isIdle.	
	
	self assert: endCalled isNil
]

{ #category : #tests }
Q787CommonSpecTest >> test1_1_2_1_2_1s3 [
	| env  begin abort |
	env := self given: #shouldCreateTestEnvironment.
	env servicePointA onDialogue: [ :dialogue|
		dialogue onBegin: [ 
			dialogue requestTcUAbort:  nil ] ].
	
	env servicePointB newDialogue
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
		
	"SP A received the message" 
	self assert: env servicePointA didReceiveMessage.
	begin := self checkBegin: env servicePointA receivedPackets first.

	"SP A sent abort message"
	self assert: env servicePointA didSendMessage.
	abort := self checkAbort: env servicePointA sentPackets first.
	
	"ids are corresponding"
	self assert:  (abort findKey: 'dtid') = (begin findKey: 'otid').
	self assert: env servicePointA isIdle.	
]

{ #category : #tests }
Q787CommonSpecTest >> test1_1_2_1_2_2s1 [
	| env begin abort abortHandlerCalled |
	env := self given: #shouldCreateTestEnvironment.
	env servicePointB onDialogue: [ :dialogue|
		dialogue onBegin: [ 
			dialogue requestTcUAbort: nil ] ].
	
	env servicePointA newDialogue
		onUAbort: [ abortHandlerCalled := true ]; 
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
			
	"SP A received the message" 
	self assert: env servicePointA didSendMessage.
	begin := self checkBegin: env servicePointA sentPackets first.

	"SP A sent abort message"
	self assert: env servicePointA didReceiveMessage.
	abort := self checkUAbort: env servicePointA receivedPackets first.

	self assert: env servicePointA isIdle.
	self assert: (abort findKey: 'dtid') = (begin findKey: 'otid').	
	self assert: abortHandlerCalled notNil.
		
	self assert: env hasInitialState
]

{ #category : #tests }
Q787CommonSpecTest >> test1_1_2_1_2_2s3 [
	| env begin end |
	env := self given: #shouldCreateTestEnvironment.
	env servicePointB onDialogue: [ :dialogue|
		dialogue onBegin: [ 
			env servicePointB transactionCoordinator  
				requestTrEnd: self createDialogueResponse 
				transaction: dialogue transaction ] ].
	
	env servicePointA newDialogue
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
			
	"SP A received the message" 
	self assert: env servicePointA didSendMessage.
	begin := self checkBegin: env servicePointA sentPackets first.

	"SP A sent abort message"
	self assert: env servicePointA didReceiveMessage.
	end := self checkEnd: env servicePointA receivedPackets first.

	self assert: env servicePointA isIdle.
	self assert: (end findKey: 'dtid') = (begin findKey: 'otid').	
		
	self assert: env hasInitialState
]

{ #category : #tests }
Q787CommonSpecTest >> test1_1_2_2_1_1s1 [
	| env continue end continueCalled endCalled |
	env := self given: #shouldCreateTestEnvironment.
	env servicePointB onDialogue: [ :dialogue|
		dialogue 
			onBegin: [ dialogue requestTcContinue ];
			onEnd: [ endCalled := true ] ].
	
	env servicePointA newDialogue
		onContinue: [ :received |
			continueCalled := true.
			env servicePointA transactionCoordinator 
				requestTrEnd: self createDialogueResponse  
				transaction: received dialogue transaction]; 
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
			
	self assert: env servicePointA didSendMessage.
	self checkBegin: env servicePointA sentPackets first.

	self assert: env servicePointA didReceiveMessage.
	continue := self checkContinue: env servicePointA receivedPackets first.
	self assert: continue isContinue.

	self assert: env servicePointA sentPackets size = 2.
	end := self checkEnd: env servicePointA sentPackets second.
	
	self assert: (end findKey: 'dtid') = (continue findKey: 'otid').
	self assert: env servicePointA isIdle.
	self assert: continueCalled notNil.	
	self assert: endCalled notNil.	
	self assert: env hasInitialState
]

{ #category : #tests }
Q787CommonSpecTest >> test1_1_2_2_1_1s2 [
	| env continue continueCalled endCalled |
	env := self given: #shouldCreateTestEnvironment.
	
	env servicePointB onDialogue: [ :dialogue|
		dialogue 
			onBegin: [ dialogue requestTcContinue ];
			onEnd: [ endCalled := true ] ].
	
	env servicePointA newDialogue
		onContinue: [ :cont  |
			continueCalled := true.
			env servicePointA transactionCoordinator 
				requestTrEnd: nil
				transaction: cont dialogue transaction]; 
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
			
	self assert: env servicePointA didSendMessage.
	self checkBegin: env servicePointA sentPackets first.

	self assert: env servicePointA didReceiveMessage.
	continue := self checkContinue: env servicePointA receivedPackets first.
	self assert: continue isContinue.

	self assert: continueCalled notNil.	
	self assert: env servicePointA sentPackets size = 1.
	self deny: endCalled notNil.
	
	self assert: env servicePointA isIdle.
	self deny: env hasInitialState
]

{ #category : #tests }
Q787CommonSpecTest >> test1_1_2_2_1_1s3 [
	| env continue abort continueCalled |
	env := self given: #shouldCreateTestEnvironment.
	env servicePointB onDialogue: [ :dialogue|
		dialogue onBegin: [
			dialogue requestTcContinue ] ].
	
	env servicePointA newDialogue
		onContinue: [ :cont |
			continueCalled := true.
			env servicePointA transactionCoordinator 
				requestTrUAbort: TCAPDialogueUAbort serviceUser pdu
				transaction: cont dialogue transaction]; 
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
			
	self assert: env servicePointA didSendMessage.
	self checkBegin: env servicePointA sentPackets first.

	self assert: env servicePointA didReceiveMessage.
	continue := self checkContinue: env servicePointA receivedPackets first.
	self assert: continue isContinue.

	self assert: env servicePointA sentPackets size = 2.
	abort := self checkUAbort: env servicePointA sentPackets second.
	
	self assert: (abort findKey: 'dtid') = (continue findKey: 'otid').
	self assert: env servicePointA isIdle.
	self assert: continueCalled notNil.	
	self assert: env hasInitialState
]

{ #category : #tests }
Q787CommonSpecTest >> test1_1_2_2_1_2s1 [
	| env continue end continueCalled |
	env := self given: #shouldCreateTestEnvironment.
	env servicePointA onDialogue: [ :dialogue|
		dialogue onBegin: [
			dialogue requestTcContinue ] ].
	
	env servicePointB newDialogue
		onContinue: [ :cont |
			continueCalled := true.
			env servicePointA transactionCoordinator 
				requestTrEnd: self createDialogueResponse 
				transaction: cont dialogue transaction]; 
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
			
	self assert: env servicePointB didSendMessage.
	self checkBegin: env servicePointB sentPackets first.

	self assert: env servicePointA didSendMessage.
	continue := self checkContinue: env servicePointA sentPackets first.
	self assert: continue isContinue.

	self assert: env servicePointB sentPackets size = 2.
	end := self checkEnd: env servicePointB sentPackets second.
	
	self assert: (end findKey: 'dtid') = (continue findKey: 'otid').
	self assert: env servicePointA isIdle.
	self assert: continueCalled notNil.	
	self assert: env hasInitialState
]

{ #category : #tests }
Q787CommonSpecTest >> test1_1_2_2_1_2s2 [
	| env continue abort  continueCalled abortCalled |
	env := self given: #shouldCreateTestEnvironment.
	env servicePointA onDialogue: [ :dialogue|
		dialogue 
			onBegin: [ dialogue requestTcContinue ];
			onPAbort: [  abortCalled := true ] ].
	
	env servicePointB newDialogue
		onContinue: [ :cont |
			continueCalled := true.
			env servicePointA transactionCoordinator requestTrPAbort: TCAPDialoguePAbort unrecognizedMessageType transaction: cont dialogue transaction]; 
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
			
	self assert: env servicePointA didReceiveMessage.
	self checkBegin: env servicePointA receivedPackets first.

	self assert: env servicePointA didSendMessage.
	continue := self checkContinue: env servicePointA sentPackets first.

	self assert: env servicePointA receivedPackets size = 2.
	abort := self checkPAbort: env servicePointA receivedPackets second.
	self assert: abort isAbort.
	
	self assert: continueCalled notNil.
	self assert: abortCalled notNil.
	
	self assert: (abort findKey: 'dtid') = (continue findKey: 'otid').
	self assert: env servicePointA isIdle.
	self assert: env hasInitialState
]

{ #category : #tests }
Q787CommonSpecTest >> test1_1_2_2_1_2s3 [
	| env continue abort  continueCalled abortCalled |
	env := self given: #shouldCreateTestEnvironment.
	env servicePointA onDialogue: [ :dialogue|
		dialogue 
			onBegin: [ dialogue requestTcContinue ];
			onUAbort: [ abortCalled := true ] ].
	
	env servicePointB newDialogue
		onContinue: [ :cont |
			continueCalled := true.
			cont dialogue transaction requestTrUAbort: TCAPDialogueUAbort serviceUser pdu]; 
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
			
	self assert: env servicePointA didReceiveMessage.
	self checkBegin: env servicePointA receivedPackets first.
	self assert: env servicePointA didSendMessage.
	continue := self checkContinue: env servicePointA sentPackets first.
	self assert: env servicePointA receivedPackets size = 2.
	abort := self checkUAbort: env servicePointA receivedPackets second.
	
	self assert: continueCalled notNil.
	self assert: abortCalled notNil.
	
	self assert: (abort findKey: 'dtid') = (continue findKey: 'otid').
	self assert: env servicePointA isIdle.

]

{ #category : #tests }
Q787CommonSpecTest >> test1_1_2_2_2_1s1 [
	| env  |
	env := self given: #shouldCreateTestEnvironment.
	env servicePointA onDialogue: [ :dialogue|
		dialogue 
			onBegin: [ 
				dialogue requestTcContinue.
				dialogue transactionCoordinator 
					requestTrEnd: self createDialogueResponse 
					transaction: dialogue transaction ] ].
	
	env servicePointB newDialogue
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
			
	self assert: env servicePointA didReceiveMessage.
	self checkBegin: env servicePointA receivedPackets first.
	self assert: env servicePointA didSendMessage.
	self checkContinue: env servicePointA sentPackets first.
	self assert: env servicePointA sentPackets size = 2.
	self checkEnd: env servicePointA sentPackets second.

		
	self assert: env servicePointA isIdle.
	self assert: env hasInitialState
]

{ #category : #tests }
Q787CommonSpecTest >> test1_1_2_2_2_1s2 [
	| env  |
	env := self given: #shouldCreateTestEnvironment.
	env servicePointA onDialogue: [ :dialogue|
		dialogue 
			onBegin: [ 
				dialogue requestTcContinue.
				dialogue transactionCoordinator 
					requestTrEnd: nil
					transaction: dialogue transaction ] ].
	
	env servicePointB newDialogue
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
			
	self assert: env servicePointA didReceiveMessage.
	self checkBegin: env servicePointA receivedPackets first.
	self assert: env servicePointA didSendMessage.
	self checkContinue: env servicePointA sentPackets first.
	self assert: env servicePointA sentPackets size = 1.
		
	self assert: env servicePointA isIdle.
	self deny: env hasInitialState
]

{ #category : #tests }
Q787CommonSpecTest >> test1_1_2_2_2_1s3 [
	| env  |
	env := self given: #shouldCreateTestEnvironment.
	env servicePointA onDialogue: [ :dialogue|
		dialogue 
			onBegin: [ 
				dialogue requestTcContinue.
				dialogue requestTcUAbort: nil ] ].
	
	env servicePointB newDialogue
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
			
	self assert: env servicePointA didReceiveMessage.
	self checkBegin: env servicePointA receivedPackets first.
	self assert: env servicePointA didSendMessage.
	self checkContinue: env servicePointA sentPackets first.
	self assert: env servicePointA sentPackets size = 2.
		
	self assert: env servicePointA isIdle.
	self assert: env hasInitialState
]

{ #category : #tests }
Q787CommonSpecTest >> test1_1_2_2_2_2s1 [
	| env  |
	env := self given: #shouldCreateTestEnvironment.
	env servicePointB onDialogue: [ :dialogue|
		dialogue 
			onBegin: [ 
				dialogue requestTcContinue.
				dialogue transactionCoordinator 
					requestTrEnd: self createDialogueResponse 
					transaction: dialogue transaction ] ].
	
	env servicePointA newDialogue
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
			
	self assert: env servicePointB didReceiveMessage.
	self checkBegin: env servicePointB receivedPackets first.
	self assert: env servicePointB didSendMessage.
	self checkContinue: env servicePointB sentPackets first.
	self assert: env servicePointB sentPackets size = 2.
	self checkEnd: env servicePointB sentPackets second.
		
	self assert: env servicePointA isIdle.
	self assert: env hasInitialState
]

{ #category : #tests }
Q787CommonSpecTest >> test1_1_2_2_2_2s3 [
	| env  |
	env := self given: #shouldCreateTestEnvironment.
	env servicePointB onDialogue: [ :dialogue|
		dialogue 
			onBegin: [ 
				dialogue requestTcContinue.
				dialogue transactionCoordinator 
					requestTrUAbort: TCAPDialogueUAbort serviceUser pdu
					transaction: dialogue transaction ] ].
	
	env servicePointA newDialogue
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
			
	self assert: env servicePointB didReceiveMessage.
	self checkBegin: env servicePointB receivedPackets first.
	self assert: env servicePointB didSendMessage.
	self checkContinue: env servicePointB sentPackets first.
	self assert: env servicePointB sentPackets size = 2.
	self checkUAbort: env servicePointB sentPackets second.
		
	self assert: env servicePointA isIdle.
	self assert: env hasInitialState
]

{ #category : #tests }
Q787CommonSpecTest >> test2_1_1_1_1 [
	| env dialogue invocation called |
	env := self given: #shouldCreateTestEnvironment.
	
	env servicePointB
		onDialogue: [ :dialog |
			 dialog 
				onInvoke: [ : inv | 
					inv returnResultLast: self exampleResult.
					dialog requestTcContinue ]].
	dialogue := env servicePointA newDialogue.	
	invocation :=dialogue requestTcInvokeNamed: 'sendAuthenticationInfoV2' parameters:  '123456789' class: TCAPReportSuccessAndFailure timeout: 500.
	invocation onReturnLast: [ :result |  called := true ].
	dialogue 
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: '0.4.0.0.1.0.14.2'.
	
	self assert: env servicePointA didSendMessage.
	self checkBegin: env servicePointA sentPackets first.
	self checkContinue: env servicePointA receivedPackets first.
	self assert: called notNil

]

{ #category : #tests }
Q787CommonSpecTest >> test2_1_1_1_2 [
	| env dialogue invocation called |
	env := self given: #shouldCreateTestEnvironment.
	
	env servicePointB
		onDialogue: [ :dialog |
			 dialog 
				onInvoke: [ : inv | 
					inv returnResultLast: self exampleResult.
					dialog requestTcContinue ]].
	dialogue := env servicePointA newDialogue.	
	invocation :=dialogue 
		requestTcInvokeNamed: 'sendAuthenticationInfoV2' 
		parameters:  '123456789' 
		class: TCAPReportSuccessAndFailure 
		timeout: 10.
	invocation onReturnLast: [ :result |  called := true ].
	dialogue 
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: '0.4.0.0.1.0.14.2'.
	
	self assert: env servicePointA didSendMessage.
	self checkBegin: env servicePointA sentPackets first.
	self checkContinue: env servicePointA receivedPackets first.
	self assert: called notNil

]

{ #category : #tests }
Q787CommonSpecTest >> test2_1_1_1_3 [
	| env dialogue invocation called |
	env := self given: #shouldCreateTestEnvironment.
	
	env servicePointB
		onDialogue: [ :dialog |
			 dialog 
				onInvoke: [ : inv | 
					inv returnError: 'systemFailure' with: nil.
					dialog requestTcEnd: false ]].
	dialogue := env servicePointA newDialogue.	
	invocation :=dialogue 
		requestTcInvokeNamed: 'sendAuthenticationInfoV2' 
		parameters:  '123456789' 
		class: TCAPReportSuccessAndFailure 
		timeout: 10.
	invocation onError: [ :result |  called := true ].
	dialogue 
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: '0.4.0.0.1.0.14.2'.
	
	self assert: env servicePointA didSendMessage.
	self checkBegin: env servicePointA sentPackets first.
	self checkEnd: env servicePointA receivedPackets first.
	self assert: called notNil

]

{ #category : #tests }
Q787CommonSpecTest >> test2_1_1_1_5 [
	| env dialogue invocation called  |
	env := self given: #shouldCreateTestEnvironment.
	"env servicePointB
		onDialogue: [ :dialog |
			 dialog 
				onInvoke: [ : inv | 
					inv returnError: 'systemFailure' with: nil.
					dialog requestTcEnd: false ]]."
	dialogue := env servicePointA newDialogue.	
	invocation := dialogue newInvocationForName: 'sendAuthenticationInfoV2'  parameters:  '123456789'.
	invocation onLCancel: [ :result | called := true ].
	dialogue invoke: invocation withTimeout: 0 seconds.
	dialogue 
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: '0.4.0.0.1.0.14.2'.
	Processor yield.
	(Delay forSeconds: 1) wait.
	self assert: env servicePointA didSendMessage.
	self checkBegin: env servicePointA sentPackets first.
	self assert: called notNil

]
