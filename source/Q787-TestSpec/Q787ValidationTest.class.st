Class {
	#name : #Q787ValidationTest,
	#superclass : #Q787CommonSpecTest,
	#category : #'Q787-TestSpec'
}

{ #category : #'as yet unclassified' }
Q787ValidationTest class >> isAbstract [
	^ false
]

{ #category : #'as yet unclassified' }
Q787ValidationTest >> addExtraElementAfterDtidBlock [
	^ [ :bytes| | insp |
		insp := TCAPMessageInspector packet: bytes.
		"insert bogus p-abortcause"
		insp taggedValue elements add: (ASN1EncodedPrimitiveValue new tag: (ASN1Tag clazz: 'APPLICATION' number:10); contents: 3) afterIndex: 2.
		insp updatePacketFromTaggedValue; packet ].
	
]

{ #category : #'as yet unclassified' }
Q787ValidationTest >> authInfoV3Arguments [
	^ (self newValueOfTypeNamed: 'SendAuthenticationInfoArgV3')
		at: 'imsi' put: (ByteArray readHexFrom: '72040800004067F4');
		at: 'numberOfRequestedVectors' put: 4;
		yourself
]

{ #category : #spec }
Q787ValidationTest >> spec1_1_2_1_2_2s2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.1.2.1.2.2 2) REFERENCE: 3.3.3.2.1/Q.774 and 3.3.4/Q.774 TITLE: Valid function; Structured dialogue

Sheet: 1 of 1

SUBTITLE: Clearing before subsequent Message; Valid clearing from responding side; IUT receiving; Abort by transaction sublayer PURPOSE: To verify that the signalling point A is able to terminate a transaction on reception of an Abort (P) message SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (TSL) TR-BEGIN req. ============> BEGIN   TR-P-ABORT ind. <============ TEST DESCRIPTION 1. 2. 3. 4. 5. Send a Begin message from SP A to SP B. Arrange for SP B to send an P-Abort message to SP A. CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? CHECK B: WAS THE ABORT MESSAGE CORRECTLY RECEIVED AT SP A? CHECK C: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A? ABORT (P) SP B (TSL)

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets ABORT (P) Message type tag: 01100111 Message type length: correct number of octets Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) P-Abort cause tag: 01001010 P-Abort cause length: one octet P-Abort cause value: INTEGER (between 0 and 4)

Recommendation Q.787 (09/97)

15

'
]

{ #category : #spec }
Q787ValidationTest >> spec1_1_2_2_2_2s2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.1.2.2.2.2 2) REFERENCE: 3.3.3.2.1/Q.774 and 3.3.4/Q.774 TITLE: Valid function; Structured dialogue

Sheet: 1 of 2

SUBTITLE: Clearing after continue Message; Valid clearing from responding side; IUT receiving; Abort by the transaction sublayer PURPOSE: To verify that the signalling point A is able to terminate the transaction on reception of an Abort (P) message following a Continue message SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (TSL) TR-BEGIN req. ============> BEGIN   TR-CONTINUE ind. <============  TR-P-ABORT ind. <============ ABORT (P) CONTINUE SP B (TSL)

TEST DESCRIPTION 1. 2. 3. 4. 5. 6. 7. Arrange for SP A to send a Begin message to SP B. Arrange for SP B to respond with a Continue message. Terminate the transaction with an Abort (P) message from SP B. CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? CHECK B: WAS THE CONTINUE MESSAGE CORRECTLY RECEIVED AT SP A? CHECK C: WAS THE ABORT MESSAGE CORRECTLY RECEIVED AT SP A? CHECK D: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?

Recommendation Q.787 (09/97)

37

TEST NUMBER: 1.1.2.2.2.2 2) CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets CONTINUE Message type tag: 01100101 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets ABORT (P) Message type tag: 01100111 Message type length: correct number of octets Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) P-Abort cause tag: 01001010 P-Abort cause length: one octet P-Abort cause value: INTEGER (0 .. 4)

Sheet: 2 of 2

38

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787ValidationTest >> spec1_1_2_3_1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.1.2.3.1 REFERENCE: 3.2.1.3/Q.774 TITLE: Valid function; Structured dialogue

Sheet: 1 of 2

SUBTITLE: Clearing after continue Message (component portion not present); Basic ending IUT sending PURPOSE: To verify that SP A is able to accept a Continue message without CP SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (TSL) TR-BEGIN req. ============> BEGIN   TR-CONTINUE ind. <============ TR-END req. ============> END  CONTINUE SP B (TSL)

TEST DESCRIPTION 1. 2. 3. 4. 5. 6. 7. Arrange for SP A to send a Begin message to SP B. Arrange for SP B to send a Continue message to SP A without CP. Arrange for SP A to send an End message to SP B CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? CHECK B: WAS THE CONTINUE MESSAGE CORRECTLY RECEIVED AT SP A? CHECK C: WAS THE END MESSAGE CORRECTLY SENT FROM SP A? CHECK D: WAS THE TSL STATE MACHINE LEFT IN THE IDLE STATE AT SP A?

Recommendation Q.787 (09/97)

41

TEST NUMBER: 1.1.2.3.1 CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets (range 1-4) Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets CONTINUE Message type tag: 01100101 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets (range 1-4) Originating transaction ID value: OCTET STRING (1-4 octets long) Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets (range 1-4) Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) END Message type tag: 01100100 Message type length: correct number of octets

Sheet: 2 of 2

Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets (range 1-4) Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in CONTINUE message) Component portion tag: 01101100 Component portion length: correct number of octets

42

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787ValidationTest >> spec1_1_2_3_2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.1.2.3.2 REFERENCE: 3.2.1.3/Q.774 TITLE: Valid function; Structured dialogue

Sheet: 1 of 2

SUBTITLE: Clearing after continue Message (component portion not present); Basic ending IUT receiving PURPOSE: To verify that SP A is able to accept a Begin message without CP SP A (TSL) and SP B (TSL) are in the idle state TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (TSL)  TR-BEGIN ind. <============ TR-CONTINUE req. ============> CONTINUE   TR-END ind. <============ END SP B (TSL) BEGIN

TEST DESCRIPTION 1. 2. 3. 4. 5. 6. 7. Arrange for SP B to send a BEGIN message to SP A without CP. Arrange for SP A to send a CONTINUE messager to SP B. Arrange for SP B to send an END message to SP A without CP. CHECK A: WAS THE BEGIN MESSAGE CORRECTLY RECEIVED AT SP A? CHECK B: WAS THE CONTINUE MESSAGE CORRECTLY SENT FROM SP A? CHECK C: WAS THE END MESSAGE CORRECTLY RECEIVED AT SP A? CHECK D: WAS THE TSL STATE MACHINE LEFT IN THE IDLE STATE AT SP A?

Recommendation Q.787 (09/97)

43

TEST NUMBER: 1.1.2.3.2 CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets (range 1-4) Originating transaction ID value: OCTET STRING (1-4 octets long) CONTINUE Message type tag: 01100101 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets (range 1-4) Originating transaction ID value: OCTET STRING (1-4 octets long) Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets (range 1-4) Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) END Message type tag: 01100100 Message type length: correct number of octets

Sheet: 2 of 2

Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets (range 1-4) Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in CONTINUE message)

44

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787ValidationTest >> spec1_1_2_5_1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.1.2.5.1 REFERENCE: 3.1.2.2.2.2/Q.771 TITLE: Valid function, Structured dialogue SUBTITLE: TC addressing; Register address change PURPOSE:

Sheet: 1 of 1

To verify that a correctly reported address change of the peer implementation is registered and used in subsequent messages. SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (TSL) UDT ( CLG A, CLD B) BEGIN  TR-BEGIN ind. ============> TR-CONTINUE req. <============ UDT ( CLG B*, CLD A)  TR-CONTINUE ind. <============ TR-END req ============> UDT ( CLG A, CLD B*) END TEST DESCRIPTION 1. 2. 3. 4. Arrange for SP A to send a Begin message to SP B. Arrange for SP B to respond with a Continue message in which the calling address has been optimized. Arrange for SP A to respond with an End message. CHECK A: WAS THE CALLED ADDRESS IN THE SCCP MESSAGE HEADER FOR THE END THE SAME AS THE CALLING ADDRESS IN THE SCCP MESSAGE HEADER FOR THE CONTINUE MESSAGE?  CONTINUE SP B (TSL)

Recommendation Q.787 (09/97)

49

'
]

{ #category : #spec }
Q787ValidationTest >> spec1_1_3_1_1_1s1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.1.3.1.1.1 1) REFERENCE: 3.3/Q.774 TITLE: Valid function; Encoding and value variations

Sheet: 1 of 2

SUBTITLE: Encoding variations; Length variations; Definite short; Component portion length in definite short form embedded in short form PURPOSE: To verify that signalling point A is able to accept a Begin message whose length is encoded using the definite short form and with a component portion whose length is encoded using the definite short form SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (TSL)  TR-BEGIN ind. <============ TR-END req. ============> (Basic) END  SP B (TSL) BEGIN

TEST DESCRIPTION 1. 2. 3. 4. 5. 6. Arrange for SP B to send a Begin message to SP A with lengths encoded as described in the purpose of the test. Arrange for SP A to respond with an End message. CHECK A: WAS THE BEGIN MESSAGE CORRECTLY RECEIVED AT SP A AND PASSED TO THE TR-USER? CHECK B: WAS AN END MESSAGE CORRECTLY SENT BY SP A? CHECK C: WAS THE DTID IN THE END MESSAGE THE SAME AS THE OTID IN THE BEGIN MESSAGE? CHECK D: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?

50

Recommendation Q.787 (09/97)

TEST NUMBER: 1.1.3.1.1.1 1) CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets coded in definite short form Originating transaction ID tag: 01001000 Originating transaction ID length: one octet Originating transaction ID value: OCTET STRING (1 octet)

Sheet: 2 of 2

Component portion tag: 01101100 Component portion length: correct number of octets coded in definite short form END Message type tag: 01100100 Message type length: correct number of octets Destination transaction ID tag: 01001001 Destination transaction ID length: one octet Destination transaction ID value: OCTET STRING (1 octet) (OTID value received in BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets

Recommendation Q.787 (09/97)

51

'
]

{ #category : #spec }
Q787ValidationTest >> spec1_1_3_1_1_1s2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.1.3.1.1.1 2) REFERENCE: 3.3/Q.774 TITLE: Valid function; Encoding and value variations

Sheet: 1 of 2

SUBTITLE: Encoding variations; Length variations; Definite short; Component portion length in definite short form embedded in long form PURPOSE: To verify that signalling point A is able to accept a Begin message whose length is encoded using the definite long form and with a component portion whose length is encoded using the definite short form SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (TSL)  TR-BEGIN ind. <============ TR-END req. ============> (Basic) END  SP B (TSL) BEGIN

TEST DESCRIPTION 1. 2. 3. 4. 5. 6. Arrange for SP B to send a Begin message to SP A with lengths encoded as described in the purpose of the test. Arrange for SP A to respond with an End message. CHECK A: WAS THE BEGIN MESSAGE CORRECTLY RECEIVED AT SP A AND PASSED TO THE TR-USER? CHECK B: WAS AN END MESSAGE CORRECTLY SENT BY SP A? CHECK C: WAS THE DTID IN THE END MESSAGE THE SAME AS THE OTID IN THE BE GIN MESSAGE? CHECK D: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?

52

Recommendation Q.787 (09/97)

TEST NUMBER: 1.1.3.1.1.1 2) CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets coded in definite long form Originating transaction ID tag: 01001000 Originating transaction ID length: one octet Originating transaction ID value: OCTET STRING (1 octet)

Sheet: 2 of 2

Component portion tag: 01101100 Component portion length: correct number of octets coded in definite short form END Message type tag: 01100100 Message type length: correct number of octets Destination transaction ID tag: 01001001 Destination transaction ID length: one octet Destination transaction ID value: OCTET STRING (1 octet) (OTID value received in BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets

Recommendation Q.787 (09/97)

53

'
]

{ #category : #spec }
Q787ValidationTest >> spec1_1_3_1_1_2s1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.1.3.1.1.2 1) REFERENCE: 3.3/Q.774 TITLE: Valid function; Encoding and value variations

Sheet: 1 of 2

SUBTITLE: Encoding variations; Length variations; Definite long; Component portion length in definite long form embedded in long form PURPOSE: To verify that signalling point A is able to accept a Begin message whose length is encoded using the definite long form and with a component portion whose length is encoded using the definite long form SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (TSL)  TR-BEGIN ind. <============ TR-END req. ============> (Basic) END  SP B (TSL) BEGIN

TEST DESCRIPTION 1. 2. 3. 4. 5. 6. Arrange for SP B to send a Begin message to SP A with lengths encoded as described in the purpose of the test. Arrange for SP A to respond with an End message. CHECK A: WAS THE BEGIN MESSAGE CORRECTLY RECEIVED AT SP A AND PASSED TO THE TR-USER? CHECK B: WAS AN END MESSAGE CORRECTLY SENT BY SP A? CHECK C: WAS THE DTID IN THE END MESSAGE THE SAME AS THE OTID IN THE BEGIN MESSAGE? CHECK D: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?

54

Recommendation Q.787 (09/97)

TEST NUMBER: 1.1.3.1.1.2 1) CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets coded in definite long form Originating transaction ID tag: 01001000 Originating transaction ID length: one octet Originating transaction ID value: OCTET STRING (1 octet)

Sheet: 2 of 2

Component portion tag: 01101100 Component portion length: correct number of octets coded in definite long form END Message type tag: 01100100 Message type length: correct number of octets Destination transaction ID tag: 01001001 Destination transaction ID length: one octet Destination transaction ID value: OCTET STRING (1 octet) (OTID value received in BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets

Recommendation Q.787 (09/97)

55

'
]

{ #category : #spec }
Q787ValidationTest >> spec1_1_3_1_1_3s1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.1.3.1.1.3 1) REFERENCE: 3.3/Q.774 TITLE: Valid function; Encoding and value variations

Sheet: 1 of 2

SUBTITLE: Encoding variations; Length variations; Indefinite form; Component portion length in indefinite form embedded in indefinite form PURPOSE: To verify that signalling point A is able to accept a Begin message whose length is encoded using the indefinite form and with a component portion whose length is encoded using the indefinite form SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (TSL)  TR-BEGIN ind. <============ TR-END req. ============> (Basic) END  SP B (TSL) BEGIN

TEST DESCRIPTION 1. 2. 3. 4. 5. 6. Arrange for SP B to send a Begin message to SP A with lengths encoded as described in the purpose of the test. Arrange for SP A to respond with an End message. CHECK A: WAS THE BEGIN MESSAGE CORRECTLY RECEIVED AT SP A AND PASSED TO THE TR-USER? CHECK B: WAS AN END MESSAGE CORRECTLY SENT BY SP A? CHECK C: WAS THE DTID IN THE END MESSAGE THE SAME AS THE OTID IN THE BEGIN MESSAGE? CHECK D: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?

56

Recommendation Q.787 (09/97)

TEST NUMBER: 1.1.3.1.1.3 1) CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets coded in indefinite form Originating transaction ID tag: 01001000 Originating transaction ID length: one octet Originating transaction ID value: OCTET STRING (1 octet) Component portion tag: 01101100 Component portion length: correct number of octets coded in indefinite form Component contents provided by TC user EOC Tag: 00000000, END Message type tag: 01100100 Message type length: correct number of octets Destination transaction ID tag: 01001001 Destination transaction ID length: one octet Destination transaction ID value: OCTET STRING (1 octet) (OTID value received in BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets Length: 00000000

Sheet: 2 of 2

Recommendation Q.787 (09/97)

57

'
]

{ #category : #spec }
Q787ValidationTest >> spec1_2_1_1s1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.2.1.1 1) REFERENCE: 3.3.4/Q.774 TITLE: Syntactically invalid behaviour; Invalid values for information elements SUBTITLE: Begin message type; OTID length = 0 PURPOSE:

Sheet: 1 of 1

To verify that on receipt of a corrupted Begin message, signalling point A is able to discard the message SP A (TSL) and SP B (TSL) are to be in the idle state. Arrange the data at SP B such that the Begin message contains an OTID length of 0 TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1 EXPECTED MESSAGE SEQUENCE: SP A (TSL) Detect syntax error

SP 

B

(TSL)

BEGIN

TEST DESCRIPTION 1. 2. 3. 4. Arrange for SP B to send the corrupted Begin message to SP A, with an OTID length of 0. CHECK A: THAT THE USER WAS NOT INFORMED OF THE BEGIN MESSAGE. CHECK B: WERE NO MESSAGES SENT FROM SP A? CHECK C: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: 0 Originating transaction ID value: not present Component portion tag: 01101100 Component portion length: correct number of octets

62

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787ValidationTest >> spec1_2_1_1s2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.2.1.1 2) REFERENCE: 3.3.4/Q.774 TITLE: Syntactically invalid behaviour; Invalid values for information elements SUBTITLE: Begin message type; OTID length > four octets PURPOSE:

Sheet: 1 of 1

To verify that signalling point A is able to deal with invalid encoding of OTID information element SP A (TSL) and SP B (TSL) are to be in the idle state. Arrange the data at SP B such that the Begin message contains an OTID length of > four octets TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1 EXPECTED MESSAGE SEQUENCE: SP A (TSL) Detect syntax error

SP 

B

(TSL)

BEGIN

TEST DESCRIPTION 1. 2. 3. 4. 5. Arrange for SP B to send the corrupted Begin message to SP A, with an OTID five octets long. CHECK A: WAS THE BEGIN MESSAGE CORRECTLY RECEIVED AT SP A? CHECK B: VERIFY THAT THE TR-USER AT SP A WAS NOT INFORMED OF THIS EVENT. CHECK C: VERIFY THAT NO MESSAGES WERE GENERATED BY SP A IN RESPONSE TO THE BEGIN MESSAGE. CHECK D: WERE ALL TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: five octets Originating transaction ID value: OCTET STRING (5 octets long) Component portion tag: 01101100 Component portion length: correct number of octets

Recommendation Q.787 (09/97)

63

'
]

{ #category : #spec }
Q787ValidationTest >> spec1_2_1_2s1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.2.1.2 1) REFERENCE: 3.3.4/Q.774 TITLE: Syntactically invalid behaviour; Invalid values for information elements SUBTITLE: First continue Message; DTID length = 0 PURPOSE:

Sheet: 1 of 2

To verify that on receipt of a corrupted Continue message, with DTID length = 0, SP A is able to discard the message or abort the transaction correctly SP A (TSL) and SP B (TSL) are to be in the idle state. Arrange the data at SP B such that the first Continue message contains a DTID of length = 0 TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1 EXPECTED MESSAGE SEQUENCE: SP A (TSL) TR-BEGIN req. ============> BEGIN Detect syntax error ABORT (P) (see Note)

SP

B

(TSL)

   CONTINUE

NOTE ­ If the Abort is not sent, this may be valid behaviour depending on the implementation. TEST DESCRIPTION 1. 2. 3. 4. 5. 6. Arrange for SP A to send a Begin message to SP B. Arrange for SP B to send the corrupted Continue message. CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? CHECK B: VERIFY THAT THE TR-USER AT SP A WAS NOT INFORMED OF THE CONTINUE MESSAGE AT SP A. CHECK C: WERE THE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSA CTION PRIOR TO THE CONTINUE MESSAGE LEFT IN INITIATION SENT STATE ? CHECK D: IF AN ABORT MESSAGE WAS SENT, WAS IT SENT CORRECTLY FROM SP A WITH CORRECT DTID AND P-ABORT CAUSE VALUE?

64

Recommendation Q.787 (09/97)

TEST NUMBER: 1.2.1.2 1) CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets CONTINUE Message type tag: 01100101 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets ABORT (P) Message type tag: 01100111 Message type length: correct number of octets

Sheet: 2 of 2

Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in CONTINUE message) P-Abort cause tag: 01001010 P-Abort cause length: correct number of octets P-Abort cause value: incorrect transaction portion

Recommendation Q.787 (09/97)

65

'
]

{ #category : #spec }
Q787ValidationTest >> spec1_2_1_3s1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.2.1.3 1) REFERENCE: 3.3.4/Q.774 TITLE: Syntactically invalid behaviour; Invalid values for information elements SUBTITLE: Subsequent continue Message; Component portion length incorrect PURPOSE:

Sheet: 1 of 2

To verify that on receipt of a corrupted Continue message with OTID derivable and DTID derivable and assigned, after transaction establishment, SP A is able to abort the transaction SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (TSL) TR-BEGIN req. ============> BEGIN   TR-CONTINUE ind. <============ Detect error ABORT (P) (see Note) TR-P-ABORT ind. <============   CONTINUE CONTINUE SP B (TSL)

NOTE ­ If the Abort is not sent, this may be valid behaviour depending on the implementation. TEST DESCRIPTION 1. 2. 3. 4. 5. 6. 7. Send a Begin message from SP A to SP B. Arrange for SP B to send a correct Continue message to SP A. Arrange for SP B to send a corrupted Continue message to SP A (incorrect CP length). CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? CHECK B: WAS THE CONTINUE MESSAGE CORRECTLY RECEIVED AT SP A? CHECK C: IF AN ABORT MESSAGE WAS SENT, WAS IT SENT CORRECTLY FROM SP A WITH CORRECT DTID AND P-ABORT CAUSE VALUE? CHECK D: IF THE ABORT WAS SENT, WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?

66

Recommendation Q.787 (09/97)

TEST NUMBER: 1.2.1.3 1) CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets CONTINUE (1st) Message type tag: 01100101 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets CONTINUE (2nd) Message type tag: 01100101 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets ABORT (P) Message type tag: 01100111 Message type length: correct number of octets

Sheet: 2 of 2

Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in CONTINUE message) P-Abort cause tag: 01001010 P-Abort cause length: correct number of octets P-Abort cause value: badly formatted transaction portion 00000010

Recommendation Q.787 (09/97)

67

'
]

{ #category : #spec }
Q787ValidationTest >> spec1_2_1_4s1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.2.1.4 1) REFERENCE: 3.3.4/Q.774 TITLE: Syntactically invalid behaviour; Invalid values for information elements SUBTITLE: End message; DTID length > four octets PURPOSE:

Sheet: 1 of 1

To verify that on receipt of a corrupted End message, SP A is able to discard the message SP A (TSL) and SP B (TSL) are to be in the idle state. Arrange the data at SP B such that the End message DTID length > four octets TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1 EXPECTED MESSAGE SEQUENCE: SP A (TSL) TR-BEGIN req. ============> BEGIN Detect error TEST DESCRIPTION 1. 2. 3. 4. 5.

SP

B

(TSL)

  END

Arrange for SP A to Send a Begin message to SP B. Arrange for SP B to send a corrupted End message to SP A (invalid DTID length). CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? CHECK B: VERIFY THAT THE TR-USER WAS NOT INFORMED OF THE END MESSAGE. CHECK C: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION PRIOR TO THE END MESSAGE, LEFT IN THE INITIATION SENT STATE?

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets END Message type tag: 01100100 Message type length: correct number of octets Destination transaction ID tag: 01001001 Destination transaction ID length: 00000101 (Invalid length) Destination transaction ID value: OCTET STRING (5 octets long) (OTID value received in BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets

68

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787ValidationTest >> spec1_2_1_5s1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.2.1.5 1) REFERENCE: 3.3.4/Q.774 TITLE: Syntactically invalid behaviour; Invalid values for information elements SUBTITLE: Abort message; Invalid P-Abort cause value PURPOSE:

Sheet: 1 of 2

To verify that signalling point A is able to deal with incorrect encoding of P-Abort cause information element (illegal value) SP A (TSL) and SP B (TSL) are to be in the idle state. Arrange the data at SP B such that an Abort message with a DTID that is derivable and assigned, contains a syntax error and is sent to SP A in response to the Begin message TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1 EXPECTED MESSAGE SEQUENCE: SP A (TSL) TR-BEGIN req. ============> BEGIN Detect syntax error TR-P-ABORT ind. <============

SP

B

(TSL)

  ABORT (P)

NOTE ­ The sending of the TR-Abort ind. is implementation dependent. TEST DESCRIPTION 1. 2. 3. 4. Arrange for SP A to send a Begin message to SP B and for SP B to respond with the corrupted Abort message. (Illegal P-Abort cause value). CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? CHECK B: VERIFY THAT NO MESSAGES ARE GENERATED BY SP A IN RESPONSE TO THE CORRUPTED ABORT MESSAGE. CHECK C: IF THE TR-ABORT IND. WAS SENT, WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?

Recommendation Q.787 (09/97)

69

TEST NUMBER: 1.2.1.5 1) CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets ABORT (P) Message type tag: 01100111 Message type length: correct number of octets Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) P-Abort cause tag: 01001010 P-Abort cause length: correct number of octets P-Abort cause value: INTEGER (5 ­ Illegal value for this field)

Sheet: 2 of 2

70

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787ValidationTest >> spec1_2_1_5s2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.2.1.5 2) REFERENCE: 3.3.4/Q.774 TITLE: Syntactically invalid behaviour; Invalid values for information elements SUBTITLE: Abort message; P-Abort cause length incorrect PURPOSE:

Sheet: 1 of 2

To verify that on receipt of a corrupted Abort message with incorrect cause length, signalling point A is able to discard the message and advise the local user SP A (TSL) and SP B (TSL) are to be in the idle state. Arrange the data at SP B such that an Abort message with a DTID that is derivable and assigned, contains a syntax error and is sent to SP A in response to the Begin message TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1 EXPECTED MESSAGE SEQUENCE: SP A (TSL) TR-BEGIN req. ============> BEGIN Detect syntax error TR-P-ABORT ind. <============

SP

B

(TSL)

  ABORT (P)

NOTE ­ The sending of the TR-Abort ind. is implementation dependent. TEST DESCRIPTION 1. 2. 3. 4. Arrange for SP A to send a Begin message to SP B and for SP B to respond with the corrupted Abort message. (Corrupted P-Abort cause length). CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? CHECK B: VERIFY THAT NO MESSAGES ARE GENERATED BY SP A IN RESPONSE TO THE CORRUPTED ABORT MESSAGE. CHECK C: IF THE TR-ABORT IND. WAS SENT, WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?

Recommendation Q.787 (09/97)

71

TEST NUMBER: 1.2.1.5 2) CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets ABORT (P) Message type tag: 01100111 Message type length: correct number of octets Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) P-Abort cause tag: 01001010 P-Abort cause length: correct number of octets (i.e. not one) P-Abort cause value: INTEGER (0 .. 4)

Sheet: 2 of 2

72

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787ValidationTest >> spec1_2_2_1s1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.2.2.1 1) REFERENCE: 3.3.4/Q.774 TITLE: Syntactically invalid behaviour; Invalid structure

Sheet: 1 of 1

SUBTITLE: Unidirectional Message type; Unknown information element present PURPOSE: To verify that on receipt of a corrupted Unidirectional message, signalling point A is able to discard the message SP A (TSL) and SP B (TSL) are to be in the idle state. Arrange the data at SP B such that an Unidirectional message contains a syntax error and is sent to SP A TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1 EXPECTED MESSAGE SEQUENCE: SP A (TSL) Detect syntax error TEST DESCRIPTION 1. 2. 3. 4.

SP 

B

(TSL)

UNIDIRECTIONAL

Arrange for SP B to send the corrupted Unidirectional message to SP A. CHECK A: VERIFY THAT THE TR-USER WAS NOT INFORMED OF THE UNID IRECTIONAL MESSAGE AT SP A. CHECK B: VERIFY THAT NO MESSAGES WERE GENERATED IN RESPONSE TO THE UNIDIRECTIONAL MESSAGE. CHECK C: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES UNIDIRECTIONAL Message type tag: 01100001 Message type length: correct number of octets Component portion missing

Recommendation Q.787 (09/97)

73

'
]

{ #category : #spec }
Q787ValidationTest >> spec1_2_2_2s1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.2.2.2 1) REFERENCE: 3.3.4/Q.774 TITLE: Syntactically invalid behaviour; Invalid structure SUBTITLE: Begin Message type; OTID absent PURPOSE:

Sheet: 1 of 1

To verify that on receipt of a corrupted Begin message; signalling point A is able to discard the message SP A (TSL) and SP B (TSL) are to be in the idle state. Arrange the data at SP B such that the Begin message contains a syntax error and the OTID is not derivable TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1 EXPECTED MESSAGE SEQUENCE: SP A (TSL) Detect syntax error TEST DESCRIPTION 1. 2. 3. 4.

SP 

B

(TSL)

BEGIN

Arrange for SP B to send the corrupted Begin message to SP A, with OTID not present. CHECK A: VERIFY THAT THE TR-USER WAS NOT INFORMED OF THIS EVENT AT SP A. CHECK B: VERIFY THAT NO MESSAGES WERE GENERATED IN RESPONSE TO THE THE CORRUPTED BEGIN MESSAGE. CHECK C: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets OTID absent

74

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787ValidationTest >> spec1_2_2_2s2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.2.2.2 2) REFERENCE: 3.3.4/Q.774 TITLE: Syntactically invalid behaviour; Invalid structure SUBTITLE: Begin Message type; Unknown information element present PURPOSE:

Sheet: 1 of 2

To verify that on receipt of a corrupted Begin message, with an invalid information element, signalling point A is able to discard the message and generate an Abort message SP A (TSL) and SP B (TSL) are to be in the idle state. Arrange the data at SP B such that the Begin message contains a syntax error TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1 EXPECTED MESSAGE SEQUENCE: SP A (TSL)

SP  

B

(TSL)

Detect syntax error ABORT (P)

BEGIN

NOTE ­ If the Abort is not sent, this may be valid behavior depending on the implementation. TEST DESCRIPTION 1. 2. 3. Arrange for SP B to send the corrupted Begin message to SP A, with an invalid information element after the OTID. CHECK A: IF AN ABORT MESSAGE WAS SENT, WAS IT SENT CORRECTLY FROM SP A WITH CORRECT DTID AND CORRECT P-ABORT CAUSE VALUE? CHECK B: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?

Recommendation Q.787 (09/97)

75

TEST NUMBER: 1.2.2.2 2) CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Information element tag: unknown (eg. 01101101) Information element length: correct number of octets Information element value: OCTET STRING ABORT (P) Message type tag: 01100111 Message type length: correct number of octets Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) P-Abort cause tag: 01001010 P-Abort cause length: correct number of octets P-Abort cause value: incorrect transaction portion 00000011

Sheet: 2 of 2

76

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787ValidationTest >> spec1_2_2_3s1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.2.2.3 1) REFERENCE: 3.3.4/Q.774 TITLE: Syntactically invalid behaviour; Invalid structure SUBTITLE: First Continue Message; OTID absent PURPOSE:

Sheet: 1 of 2

To verify that on receipt of a corrupted Continue message, signalling point A is able to discard the message SP A (TSL) and SP B (TSL) are to be in the idle state. SP B to respond with a Continue message on receipt of the Begin message. Arrange the data at SP B such that the Continue message contains a syntax error and the OTID is not derivable TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1 EXPECTED MESSAGE SEQUENCE: SP A (TSL)

SP

B

(TSL)

TR-BEGIN req. ============> BEGIN Detect syntax error   CONTINUE

TEST DESCRIPTION 1. 2. 3. 4. 5. 6. Arrange for SP A to send a Begin message to SP B. Arrange for SP B to send the corrupted Continue message (OTID not derivable) to SP A. CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? CHECK B: VERIFY THAT THE TR-USER WAS NOT INFORMED OF THE CONTINUE MESSAGE AT SP A. CHECK C: VERIFY THAT NO MESSAGES WERE GENERATED BY SP A IN RESPONSE TO THE CORRUPTED CONTINUE MESSAGE? CHECK D: WERE TSL STATE MACHINES ASSOCIATED WITH THE TRANSACTION, PRIOR TO THE CONTINUE MESSAGE, LEFT IN THE INITIATION SENT STATE AT SP A?

Recommendation Q.787 (09/97)

77

TEST NUMBER: 1.2.2.3 1) CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets CONTINUE Message type tag: 01100101 Message type length: correct number of octets OTID absent Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets

Sheet: 2 of 2

78

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787ValidationTest >> spec1_2_2_3s2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.2.2.3 2) REFERENCE: 3.3.4/Q.774 TITLE: Syntactically invalid behaviour; Invalid structure SUBTITLE: First Continue Message; DTID absent PURPOSE:

Sheet: 1 of 2

To verify that on receipt of a corrupted Continue message containing no DTID, signalling point A is able to discard the message or abort the transaction SP A (TSL) and SP B (TSL) are to be in the idle state. SP B to respond with a Continue message on receipt of the Begin message. Arrange the data at SP B such that the Continue message contains no DTID TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1 EXPECTED MESSAGE SEQUENCE: SP A (TSL)

SP

B

(TSL)

TR-BEGIN req. ============> BEGIN Detect syntax error ABORT (P)   (DTID absent)  CONTINUE

NOTE ­ If the Abort is not sent, this may be valid behaviour depending on the implementation. TEST DESCRIPTION 1. 2. 3. 4. 5. 6. Arrange for SP A to send a Begin message to SP B. Arrange for SP B to send the corrupted Continue message (DTID absent). CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? CHECK B: VERIFY THAT THE TR-USER WAS NOT INFORMED OF THE CONTINUE MESSAGE AT SP A. CHECK C: WERE THE TSL STATE MACHINES ASSOCIATED WITH THE TRANSACTION, PRIOR TO THE CONTINUE MESSAGE, LEFT IN THE INITIATION SENT STATE? CHECK D: IF AN ABORT MESSAGE WAS SENT, WAS IT SENT CORRECTLY FROM SP A WITH CORRECT DTID AND CORRECT P-ABORT CAUSE VALUE?

Recommendation Q.787 (09/97)

79

TEST NUMBER: 1.2.2.3 2) CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets CONTINUE Message type tag: 01100101 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) DTID absent Component portion tag: 01101100 Component portion length: correct number of octets ABORT (P) Message type tag: 01100111 Message type length: correct number of octets

Sheet: 2 of 2

Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in CONTINUE message) P-Abort cause tag: 01001010 P-Abort cause length: correct number of octets P-Abort cause value: incorrect transaction portion 00000011

80

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787ValidationTest >> spec1_2_2_3s3 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.2.2.3 3) REFERENCE: 3.3.4/Q.774 TITLE: Syntactically invalid behaviour; Invalid structure SUBTITLE: First Continue Message; OTID duplicated PURPOSE:

Sheet: 1 of 2

To check the correct behaviour of the implementation under test on receipt of a first Continue message with a duplicated OTID SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (TSL) SP B (TSL) TR-BEGIN req. ============> BEGIN  (with duplicated OTID)  ABORT (P) TR-P-ABORT ind. <============  CONTINUE

NOTE ­ If the ABORT message and primitive are not sent, this may be valid behaviour depending on the implementation. TEST DESCRIPTION 1. 2. 3. 4. 5. Arrange SP A to send a Begin message. Arrange for SP B to send a Continue message to SP A with a duplicated OTID. CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? CHECK B: IF AN ABORT MESSAGE WAS SENT, WAS IT SENT CORRECTLY FROM SP A WITH CORRECT DTID VALUE AND CORRECT P-ABORT CAUSE VALUE? CHECK C: IF THE ABORT MESSAGE AND PRIMITIVE WERE SENT, WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?

Recommendation Q.787 (09/97)

81

TEST NUMBER: 1.2.2.3 3) CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets CONTINUE Message type tag: 01100101 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long)

Sheet: 2 of 2

} } } } Duplicated } } }

Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets ABORT (P) Message type tag: 01100111 Message type length: correct number of octets Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in CONTINUE message) P-Abort cause tag: 01001010 P-Abort cause length: correct number of octets P-Abort cause value: incorrect transaction portion 00000011

82

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787ValidationTest >> spec1_2_2_3s4 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.2.2.3 4) REFERENCE: 3.3.4/Q.774 TITLE: Syntactically invalid behaviour; Invalid structure SUBTITLE: First Continue Message; DTID duplicated PURPOSE:

Sheet: 1 of 2

To check the correct behaviour of the implementation under test on receipt of a first Continue message with a duplicated DTID SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (TSL) SP B (TSL) TR-BEGIN req. ============> BEGIN  (with duplicated DTID)  ABORT (P) TR-P-ABORT ind. <============  CONTINUE

NOTE ­ If the ABORT message and primitive are not sent, this may be valid behaviour depending on the implementation. TEST DESCRIPTION 1. 2. 3. 4. 5. Arrange SP A to send a Begin message. Arrange for SP B to send a Continue message to SP A with a duplicated DTID. CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? CHECK B: WAS AN ABORT MESSAGE WITH CORRECT DTID VALUE AND CORRECT P-ABORT CAUSE VALUE CORRECTLY SENT FROM SP A? CHECK C: IF THE ABORT MESSAGE AND PRIMITIVE WERE SENT, WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?

Recommendation Q.787 (09/97)

83

TEST NUMBER: 1.2.2.3 4) CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets CONTINUE Message type tag: 01100101 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets ABORT (P) Message type tag: 01100111 Message type length: correct number of octets

Sheet: 2 of 2

} } } } } Duplicated } } } }

Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in CONTINUE message) P-Abort cause tag: 01001010 P-Abort cause length: correct number of octets P-Abort cause value: incorrect transaction portion 00000011

84

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787ValidationTest >> spec1_2_2_3s5 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.2.2.3 5) REFERENCE: 3.3.4/Q.774 TITLE: Syntactically invalid behaviour; Invalid structure SUBTITLE: First Continue Message; Unknown information element present PURPOSE:

Sheet: 1 of 2

To verify that on receipt of a corrupted Continue message, signalling point A behaves correctly SP A (TSL) and SP B (TSL) are to be in the idle state. Arrange the data at SP B such that a Continue message with an OTID that is derivable and a DTID that is derivable and assigned, contains a syntax error and is sent to SP A in response to the Begin message TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1 EXPECTED MESSAGE SEQUENCE: SP A (TSL)

SP

B

(TSL)

TR-BEGIN req. ============> BEGIN Detect syntax error ABORT (P) TR-P-ABORT ind. <============    CONTINUE

NOTE ­ If the ABORT message and primitive are not sent, this may be valid behaviour depending on the implementation. TEST DESCRIPTION 1. 2. 3. 4. Arrange for SP A to send a Begin message to SP B. Arrange for SP B to send the corrupted Continue message with an extra information element after the DTID information element (eg P-Abort Cause). CHECK A: VERIFY THAT THE TR-USER WAS NOT INFORMED OF THE CONTINUE MESSAGE AT SP A. CHECK B: IF THE ABORT MESSAGE WAS SENT, WAS IT SENT CORRECTLY FROM SP A, WITH CORRECT DTID AND THE CORRECT P-ABORT CAUSE VALUE? (INCORRECT TRANSACTION PORTION) CHECK C: IF THE MESSAGE AND PRIMITIVE ABORT WERE SENT, WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?

5.

Recommendation Q.787 (09/97)

85

TEST NUMBER: 1.2.2.3 5) CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets CONTINUE Message type tag: 01100101 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) Information element tag: unknown (eg. 01101101) Information element length: correct number of octets Information element value: OCTET STRING ABORT (P) Message type tag: 01100111 Message type length: correct number of octets

Sheet: 2 of 2

Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in CONTINUE message) P-Abort cause tag: 01001010 P-Abort cause length: correct number of octets P-Abort cause value: incorrect transaction portion 00000011

86

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787ValidationTest >> spec1_2_2_4s1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.2.2.4 1) REFERENCE: 3.3.4/Q.774 TITLE: Syntactically invalid behaviour; Invalid structure SUBTITLE: Subsequent Continue Message; OTID absent PURPOSE:

Sheet: 1 of 2

To verify that on receipt of a corrupted Continue message after transaction establishment, SP A is able to discard the message SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (TSL) SP B (TSL) TR-BEGIN req. ============> BEGIN   TR-CONTINUE ind. <============ Detect error  CONTINUE CONTINUE

TEST DESCRIPTION 1. 2. 3. 4. 5. 6. 7. 8. Send a Begin message from SP A to SP B. Arrange for SP B to send a correct Continue message to SP A. Arrange for SP B to send a corrupted Continue message to SP A (OTID not derivable). CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? CHECK B: WAS THE FIRST CONTINUE MESSAGE CORRECTLY RECEIVED AT SP A? CHECK C: VERIFY THAT THE TR-USER AT SP A WAS NOT INFORMED OF THE CORRUPTED CONTINUE MESSAGE. CHECK D: VERIFY THAT NO MESSAGES WERE GENERATED BY SP A IN RESPONSE TO THE CORRUPTED CONTINUE MESSAGE. CHECK E: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION, PRIOR TO THE CORRUPTED CONTINUE MESSAGE, LEFT IN THE ACTIVE STATE AT SP A?

Recommendation Q.787 (09/97)

87

TEST NUMBER: 1.2.2.4 1) CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets CONTINUE (1st) Message type tag: 01100101 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets CONTINUE (2nd) Message type tag: 01100101 Message type length: correct number of octets Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message)

Sheet: 2 of 2

88

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787ValidationTest >> spec1_2_2_4s2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.2.2.4 2) REFERENCE: 3.3.4/Q.774 TITLE: Syntactically invalid behaviour; Invalid structure

Sheet: 1 of 2

SUBTITLE: Subsequent Continue Message; Unknown information element present PURPOSE: To verify that on receipt of a corrupted Continue message with OTID derivable and DTID derivable and assigned, after transaction establishment, SP A behaves correctly SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (TSL)  TR-BEGIN ind. <============ TR-CONTINUE req. ============> CONTINUE Detect error ABORT (P) TR-P-ABORT ind. <============    CONTINUE SP B (TSL) BEGIN

NOTE ­ If the ABORT message and primitive are not sent, this may be valid behaviour depending on the implementation. TEST DESCRIPTION 1. 2. 3. 4. 5. 6. 7. Send a Begin message from SP B to SP A. Arrange for SP A to send a correct Continue message to SP B. Arrange for SP B to send a corrupted Continue message to SP A (extra Information Element after the DTID Information Element). CHECK A: WAS THE BEGIN MESSAGE CORRECTLY RECEIVED AT SP A? CHECK B: WAS THE FIRST CONTINUE MESSAGE CORRECTLY SENT FROM SP A? CHECK C: IF AN ABORT MESSAGE WAS SENT, WAS IT SENT CORRECTLY FROM SP A WITH CORRECT DTID AND CORRECT P-ABORT CAUSE VALUE? CHECK D: IF THE ABORT WAS SENT, WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN IDLE STATE AT SP A?

Recommendation Q.787 (09/97)

89

TEST NUMBER: 1.2.2.4 2) CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets CONTINUE (1st) Message type tag: 01100101 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets CONTINUED (2nd) Message type tag: 01100101 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) (OTID value used in BEGIN message) Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) Information element tag: unknown (eg. 01101101) Information element length: correct number of octets Information element value: OCTET STRING ABORT (P) Message type tag: 01100111 Message type length: correct number of octets Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) P-Abort cause tag: 01001010 P-Abort cause length: correct number of octets P-Abort cause value: incorrect transaction portion 00000011

Sheet: 2 of 2

90

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787ValidationTest >> spec1_2_2_5s1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.2.2.5 1) REFERENCE: 3.3.4/Q.774 TITLE: Syntactically invalid behaviour; Invalid structure SUBTITLE: End Message; DTID absent PURPOSE:

Sheet: 1 of 1

To verify that on receipt of a corrupted End message, SP A is able to discard the message SP A (TSL) and SP B (TSL) are to be in the idle state. Arrange the data at SP B such that the End message contains a syntax error ( DTID absent) TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1 EXPECTED MESSAGE SEQUENCE: SP A (TSL)

SP

B

(TSL)

TR-BEGIN req. ============> BEGIN Detect syntax error TEST DESCRIPTION 1. 2. 3. 4. 5. 6. Arrange for SP A to send a Begin message to SP B. Arrange for SP B to send a corrupted End message to SP A.(DTID absent.) CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? CHECK B: VERIFY THAT THE TR-USER WAS NOT INFORMED OF THE MESSAGE AT SP A. CHECK C: VERIFY THAT NO MESSAGES WERE GENERATED BY SP A IN RESPONSE TO THE CORRUPTED END MESSAGE? CHECK D: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION, PRIOR TO THE END MESSAGE, LEFT IN THE INITIATION SENT STATE AT SP A?   END

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets END Message type tag: 01100100 Message type length: correct number of octets DTID absent Component portion tag: 01101100 Component portion length: correct number of octets

Recommendation Q.787 (09/97)

91

'
]

{ #category : #spec }
Q787ValidationTest >> spec1_2_2_6s1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.2.2.6 1) REFERENCE: 3.3.4/Q.774 TITLE: Syntactically invalid behaviour; Invalid structure SUBTITLE: Abort Message; DTID absent PURPOSE:

Sheet: 1 of 1

To verify that on receipt of a corrupted Abort message, SP A is able to discard the message SP A (TSL) and SP B (TSL) are to be in the idle state. Arrange the data at SP B such that the Abort message contains a syntax error ( DTID absent) TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1 EXPECTED MESSAGE SEQUENCE: SP A (TSL)

SP

B

(TSL)

TR-BEGIN req. ============> BEGIN Detect syntax error TEST DESCRIPTION 1. 2. 3. 4. 5. 6. Arrange for SP A to send a Begin message to SP B. Arrange for SP B to send a corrupted Abort message to SP A. CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? CHECK B: VERIFY THAT THE TR-USER WAS NOT INFORMED OF THE MESSAGE AT SP A. CHECK C: VERIFY THAT NO MESSAGES WERE GENERATED BY SP A IN RESPONSE TO THE CORRUPTED ABORT MESSAGE. CHECK D: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION, PRIOR TO THE ABORT MESSAGE, LEFT IN THE INITIATION SENT STATE AT SP A?   ABORT

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets ABORT (P) Message type tag: 01100111 Message type length: correct number of octets DTID absent P-Abort cause tag: 01101100 P-Abort cause length: correct number of octets P-Abort cause value: e.g. incorrect transaction portion 00000011

92

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787ValidationTest >> spec1_2_2_7s1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.2.2.7 1) REFERENCE: 3.3.4/Q.774 TITLE: Syntactically invalid behaviour; Invalid structure SUBTITLE: Unknown Message; OTID not included PURPOSE:

Sheet: 1 of 1

To verify that on receipt of an Unknown message, signalling point A is able to discard the message SP A (TSL) and SP B (TSL) are to be in the idle state. Arrange the data at SP B such that an Unknown message with an OTID that is not derivable is sent to SP A TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1 EXPECTED MESSAGE SEQUENCE: SP A (TSL)

SP 

B

(TSL)

Detect Unknown message type

UNKNOWN MESSAGE

TEST DESCRIPTION 1. 2. 3. 4. Arrange for SP B to send the Unknown message to SP A. CHECK A: VERIFY THAT THE TR-USER WAS NOT INFORMED OF THIS EVENT AT SP A. CHECK B: VERIFY THAT NO MESSAGES WERE GENERATED BY SP A IN RESPONSE TO THE UNKNOWN MESSAGE. CHECK C: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES UNKNOWN MESSAGE Message type tag: unknown (e.g. 01100110) Message type length: correct number of octets OTID absent

Recommendation Q.787 (09/97)

93

'
]

{ #category : #spec }
Q787ValidationTest >> spec1_2_2_7s2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.2.2.7 2) REFERENCE: 3.3.4/Q.774 TITLE: Syntactically invalid behaviour; Invalid structure SUBTITLE: Unknown Message; OTID included and DTID not included PURPOSE:

Sheet: 1 of 1

To verify that on receipt of an Unknown message, signalling point A behaves correctly SP A (TSL) and SP B (TSL) are to be in the idle state. Arrange the data at SP B that an Unknown message with an OTID that is derivable and a DTID that is not derivable or derivable but unassigned is sent to SP A TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1 EXPECTED MESSAGE SEQUENCE: SP A (TSL)

SP  

B

(TSL)

Detect Unknown message type ABORT (P)

UNKNOWN MESSAGE

NOTE ­ If the Abort message is not sent, this may be valid behaviour depending on the implementation. TEST DESCRIPTION 1. 2. 3. Arrange for SP B to send the Unknown message to SP A. CHECK A: IF A P-ABORT MESSAGE WAS SENT, WAS IT SENT CORRECTLY FROM SP A WITH THE CORRECT DTID AND CORRECT P-ABORT CAUSE VALUE? CHECK B: IF THE ABORT WAS SENT, WERE TSL THE STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES UNKNOWN MESSAGE Message type tag: unknown (e.g. 01100110) Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) ABORT (P) Message type tag: 01100111 Message type length: correct number of octets Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in UNKNOWN message) P-Abort cause tag: 01001010 P-Abort cause length: one octet P-Abort cause value: unrecognized message type 00000000

94

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787ValidationTest >> spec1_2_2_7s3 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.2.2.7 3) REFERENCE: 3.3.4/Q.774 TITLE: Syntactically invalid behaviour; Invalid structure SUBTITLE: Unknown Message; OTID included and DTID included PURPOSE:

Sheet: 1 of 2

To verify that on receipt of an Unknown message with assigned DTID, SP A is able to behave correctly SP A (TSL) and SP B (TSL) are to be in the idle state. Arrange the data at SP B such than an Unknown message with an OTID that is derivable and a DTID that is derivable and assigned is sent to SP A in response to the Begin message TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1 EXPECTED MESSAGE SEQUENCE: SP A (TSL)

SP

B

(TSL)

TR-BEGIN req. ============> BEGIN Detect Unknown message type ABORT (P) TR-P-ABORT ind. <============    UNKNOWN MESSAGE

NOTE ­ If the ABORT message and primitive are not sent, this may be valid behaviour depending on the implementation. TEST DESCRIPTION 1. 2. 3. 4. 5. Arrange for SP A to send a Begin message to SP B and for SP B to respond with the Unknown message. CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? CHECK B: IF THE P-ABORT MESSAGE WAS SENT, WAS IT SENT CORRECTLY FROM SP A WITH THE CORRECT DTID AND CORRECT P-ABORT CAUSE VALUE? CHECK C: IF THE ABORT WAS SENT, WAS THE TR-USER AT SP A ADVISED BY A TR-P-ABORT INDICATION PRIMITIVE THAT THIS TRANSACTION HAD BEEN ABORTED? CHECK D: IF THE ABORT WAS SENT, WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?

Recommendation Q.787 (09/97)

95

TEST NUMBER: 1.2.2.7 3) CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets UNKNOWN MESSAGE Message type tag: unknown (e.g. 01100110) Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) ABORT (P) Message type tag: 01100111 Message type length: correct number of octets

Sheet: 2 of 2

Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in UNKNOWN message) P-Abort cause tag: 01001010 P-Abort cause length: one octet P-Abort cause value: unrecognized message type 00000000

96

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787ValidationTest >> spec1_2_3_1s1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.2.3.1 1) REFERENCE: 3.3.4/Q.774 TITLE: Syntactically invalid behaviour; Invalid encoding SUBTITLE: Begin Message type; Invalid tag PURPOSE:

Sheet: 1 of 1

To verify that on receipt of a corrupted Begin message with Invalid tag, signalling point A behaves correctly SP A (TSL) and SP B (TSL) are to be in the idle state. Arrange the data at SP B that the Begin message contains an Invalid tag TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1 EXPECTED MESSAGE SEQUENCE: SP A (TSL)

SP  

B

(TSL)

Detect syntax error ABORT (P)

BEGIN

NOTE ­ If the Abort message is not sent, this may be valid behaviour depending on the implementation. TEST DESCRIPTION 1. 2. 3. 4. Arrange for SP B to send the corrupted Begin message to SP A. CHECK A: CHECK THAT THE USER WAS NOT INFORMED OF THE BEGIN MESSAGE. CHECK B: WERE THE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A? CHECK C: IF AN ABORT MESSAGE WAS SENT, WAS IT SENT CORRECTLY FROM SP A WITH CORRECT DTID AND CORRECT P-ABORT CAUSE VALUE?

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Invalid tag: e.g. 00100010 Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) ABORT (P) Message type tag: 01100111 Message type length: correct number of octets Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) P-Abort cause tag: 01001010 P-Abort cause length: correct number of octets P-Abort cause value: incorrect transaction portion 00000011

Recommendation Q.787 (09/97)

97

'
]

{ #category : #spec }
Q787ValidationTest >> spec1_2_3_2s1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.2.3.2 1) REFERENCE: 3.3.4/Q.774 TITLE: Syntactically invalid behaviour; Invalid encoding SUBTITLE: Continue Message type; Invalid tag PURPOSE:

Sheet: 1 of 2

To verify that on receipt of a corrupted Continue message with Invalid tag, signalling point A behaves correctly SP A (TSL) and SP B (TSL) are to be in the idle state. SP B to respond with a Continue message on receipt of the Begin message. Arrange the data at SP B such that Continue message contains a syntax error (invalid tag) TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1 EXPECTED MESSAGE SEQUENCE: SP A (TSL)

SP

B

(TSL)

TR-BEGIN req. ============> BEGIN Detect syntax error ABORT (P) TR-P-ABORT ind. <============    CONTINUE

NOTE ­ If the ABORT message and the primitive are not sent, this may be valid behaviour depending on the implementation. TEST DESCRIPTION 1. 2. 3. 4. 5. Arrange for SP A to send a Begin message to SP B. Arrange for SP B to send the corrupted Continue message to SP A. CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? CHECK B: VERIFY THAT THE TR-USER WAS NOT INFORMED OF THE CONTINUE MESSAGE AT SP A. CHECK C: IF AN ABORT MESSAGE WAS SENT, WAS IT SENT CORRECTLY FROM SP A WITH CORRECT DTID AND CORRECT P-ABORT CAUSE VALUE?

98

Recommendation Q.787 (09/97)

TEST NUMBER: 1.2.3.2 1) CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets CONTINUE Message type tag: 01100101 Message type length: correct number of octets Invalid tag: e.g. 00011111 Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in BEGIN message) ABORT (P) Message type tag: 01100111 Message type length: correct number of octets

Sheet: 2 of 2

Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in CONTINUE message) P-Abort cause tag: 01001010 P-Abort cause length: correct number of octets P-Abort cause value: incorrect transaction portion 00000011

Recommendation Q.787 (09/97)

99

'
]

{ #category : #spec }
Q787ValidationTest >> spec1_3_1s1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.3.1 1) REFERENCE: 3.3.4/Q.774 TITLE: Inopportune Messages; Continue message type SUBTITLE: Receipt of Continue Message in idle state with unassigned DTID PURPOSE:

Sheet: 1 of 2

To verify that on receipt of a Continue message with unassigned DTID, signalling point A is able to discard the message and generate an Abort message SP A (TSL) to be in the idle state and SP B (TSL) to be in the IR/Active state. Arrange the data at SP B such that a Continue message with an OTID that is derivable and a DTID that is derivable but unassigned is sent to SP A TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1 EXPECTED MESSAGE SEQUENCE: SP A (TSL)

SP  

B

(TSL)

CONTINUE

ABORT (P)

TEST DESCRIPTION 1. 2. 3. 4. 5. Arrange for SP B to send the Continue message with unassigned DTID to SP A. CHECK A: VERIFY THAT THE TR-USER WAS NOT INFORMED OF THE CONTINUE MESSAGE AT SP A. CHECK B: WAS THE DTID IN THE ABORT MESSAGE EQUAL TO THE OTID IN THE CONTINUE MESSAGE? CHECK C: WAS AN ABORT MESSAGE CORRECTLY SENT FROM SP A WITH A P-ABORT CAUSE VALUE OF UNRECOGNIZED TRANSACTION ID? CHECK D: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?

100

Recommendation Q.787 (09/97)

TEST NUMBER: 1.3.1 1) CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES CONTINUE Message type tag: 01100101 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets ABORT (P) Message type tag: 01100111 Message type length: correct number of octets

Sheet: 2 of 2

Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) (OTID value received in CONTINUE message) P-Abort cause tag: 01001010 P-Abort cause length: one octet P-Abort cause value: unrecognized transaction ID 00000001

Recommendation Q.787 (09/97)

101

'
]

{ #category : #spec }
Q787ValidationTest >> spec1_3_2s1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.3.2 1) REFERENCE: 3.3.4/Q.774 TITLE: Inopportune Messages; End Message type SUBTITLE: Receipt of End Message in Idle state PURPOSE:

Sheet: 1 of 1

To verify that on receipt of an End message with unassigned DTID, signalling point A is able to discard the message SP A (TSL) to be in the idle state and SP B (TSL) to be in the IR/Active state. Arrange the data at SP B such that an End message with a DTID that is derivable but unassigned is sent to SP A TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1 EXPECTED MESSAGE SEQUENCE: SP A (TSL)

SP  END

B

(TSL)

TEST DESCRIPTION 1. 2. 3. 4. Arrange for SP B to send the End message with unassigned DTID to SP A. CHECK A: VERIFY THAT THE TR-USER WAS NOT INFORMED OF THE END MESSAGE AT SP A. CHECK B: VERIFY THAT NO MESSAGES WERE GENERATED BY SP A IN RESPONSE TO THE END MESSAGE. CHECK C: WERE TSL STATE MACHINES ASSOCIATED WITH THE TRANSACTION LEFT IN THE IDLE STATE AT SP A?

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES END Message type tag: 01100100 Message type length: correct number of octets Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) Component portion tag: 01101100 Component portion length: correct number of octets

102

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787ValidationTest >> spec1_3_3s1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.3.3 1) REFERENCE: 3.3.4/Q.774 TITLE: Inopportune Messages; Abort Message type SUBTITLE: Receipt of Abort message in Idle state PURPOSE:

Sheet: 1 of 1

To verify that on receipt of an Abort message with unassigned DTID, signalling point A is able to discard the message SP A (TSL) to be in the idle state and SP B (TSL) to be in the IR/Active state. Arrange the data at SP B such that an Abort message with a DTID that is derivable but unassigned is sent to SP A TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1 EXPECTED MESSAGE SEQUENCE: SP A (TSL)

SP 

B

(TSL)

ABORT (P)

TEST DESCRIPTION 1. 2. 3. 4. Arrange for SP B to send the Abort message with unassigned DTID to SP A. CHECK A: VERIFY THAT THE TR-USER WAS NOT INFORMED OF THE ABORT MESSAGE AT SP A. CHECK B: VERIFY THAT NO MESSAGES WERE GENERATED BY SP A IN RESPONSE TO THE ABORT MESSAGE. CHECK C: WERE ALL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES ABORT (P) Message type tag: 01100111 Message type length: correct number of octets Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) P-Abort cause tag: 01001010 P-Abort cause length: one octet P-Abort cause value: INTEGER {0, 1, 2, 3, 4}

Recommendation Q.787 (09/97)

103

'
]

{ #category : #spec }
Q787ValidationTest >> spec1_4_1s1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.4.1 1) REFERENCE: 3.3.3.2/Q.774 TITLE: Multiple Transaction Encoding; Valid Transaction Encoding SUBTITLE: New transaction request during transaction establishment PURPOSE:

Sheet: 1 of 2

To verify that the signalling point A is able to correctly react to a Begin message during the establishment of another transaction SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (TSL) SP B (TSL) TR-BEGIN req. ============> BEGIN   TR-BEGIN ind. <============ TR-END req. ============> (Basic) (end new transaction) END   TR-END ind. <============ END BEGIN (new transaction)

TEST DESCRIPTION 1. 2. 3. 4. 5. 6. 7. 8. 9. Arrange for SP A to send a Begin message to SP B. Arrange for SP B to send a Begin message to SP A (new transaction). Arrange for SP A to respond with an End message to the 2nd Begin message. Arrange for SP B to respond with an End message to the 1st Begin message. CHECK A: WAS THE FIRST BEGIN MESSAGE CORRECTLY SENT BY SP A? CHECK B: WAS THE SECOND BEGIN MESSAGE CORRECTLY RECEIVED BY SP A? CHECK C: WAS THE DTID IN THE FIRST END MESSAGE THE SAME AS THE OTID IN THE SECOND BEGIN MESSAGE? CHECK D: WAS THE SECOND END MESSAGE CORRECTLY RECEIVED BY SP A? CHECK E: WERE TSL STATE MACHINES ASSOCIATED WITH THESE TRANSACTIONS LEFT IN THE IDLE STATE AT SP A?

104

Recommendation Q.787 (09/97)

TEST NUMBER: 1.4.1 1) CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN (1st) Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) X Component portion tag: 01101100 Component portion length: correct number of octets BEGIN (2nd) Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Y Component portion tag: 01101100 Component portion length: correct number of octets END (1st) Message type tag: 01100100 Message type length: correct number of octets

Sheet: 2 of 2

Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) Y (OTID value received in 2nd BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets END (2nd) Message type tag: 01100100 Message type length: correct number of octets Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) X (OTID value received in 1st BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets

Recommendation Q.787 (09/97)

105

'
]

{ #category : #spec }
Q787ValidationTest >> spec1_4_1s2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.4.1 2) REFERENCE: 3.3.3.2/Q.774 TITLE: Multiple Transaction Encoding; Valid Transaction Encoding SUBTITLE: New transaction request after transaction establishment PURPOSE:

Sheet: 1 of 3

To verify that the signalling point A is able to correctly react to a Begin message after the establishment of another transaction SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (TSL) SP B (TSL) TR-BEGIN req. ============> BEGIN   TR-CONTINUE ind. <============  TR-BEGIN ind. <============ TR-END req. ============> (Basic) (end new transaction) END   TR-END ind. <============ END BEGIN (new transaction) CONTINUE

106

Recommendation Q.787 (09/97)

TEST NUMBER: 1.4.1 2) TEST DESCRIPTION 1. 2. 3. 4. 5. 6. 7. 8. 9. 10. 11. Arrange for SP A to send a Begin message to SP B. Arrange for SP B to respond with a Continue message to Begin message. Arrange for SP B to send a Begin message to SP A (new transaction).

Sheet: 2 of 3

Arrange for SP A to respond with an End message to the 2nd Begin message. Arrange for SP B to respond with an End message to the 1st Begin message. CHECK A: WAS THE FIRST BEGIN MESSAGE CORRECTLY SENT BY SP A? CHECK B: WAS THE CONTINUE MESSAGE CORRECTLY RECEIVED BY SP A? CHECK C: WAS THE SECOND BEGIN MESSAGE CORRECTLY RECEIVED BY SP A? CHECK D: WAS THE DTID IN THE FIRST END MESSAGE THE SAME AS THE OTID IN THE SECOND BEGIN MESSAGE? CHECK E: WAS THE SECOND END MESSAGE CORRECTLY RECEIVED BY SP A? CHECK F: WERE TSL STATE MACHINES ASSOCIATED WITH THESE TRANSACTIONS LEFT IN THE IDLE STATE AT SP A?

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN (1st) Message type tag: 01100010 Message type length: correct number of octets Destination transaction ID tag: 01001000 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) X Component portion tag: 01101100 Component portion length: correct number of octets

Recommendation Q.787 (09/97)

107

TEST NUMBER: 1.4.1 2) CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES CONTINUE Message type tag: 01100101 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Y

Sheet: 3 of 3

Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) X (OTID value received in 1st BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets BEGIN (2nd) Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Z Component portion tag: 01101100 Component portion length: correct number of octets END (1st) Message type tag: 01100100 Message type length: correct number of octets Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) Z (OTID value received in 2nd BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets END (2nd) Message type tag: 01100100 Message type length: correct number of octets Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) X (OTID value received in 1st BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets

108

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787ValidationTest >> spec1_4_2s1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.4.2 1) REFERENCE: 3.3.3.2/Q.774 TITLE: Multiple Transaction Encoding; Inopportune Messages SUBTITLE: Message with unassigned DTID during transaction establishment PURPOSE:

Sheet: 1 of 2

To verify that the signalling point A is able to correctly react to a Continue message with DTID unassigned during the establishment of another transaction SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (TSL) SP B (TSL) TR-BEGIN req. ============> BEGIN   ABORT (P) TR-P-ABORT ind. <============  TR-END ind. <============ END  CONTINUE (new transaction)

TEST DESCRIPTION 1. 2. 3. 4. 5. 6. 7. 8. 9. Arrange for SP A to send a Begin message to SP B. Arrange for SP B to send a Continue message with unassigned DTID to SP A. Arrange for SP B to respond with an End message to the Begin message. CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT BY SP A? CHECK B: WAS THE CONTINUE MESSAGE CORRECTLY RECEIVED BY SP A? CHECK C: WAS THE DTID IN THE ABORT MESSAGE THE SAME AS THE OTID IN THE CONTINUE MESSAGE? CHECK D: WAS THE P-ABORT CAUSE IN THE ABORT MESSAGE THE CORRECT VALUE, (UNRECOGNIZED TRANSACTION ID)? CHECK E: WAS THE END MESSAGE CORRECTLY RECEIVED BY SP A? CHECK F: WERE TSL STATE MACHINES ASSOCIATED WITH THESE TRANSACTIONS LEFT IN THE IDLE STATE AT SP A?

Recommendation Q.787 (09/97)

109

TEST NUMBER: 1.4.2 1) CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) X Component portion tag: 01101100 Component portion length: correct number of octets CONTINUE Message type tag: 01100101 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Y Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) Z (Not equal to X) Component portion tag: 01101100 Component portion length: correct number of octets ABORT (P) Message type tag: 01100111 Message type length: correct number of octets

Sheet: 2 of 2

Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) Y (OTID value received in CONTINUE message) P-Abort cause tag: 01001010 P-Abort cause length: one octet P-Abort cause value: 00000001 Unrecognized Transaction ID END Message type tag: 01100100 Message type length: correct number of octets Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) X (OTID value received in BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets

110

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787ValidationTest >> spec1_4_2s2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 1.4.2 2) REFERENCE: 3.3.3.2/Q.774 TITLE: Multiple Transaction Encoding; Inopportune Messages SUBTITLE: Message with unassigned DTID after transaction establishment PURPOSE:

Sheet: 1 of 3

To verify that the signalling point A is able to correctly react to a Continue message with DTID unassigned after the establishment of another transaction SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (TSL) SP B (TSL) TR-BEGIN req. ============> BEGIN   TR-CONTINUE ind. <============  ABORT (P) TR-P-ABORT ind. <============  TR-END ind. <============ END  CONTINUE (new transaction) CONTINUE

Recommendation Q.787 (09/97)

111

TEST NUMBER: 1.4.2 2) TEST DESCRIPTION 1. 2. 3. 4. 5. 6. 7. 8. 9 10. Arrange for SP A to send a Begin message to SP B.

Sheet: 2 of 3

Arrange for SP B to send a Continue message in response to Begin message from SP A. Arrange for SP B to send a Continue message with unassigned DTID to SP A. Arrange for SP B to respond with an End message to the Begin message. CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT BY SP A? CHECK B: WERE THE CONTINUE MESSAGES CORRECTLY RECEIVED BY SP A? CHECK C: WAS THE DTID IN THE ABORT MESSAGE THE SAME AS THE OTID IN THE SECOND CONTINUE MESSAGE? CHECK D: WAS THE P-ABORT CAUSE IN THE ABORT MESSAGE THE CORRECT VALUE, (UNRECOGNIZED TRANSACTION ID)? CHECK E: WAS THE END MESSAGE CORRECTLY RECEIVED BY SP A? CHECK F: WERE TSL STATE MACHINES ASSOCIATED WITH THESE TRANSACTIONS LEFT IN THE IDLE STATE AT SP A?

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES BEGIN Message type tag: 01100010 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) W Component portion tag: 01101100 Component portion length: correct number of octets CONTINUE (1st) Message type tag: 01100101 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) X Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) W (OTID value received in BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets

112

Recommendation Q.787 (09/97)

TEST NUMBER: 1.4.2 2) CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES CONTINUE (2nd) Message type tag: 01100101 Message type length: correct number of octets Originating transaction ID tag: 01001000 Originating transaction ID length: correct number of octets Originating transaction ID value: OCTET STRING (1-4 octets long) Y Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) Z (Not equal to W) Component portion tag: 01101100 Component portion length: correct number of octets ABORT (P) Message type tag: 01100111 Message type length: correct number of octets

Sheet: 3 of 3

Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) Y (OTID value received in 2nd CONTINUE message) P-Abort cause tag: 01001010 P-Abort cause length: one octet P-Abort cause value: 00000001 Unrecognized Transaction ID END Message type tag: 01100100 Message type length: correct number of octets Destination transaction ID tag: 01001001 Destination transaction ID length: correct number of octets Destination transaction ID value: OCTET STRING (1-4 octets long) W (OTID value received in BEGIN message) Component portion tag: 01101100 Component portion length: correct number of octets

Recommendation Q.787 (09/97)

113

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_1_3_1_1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.3.1.1 REFERENCES: 3.2.1/Q.774; 3.7.1/Q.772 TITLE: Valid functions; Remote Reject SUBTITLE: Remote Reject by CSL; General problem code PURPOSE:

Sheet: 1 of 2

To verify that a remote rejection by CSL with general problem code can be delivered to the TC-User

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains an Invoke component 2) Arrange the data at SP B such that a Reject component with general problem code can be generated CONFIGURATION: 1 TYPE OF TEST: VAT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i)   TC-R-REJECT ind. <============ REJECT (i) SP B (CSL)

TEST DESCRIPTION 1. 2. 3. 4. Initiate a single Class 1 operation invocation from SP A to SP B. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE REJECT COMPONENT WITH CORRECT INFORMATION PAS SED TO TC-USER BY SP A? CHECK C: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

150

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.3.1.1 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) REJECT component in TSL message sent from SP B to SP A Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Problem code tag: 10000000 (General Problem) Problem code length: 00000001 Problem code: 00000000 (unrecognized component)

Recommendation Q.787 (09/97)

151

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_1_3_1_2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.3.1.2 REFERENCES: 3.2.1/Q.774; 3.7.2/Q.772 TITLE: Valid functions; Remote Reject SUBTITLE: Remote Reject by CSL; Invoke problem code PURPOSE:

Sheet: 1 of 2

To verify that the remote rejection by CSL with Invoke problem code can be received and delivered to the TC-User

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP B contains an Invoke component 2) Arrange the data at SP B such that a Reject component with Invoke problem code can be generated CONFIGURATION: 1 TYPE OF TEST: VAT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL)  TC-INVOKE ind. <============ TC-INVOKE req. ============> INVOKE (j,i)   TC-R-REJECT ind. <============ TEST DESCRIPTION 1. 2. 3. 4. Initiate a linked Class 1 operation invocation from SP B to SP A. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? CHECK B: WAS THE REJECT COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? CHECK C: WAS THE INVOCATION STATE MACHINE IDLE AT SP A? REJECT (j) SP B (CSL) INVOKE (i)

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP B to SP A Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

152

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.3.1.2 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents an operation code) parameters (provided by the TC-User) INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: j (j represents an integer) Linked ID tag: 10000000 Linked ID length: 00000001 (one octet) Linked ID: i Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if y is one octet long) Operation code: y (y represents a valid operation code) parameters (provided by the TC-User) REJECT component in TSL messages from SP B to SP A Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: j Problem code tag: 10000001 (INVOKE) Problem code length: 00000001 Problem code: 00000101 (unrecognized linked ID)

Recommendation Q.787 (09/97)

153

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_1_3_1_3 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.3.1.3 REFERENCE: 3.2.1/Q.774; 3.7.3/Q.772 TITLE: Valid functions; Remote Reject SUBTITLE: Remote Reject by CSL; Return Result problem code PURPOSE:

Sheet: 1 of 2

To verify that a single Class 1 operation can be successfully invoked and the remote rejection can be received and delivered to the TC-User

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP B contains an Invoke component 2) Arrange the data at SP B such that a Reject component can be generated CONFIGURATION: 1 TYPE OF TEST: VAT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL)  TC-INVOKE ind. <============ TC-RESULT-L req. ============> RETURN RESULT-LAST (i)   TC-R-REJECT ind. <============ REJECT (i) SP B (CSL) INVOKE (i)

TEST DESCRIPTION 1. 2. 3. Initiate a single Class 1 operation invocation from SP B to SP A. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? CHECK B: WAS THE REJECT COMPONENT WITH CORRECT I NFORMATION PASSED TO TC-USER BY SP A?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP B to SP A Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

154

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.3.1.3 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) RETURN RESULT-LAST component in TSL message from SP A to SP B Component type tag: 10100010 (RETURN RESULT-LAST) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Sequence tag: 00110000 (see Note) Sequence length: correct number of octets (see Note) Operation code tag: 00000010 (local) or 00000110 (global) (see Note) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) (see Note) Operation code: x (see Note) Parameters (provided by the TC-User) REJECT component in TSL message from SP B to SP A Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Problem code tag: 10000010 (RETURN RESULT) Problem code length: 00000001 Problem code: 00000000 (unrecognized Invoke ID) NOTE ­ Omitted when no parameter is present.

Recommendation Q.787 (09/97)

155

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_1_3_1_4 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.3.1.4 REFERENCE: 3.2.1/Q.774; 3.7.4/Q.772 TITLE: Valid functions; Remote Reject SUBTITLE: Remote Reject by CSL; Return Error problem code PURPOSE:

Sheet: 1 of 2

To verify that a single Class 1 operation can be successfully invoked and the remote rejection can be received and delivered to the TC-User

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP B contains an Invoke component 2) Arrange the data at SP B such that a Reject component can be generated CONFIGURATION: 1 TYPE OF TEST: VAT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL)  TC-INVOKE ind. <============ TC-U-ERROR req. ============> RETURN ERROR (i)   TC-R-REJECT ind. <============ TEST DESCRIPTION 1. 2. 3. Initiate a single Class 1 operation invocation from SP B to SP A. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? CHECK B: WAS THE REJECT COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? REJECT (i) SP B (CSL) INVOKE (i)

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP B to SP A Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

156

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.3.1.4 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) RETURN ERROR component in TSL message from SP A to SP B Component type tag: 10100011 (RETURN ERROR) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Error code tag: 00000010 (local) or 00000110 (global) Error code length: correct number of octets (e.g. 00000001 if y is one octet long) Error code: y parameters (provided by the TC-User) REJECT component in TSL message from SP B to SP A Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Problem code tag: 10000011 (RETURN ERROR) Problem code length: 00000001 Problem code: 00000001 (unrecognized Invoke ID)

Recommendation Q.787 (09/97)

157

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_1_3_2_1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.3.2.1 REFERENCE: 3.2.1/Q.774; 3.7.2/Q.772 TITLE: Valid functions; Remote Reject SUBTITLE: Remote Reject by TC-User; Invoke problem code PURPOSE:

Sheet: 1 of 2

To verify that the remote rejection by TC-User with Invoked problem code can be received and delivered to the TC-User

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains an Invoke component 2) Arrange the data at SP B such that a Reject component can be generated CONFIGURATION: 1 TYPE OF TEST: VAT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i)   TC-U-REJECT ind. <============ REJECT (i) SP B (CSL)

TEST DESCRIPTION 1. 2. 3. 4. Initiate a single Class 1 operation invocation from SP A to SP B. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE REJECT COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? CHECK C: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

158

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.3.2.1 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents an operation code) parameters (provided by the TC-User) REJECT component in TSL message from SP B to SP A Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Problem code tag: 10000001 (RETURN ERROR) Problem code length: 00000001 Problem code: 00000000 (unrecognized Invoke ID)

Recommendation Q.787 (09/97)

159

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_1_3_2_2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.3.2.2 REFERENCE: 3.2.1/Q.774; 3.7.3/Q.772 TITLE: Valid functions; Remote Reject SUBTITLE: Remote Reject by TC-User; Return Result problem code PURPOSE:

Sheet: 1 of 2

To verify that the remote rejection by TC-User with Return Result problem code can be received and delivered to the TC-User

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP B contains an Invoke component 2) Arrange the data at SP B such that a Reject component with Return Result problem code can be generated CONFIGURATION: 1 TYPE OF TEST: VAT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL)  TC-INVOKE ind. <============ TC-RESULT-L req. ============> RETURN RESULT-LAST (i)   TC-U-REJECT ind. <============ TEST DESCRIPTION 1. 2. 3. Initiate a single Class 1 operation invocation from SP B to SP A. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? CHECK B: WAS THE REJECT COMPONENT WITH CORRECT INFORMATION PAS SED TO TC-USER BY SP A? REJECT (i) SP B (CSL) INVOKE (i)

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP B to SP A Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

160

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.3.2.2 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents an operation code) parameters (provided by the TC-User) RETURN RESULT-LAST component in TSL message from SP A to SP B Component type tag: 10100010 (RETURN RESULT-LAST) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Sequence tag: 00110000 (see Note) Sequence length: correct number of octets (see Note) Operation code tag: 00000010 (local) or 00000110 (global) (see Note) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) (see Note) Operation code: x (see Note) parameters (provided by the TC-User) REJECT component in TSL message from SP B to SP A Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Problem code tag: 10000010 (RETURN RESULT) Problem code length: 00000001 Problem code: 00000010 (wrong type parameter) NOTE ­ Omitted when no parameter is present.

Recommendation Q.787 (09/97)

161

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_1_3_2_3 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.3.2.3 REFERENCE: 3.2.1/Q.774; 3.7.4/Q.772 TITLE: Valid functions; Remote Reject SUBTITLE: Remote Reject by TC-User; Return Error problem code PURPOSE:

Sheet: 1 of 2

To verify that the remote rejection by TC-User with Return Error problem code can be received and delivered to the TC-User

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP B contains an Invoke component 2) Arrange the data at SP B such that a Reject component with Return Error problem code can be generated CONFIGURATION: 1 TYPE OF TEST: VAT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL)  TC-INVOKE ind. <============ TC-U-ERROR req. ============> RETURN ERROR (i)   TC-U-REJECT ind. <============ REJECT (i) SP B (CSL) INVOKE (i)

TEST DESCRIPTION 1. 2. 3. Initiate a single Class 1 operation invocation from SP B to SP A. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? CHECK B: WAS THE REJECT COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP B to SP A Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

162

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.3.2.3 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents an operation code) parameters (provided by the TC-User) RETURN ERROR component in TSL message from SP A to SP B Component type tag: 10100011 (RETURN ERROR) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Error code tag: 00000010 (local) or 00000110 (global) Error code length: correct number of octets (e.g. 00000001 if y is one octet long) Error code: y parameters (provided by the TC-User) REJECT component in TSL message from SP B to SP A Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Problem code tag: 10000011 (RETURN ERROR) Problem code length: 00000001 Problem code: 00000010 (unrecognized error)

Recommendation Q.787 (09/97)

163

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_1_3_3_1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.3.3.1 REFERENCE: 3.2.1/Q.774 TITLE: Valid functions; Remote Reject

Sheet: 1 of 2

SUBTITLE: Remote Reject with an Invoke problem code; Class 1 operation invocation PURPOSE: To verify that a single Class 1 operation can be successfully invoked and the remote rejection can be received and delivered to the TC-User

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains an Invoke component 2) Arrange the data at SP B such that a Reject component can be generated CONFIGURATION: 1 TYPE OF TEST: VAT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i)   TC-U-REJECT ind. <============ TEST DESCRIPTION 1. 2. 3. 4. Initiate a single Class 1 operation invocation from SP A to SP B. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE REJECT COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? CHECK C: WAS THE INVOCATION STATE MACHINE IDLE AT SP A? REJECT (i) SP B (CSL)

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

164

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.3.3.1 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a operation code) parameters (provided by the TC-User) REJECT component in TSL message from SP B to SP A Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Problem code tag: 10000001 (INVOKE) Problem code length: 00000001 Problem code: 00000010 (wrong type parameter)

Recommendation Q.787 (09/97)

165

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_1_3_3_2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.3.3.2 REFERENCE: 3.2.1/Q.774 TITLE: Valid functions; Remote Reject

Sheet: 1 of 2

SUBTITLE: Remote Reject with an Invoke problem code; Class 2 operation invocation PURPOSE: To verify that a single Class 2 operation can be successfully invoked and the remote rejection can be received and delivered to the TC-User

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains an Invoke component 2) Arrange the data at SP B such that a Reject component can be generated CONFIGURATION: 1 TYPE OF TEST: VAT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i)   TC-U-REJECT ind. <============ TEST DESCRIPTION 1. 2. 3. 4. Initiate a single Class 2 operation invocation from SP A to SP B. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE REJECT COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? CHECK C: WAS THE INVOCATION STATE MACHINE IDLE AT SP A? REJECT (i) SP B (CSL)

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

166

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.3.3.2 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a operation code) parameters (provided by the TC-User) REJECT component in TSL message from SP B to SP A Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Problem code tag: 10000001 (INVOKE) Problem code length: 00000001 Problem code: 00000010 (wrong type parameter)

Recommendation Q.787 (09/97)

167

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_1_3_3_3 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.3.3.3 REFERENCE: 3.2.1/Q.774 TITLE: Valid functions; Remote Reject

Sheet: 1 of 2

SUBTITLE: Remote Reject with an Invoke problem code; Class 3 operation invocation PURPOSE: To verify that a single Class 3 operation can be successfully invoked and the remote rejection can be received and delivered to the TC-User

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains an Invoke component 2) Arrange the data at SP B such that a Reject component can be generated CONFIGURATION: 1 TYPE OF TEST: VAT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i)   TC-U-REJECT ind. <============ TEST DESCRIPTION 1. 2. 3. 4. Initiate a single Class 3 operation invocation from SP A to SP B. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE REJECT COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? CHECK C: WAS THE INVOCATION STATE MACHINE IDLE AT SP A? REJECT (i) SP B (CSL)

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

168

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.3.3.3 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents an operation code) parameters (provided by the TC-User) REJECT component in TSL message from SP B to SP A Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Problem code tag: 10000001 (INVOKE) Problem code length: 00000001 Problem code: 00000010 (wrong type parameter)

Recommendation Q.787 (09/97)

169

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_1_3_3_4 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.3.3.4 REFERENCE: 3.2.1/Q.774 TITLE: Valid functions; Remote Reject

Sheet: 1 of 2

SUBTITLE: Remote Reject with an Invoke problem code; Class 4 operation invocation PURPOSE: To verify that a single Class 4 operation can be successfully invoked and the remote rejection can be received and delivered to the TC-User

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains an Invoke component 2) Arrange the data at SP B such that a Reject component can be generated CONFIGURATION: 1 TYPE OF TEST: VAT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i)   TC-U-REJECT ind. <============ TEST DESCRIPTION 1. 2. 3. 4. Initiate a single Class 4 operation invocation from SP A to SP B. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE REJECT COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? CHECK C: WAS THE INVOCATION STATE MACHINE IDLE AT SP A? REJECT (i) SP B (CSL)

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

170

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.3.3.4 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a operation code) parameters (provided by the TC-User) REJECT component in TSL message from SP B to SP A Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Problem code tag: 10000001 (INVOKE) Problem code length: 00000001 Problem code: 00000010 (wrong type parameter)

Recommendation Q.787 (09/97)

171

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_1_4_1_1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.4.1.1 REFERENCE: 3.2.2.2/Q.774 TITLE: Valid functions; Reception of component leading to TC-User reject SUBTITLE: Invoke problem; Unrecognized operation code PURPOSE: To verify that a rejection of a requested operation can be performed

Sheet: 1 of 2

PRE-TEST CONDITIONS:

Arrange the stimulus such that an appropriate TSL message generated at SP B contains an Invoke component with an error as described below TYPE OF TEST: VAT TYPE OF SP: SP

CONFIGURATION: 1

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL)  TC-INVOKE ind. <============ TC-U-REJECT req. ============> REJECT (i)  SP B (CSL) INVOKE (i)

TEST DESCRIPTION 1. 2. 3. Initiate an operation invocation from SP B to SP A with an unrecognized operation code. CHECK A: WAS THE REJECT COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE INVOKE ID IN THE REJECT COMPONENT THE SAME AS THE ONE IN THE INVOKE COMPONENT?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP B to SP A Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

172

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.4.1.1 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents an invalid operation code) parameters (provided by the TC-User) REJECT component in TSL message sent from SP A to SP B Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Problem code tag: 10000001 (INVOKE problem type) Problem code length: 00000001 Problem code: 00000001 (unrecognized operation)

Recommendation Q.787 (09/97)

173

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_1_4_1_2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.4.1.2 REFERENCE: 3.2.2/Q.774 TITLE: Valid functions; Reception of component leading to TC-User reject SUBTITLE: Invoke problem; Unexpected linked operation PURPOSE:

Sheet: 1 of 3

To verify that a rejection can be successfully initiated due to an unexpected linked operation and without affecting the original invocation.

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains an Invoke component 2) Arrange the data at SP B such that an Invoke with a linked ID is contained in an appropriate TSL message CONFIGURATION: 1 TYPE OF TEST: VAT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i)   TC-INVOKE ind. <============ TC-U-REJECT req. ============> REJECT (j)   TC-RESULT-L ind. <============ RETURN RESULT-LAST (i) INVOKE (j, i) SP B (CSL)

TEST DESCRIPTION 1. 2. 3. 4. 5. 6. Initiate an unlinked operation invocation from SP A to SP B. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS A LINKED INVOKE COMPONENT PASSED TO THE TC-USER BY SP A? CHECK C: WAS THE REJECT COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK D: WAS THE INVOKE ID IN THE REJECT COMPONENT THE SAME AS THE INVOKE ID IN THE INVOKE COMPONENT SENT BY SP B? CHECK E: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?

174

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.4.1.2 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

Sheet: 2 of 3

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) INVOKE component in the TSL message sent by SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: j (j represents an integer) Linked ID tag: 10000000 Linked ID length: 00000001 (one octet) Linked ID: i (i is an integer) Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if y is one octet long) Operation code: y (y represents an operation code not linked to x) parameters (provided by the TC-User) REJECT component in TSL message sent by SP A Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: j Problem code tag: 10000001 (INVOKE) Problem code length: 00000001 Problem code: 00000111 (unexpected linked operation)

Recommendation Q.787 (09/97)

175

TEST NUMBER: 2.1.4.1.2 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES RETURN RESULT-LAST component in TSL message from SP B to SP A Component type tag: 10100010 (RETURN RESULT-LAST) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Sequence tag: 00110000 (see Note) Sequence length: corect number of octets (see Note)

Sheet: 3 of 3

Operation code tag: 00000010 (local) or 00000110 (global) (see Note) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) (see Note) Operation code: x (see Note) parameters (provided by the TC-User) NOTE ­ Omitted when no parameter is present.

176

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_1_4_1_3 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.4.1.3 REFERENCE: 3.2.1/Q.774 TITLE: Valid functions; Reception of component leading to TC-User reject SUBTITLE: Invoke problem; Linked response unexpected PURPOSE: To verify that an unexpected linked response can be rejected

Sheet: 1 of 3

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP B contains an Invoke component which will invoke a linked operation 2) Arrange the data at SP B such that a linked response contains at least one parameter which is not associated with the outcome of the operation CONFIGURATION: 1 TYPE OF TEST: VAT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i)   TC-INVOKE ind. <============ TC-U-REJECT req. ============> REJECT (j)   TC-RESULT-L ind. <============ RETURN RESULT-LAST (i) INVOKE (j, i) SP B (CSL)

TEST DESCRIPTION 1. 2. 3. 4. 5. 6. Initiate an operation invocation from SP A to SP B. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS A LINKED INVOKE COMPONENT PASSED TO THE TC-USER BY SP A? CHECK C: WAS THE REJECT COMPONENT SENT BY SP A? CHECK D: WAS THE RETURN RESULT-LAST COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? CHECK E: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?

Recommendation Q.787 (09/97)

177

TEST NUMBER: 2.1.4.1.3 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

Sheet: 2 of 3

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code that does not allow any linked operation) parameters (provided by the TC-User) INVOKE component in the TSL message sent from SP B to SP A Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: j (j represents an integer) Linked ID tag: 10000000 Linked ID length: 00000001 (one octet) Linked ID: i Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if y is one octet long) Operation code: y (y represents a valid operation code) parameters (provided by the TC-User) REJECT component in TSL message sent by SP A Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: j

178

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.4.1.3 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Problem code tag: 10000001 (INVOKE) Problem code length: 00000001 Problem code: 00000111 (linked response unexpected) RETURN RESULT-LAST component in TSL message by SP B Component type tag: 10100010 (RETURN RESULT-LAST) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Sequence tag: 00110000 (see Note) Sequence length: corect number of octets (see Note)

Sheet: 3 of 3

Operation code tag: 00000010 (local) or 00000110 (global) (see Note) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) (see Note) Operation code: x (see Note) parameters (provided by the TC-User) NOTE ­ Omitted when no parameter is present.

Recommendation Q.787 (09/97)

179

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_1_4_1_4 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.4.1.4 REFERENCE: 3.2.2.2/Q.774 TITLE: Valid functions; Reception of component leading to TC-User reject SUBTITLE: Invoke problem; Wrong type parameter PURPOSE: To verify that a rejection of a requested operation can be performed

Sheet: 1 of 2

PRE-TEST CONDITIONS:

Arrange the stimulus such that an appropriate TSL message generated at SP B contains an Invoke component with an error as described below TYPE OF TEST: VAT TYPE OF SP: SP

CONFIGURATION: 1

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL)  TC-INVOKE ind. <============ TC-U-REJECT req. ============> REJECT (i)  SP B (CSL) INVOKE (i)

TEST DESCRIPTION 1. 2. 3. Initiate an operation invocation from SP B to SP A with a wrong type parameter included. CHECK A: WAS THE REJECT COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE INVOKE ID IN THE REJECT COMPONENT THE SAME AS THE ONE IN THE INVOKE COMPONENT?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP B to SP A Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

180

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.4.1.4 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User, including at least one parameter which is not one of those associated with the operation) REJECT component in TSL message from SP A to SP B Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Problem code tag: 10000001 (Invoke problem type) Problem code length: 00000001 Problem code: 00000010 (wrong type parameter)

Recommendation Q.787 (09/97)

181

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_1_4_2_1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.4.2.1 REFERENCE: 3.2.2/Q.774 TITLE: Valid functions; Reception of component leading to TC-User reject SUBTITLE: Return Result problem; Wrong type parameter PURPOSE:

Sheet: 1 of 2

To verify that a rejection can be successfully initiated due to an invalid operation code included in the Return Result-Last component

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains an Invoke component for Class 1 or 3 2) Arrange the data at SP B such that a Return Result-Last with an invalid operation code is generated CONFIGURATION: 1 TYPE OF TEST: VAT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i)   TC-RESULT-L ind. <============ TC-U-REJECT req. ============> REJECT (i)  RETURN RESULT-LAST (i) SP B (CSL)

TEST DESCRIPTION 1. 2. 3. 4. 5. Initiate an operation invocation from SP A to SP B. Generate a response from SP B to SP A with a valid Invoke ID but a different operation code. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE RETURN RESULT-LAST COMPONENT PASSED TO TC-USER BY SP A? CHECK C: WAS THE REJECT COMPONENT SENT BY SP A? CHECK D: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?

182

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.4.2.1 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

Sheet: 2 of 2

Operation code tag: 00000010 (local) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) RETURN RESULT-LAST component in TSL message from SP B to SP A Component type tag: 10100010 (RETURN RESULT-LAST) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Sequence tag: 00110000 (see Note) Sequence length: correct number of octets (see Note) Operation code tag: 00000010 (local) or 00000110 (global) (see Note) Operation code length: correct number of octets (e.g. 00000001 if y is one octet long) (see Note) Operation code: y (y is different from x) (see Note) parameters (provided by the TC-User) REJECT component in TSL message from SP A to SP B Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Problem code tag: 10000010 (RETURN RESULT) Problem code length: 00000001 Problem code: 00000010 (wrong type parameter) NOTE ­ Omitted when no parameter is present.

Recommendation Q.787 (09/97)

183

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_1_4_3_1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.4.3.1 REFERENCE: 3.2.2/Q.774 TITLE: Valid functions; Reception of component leading to TC-User reject SUBTITLE: Return Error problem; Unrecognized error PURPOSE:

Sheet: 1 of 2

To verify that a rejection can be successfully initiated due to an unrecognized error code included in the Return Error component

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains an Invoke component of Class 1 2) Arrange the data at SP B such that a Return Error with an invalid error code is generated CONFIGURATION: 1 TYPE OF TEST: VAT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i)   TC-U-ERROR ind. <============ TC-U-REJECT req. ============> REJECT (i)  RETURN ERROR (i) SP B (CSL)

TEST DESCRIPTION 1. Initiate A Class 1 operation invocation from SP A to SP B. Generate an unsuccessful response from SP B to SP A with a valid Invoke ID but an invalid error code for this operation. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE RETURN ERROR COMPONENT PASSED TO TC-USER BY SP A? CHECK C: WAS THE REJECT COMPONENT SENT BY SP A? CHECK D: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?

2. 3. 4. 5.

184

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.4.3.1 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) RETURN ERROR component in TSL message from SP B to SP A Component type tag: 10100011 (RETURN ERROR) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Error code tag: 00000010 (local) or 00000110 (global) Error code length: correct number of octets (e.g. 00000001 if y is one octet long) Error code: y (y is an invalid error code for this operation) parameters (provided by the TC-User) REJECT component in TSL message from SP A to SP B Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Problem code tag: 10000011 (RETURN ERROR) Problem code length: 00000001 Problem code: 00000010 (unrecognized error)

Recommendation Q.787 (09/97)

185

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_1_4_3_2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.4.3.2 REFERENCE: 3.2.2/Q.774 TITLE: Valid functions; Reception of component leading to TC-User reject SUBTITLE: Return Error problem; Unexpected error PURPOSE:

Sheet: 1 of 2

To verify that a rejection can be successfully initiated due to an unexpected error code included in the Return Error component

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains an Invoke component of Class 1 2) Arrange the data at SP B such that a Return Error with an unexpected error code is generated CONFIGURATION: 1 TYPE OF TEST: VAT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i)   TC-U-ERROR ind. <============ TC-U-REJECT req. ============> REJECT (i)  RETURN ERROR (i) SP B (CSL)

TEST DESCRIPTION 1. Initiate a Class 1 operation invocation from SP A to SP B. Generate an unsuccessful response from SP B to SP A with a valid Invoke ID but an unexpected error code for this operation. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE RETURN ERROR COMPONENT PASSED TO TC-USER BY SP A? CHECK C: WAS THE REJECT COMPONENT SENT BY SP A? CHECK D: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?

2. 3. 4. 5.

186

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.4.3.2 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) RETURN ERROR component in TSL message from SP B to SP A Component type tag: 10100011 (RETURN ERROR) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Error code tag: 00000010 (local) or 00000110 (global) Error code length: correct number of octets (e.g. 00000001 if y is one octet long) Error code: y (y is an error code that is not one of those which the invoked operation may report) parameters (provided by the TC-User) REJECT component in TSL message from SP A to SP B Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Problem code tag: 10000011 (RETURN ERROR) Problem code length: 00000001 Problem code: 00000011 (unexpected error)

Recommendation Q.787 (09/97)

187

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_1_4_3_3 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.4.3.3 REFERENCE: 3.2.2/Q.774 TITLE: Valid functions; Reception of component leading to TC-User reject SUBTITLE: Return Error problem; Wrong type parameter PURPOSE:

Sheet: 1 of 2

To verify that a rejection can be successfully initiated due to a wrong type parameter included in the Return Error component

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains an Invoke component of Class 1 2) Arrange the data at SP B such that a Return Error with a wrong type parameter is generated CONFIGURATION: 1 TYPE OF TEST: VAT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i)   TC-U-ERROR ind. <============ TC-U-REJECT req. ============> REJECT (i)  RETURN ERROR (i) SP B (CSL)

TEST DESCRIPTION 1. Initiate a Class 1 operation invocation from SP A to SP B. Generate an unsuccessful response from SP B to SP A with a valid Invoke ID but a wrong type parameter for this operation. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE RETURN ERROR COMPONENT PASSED TO TC-USER BY SP A? CHECK C: WAS THE REJECT COMPONENT SENT BY SP A? CHECK D: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?

2. 3. 4. 5.

188

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.4.3.3 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) RETURN ERROR component in TSL message from SP B to SP A Component type tag: 10100011 (RETURN ERROR) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Error code tag: 00000010 (local) or 00000110 (global) Error code length: correct number of octets (e.g. 00000001 if y is one octet long) Error code: y (y is a valid error code for this operation) parameters (provided by the TC-User, including at least one parameter tag which is not one of those associated with the outcome of the operation) REJECT component in TSL message from SP A to SP B Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Problem code tag: 10000011 (RETURN ERROR) Problem code length: 00000001 Problem code: 00000100 (wrong type parameter)

Recommendation Q.787 (09/97)

189

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_1_7_1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.7.1 REFERENCE: 3.3/Q.773 TITLE: Valid functions; Encoding variations SUBTITLE: Component length definite short PURPOSE:

Sheet: 1 of 2

To verify that a component portion with a definite short form can be accepted

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP B contains an Invoke component 2) Arrange the data at SP A such that a Return Result-Last component can be generated CONFIGURATION: 1 TYPE OF TEST: VAT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL)  TC-INVOKE ind. <============ TC-RESULT-L req. ============> RETURN RESULT-LAST (i)  SP B (CSL) INVOKE (i)

TEST DESCRIPTION 1. 2. 3. Initiate a Class 1 or 3 operation invocation from SP B to SP A. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? CHECK B: WAS THE RETURN RESULT-LAST COMPONENT WITH CORRECT INFORMATION SENT BY SP A?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP B to SP A Component type tag: 10100001 (INVOKE) Component length: correct number of octets (definite short form) Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

198

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.7.1 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) RETURN RESULT-LAST component in TSL message from SP A to SP B Component type tag: 10100011 (RETURN RESULT-LAST) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Sequence tag: 00110000 (see Note) Sequence length: correct number of octets (see Note) Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) (see Note) Operation code: x (see Note) parameters (provided by the TC-User) NOTE ­ Omitted when no parameter is present.

Recommendation Q.787 (09/97)

199

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_1_7_2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.7.2 REFERENCE: 3.3/Q.773 TITLE: Valid functions; Encoding variations SUBTITLE: Component length definite long PURPOSE:

Sheet: 1 of 2

To verify that a component portion with a definite long form can be accepted

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP B contains an Invoke component 2) Arrange the data at SP A such that a Return Result-Last component can be generated CONFIGURATION: 1 TYPE OF TEST: VAT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL)  TC-INVOKE ind. <============ TC-RESULT-L req. ============> RETURN RESULT-LAST (i)  SP B (CSL) INVOKE (i)

TEST DESCRIPTION 1. 2. 3. Initiate a Class 1 or 3 operation invocation from SP B to SP A. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? CHECK B: WAS THE RETURN RESULT-LAST COMPONENT WITH CORRECT INFORMATION SENT BY SP A?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP B to SP A Component type tag: 10100001 (INVOKE) Component length: correct number of octets (definite long) Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

200

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.7.2 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) RETURN RESULT-LAST component in TSL message from SP A to SP B Component type tag: 10100010 (RETURN RESULT-LAST) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Sequence tag: 00000010 (see Note) Sequence length: correct number of octets (see Note) Operation code tag: 00000010 (local) or 00000110 (global) (see Note) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) (see Note) Operation code: x (see Note) parameters (provided by the TC-User) NOTE ­ Omitted when no parameter is present.

Recommendation Q.787 (09/97)

201

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_1_7_3 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.7.3 REFERENCE: 3.3/Q.773 TITLE: Valid functions; Encoding variations SUBTITLE: Component length indefinite PURPOSE:

Sheet: 1 of 2

To verify that a component portion with a indefinite form can be accepted

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP B contains an Invoke component 2) Arrange the data at SP A such that a Return Result-Last component can be generated CONFIGURATION: 1 TYPE OF TEST: VAT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL)  TC-INVOKE ind. <============ TC-RESULT-L req. ============> RETURN RESULT-LAST (i)  SP B (CSL) INVOKE (i)

TEST DESCRIPTION 1. 2. 3. Initiate a Class 1 or 3 operation invocation from SP B to SP A. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? CHECK B: WAS THE RETURN RESULT-LAST COMPONENT WITH CORRECT INFORMATION SENT BY SP A?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP B to SP A Component type tag: 10100001 (INVOKE) Component length: correct number of octets (indefinite form) Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

202

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.7.3 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) EOC Tag: 00000000 EOC Length: 00000000 RETURN RESULT-LAST component in TSL message from SP A to SP B Component type tag: 10100010 (RETURN RESULT-LAST) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Sequence tag: 00110000 (see Note) Sequence length: correct number of octets (see Note) Operation code tag: 00000010 (local) or 00000110 (global) (see Note) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (see Note) parameters (provided by the TC-User) NOTE ­ Omitted when no parameter is present.

Recommendation Q.787 (09/97)

203

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_1_7_4_1_1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.7.4.1.1 REFERENCE: 6.2/Q.773 TITLE: Valid functions; Encoding variations SUBTITLE: Value variations; Invoke ID; Invoke ID = ­127 (FFh) PURPOSE:

Sheet: 1 of 2

To verify that the IUT (SP A) is able to deal with correct encoding of component ID (upper value) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP B contains an Invoke component TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL)  TC-INVOKE ind. <============ TC-RESULT-L req. ============> RETURN RESULT-LAST (i)  SP B (CSL) INVOKE (i)

TEST DESCRIPTION 1. 2. 3. 4. 5. Initiate a single operation invocation from SP B to SP A with Invoke ID set to 11111111. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? CHECK B: WAS THE RETURN RESULT-LAST COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK C: WAS THE INVOKE ID IN THE RETURN RESULT-LAST COMPONENT THE SAME AS THE ONE IN THE INVOKE COMPONENT? CHECK D: WAS THE OPERATION CODE IN THE RETURN RESULT-LAST COMPONENT THE SAME AS THE ONE IN THE INVOKE COMPONENT?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP B to SP A Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: 11111111 (FFh)

204

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.7.4.1.1 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) RETURN RESULT-LAST component in TSL message from SP A to SP B Component type tag: 10100010 (RETURN RESULT-LAST) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: 11111111 (FFh) Sequence tag: 00110000 (see Note) Sequence length: correct number of octets (see Note) Operation code tag: 00000010 (local) or 00000110 (global) (see Note) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) (see Note) Operation code: x (see Note) parameters (provided by the TC-User) NOTE ­ Omitted when no parameter is present.

Recommendation Q.787 (09/97)

205

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_1_7_4_1_2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.7.4.1.2 REFERENCE: 6.2/Q.773 TITLE: Valid functions; Encoding variations SUBTITLE: Value variations; Invoke ID; Invoke ID = 0 (00h) PURPOSE:

Sheet: 1 of 2

To verify that the IUT (SP A) is able to deal with correct encoding of component ID (lower value) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP B contains an Invoke component TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL)  TC-INVOKE ind. <============ TC-RESULT-L req. ============> RETURN RESULT-LAST (i)  SP B (CSL) INVOKE (i)

TEST DESCRIPTION 1. 2. 3. 4. 5. Initiate a single operation invocation from SP B to SP A with Invoke ID set to 0. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? CHECK B: WAS THE RETURN RESULT-LAST COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK C: WAS THE INVOKE ID IN THE RETURN RESULT-LAST COMPONENT THE SAME AS THE ONE IN THE INVOKE COMPONENT? CHECK D: WAS THE OPERATION CODE IN THE RETURN RESULT-LAST COMPONENT THE SAME AS THE ONE IN THE INVOKE COMPONENT?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP B to SP A Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: 0

206

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.7.4.1.2 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) RETURN RESULT-LAST component in TSL message from SP A to SP B Component type tag: 10100010 (RETURN RESULT-LAST) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: 0 Sequence tag: 00110000 (see Note) Sequence length: correct number of octets (see Note) Operation code tag: 00000010 (local) or 00000110 (global) (see Note) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) (see Note) Operation code: x (see Note) parameters (provided by the TC-User) NOTE ­ Omitted when no parameter is present.

Recommendation Q.787 (09/97)

207

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_1_7_4_2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.7.4.2 REFERENCE: 6.3/Q.773 TITLE: Valid functions; Encoding variations SUBTITLE: Value variations; Global operation code PURPOSE: To verify that a global operation code is correctly decoded by TCAP

Sheet: 1 of 2

PRE-TEST CONDITIONS:

Arrange the TC-User stimulus such that an appropriate TSL message generated at SP B contains an Invoke component with a global operation code. The global value does not correspond to a supported operation TYPE OF TEST: VAT TYPE OF SP: SP

CONFIGURATION: 1

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL)  TC-INVOKE ind. <============ TC-U-REJECT req. ============> REJECT (i) TEST DESCRIPTION 1. 2. 3. Initiate an operation invocation from SP B to SP A with a non-supported global operation code. CHECK A: WAS THE REJECT COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE INVOKE ID IN THE REJECT COMPONENT THE SAME AS THE ONE IN THE INVOKE COMPONENT?  SP B (CSL) INVOKE (i)

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP B to SP A Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer) Operation code tag: 00000110 (global) Operation code length: 00000011 (3) Operation code: 0000 0000 0001 0001 1000 0101

208

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.7.4.2 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES REJECT component in TSL message from SP A to SP B Component type tag: 10100001 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Problem code tag: 10000001 (INVOKE problem type) Problem code length: 00000001 Problem code: 00000001 (unrecognized operation)

Sheet: 2 of 2

Recommendation Q.787 (09/97)

209

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_1_8_1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.8.1 REFERENCE: Q.774 TITLE: Valid functions; Multiple components grouping SUBTITLE: Multiple operations invocation; receiving success PURPOSE:

Sheet: 1 of 2

To verify that multiple operations can be successfully invoked and the successful completions of the operations can be received

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains multiple components 2) Arrange the TC-User at SP B to send successful completions with an appropriate TSL message CONFIGURATION: 1 TYPE OF TEST: VAT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. (#1) ============> · · · TC-INVOKE req. (#n) ============> INVOKE #1, ..., #n a)  RETURN RESULT-LAST #1, ..., #na)  TC-RESULT-L ind. (#1) <============ · · · TC-RESULT-L ind. (#n) <============
a)

SP

B

(CSL)

The sequence of the components is provided by the TC-User.

NOTE ­ Number of components is subject to the TC-User. TEST DESCRIPTION 1. 2. 3. Initiate multiple operations within a TSL message from SP A to SP B. CHECK A: WERE ALL THE INVOKE COMPONENTS WITHIN A TSL MESSAGE SENT BY SP A WITH CORRECT INFORMATION? CHECK B: WERE ALL THE RETURN-LAST COMPONENTS INSIDE A TSL MESSAGE PASSED TO TC-USER IN THE SAME ORDER AS PROVIDED BY SP B WITH CORRECT INFORMATION? CHECK C: WERE ALL THE INVOKE STATE MACHINES (1, ..., n) IDLE AT SP A?

4.

210

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.8.1 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: 1, or, ..., n corresponding to the INVOKE #1, ..., #n

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x1, ..., xn representing valid operation codes parameters (provided by the TC-User) RETURN RESULT-LAST component in TSL message from SP B to SP A Component type tag: 10100010 (RETURN RESULT-LAST) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: 1, or, ..., n Sequence tag: 00110000 (see Note) Sequence length: correct number of octets (see Note) Operation code tag: 00000010 (local) or 00000110 (global) (see Note) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) (see Note) Operation code: x1, or, ..., xn (see Note) parameters (provided by the TC-User) NOTE ­ Omitted when no parameter is present.

Recommendation Q.787 (09/97)

211

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_1_8_2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.8.2 REFERENCE: Q.774 TITLE: Valid functions; Multiple components grouping SUBTITLE: Multiple operations invocation; reporting success PURPOSE:

Sheet: 1 of 2

To verify that multiple operations can be successfully invoked and the successful completions of the operations can be sent

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP B contains multiple components 2) Arrange the TC-User at SP A to send successful completions with an appropriate TSL message CONFIGURATION: 1 TYPE OF TEST: VAT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) INVOKE #1, ..., #n  TC-INVOKE ind. (#1) <============ · · · TC-INVOKE ind. (#n) <============ TC-RESULT-L req. (#1) ============> · · · TC-RESULT-L req. (#n) ============> RETURN RESULT-LAST #n, ..., #1a) 
a) a)

SP

B

(CSL)

The sequence of the components is provided by the TC-User.

NOTE ­ Number of components is subject to the TC-User.

TEST DESCRIPTION 1. 2. Initiate multiple operations within a TSL message from SP B to SP A. CHECK A: WERE ALL THE INVOKE COMPONENTS WITHIN A TSL MESSAGE PASSED TO TC-USER IN THE SAME ORDER AS PROVIDED BY SP B WITH CORRECT INFORMATION? CHECK B: WERE ALL THE RETURN RESULT-LAST COMPONENTS WITHIN A TSL MESSAGE SENT BY SP A WITH CORRECT INFORMATION? CHECK C: WAS THE INVOKE ID IN EACH OF THE RETURN RESULT-LAST COMPONENTS ONE-TO-ONE CORRESPONDENT WITH THE ONE IN EACH OF THE INVOKE COMPONENTS?

3. 4.

212

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.8.2 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP B to SP A Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: 1, or, ..., n corresponding to the INVOKE #1, ..., #n

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x1, ..., xn representing valid operation codes parameters (provided by the TC-User) RETURN RESULT-LAST component in TSL message from SP A to SP B Component type tag: 10100010 (RETURN RESULT-LAST) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: 1, or, ..., n Sequence tag: 00110000 (see Note) Sequence length: correct number of octets (see Note) Operation code tag: 00000010 (local) or 00000110 (global) (see Note) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) (see Note) Operation code: x1, or, ..., xn (see Note) parameters (provided by the TC-User) NOTE ­ Omitted when no parameter is present.

Recommendation Q.787 (09/97)

213

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_1_8_3 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.8.3 REFERENCE: 3.2.2.2/Q.774 TITLE: Valid functions; Multiple components grouping SUBTITLE: A malformed component received PURPOSE:

Sheet: 1 of 3

To verify that subsequent components in the message can be discarded when a badly structured component is detected by the component sublayer Arrange the TC-User stimulus such that an appropriate TSL message generated at SP B contains multiple components, the second of which is badly structured TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) INVOKE #1, #2, #3 (Note 1)  (#2 badly structured, e.g. operation code missing) TC-INVOKE ind. (#1) <============ TC-L-REJECT ind. (#2) <============ TC-RESULT-L req. (#1) ============> REJECT #2, RETURN RESULT-LAST #1 (Note 2)  SP B (CSL)

NOTE 1 ­ The sequence of the Invoke components is important. NOTE 2 ­ The sequence of these components is not important.

TEST DESCRIPTION 1. 2. 3. Initiate multiple operations within a TSL message from SP B to SP A with the order shown in the diagram. CHECK A: WAS THE FIRST INVOKE COMPONENT PASSED TO TC-USER? CHECK B: WERE ONLY THE RETURN RESULT-LAST COMPONENT FOR THE FIRST OPERATION AND THE REJECT COMPONENT FOR THE SECOND OPERATION SENT BY SP A?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets

214

Recommendation Q.787 (09/97)

TEST NUMBER: 2.1.8.3 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES INVOKE #1 component in TSL message from SP B to SP A Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: 1

Sheet: 2 of 3

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x is a valid operation code parameters (provided by the TC-User) INVOKE #2 component in TSL message from SP B to SP A Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: 2 parameters (provided by the TC-User) INVOKE #3 component in TSL message from SP B to SP A Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: 3 Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x is a valid operation code parameters (provided by the TC-User)

Recommendation Q.787 (09/97)

215

TEST NUMBER: 2.1.8.3 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES RETURN RESULT-LAST #1 component in TSL message from SP A to SP B Component type tag: 10100010 (RETURN RESULT-LAST) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: 1 Sequence tag: 00110000 (see Note) Sequence length: correct number of octets (see Note)

Sheet: 3 of 3

Operation code tag: 00000010 (local) or 00000110 (global) (see Note) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) (see Note) Operation code: x parameters (provided by the TC-User) REJECT #2 component in TSL message from SP A to SP B Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: 2 Problem code tag: 10000000 (General Problem) Problem code length: 00000001 Problem code: 00000010 (badly structured component) NOTE ­ Omitted when no parameter is present.

216

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_1_9_5_3 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.9.5.3 REFERENCE: 3.2.1.2/Q.774 TITLE: Valid functions; Dialogue Portion

Sheet: 1 of 1

SUBTITLE: Transport of User information; accept user information in subsequent Continue message PURPOSE: To verify that SP A can accept a user information element in a subsequent Continue message SP A (TSL) and SP B (TSL) are to be in the idle state and test cases 2.1.9.5.2 has to be executed successfully TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1 EXPECTED MESSAGE SEQUENCE: SP A (CSL)

SP 

B

(CSL)

BEGIN (AARQ)

TR-BEGIN ind. <============ TR-CONTINUE req. ============> CONTINUE (AARE)   TR-CONTINUE ind. <============ TEST DESCRIPTION 1. 2. 3. 4. Arrange for SP B to send a Begin message with dialogue request to SP A. Arrange for SP A to confirm the dialogue. Arrange for SP B to send a Continue message including an user information element as dialogue portion. CHECK A: VERIFY THAT THE IUT AT SP A ACCEPTED THE USER INFORMATION ELEMENT Also arrange an END message to be sent by IUT or by the Tester. When the last message has been sent by Tester, the END message sent by IUT can be used to check that the last message has been correctly received. CHECK TABLE FOR INFORMATION ELEMENTS WITHIN DIALOGUE PORTION Dialogue portion in Continue message Dialogue portion tag: 01101011 Dialogue portion length: correct number of octets External data type in dialogue portion (user information element) External type tag: 00101000 External length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: correct number of octets Direct reference: any abstract syntax Single ASN.1 type tag: 10100000 Single ASN.1 type length: correct number of octets Some bytes of user data in the user defined abstract syntax CONTINUE

Recommendation Q.787 (09/97)

235

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_1_9_7_3 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.9.7.3 REFERENCE: 3.2.1.2/Q.774 TITLE: Valid functions; Dialogue Portion

Sheet: 1 of 1

SUBTITLE: Dialogue control APDU Version Unstructured dialogue; Version not 1 PURPOSE: To verify that an IUT can discard a UNIDIRECTIONAL msg if the first bit of the protocol version field in the dialogue request AUDT, is not set to 1 SP A (TSL) and SP B (TSL) are to be in the idle state and test case 2.1.9.6 has to be executed successfully TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1 EXPECTED MESSAGE SEQUENCE: SP A (CSL) msg discarded TEST DESCRIPTION 1. 2.

SP 

B

(CSL)

UNIDIRECTIONAL (AUDT)

Arrange SP B to send an Unidirectional msg containing APDU AUDT indicating that Version 1 is not supported to SP A. CHECK A: WAS THE UNIDIRECTIONAL MESSAGE WITH APDU ''AUDT'' DISCARDED AT SP A?

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES Dialogue portion in Unidirectional message Dialogue portion tag: 01101011 Dialogue portion length: correct number of octets External data type in dialogue portion External type tag: 00101000 External length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: 00000111 Direct reference: H''00118605010201 Single ASN.1 type tag: 10100000 Single ASN.1 type length: correct number of octets Dialogue PDU Dialogue Request tag: 01100000 Dialogue Request length: correct number of octets Protocol Version tag: 10000000 Protocol Version length: 00000010 Protocol Version: 00000110 01000000 (only version 2 supported) Application context tag: 10100001 Application context length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: correct number of octets Direct reference: any object identifier

242

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_1_9_7_4 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.1.9.7.4 REFERENCE: 3.2.1.2/Q.774 TITLE: Valid functions; Dialogue Portion SUBTITLE: Dialogue control APDU Version Unstructured dialogue; Version 1 PURPOSE:

Sheet: 1 of 2

To verify that an IUT can accept a UNIDIRECTIONAL msg if the first bit of the protocol version is set to 1 and also other bits are set to 1 SP A (TSL) and SP B (TSL) are to be in the idle state and test case 2.1.9.6 has to be executed successfully TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1 EXPECTED MESSAGE SEQUENCE: SP A (CSL)

SP 

B

(CSL)

UNIDIRECTIONAL (AUDT)

TR-UNI ind. <============

TEST DESCRIPTION 1. 2. Arrange SP B to send an Unidirectional msg containing APDU AUDT offering several versions including Version 1, to SP A. CHECK A: WAS THE UNIDIRECTIONAL MESSAGE WITH APDU ''AUDT'' ACCEPTED AT SP A?

Recommendation Q.787 (09/97)

243

TEST NUMBER: 2.1.9.7.4 CHECK TABLE FOR INFORMATION ELEMENTS WITHIN MESSAGES Dialogue portion in Unidirectional message Dialogue portion tag: 01101011 Dialogue portion length: correct number of octets External data type in dialogue portion External type tag: 00101000 External length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: 00000111 Direct reference: H''00118605010201 Single ASN.1 type tag: 10100000 Single ASN.1 type length: correct number of octets Dialogue PDU Dialogue Request tag: 01100000 Dialogue Request length: correct number of octets Protocol Version tag: 10000000 Protocol Version length: 00000010 Protocol Version: 00000110 11000000 (version 1 and version 2 supported) Application context tag: 10100001 Application context length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: correct number of octets Direct reference: any object identifier

Sheet: 2 of 2

244

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_2_1_1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.2.1.1 REFERENCE: 6.2/Q.773 TITLE: Syntactically invalid behaviour; Invalid values for information elements SUBTITLE: Length of Invoke ID >1 in Invoke component PURPOSE:

Sheet: 1 of 2

To verify that a rejection of a requested operation can be performed due to incorrect encoding of component ID (value out of range) Arrange the stimulus such that an appropriate TSL message generated at SP B contains an Invoke component with an error as described below TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL)  TC-L-REJECT ind. <============ REJECT (NULL)  SP B (CSL) INVOKE (i)

TEST DESCRIPTION 1. 2. Initiate an operation invocation from SP B to SP A with Invoke ID equal to 2 octets (illegal value). CHECK A: WAS THE REJECT COMPONENT WITH CORRECT INFORMATION SENT BY SP A?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP B to SP A Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000010 (two octets) Invoke ID: 129

Recommendation Q.787 (09/97)

245

TEST NUMBER: 2.2.1.1 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) REJECT component in TSL message from SP A to SP B Component type tag: 10100100 (REJECT) Component length: correct number of octets NULL tag: 00000101 NULL length: 00000000 Problem code tag: 10000000 (General problem type) Problem code length: 00000001 Problem code: 00000001 (mistyped component)

246

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_2_1_2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.2.1.2 REFERENCE: 6.2/Q.773 TITLE: Syntactically invalid behaviour; Invalid values for information elements SUBTITLE: Length of Invoke ID = 0 in Invoke component PURPOSE:

Sheet: 1 of 1

To verify that a rejection of a requested operation can be performed due to incorrect encoding of component ID (length equals 0) Arrange the stimulus such that an appropriate TSL message generated at SP B contains an Invoke component with an error as described below TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL)  TC-L-REJECT ind. <============ REJECT (NULL)  SP B (CSL) INVOKE

TEST DESCRIPTION 1. 2. Initiate an operation invocation from SP B to SP A with Invoke ID equal to 0 octets (illegal value). CHECK A: WAS THE REJECT COMPONENT WITH CORRECT INFORMATION SENT BY SP A?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP B to SP A Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000000 (zero octet) Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) REJECT component in TSL message from SP A to SP B Component type tag: 10100100 (REJECT) Component length: correct number of octets NULL tag: 00000101 NULL length: 00000000 Problem code tag: 10000000 (General problem type) Problem code length: 00000001 Problem code: 00000001 (wrong type component)

Recommendation Q.787 (09/97)

247

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_2_2_1_1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.2.2.1.1 REFERENCE: 6.2/Q.773 TITLE: Syntactically invalid behaviour; Invalid structure SUBTITLE: Invoke component; Invoke ID missing PURPOSE:

Sheet: 1 of 1

To verify that a rejection of a requested operation can be performed due to Invoke ID missing Arrange the stimulus such that an appropriate TSL message generated at SP B contains an Invoke component with an error as described below TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL)  TC-L-REJECT ind. <============ REJECT (NULL)  SP B (CSL) INVOKE

TEST DESCRIPTION 1. 2. Initiate a single operation invocation from SP B to SP A with Invoke ID missing. CHECK A: WAS THE REJECT COMPONENT WITH CORRECT INFORMATION SENT BY SP A?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP B to SP A Component type tag: 10100001 (INVOKE) Component length: correct number of octets Operation code tag: 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) REJECT component in TSL message from SP A to SP B Component type tag: 10100100 (REJECT) Component length: correct number of octets NULL tag: 00000101 NULL length: 00000000 Problem code tag: 10000000 (General problem type) Problem code length: 00000001 Problem code: 00000001 (wrong type component)

248

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_2_2_1_2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.2.2.1.2 REFERENCE: 3.2.2.2/Q.774 TITLE: Syntactically invalid behaviour; Invalid structure SUBTITLE: Invoke component; Operation code missing PURPOSE:

Sheet: 1 of 1

To verify that a rejection of a requested operation can be performed due to operation code missing Arrange the stimulus such that an appropriate TSL message generated at SP B contains an Invoke component with a syntax error as described below TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL)  TC-L-REJECT ind. <============ REJECT (i)  SP B (CSL) INVOKE (i)

TEST DESCRIPTION 1. 2. 3. Initiate an operation invocation from SP B to SP A with operation code missing. CHECK A: WAS THE REJECT COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE INVOKE ID IN THE REJECT COMPONENT THE SAME AS THE ONE IN THE INVOKE COMPONENT?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP B to SP A Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer) parameters (provided by the TC-User) REJECT component in TSL message from SP A to SP B Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Problem code tag: 10000000 (General problem type) Problem code length: 00000001 Problem code: 00000001 (wrong type component)

Recommendation Q.787 (09/97)

249

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_2_2_2_1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.2.2.2.1 REFERENCE: 3.2.2/Q.774 TITLE: Syntactically invalid behaviour; Invalid structure SUBTITLE: Return Result component; Invoke ID missing PURPOSE:

Sheet: 1 of 2

To verify that a rejection can be successfully initiated due to the absence of the Invoke ID in the Return Result-Last component

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains an Invoke component 2) Arrange the data at SP B such that a Return Result-Last without an Invoke ID is generated CONFIGURATION: 1 TYPE OF TEST: VAT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i)   TC-L-REJECT ind. <============ REJECT (NULL) time expiry for invocation (i)  RETURN RESULT-LAST SP B (CSL)

TEST DESCRIPTION 1. 2. 3. 4. Initiate a Class 1 or 3 operation invocation from SP A to SP B. Generate a response from SP B to SP A without an Invoke ID. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE REJECT COMPONENT SENT BY SP A? CHECK C: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

250

Recommendation Q.787 (09/97)

TEST NUMBER: 2.2.2.2.1 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) RETURN RESULT-LAST component in TSL message from SP B to SP A Component type tag: 10100010 (RETURN RESULT-LAST) Component length: correct number of octets Sequence tag: 00110000 (see Note) Sequence length: correct number of octets (see Note) Operation code tag: 00000010 (local) or 00000110 (global) (see Note) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) (see Note) Operation code: y (y is different from x) (see Note) parameters (provided by the TC-User) REJECT component in TSL message from SP A to SP B Component type tag: 10100100 (REJECT) Component length: correct number of octets NULL tag: 00000101 NULL length: 00000000 Problem code tag: 10000000 (General problem type) Problem code length: 00000001 Problem code: 00000001 (wrong type component) NOTE ­ Omitted when no parameter is present.

Recommendation Q.787 (09/97)

251

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_2_2_2_2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.2.2.2.2 REFERENCE: 3.2.2/Q.774 TITLE: Syntactically invalid behaviour; Invalid structure

Sheet: 1 of 2

SUBTITLE: Return Result component; Operation code missing while parameters included PURPOSE: To verify that a rejection can be successfully initiated due to the operation code being missing in the Return Result-Last component

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains an Invoke component for Class 1 or 3 2) Arrange the data at SP B such that a Return Result-Last without an operation code is generated CONFIGURATION: 1 TYPE OF TEST: VAT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i)   TC-L-REJECT ind. <============ REJECT (i)  RETURN RESULT-LAST (i) SP B (CSL)

TEST DESCRIPTION 1. 2. 3. 4. Initiate an operation invocation from SP A to SP B. Generate a response from SP B to SP A with a valid Invoke ID but a different operation code. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE REJECT COMPONENT SENT BY SP A? CHECK C: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

252

Recommendation Q.787 (09/97)

TEST NUMBER: 2.2.2.2.2 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) RETURN RESULT-LAST component in TSL message from SP B to SP A Component type tag: 10100010 (RETURN RESULT-LAST) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Sequence tag: 00110000 Sequence length: correct number of octets parameters (provided by the TC-User) REJECT component in TSL message from SP A to SP B Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Problem code tag: 10000000 (General problem type) Problem code length: 00000001 Problem code: 00000001 (wrong type component)

Recommendation Q.787 (09/97)

253

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_2_2_2_3 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.2.2.2.3 REFERENCE: 6.4/Q.773; 3.2.2.2/Q.774 TITLE: Syntactically invalid behaviour; Invalid structure

Sheet: 1 of 2

SUBTITLE: Return Result component; Sequence tag missing while parameters included PURPOSE: To verify that a rejection can be successfully initiated due to Sequence tag missing while parameters included

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains an Invoke component 2) Arrange the data at SP B such that an appropriate TSL message contains a Return Result-Last component with an invalid Sequence tag CONFIGURATION: 1 TYPE OF TEST: VAT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i)   TC-L-REJECT ind. <============ REJECT (i)  RETURN RESULT-LAST (i) SP B (CSL)

TEST DESCRIPTION 1. 2. 3. 4. Initiate an operation invocation from SP A to SP B. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE REJECT COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK C: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

254

Recommendation Q.787 (09/97)

TEST NUMBER: 2.2.2.2.3 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) RETURN RESULT-LAST component in TSL message from SP B to SP A Component type tag: 10100010 (RETURN RESULT-LAST) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) REJECT component in TSL message from SP A to SP B Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Problem code tag: 10000000 (General problem type) Problem code length: 00000001 Problem code: 00000001 (wrong type component)

Recommendation Q.787 (09/97)

255

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_2_2_3_1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.2.2.3.1 REFERENCE: 3.2.2/Q.774 TITLE: Syntactically invalid behaviour; Invalid structure SUBTITLE: Return Error; Invoke ID missing PURPOSE:

Sheet: 1 of 2

To verify that a rejection can be successfully initiated due to the absence of the Invoke ID in the Return Error component

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains an Invoke component of the Class 1 2) Arrange the data at SP B such that a Return Error without an Invoke ID is generated CONFIGURATION: 1 TYPE OF TEST: VAT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i)   TC-L-REJECT ind. <============ REJECT (NULL) time expiry for invocation (i)  RETURN ERROR SP B (CSL)

TEST DESCRIPTION 1. 2. 3. 4. Initiate a Class 1 operation invocation from SP A to SP B. Generate an unsuccessful response from SP B to SP A without an Invoke ID. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE REJECT COMPONENT SENT BY SP A? CHECK C: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

256

Recommendation Q.787 (09/97)

TEST NUMBER: 2.2.2.3.1 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) RETURN ERROR component in TSL message from SP B to SP A Component type tag: 10100010 (RETURN ERROR) Component length: correct number of octets Error code tag: 00000010 (local) or 00000110 (global) Error code length: correct number of octets (e.g. 00000001 if y is one octet long) Error code: y (y is an error code which the invoked operation may report) parameters (provided by the TC-User) REJECT component in TSL message from SP A to SP B Component type tag: 10100100 (REJECT) Component length: correct number of octets NULL tag: 00000101 NULL length: 00000000 Problem code tag: 10000000 (General problem type) Problem code length: 00000001 Problem code: 00000001 (mistyped component)

Recommendation Q.787 (09/97)

257

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_2_2_3_2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.2.2.3.2 REFERENCE: 3.2.2/Q.774 TITLE: Syntactically invalid behaviour; Invalid structure SUBTITLE: Return Error; Error code missing PURPOSE:

Sheet: 1 of 2

To verify that a rejection can be successfully initiated due to the absence of the error code in the Return Error component

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains an Invoke component of Class 1 2) Arrange the data at SP B such that a Return Error without an error code is generated CONFIGURATION: 1 TYPE OF TEST: VAT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i)   TC-L-REJECT ind. <============ REJECT (i)  RETURN ERROR (i) SP B (CSL)

TEST DESCRIPTION 1. Initiate a Class 1 operation invocation from SP A to SP B. Generate an unsuccessful response from SP B to SP A with a valid Invoke ID but without error code for this operation. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE REJECT COMPONENT SENT BY SP A? CHECK C: WAS THE INVOCATION STATE MACHINE IDLE AT SP A ?

2. 3. 4.

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

258

Recommendation Q.787 (09/97)

TEST NUMBER: 2.2.2.3.2 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) RETURN ERROR component in TSL message from SP B to SP A Component type tag: 10100011 (RETURN ERROR) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i parameters (provided by the TC-User) REJECT component in TSL message from SP A to SP B Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000101 Invoke ID length: 00000001 Invoke ID: i Problem code tag: 10000000 (General problem type) Problem code length: 00000001 Problem code: 00000001 (mistyped component)

Recommendation Q.787 (09/97)

259

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_2_2_4_1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.2.2.4.1 REFERENCE: 3.2.2.2/Q.774 TITLE: Syntactically invalid behaviour; Invalid structure SUBTITLE: Unknown component type; Invoke ID unrecognizable PURPOSE:

Sheet: 1 of 1

To verify that a rejection can be initiated due to Unknown component type with unrecognized Invoke ID Arrange the stimulus such that an appropriate TSL message generated at SP B contains an Unknown component as described below TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL)  TC-L-REJECT ind. <============ REJECT (NULL)  SP B (CSL) Unknown component

TEST DESCRIPTION 1. 2. Initiate an operation invocation from SP B to SP A with an Unknown component type with any content. CHECK A: WAS THE REJECT COMPONENT WITH CORRECT INFORMATION SENT BY SP A?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets Unknown component in TSL message from SP B to SP A Component type tag: any values except 10100001, 10100010, 10100011, 10100100 and 10100111 Component length: correct number of octets Component content: any REJECT component in TSL message from SP A to SP B Component type tag: 10100100 (REJECT) Component length: correct number of octets NULL tag: 00000101 NULL length: 00000000 Problem code tag: 10000000 (General problem type) Problem code length: 00000001 Problem code: 00000000 (unrecognized component)

260

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_2_2_4_2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.2.2.4.2 REFERENCE: 3.2.2.2/Q.774 TITLE: Syntactically invalid behaviour; Invalid structure SUBTITLE: Unknown component type; Invoke ID derivable PURPOSE:

Sheet: 1 of 1

To verify that a rejection can be initiated due to Unknown component type with derivable Invoke ID Arrange the stimulus such that an appropriate TSL message generated at SP B contains an Unknown component with a derivable Invoke ID as described below TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL)  TC-L-REJECT ind. <============ REJECT (i or NULL) TEST DESCRIPTION 1. 2. Initiate an operation invocation from SP B to SP A with an Unknown component type as described below. CHECK A: WAS THE REJECT COMPONENT WITH CORRECT INFORMATION SENT BY SP A?  SP B (CSL) Unknown component (i)

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets Unknown component in TSL message from SP B to SP A Component type tag: any values except 10100001, 10100010, 10100011, 10100100 and 10100111 Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer) Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents an operation code) parameters (provided by the TC-User) REJECT component in TSL message from SP A to SP B Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i or NULL tag: 00000101 NULL length: 00000000 Problem code tag: 10000000 (General problem type) Problem code length: 00000001 Problem code: 00000000 (unrecognized component)

Recommendation Q.787 (09/97)

261

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_2_2_5_1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.2.2.5.1 REFERENCE: 3.2.2.1/Q.774 TITLE: Syntactically invalid behaviour; Invalid structure SUBTITLE: Dialogue Portion; Missing Application Context in APDU AARQ PURPOSE:

Sheet: 1 of 2

To verify that the IUT aborts the transaction upon reception of a Begin message containing an APDU ''AARQ'' without application context parameter. SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (CSL) Detect syntax error TR-U-ABORT req. ============> ABORT (ABRT)   SP B (CSL)

BEGIN (AARQ)

TEST DESCRIPTION 1. 2. Arrange for SP B to send a Begin message containing a dialogue request without application context. CHECK A: DOES SP A TRANSMIT THE EXPECTED ABORT MESSAGE WITH APDU ''ABRT''?

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN DIALOGUE PORTION Dialogue portion in Abort message Dialogue portion tag: 01101011 Dialogue portion length: 00010010 External data type in dialogue portion External type tag: 00101000 External length: 00010000 Object Identifier tag: 00000110 Object Identifier length: 00000111 Direct reference: H''00118605010101 (structured dialogue abstract syntax) Single ASN.1 type tag: 10100000 Single ASN.1 type length: 00000101 Dialogue PDU Dialogue Abort tag: 01100100 Dialogue Abort length: 00000011 Abort Source tag: 10000000 Abort source length: 00000001 Abort source: 00000001 (dialogue service provider)

262

Recommendation Q.787 (09/97)

TEST NUMBER: 2.2.2.5.1

Sheet: 2 of 2

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN DIALOGUE PORTION Dialogue portion in Begin message Dialogue portion tag: 01101011 Dialogue portion length: correct number of octets External data type in dialogue portion External type tag: 00101000 External length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: 00000111 Direct reference: H''00118605010101 Single ASN.1 type tag: 10100000 Single ASN.1 type length: correct number of octets Dialogue PDU Dialogue Request tag: 01100000 Dialogue Request length: correct number of octets Application context tag: Missing

Recommendation Q.787 (09/97)

263

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_2_2_5_3 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.2.2.5.3 REFERENCE: 3.2.2.1/Q.774 TITLE: Syntactically invalid behaviour; Invalid structure SUBTITLE: Dialogue Portion; Missing result-source-diagnostic PURPOSE:

Sheet: 1 of 2

To verify that the IUT aborts the transaction upon reception of a Continue message containing an APDU ''AARE'' with a missing result-source-diagnostic parameter SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (CSL) TR-BEGIN req. ============> BEGIN (AARQ) Detect syntax error TR-P-ABORT ind. <============ TR-U-ABORT req. ============> ABORT (ABRT)    CONTINUE (AARE) SP B (CSL)

TEST DESCRIPTION 1. 2. 3. 4. Arrange for SP A to send a Begin message containing a dialogue portion. Arrange for SP B to confirm the dialogue with an incorrect AARE, parameter missing. CHECK A: VERIFY THAT THE DIALOGUE AT SP A HAS BEEN TERMINATED. CHECK B: DOES THE DIALOGUE PORTION IN THE ABORT MESSAGE CONTAIN APDU ''ABRT''?

266

Recommendation Q.787 (09/97)

TEST NUMBER: 2.2.2.5.3

Sheet: 2 of 2

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN DIALOGUE PORTION Dialogue portion in Continue message Dialogue portion tag: 01101011 Dialogue portion length: correct number of octets External data type in dialogue portion External type tag: 00101000 External length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: 00000111 Direct reference: H''00118605010101 Single ASN.1 type tag: 10100000 Single ASN.1 type length: correct number of octets Dialogue PDU Dialogue Response tag: 01100001 Dialogue Response length: correct number of octets Application context tag: 10100001 Application context length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: correct number of octets Direct reference: same octets as in dialogue request Result tag: 10100010 Result length: 00000011 INTEGER type tag: 00000010 INTEGER length: 00000001 Result value: 00000000 (Accepted) Result source diagnostic tag: Missing

Recommendation Q.787 (09/97)

267

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_2_2_5_4 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.2.2.5.4 REFERENCE: 3.2.2.1/Q.774 TITLE: Syntactically invalid behaviour; Invalid structure SUBTITLE: Dialogue Portion; Missing application context in APDU AUDT PURPOSE:

Sheet: 1 of 1

To verify that the IUT discards an Unidirectional message containing a dialogue request without AC parameter SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (CSL) Detect syntax error  SP B (CSL) UNIDIRECTIONAL (AUDT)

TEST DESCRIPTION 1. 2. Arrange for SP B to send an Unidirectional message with corrupted dialogue request to SP A. CHECK A: VERIFY THAT NO MESSAGE IS GENERATED IN RESPONSE TO THE RECEIVED MESSAGE. Dialogue Portion in Unidirectional message Dialogue portion tag: 01101011 Dialogue portion length: correct number of octets External type tag: 00101000 External length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: 00000111 Direct reference: H''00118605010201 Single ASN.1 type tag: 10100000 Single ASN.1 type length: correct number of octets Dialogue Request tag: 01100000 Dialogue Request length: correct number of octets Protocol Version tag: 10000000 Protocol Version length: 00000010 Protocol Version: 00000110 11000000 Application context tag: missing

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN DIALOGUE PORTION

268

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_2_2_5_5 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.2.2.5.5 REFERENCE: 3.2.2.1/Q.774 TITLE: Syntactically invalid behaviour; Invalid structure SUBTITLE: Dialogue Portion; External type without direct reference PURPOSE:

Sheet: 1 of 1

To verify that the IUT aborts the transaction on reception of a Begin message containing an external type which does not contain a direct reference SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (CSL) Detect semantic error TR-U-ABORT req. ============> ABORT (ABRT)   SP B (CSL)

BEGIN (AARQ)

TEST DESCRIPTION 1. 2. Arrange for SP B to send a Begin message containing a dialogue portion with an external type without direct reference. CHECK A: DOES SP A TRANSMIT THE EXPECTED ABORT MESSAGE WITH APDU ''ABRT''?

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN DIALOGUE PORTION Dialogue portion in Begin message. Dialogue portion tag: 01101011 Dialogue portion length: correct number of octets External data type in dialogue portion External type tag: 00101000 External length: correct number of octets Object Identifier tag: missing Direct reference: missing Single ASN.1 type tag: 10100000 Single ASN.1 type length: correct number of octets ANY number of bytes

Recommendation Q.787 (09/97)

269

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_2_2_5_6 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.2.2.5.6 REFERENCE: 3.2.2.1/Q.774 TITLE: Syntactically invalid behaviour; Invalid structure SUBTITLE: Dialogue Portion; Indirect reference in External type PURPOSE:

Sheet: 1 of 1

To verify that the IUT aborts the transaction on reception of a Begin message containing an external type which contains both a direct reference and indirect reference SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (CSL) Detect semantic error TR-U-ABORT req. ============> ABORT (ABRT)   SP B (CSL)

BEGIN (AARQ)

TEST DESCRIPTION 1. 2. Arrange for SP B to send a Begin message containing a dialogue portion with an external type also containing an indirect reference. CHECK A: DOES SP A TRANSMIT THE EXPECTED ABORT MESSAGE WITH APDU ''ABRT''?

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN DIALOGUE PORTION Dialogue portion in Begin message Dialogue portion tag: 01101011 Dialogue portion length: correct number of octets External data type in dialogue portion External type tag: 00101000 External length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: 00000111 Direct reference: H''00118605010101 INTEGER type tag: 00000010 INTEGER length: 00000001 Indirect reference: 00000001 Single ASN.1 type tag: 10100000 Single ASN.1 type length: correct number of octets Dialogue PDU Dialogue Request tag: 01100000 Dialogue Request length: correct number of octets Application context tag: 10100001 Application context length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: correct number of octets Direct reference: any object identifier

270

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_2_2_5_7 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.2.2.5.7 REFERENCE: 3.2.2.1/Q.774 TITLE: Syntactically invalid behaviour; Invalid structure SUBTITLE: Dialogue Portion; User information without direct reference PURPOSE:

Sheet: 1 of 2

To verify that the IUT aborts a dialogue on reception of an User information element without direct reference SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (CSL) Detect semantic error TR-U-ABORT req. ============> ABORT (ABRT)   SP B (CSL)

BEGIN (AARQ)

TEST DESCRIPTION 1. 2. Arrange for SP B to send a Begin message containing a dialogue portion including a user information element whose external type does not contain a direct reference. CHECK A: DOES SP A TRANSMIT THE EXPECTED ABORT MESSAGE WITH APDU ''ABRT''?

Recommendation Q.787 (09/97)

271

TEST NUMBER: 2.2.2.5.7

Sheet: 2 of 2

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN DIALOGUE PORTION Dialogue portion in Begin message Dialogue portion tag: 01101011 Dialogue portion length: correct number of octets External data type in dialogue portion External type tag: 00101000 External length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: 00000111 Direct reference: H''00118605010101 Single ASN.1 type tag: 10100000 Single ASN.1 type length: correct number of octets Dialogue PDU Dialogue Request tag: 01100000 Dialogue Request length: correct number of octets Application context tag: 10100001 Application context length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: correct number of octets Direct reference: any object identifier User information in dialogue PDU User Information tag: 10111110 User information length: correct number of octets External type tag: 00101000 External length: correct number of octets Object Identifier tag: missing Object Identifier length: missing Direct reference: missing Octet-aligned tag: 10000001 Octet aligned length: correct number of octets Octet string value: any number of octets

272

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_2_2_5_8 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.2.2.5.8 REFERENCE: 3.2.2.1/Q.774 TITLE: Syntactically invalid behaviour; Invalid structure SUBTITLE: Dialogue Portion; Indirect reference in User information PURPOSE:

Sheet: 1 of 2

To verify that the IUT aborts a dialogue on reception of an User information element which contains both a direct reference and an indirect reference SP A (TSL) and SP B (TSL) are to be in the idle state TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS: CONFIGURATION: 1

EXPECTED MESSAGE SEQUENCE: SP A (CSL) Detect semantic error TR-U-ABORT req. ============> ABORT (ABRT)   SP B (CSL)

BEGIN (AARQ)

TEST DESCRIPTION 1. 2 Arrange for SP B to send a Begin message containing a dialogue portion with an external type also containing an indirect reference. CHECK A: DOES SP A TRANSMIT THE EXPECTED ABORT MESSAGE WITH APDU ''ABRT''?

Recommendation Q.787 (09/97)

273

TEST NUMBER: 2.2.2.5.8

Sheet: 2 of 2

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN DIALOGUE PORTION Dialogue portion in Begin message Dialogue portion tag: 01101011 Dialogue portion length: correct number of octets External data type in dialogue portion External type tag: 00101000 External length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: 00000111 Direct reference: H''00118605010101 Single ASN.1 type tag: 10100000 Single ASN.1 type length: correct number of octets Dialogue PDU Dialogue Request tag: 01100000 Dialogue Request length: correct number of octets Application context tag: 10100001 Application context length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: correct number of octets Direct reference: any object identifier User information in dialogue PDU User Information tag: 10111110 User information length: correct number of octets External type tag: 00101000 External length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: correct number of octets Direct reference: any object identifier INTEGER type tag: 00000010 INTEGER length: 00000001 Indirect reference: 00000001 Octet-aligned tag: 10000001 Octet aligned length: correct number of octets Octet string value: any number of octets

274

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_2_3_1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.2.3.1 REFERENCE: 3.2.2.2/Q.774; 3.2.3/Q.773 TITLE: Syntactically invalid behaviour; Invalid encoding for Invoke component SUBTITLE: Invalid tag PURPOSE: To verify that a rejection is generated because of an invalid tag

Sheet: 1 of 2

PRE-TEST CONDITIONS:

Arrange the stimulus such that an appropriate TSL message generated at SP B contains an Invoke component with an error as described below TYPE OF TEST: VAT TYPE OF SP: SP

CONFIGURATION: 1

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL)  TC-L-REJECT ind. <============ REJECT (i or NULL)  SP B (CSL) INVOKE (i)

TEST DESCRIPTION 1. 2. Initiate an operation invocation from SP B to SP A with an invalid tag. CHECK A: WAS THE REJECT COMPONENT WITH CORRECT INFORMATION SENT BY SP A?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP B to SP A Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

Recommendation Q.787 (09/97)

275

TEST NUMBER: 2.2.3.1 CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Invalid tag: 00100010 Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) REJECT component in TSL message from SP A to SP B Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i or NULL tag: 00000101 NULL length: 00000000 Problem code tag: 10000000 (General problem type) Problem code length: 00000001 Problem code: 00000010 (badly structured component)

276

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_2_3_2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.2.3.2(T240) REFERENCE: 3.2.2.2/Q.774 TITLE: Syntactically invalid behaviour; Invalid encoding for Invoke component SUBTITLE: Wrong component length PURPOSE:

Sheet: 1 of 2

To verify that a rejection of a requested operation can be initiated due to wrong component length Arrange the stimulus such that an appropriate TSL message generated at SP B contains an Invoke component with a syntax error as described below TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL)  TC-L-REJECT ind. <============ REJECT (i or NULL)  SP B (CSL) INVOKE (i)

TEST DESCRIPTION 1. 2. 3. Initiate an operation invocation from SP B to SP A with an invalid component length value. CHECK A: WAS THE REJECT COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE INVOKE ID IN THE REJECT COMPONENT THE SAME AS THE ONE IN THE INVOKE COMPONENT ?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP B to SP A Component type tag: 10100001 (INVOKE) Component length: wrong number of octets (e.g. 00000000) Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

Recommendation Q.787 (09/97)

277

TEST NUMBER: 2.2.3.2(T241) CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) REJECT component in TSL message from SP A to SP B Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i or NULL tag: 00000101 NULL length: 00000000 Problem code tag: 10000000 (General problem type) Problem code length: 00000001 Problem code: 00000010 (badly structured component)

278

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_2_3_3 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.2.3.3(T242) REFERENCE: 3.3/Q.773 TITLE: Syntactically invalid behaviour; Invalid encoding for Invoke component SUBTITLE: Missing EOC in indefinite form PURPOSE:

Sheet: 1 of 1

To verify that a component portion with an indefinite form but EOC missing is rejected Arrange the stimulus such that an appropriate TSL message generated at SP B contains an Invoke component TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL)  TC-L-REJECT ind. <============ REJECT (i or NULL)  SP B (CSL) INVOKE (i)

TEST DESCRIPTION 1. 2. Initiate a single operation invocation from SP B to SP A. CHECK A: WAS THE REJECT COMPONENT WITH CORRECT INFORMATION SENT BY SP A?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP B to SP A Component type tag: 10100001 (INVOKE) Component length: correct number of octets (indefinite form) Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer) Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) REJECT component in TSL message from SP A to SP B Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i or NULL tag: 00000101 NULL length: 00000000 Problem code tag: 10000000 (General problem type) Problem code length: 00000001 Problem code: 00000010 (badly structured component)

Recommendation Q.787 (09/97)

279

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_3_1_1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.3.1.1(T244) REFERENCE: 3.2.2/Q.774 TITLE: Inopportune Behaviour; Inopportune Invoke component SUBTITLE: Invalid linked ID PURPOSE:

Sheet: 1 of 2

To verify that a rejection of a requested operation can be initiated due to invalid linked ID

PRE-TEST CONDITIONS: 1) Arrange the stimulus such that an appropriate TSL message generated at SP A contains an Invoke component 2) Arrange the data at SP B such that a linked Invoke component can be generated as described below CONFIGURATION: 1 TYPE OF TEST: VAT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i)   TC-L-REJECT ind. <============ REJECT (j) time expiry for invocation (i) TC-L-CANCEL ind. <============  INVOKE (j, k) SP B (CSL)

TEST DESCRIPTION 1. 2. 3. 4. 5. Initiate an operation invocation from SP A to SP B. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE REJECT COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK C: WAS THE INVOKE ID IN THE REJECT COMPONENT THE SAME AS THE ONE IN THE INVOKE COMPONENT SENT BY SP B? CHECK D: WAS THE INVOCATION STATE MACHINE IDLE AT SP A ?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

280

Recommendation Q.787 (09/97)

TEST NUMBER: 2.3.1.1(T245) CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) INVOKE component in TSL message sent by SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: j (j represents an integer) Linked ID tag: 10000000 Linked ID length: 00000001 (one octet) Linked ID: k (k is an integer which is different from i) Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if y is one octet long) Operation code: y (y represents a valid operation code) parameters (provided by the TC-User) REJECT component in the TSL message sent by SP A Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: j Problem code tag: 10000001 (INVOKE) Problem code length: 00000001 Problem code: 00000101 (unrecognized linked ID)

Recommendation Q.787 (09/97)

281

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_3_2_1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.3.2.1(T246) REFERENCE: 3.2.2/Q.774 TITLE: Inopportune Behaviour; Unrecognized Invoke ID SUBTITLE: Inopportune Return Result-Last component PURPOSE:

Sheet: 1 of 2

To verify that a rejection can be successfully initiated due to an unrecognized Invoke ID (never used and just released) in the received Return Result-Last component

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains an Invoke component for operation Class 1 or 3 2) Arrange the data at SP B such that a Return Result-Last with an invalid Invoke ID is generated CONFIGURATION: 1 TYPE OF TEST: VAT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i)   TC-L-REJECT ind. <============ REJECT (j) time expiry for invocation (i) TC-L-CANCEL ind. <============  TC-L-REJECT ind. <============ REJECT (i)  RETURN RESULT-LAST (i)  RETURN RESULT-LAST (j) SP B (CSL)

TEST DESCRIPTION 1. 2. 3. 4. 5. 6. Initiate an operation invocation from SP A to SP B. Generate a response from SP B to SP A with an unrecognized Invoke ID. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE REJECT COMPONENT SENT BY SP A ? Generate a Return Result-Last component from SP B to SP A. CHECK C: WAS THE REJECT COMPONENT SENT BY SP A? CHECK D: WAS THE COMPONENT FLOW AS SHOWN IN ABOVE ?

282

Recommendation Q.787 (09/97)

TEST NUMBER: 2.3.2.1(T247) CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) RETURN RESULT-LAST component in TSL message from SP B to SP A Component type tag: 10100010 (RETURN RESULT-LAST) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: j (j is different from i) Sequence tag: 00110000 (see Note) Sequence length: correct number of octets (see Note) Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) (see Note) Operation code: x (see Note) parameters (provided by the TC-User) REJECT component in TSL message from SP A to SP B Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: j Problem code tag: 10000010 (RETURN RESULT) Problem code length: 00000001 Problem code: 00000000 (unrecognized invoke ID) The contents of the last two components, RETURN-RESULT-LAST (i) and REJECT (i), are the same as above except the Invoke ID is (i). NOTE ­ Omitted when no parameter is present.

Recommendation Q.787 (09/97)

283

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_3_2_2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.3.2.2(T249) REFERENCE: 3.2.2/Q.774 TITLE: Inopportune Behaviour; Unrecognized Invoke ID SUBTITLE: Inopportune Return Result Not-Last component PURPOSE:

Sheet: 1 of 3

To verify that a rejection can be successfully initiated due to an unrecognized Invoke ID (never used and just released) in the received Return Result Not-Last component

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains an Invoke component for operation Class 1 or 3 2) Arrange the data at SP B such that a Return Result Not-Last with an invalid Invoke ID is generated CONFIGURATION: 1 TYPE OF TEST: VAT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i)   TC-L-REJECT ind. <============ REJECT (j) time expiry for invocation (i) TC-L-CANCEL ind. <============  TC-L-REJECT ind. <============ REJECT (i)  RETURN RESULT NOT-LAST (i)  RETURN RESULT NOT-LAST (j) SP B (CSL)

TEST DESCRIPTION 1. 2. 3. 4. 5. 6. Initiate an operation invocation from SP A to SP B. Generate a response from SP B to SP A with an unrecognized Invoke ID. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE REJECT COMPONENT SENT BY SP A ? Generate a Return Result Not-Last component from SP B to SP A. CHECK C: WAS THE REJECT COMPONENT SENT BY SP A? CHECK D: WAS THE COMPONENT FLOW AS SHOWN IN ABOVE ?

284

Recommendation Q.787 (09/97)

TEST NUMBER: 2.3.2.2(T250) CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

Sheet: 2 of 3

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) RETURN RESULT NOT-LAST component in TSL message from SP B to SP A Component type tag: 10100111 (RETURN RESULT NOT-LAST) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: j (j is different from i) Sequence tag: 00110000 (see Note) Sequence length: correct number of octets (see Note) Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) (see Note) Operation code: x (see Note) parameters (provided by the TC-User) REJECT component in TSL message from SP A to SP B Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: j

Recommendation Q.787 (09/97)

285

TEST NUMBER: 2.3.2.2(T251) CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Problem code tag: 10000010 (RETURN RESULT) Problem code length: 00000001 Problem code: 00000000 (unrecognized invoke ID) RETURN RESULT NOT-LAST component in TSL message from SP B to SP A Component type tag: 10100111 (RETURN RESULT NOT-LAST) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Sequence tag: 00110000 (see Note) Sequence length: correct number of octets (see Note)

Sheet: 3 of 3

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) (see Note) Operation code: x (see Note) parameters (provided by the TC-User) REJECT component in TSL message from SP A to SP B Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Problem code tag: 10000010 (RETURN RESULT) Problem code length: 00000001 Problem code: 00000000 (unrecognized invoke ID) NOTE ­ Omitted when no parameter is present.

286

Recommendation Q.787 (09/97)

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_3_2_3 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.3.2.3(T252) REFERENCE: 3.2.2/Q.774 TITLE: Inopportune Behaviour; Unrecognized Invoke ID SUBTITLE: Inopportune Return Error component PURPOSE:

Sheet: 1 of 3

To verify that a rejection can be successfully initiated due to an unrecognized Invoke ID (never used and just released) in the received Return Error component

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains an Invoke component for unrecognized operation Class 1 or 2 2) Arrange the data at SP B such that a Return Error with an invalid Invoke ID is generated CONFIGURATION: 1 TYPE OF TEST: VAT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i)   TC-L-REJECT ind. <============ REJECT (j) time expiry for invocation (i) TC-L-CANCEL ind. <============  TC-L-REJECT ind. <============ REJECT (i)  RETURN ERROR (i)  RETURN ERROR (j) SP B (CSL)

TEST DESCRIPTION 1. 2. 3. 4. 5. 6. Initiate an operation invocation from SP A to SP B. Generate an unsuccessful response from SP B to SP A with an invalid Invoke ID. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE REJECT COMPONENT SENT BY SP A ? Generate a Return Error component from SP B to SP A. CHECK C: WAS THE REJECT COMPONENT SENT BY SP A? CHECK D: WAS THE COMPONENT FLOW AS ABOVE ?

Recommendation Q.787 (09/97)

287

TEST NUMBER: 2.3.2.3(T253) CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

Sheet: 2 of 3

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) RETURN ERROR component in TSL message from SP B to SP A Component type tag: 10100011 (RETURN ERROR) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: j (j is different from i) Error code tag: 00000010 (local) or 00000110 (global) Error code length: correct number of octets (e.g. 00000001 if y is one octet long) Error code: y parameters (provided by the TC-User) REJECT component in TSL message from SP A to SP B Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: j Problem code tag: 10000011 (RETURN ERROR) Problem code length: 00000001 Problem code: 00000000 (unrecognized invoke ID)

288

Recommendation Q.787 (09/97)

TEST NUMBER: 2.3.2.3(T253) CHECK TABLE FOR COMPONENTS WITHIN MESSAGES RETURN ERROR component in TSL message from SP B to SP A Component type tag: 10100011 (RETURN ERROR) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i

Sheet: 3 of 3

Error code tag: 00000010 (local) or 00000110 (global) Error code length: correct number of octets (e.g. 00000001 if y is one octet long) Error code: y parameters (provided by the TC-User) REJECT component in TSL message from SP A to SP B Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Problem code tag: 10000011 (RETURN ERROR) Problem code length: 00000001 Problem code: 00000000 (unrecognized invoke ID)

Recommendation Q.787 (09/97)

289

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_3_2_4 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.3.2.4(T255) REFERENCE: 3.2.2/Q.774 TITLE: Inopportune Behaviour; Unrecognized Invoke ID SUBTITLE: Inopportune Reject component PURPOSE:

Sheet: 1 of 2

To verify that receipt of a Reject component with an Invoke ID not corresponding to any active invocation has no effect on an active invocation

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains an Invoke component for Class 1 or 2 2) Arrange the data at SP B such that a Reject with an unrecognized Invoke ID is generated CONFIGURATION: 1 TYPE OF TEST: VAT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i)
a)

SP

B

(CSL)

  REJECT (j)

TC-R-REJECT ind. <============

 TC-L-RESULT ind. <============

RETURN RESULT-LAST (i)

a)

The issuing of the TC-R-REJECT ind. is implementation dependent.

TEST DESCRIPTION 1. 2. 3. 4. 5. Initiate an operation invocation from SP A to SP B. Generate a reject from SP B to SP A with an invalid Invoke ID. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? Generate a Reject component from SP B to SP A. CHECK B: WAS THE COMPONENT FLOW AS ABOVE? CHECK C: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?

290

Recommendation Q.787 (09/97)

TEST NUMBER: 2.3.2.4(T256) CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) REJECT component in TSL message from SP A to SP B Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: j (j is different from i) Problem code tag: 10000001 (INVOKE) Problem code length: 00000001 Problem code: any value RETURN RESULT-LAST component in TSL message from SP B to SP A Component type tag: 10100010 (RETURN RESULT-LAST) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Sequence tag: 00110000 (see Note) Sequence length: correct number of octets (see Note) Operation code tag: 00000010 (local) or 00000101 (Global) (see Note) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) (see Note) Operation code: x (see Note) parameters (provided by the TC-User) NOTE ­ Omitted when no parameter is present.

Recommendation Q.787 (09/97)

291

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_3_3_1 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.3.3.1(T257) REFERENCE: 3.2.1/Q.774 TITLE: Inopportune Behaviour; Unexpected Components SUBTITLE: Return Result-Last for Class 2 PURPOSE:

Sheet: 1 of 2

To verify that a rejection can be sent if a Return Result-Last component is received for a Class 2 operation

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains an Invoke component 2) Arrange the data at SP B such that a Return Result-Last component can be generated CONFIGURATION: 1 TYPE OF TEST: VAT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i)   TC-L-REJECT ind. <============ REJECT (i)  RETURN RESULT-LAST (i) SP B (CSL)

TEST DESCRIPTION 1. 2. 3. 4. Initiate a Class 2 operation invocation from SP A to SP B. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE REJECT COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK C: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

292

Recommendation Q.787 (09/97)

TEST NUMBER: 2.3.3.1(T258) CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) RETURN RESULT-LAST component in TSL message from SP B to SP A Component type tag: 10100010 (RETURN RESULT-LAST) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Sequence tag: 00110000 (see Note) Sequence length: correct number of octets (see Note) Operation code tag: 00000010 (local) or 00000110 (global) (see Note) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) (see Note) Operation code: x (see Note) parameters (provided by the TC-User) REJECT component in TSL message from SP A to SP B Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Problem code tag: 10000010 (RETURN RESULT) Problem code length: 00000001 Problem code: 00000001 (return result unexpected) NOTE ­ Omitted when no parameter is present.

Recommendation Q.787 (09/97)

293

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_3_3_2 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.3.3.2(T259) REFERENCE: 3.2.1/Q.774 TITLE: Inopportune Behaviour; Unexpected Components SUBTITLE: Return Result-Last for Class 4 PURPOSE:

Sheet: 1 of 2

To verify that a rejection can be sent if a Return Result-Last component is received for a Class 4 operation

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains an Invoke component 2) Arrange the data at SP B such that a Return Result-Last component can be generated CONFIGURATION: 1 TYPE OF TEST: VAT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i)   TC-L-REJECT ind. <============ REJECT (i)  RETURN RESULT-LAST (i) SP B (CSL)

TEST DESCRIPTION 1. 2. 3. 4. Initiate a Class 4 operation invocation from SP A to SP B. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE REJECT COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK C: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

294

Recommendation Q.787 (09/97)

TEST NUMBER: 2.3.3.2(T260) CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) RETURN RESULT-LAST component in TSL message from SP B to SP A Component type tag: 10100010 (RETURN RESULT-LAST) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Sequence tag: 00110000 (see Note) Sequence length: correct number of octets (see Note) Operation code tag: 00000010 (local) or 00000110 (global) (see Note) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) (see Note) Operation code: x (see Note) parameters (provided by the TC-User) REJECT component in TSL message from SP A to SP B Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Problem code tag: 10000010 (RETURN RESULT) Problem code length: 00000001 Problem code: 00000001 (return result unexpected) NOTE ­ Omitted when no parameter is present.

Recommendation Q.787 (09/97)

295

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_3_3_3 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.3.3.3(T261) REFERENCE: 3.2.1/Q.774 TITLE: Inopportune Behaviour; Unexpected Components SUBTITLE: Return Result Not-Last for Class 2 PURPOSE:

Sheet: 1 of 2

To verify that a rejection can be sent if a Return Result Not-Last component is received for a Class 2 operation

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains an Invoke component 2) Arrange the data at SP B such that a Return Result Not-Last component can be generated CONFIGURATION: 1 TYPE OF TEST: VAT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i)   TC-L-REJECT ind. <============ REJECT (i)  RETURN RESULT NOT-LAST (i) SP B (CSL)

TEST DESCRIPTION 1. 2. 3. 4. Initiate a Class 2 operation invocation from SP A to SP B. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE REJECT COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK C: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

296

Recommendation Q.787 (09/97)

TEST NUMBER: 2.3.3.3(T262) CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) RETURN RESULT NOT-LAST component in TSL message from SP B to SP A Component type tag: 10100111 (RETURN RESULT NOT-LAST) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Sequence tag: 00110000 (see Note) Sequence length: correct number of octets (see Note) Operation code tag: 00000010 (local) or 00000110 (global) (see Note) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) (see Note) Operation code: x (see Note) parameters (provided by the TC-User) REJECT component in TSL message from SP A to SP B Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Problem code tag: 10000010 (RETURN RESULT) Problem code length: 00000001 Problem code: 00000001 (return result unexpected) NOTE ­ Omitted when no parameter is present.

Recommendation Q.787 (09/97)

297

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_3_3_4 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.3.3.4(T263) REFERENCE: 3.2.1/Q.774 TITLE: Inopportune Behaviour; Unexpected Components SUBTITLE: Return Result Not-Last for Class 4 PURPOSE:

Sheet: 1 of 2

To verify that a rejection can be sent if a Return Result Not-Last component is received for a Class 4 operation

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains an Invoke component 2) Arrange the data at SP B such that a Return Result Not-Last component can be generated CONFIGURATION: 1 TYPE OF TEST: VAT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i)   TC-L-REJECT ind. <============ REJECT (i)  RETURN RESULT NOT-LAST (i) SP B (CSL)

TEST DESCRIPTION 1. 2. 3. 4. Initiate a Class 4 operation invocation from SP A to SP B. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE REJECT COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK C: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

298

Recommendation Q.787 (09/97)

TEST NUMBER: 2.3.3.4(T264) CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) RETURN RESULT NOT-LAST component in TSL message from SP B to SP A Component type tag: 10100111 (RETURN RESULT NOT-LAST) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Sequence tag: 00110000 (see Note) Sequence length: correct number of octets (see Note) Operation code tag: 00000010 (local) or 00000110 (global) (see Note) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) (see Note) Operation code: x (see Note) parameters (provided by the TC-User) REJECT component in TSL message from SP A to SP B Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Problem code tag: 10000010 (RETURN RESULT) Problem code length: 00000001 Problem code: 00000001 (return result unexpected) NOTE ­ Omitted when no parameter is present.

Recommendation Q.787 (09/97)

299

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_3_3_5 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.3.3.5(T265) REFERENCE: 3.2.1/Q.774 TITLE: Inopportune Behaviour; Unexpected Components SUBTITLE: Return Error for Class 3 PURPOSE:

Sheet: 1 of 2

To verify that a rejection can be sent if a Return Error component is received for a Class 3 operation

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains an Invoke component 2) Arrange the data at SP B such that a Return Error component can be generated CONFIGURATION: 1 TYPE OF TEST: VAT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i)   TC-L-REJECT ind. <============ REJECT (i)  RETURN ERROR (i) SP B (CSL)

TEST DESCRIPTION 1. 2. 3. 4. Initiate a Class 3 operation invocation from SP A to SP B. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE REJECT COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK C: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

300

Recommendation Q.787 (09/97)

TEST NUMBER: 2.3.3.5(T266) CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) RETURN ERROR component in TSL message from SP B to SP A Component type tag: 10100011 (RETURN ERROR) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Error code tag: 00000010 (local) or 00000110 (global) Error code length: correct number of octets (e.g. 00000001 if y is one octet long) Error code: y parameters (provided by the TC-User) REJECT component in TSL message from SP A to SP B Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Problem code tag: 10000011 (RETURN ERROR) Problem code length: 00000001 Problem code: 00000001 (unexpected return error)

Recommendation Q.787 (09/97)

301

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_3_3_6 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.3.3.6(T267) REFERENCE: 3.2.1/Q.774 TITLE: Inopportune Behaviour; Unexpected Components SUBTITLE: Return Error for Class 4 PURPOSE:

Sheet: 1 of 2

To verify that a rejection can be sent if a Return Error component is received for a Class 4 operation

PRE-TEST CONDITIONS: 1) Arrange the TC-User stimulus such that an appropriate TSL message generated at SP A contains an Invoke component 2) Arrange the data at SP B such that a Return Error component can be generated CONFIGURATION: 1 TYPE OF TEST: VAT TYPE OF SP: SP

EXPECTED MESSAGE AND COMPONENT FLOW: SP A (CSL) TC-INVOKE req. ============> INVOKE (i)   TC-L-REJECT ind. <============ REJECT (i)  RETURN ERROR (i) SP B (CSL)

TEST DESCRIPTION 1. 2. 3. 4. Initiate a Class 4 operation invocation from SP A to SP B. CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK B: WAS THE REJECT COMPONENT WITH CORRECT INFORMATION SENT BY SP A? CHECK C: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?

CHECK TABLE FOR COMPONENTS WITHIN MESSAGES Component portion in TSL messages Component portion tag: 01101100 Component portion length: correct number of octets INVOKE component in TSL message from SP A to SP B Component type tag: 10100001 (INVOKE) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 (one octet) Invoke ID: i (i represents an integer)

302

Recommendation Q.787 (09/97)

TEST NUMBER: 2.3.3.6(T268) CHECK TABLE FOR COMPONENTS WITHIN MESSAGES

Sheet: 2 of 2

Operation code tag: 00000010 (local) or 00000110 (global) Operation code length: correct number of octets (e.g. 00000001 if x is one octet long) Operation code: x (x represents a valid operation code) parameters (provided by the TC-User) RETURN ERROR component in TSL message from SP B to SP A Component type tag: 10100011 (RETURN ERROR) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Error code tag: 00000010 (local) or 00000110 (global) Error code length: correct number of octets (e.g. 00000001 if y is one octet long) Error code: y parameters (provided by the TC-User) REJECT component in TSL message from SP A to SP B Component type tag: 10100100 (REJECT) Component length: correct number of octets Invoke ID tag: 00000010 Invoke ID length: 00000001 Invoke ID: i Problem code tag: 10000011 (RETURN ERROR) Problem code length: 00000001 Problem code: 00000001 (unexpected return error)

Recommendation Q.787 (09/97)

303

'
]

{ #category : #spec }
Q787ValidationTest >> spec2_3_4_4 [
		self flag: #needsToBeChecked.
		^ 'TEST NUMBER: 2.3.4.4 REFERENCE: 3.2.2.1/Q.774 TITLE: Inopportune Behaviour; Dialogue Portion SUBTITLE: Presence of a Dialogue Portion APDU in the active state. PURPOSE:

Sheet: 1 of 2

To verify that an IUT aborts the transaction on reception of a Continue message containing a dialogue portion that carries an ''AARE'' APDU SP A (TSL) and SP B (TSL) are to be in the idle state and test case 2.1.9.1.2 has to be executed successfully TYPE OF TEST: VAT TYPE OF SP: SP

PRE-TEST CONDITIONS:

CONFIGURATION: 1 EXPECTED MESSAGE SEQUENCE: SP A (CSL)

SP 

B

(CSL)

BEGIN (AARQ)

TR-BEGIN ind. <============ TR-CONTINUE req. ============> CONTINUE (AARE)   TR-P-ABORT ind. <============ TR-U-ABORT req ============> ABORT (U) (ABRT)  CONTINUE (AARE)

TEST DESCRIPTION 1. 2. 3. 4. Arrange for SP B to send a Begin message with dialogue request to SP A. Arrange for SP A to confirm the dialogue. Arrange for SP B to send a Continue msg containing a dialogue portion carrying an AARE APDU. CHECK A: VERIFY THAT THE IUT AT SP A TERMINATES THE TRANSACTION.

310

Recommendation Q.787 (09/97)

TEST NUMBER: 2.3.4.4

Sheet: 2 of 2

CHECK TABLE FOR INFORMATION ELEMENTS WITHIN DIALOGUE PORTION Dialogue portion in Continue message Dialogue portion tag: 01101011 Dialogue portion length: correct number of octets External data type in dialogue portion External type tag: 00101000 External length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: 00000111 Direct reference: H''00118605010101 Single ASN.1 type tag: 10100000 Single ASN.1 type length: correct number of octets Dialogue PDU Dialogue Response tag: 01100001 Dialogue Response length: correct number of octets Application context tag: 10100001 Application context length: correct number of octets Object Identifier tag: 00000110 Object Identifier length: correct number of octets Direct reference: same octets as in AARQ Result tag: 10100010 Result length: 00000011 INTEGER type tag: 00000010 INTEGER length: 00000001 Result value: 00000000 (Accepted) Result source diagnostic tag: 10100011 Result source diag. length: 00000101 Dialogue Service User tag: 10100001 Dialogue Service User length: 00000011 INTEGER type tag: 00000010 INTEGER length: 00000001 Dialogue service user value: 00000000 (NULL)

Recommendation Q.787 (09/97)

311

'
]

{ #category : #tests }
Q787ValidationTest >> test1_1_2_1_2_2s2 [
	| env begin abort abortHandlerCalled |
	env := self given: #shouldCreateTestEnvironment.
	env servicePointB onDialogue: [ :dialogue|
		dialogue onBegin: [ 
			env servicePointB transactionCoordinator 
				requestTrPAbort: dialogue newPAbort unrecognizedMessageType  
				transaction: dialogue transaction ] ].
	
	env servicePointA newDialogue
		onPAbort: [ abortHandlerCalled := true ]; 
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
	
	"CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? "
	self assert: env servicePointA didSendMessage.
	begin := self checkBegin: env servicePointA sentPackets first.
	
	"CHECK B: WAS THE ABORT MESSAGE CORRECTLY RECEIVED AT SP A? "
	self assert: env servicePointA didReceiveMessage.
	abort := self checkAbort:  env servicePointA receivedPackets first.
	self assert: abortHandlerCalled notNil.
	
	"CHECK C: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?"
	self assert: env servicePointA isIdle.
	self assert: env hasInitialState.

	self assert: (abort findKey: 'dtid') basicValue = (begin findKey: 'otid') basicValue.
	
	"self assert: (abort findTaggedValueForTypeNamed: 'DialoguePortion') tagByteValue = 2r01101011."
	self assert: (abort findTaggedValue: 'p-abortCause') tag = (self applicationTag: 10).
	self assert: (abort findTaggedValue: 'p-abortCause') size = 1.
	

]

{ #category : #tests }
Q787ValidationTest >> test1_1_2_2_2_2s2 [
	| env  abortCalled |
	env := self given: #shouldCreateTestEnvironment.
	env servicePointB onDialogue: [ :dialogue|
		dialogue 
			onBegin: [ 
				dialogue requestTcContinue.
				dialogue transactionCoordinator 
					requestTrPAbort: dialogue newPAbort unrecognizedMessageType 
					transaction: dialogue transaction ] ].
	
	env servicePointA newDialogue
		onPAbort: [ abortCalled := true ];
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
			
	self assert: env servicePointB didReceiveMessage.
	self checkBegin: env servicePointB receivedPackets first.
	self assert: env servicePointB didSendMessage.
	self checkContinue: env servicePointB sentPackets first.
	self assert: env servicePointB sentPackets size = 2.
	self checkPAbort: env servicePointB sentPackets second.
		
	self assert: abortCalled notNil.
	self assert: env servicePointA isIdle.
	self assert: env hasInitialState
]

{ #category : #tests }
Q787ValidationTest >> test1_1_2_3_1 [
	| env begin  continue continueCalled end |
	env := self given: #shouldCreateTestEnvironment.
	env servicePointB onDialogue: [ :dialogue|
		dialogue 
			onBegin: [ 
				dialogue requestTcContinue ] ].
	
	env servicePointA newDialogue
			onContinue: [ :cont |
			continueCalled := true.
			cont dialogue transaction requestTrEnd: (self createDialogueResponse asEndMessageIn: cont dialogue factory)];
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
	
	" CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A?"
	self assert: env servicePointA didSendMessage.
	begin := self checkBegin: env servicePointA sentPackets first.
	
	" CHECK B: WAS THE CONTINUE MESSAGE CORRECTLY RECEIVED AT SP A? "
	self assert: env servicePointA didReceiveMessage.
	continue := self checkContinue: env servicePointA receivedPackets first.
	self assert: continueCalled == true.
 	
	" CHECK C: WAS THE END MESSAGE CORRECTLY SENT FROM SP A? "
	self assert: env servicePointA sentPackets size = 2.
	end := self checkEnd: env servicePointA sentPackets last.
	
	" CHECK D: WAS THE TSL STATE MACHINE LEFT IN THE IDLE STATE AT SP A?"
	self assert: env servicePointA isIdle.
]

{ #category : #tests }
Q787ValidationTest >> test1_1_2_3_2 [
	| env begin continue end continueCalled  |
	env := self given: #shouldCreateTestEnvironment.
	env servicePointA onDialogue: [ :dialogue|
		dialogue 
			onBegin: [ 
				dialogue requestTcContinue ]].

	env servicePointB newDialogue
			onContinue: [ :cont |
			continueCalled := true.
			cont dialogue requestTcEnd: false];
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
	
	" CHECK A: WAS THE BEGIN MESSAGE CORRECTLY RECEIVED AT SP A? "
	self assert: env servicePointA didReceiveMessage.
	begin := self checkBegin: env servicePointA receivedPackets first.
	
	" CHECK B: WAS THE CONTINUE MESSAGE CORRECTLY SENT FROM SP A? "
	self assert: env servicePointA didSendMessage.
	continue := self checkContinue: env servicePointA sentPackets first.
	self assert: continueCalled == true.
	
	" CHECK C: WAS THE END MESSAGE CORRECTLY RECEIVED AT SP A? "
	self assert: env servicePointA receivedPackets size = 2.
	end := self checkEnd: env servicePointA receivedPackets second.
	
	" CHECK D: WAS THE TSL STATE MACHINE LEFT IN THE IDLE STATE AT SP A?"
	self assert: env servicePointA isIdle.
]

{ #category : #tests }
Q787ValidationTest >> test1_2_1_1s1 [
	| env  dialogue beginCalled |
	beginCalled := false.
	
	env := self given: #shouldCreateTestEnvironment.
	
	env servicePointA onDialogue: [ : dialog|
		dialog onBegin: [ beginCalled := true] ].
	
	dialogue := env servicePointB newDialogue.
	dialogue transaction id: ''.
	dialogue
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
		
	"CHECK A: THAT THE USER WAS NOT INFORMED OF THE BEGIN MESSAGE. "
	self deny: beginCalled.
	
	"CHECK B: WERE NO MESSAGES SENT FROM SP A? "
	self assert: env servicePointA sentPackets isEmpty.	
	
	"CHECK C: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?"
	self assert: env servicePointA isIdle.		
]

{ #category : #tests }
Q787ValidationTest >> test1_2_1_1s2 [
	| env  dialogue beginCalled |
	beginCalled := false.
	
	env := self given: #shouldCreateTestEnvironment.
	
	env servicePointA onDialogue: [ : dialog|
		dialog onBegin: [ beginCalled := true] ].
	
	dialogue := env servicePointB newDialogue.
	dialogue transaction id: '100000000' byteArrayFromHex.
	dialogue
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
	
	" CHECK A: WAS THE BEGIN MESSAGE CORRECTLY RECEIVED AT SP A? "
	self assert: env servicePointA didReceiveMessage.
	self checkBegin: env servicePointA receivedPackets first.
	
	" CHECK B: VERIFY THAT THE TR-USER AT SP A WAS NOT INFORMED OF THIS EVENT. "
	self deny: beginCalled.
	
	" CHECK C: VERIFY THAT NO MESSAGES WERE GENERATED BY SP A IN RESPONSE TO THE BEGIN MESSAGE. "
	self assert: env servicePointA sentPackets isEmpty.	
	
	" CHECK D: WERE ALL TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?"
	self assert: env servicePointA isIdle.		
]

{ #category : #tests }
Q787ValidationTest >> test1_2_1_2s1 [
	| env  continueCalled begin abort  |
	env := self given: #shouldCreateTestEnvironment.
	
	env servicePointB onDialogue: [ :dialogue| |  |
		dialogue onBegin: [ 
			dialogue transaction remoteTransactionId: ''.
			dialogue requestTcContinue ] ].
	
	env servicePointA newDialogue
		onContinue: [ continueCalled := true ];
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
	
	" CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? "
	self assert: env servicePointA didSendMessage.
	begin := self checkBegin: env servicePointA sentPackets first.
	
	" CHECK B: VERIFY THAT THE TR-USER AT SP A WAS NOT INFORMED OF THE CONTINUE MESSAGE AT SP A. "
	self assert: continueCalled isNil.
	
	" CHECK C: WERE THE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION PRIOR TO THE CONTINUE MESSAGE LEFT IN INITIATION SENT STATE ? "
	self flag: #TBD. 
	"How can we check that? 	dialogue transaction state before  #requestTcContinue is TCAPInitiationReceivedTransactionState "

	" CHECK D: IF AN ABORT MESSAGE WAS SENT, WAS IT SENT CORRECTLY FROM SP A WITH CORRECT DTID AND P-ABORT CAUSE VALUE?"
	self assert: env servicePointA sentPackets size = 2.
	abort := self checkAbort: env servicePointA sentPackets second.
	self assert: (abort message abort reason at: 'p-abortCause') = TCAPDialoguePAbort incorrectTransactionPortion value.
	self assert: abort message abort dtid = begin message begin otid.

	"SP B received the message" 
	self assert: env servicePointB didReceiveMessage.
	self checkBegin: env servicePointB receivedPackets first.	
]

{ #category : #tests }
Q787ValidationTest >> test1_2_1_3s1 [
	| env  continueCalled beginInspector abortInspector |
	env := self given: #shouldCreateTestEnvironment.
	
	env servicePointB onDialogue: [ :dialogue|
		dialogue onBegin: [ 
			dialogue requestTcContinue.
			dialogue requestTcInvokeNamed: 'sendAuthenticationInfoV3' parameters: self authInfoV3Arguments class: TCAPReportSuccessAndFailure  timeout: 500. 
			dialogue transaction transactionCoordinator postProcessPayload: [ :x | x at: 16 put: 24. x ].
			dialogue requestTcContinue  ] ].
	
	env servicePointA newDialogue
		onContinue: [ continueCalled := true ];
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 

	" CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? "
	self assert: env servicePointA didSendMessage.
	self checkBegin: env servicePointA sentPackets first.
	
	" CHECK B: WAS THE CONTINUE MESSAGE CORRECTLY RECEIVED AT SP A? "
	self assert: env servicePointA didReceiveMessage.
	beginInspector := self checkBegin: env servicePointB receivedPackets first.
	self assert: continueCalled.
	
	" CHECK C: IF AN ABORT MESSAGE WAS SENT, WAS IT SENT CORRECTLY FROM SP A WITH CORRECT DTID AND P-ABORT CAUSE VALUE? "
	self assert: env servicePointA sentPackets size = 2.
	abortInspector := self checkAbort: (env servicePointA sentPackets second).
	self assert: abortInspector message abort dtid = beginInspector message begin otid.

	self assert: (abortInspector message abort reason at: 'p-abortCause') basicValue = TCAPDialoguePAbort incorrectTransactionPortion value.
	
	
	"Additional Check: SP B received the begin message" 
	self assert: env servicePointB didReceiveMessage.
	self checkBegin: env servicePointB receivedPackets first.

	"Additional Check: B received two messages"
	self assert: env servicePointB sentPackets size = 2.
	
	" CHECK D: IF THE ABORT WAS SENT, WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?"
	self assert: env servicePointA isIdle.		

]

{ #category : #tests }
Q787ValidationTest >> test1_2_1_4s1 [
	| env  endCalled |
	endCalled := false.
	
	env := self given: #shouldCreateTestEnvironment.
	
	env servicePointB onDialogue: [ :dialogue|
		dialogue onBegin: [ 
			dialogue transaction remoteTransactionId: '1234567890'.
			dialogue requestTcEnd: false.
		 ] ].
	
	env servicePointA newDialogue
		onEnd: [ endCalled := true];
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
	
	
	 "CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? "
	self assert: env servicePointA sentPackets size = 1.
	self checkBegin: env servicePointA sentPackets first.
		
	" CHECK B: VERIFY THAT THE TR-USER WAS NOT INFORMED OF THE END MESSAGE. "
	self deny: endCalled. 
		
	" additional check: B received begin message"	
	self assert: env servicePointB didReceiveMessage.
	self checkBegin: env servicePointB receivedPackets first.
 
	" additional check: A and B received one messaage each"	
	self assert: env servicePointA sentPackets size = 1.
	self assert: env servicePointB sentPackets size = 1.

	" CHECK C: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION PRIOR TO THE END MESSAGE, LEFT IN THE INITIATION SENT STATE? "
	self flag: #TBD.
]

{ #category : #tests }
Q787ValidationTest >> test1_2_1_5s1 [
	| env  abortCalled |
	abortCalled := false.
	
	env := self given: #shouldCreateTestEnvironment.
	
	env servicePointB onDialogue: [ :dialogue|
		dialogue onBegin: [ 
			dialogue requestTcPAbort: TCAPDialoguePAbort incorrectCauseValue.
		 ] ].
	
	env servicePointA newDialogue
		onPAbort: [ abortCalled := true];
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
	
	" CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? "
	self assert: env servicePointA didSendMessage.
	self checkBegin: env servicePointA sentPackets first.
	
	" CHECK B: VERIFY THAT NO MESSAGES ARE GENERATED BY SP A IN RESPONSE TO THE CORRUPTED ABORT MESSAGE. "
	self assert: env servicePointA sentPackets size = 1.
	
	" additional check: B received Begin message"
	self assert: env servicePointB didReceiveMessage.
	self checkBegin: env servicePointB receivedPackets first.

	"additional check: B received just one message"
	self assert: env servicePointB receivedPackets size = 1.
	
	" CHECK C: IF THE TR-ABORT IND. WAS SENT, WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A? "
	self assert: abortCalled. 
	self assert: env servicePointA isIdle.	
	
	


		
	

]

{ #category : #tests }
Q787ValidationTest >> test1_2_2_2s1 [
	| env beginCalled |
	beginCalled := false.
	
	env := self given: #shouldCreateTestEnvironment.
	
	env servicePointA onDialogue: [ : dialogue |
		dialogue onBegin: [ 
			beginCalled := true ]].
	
	env servicePointB transactionCoordinator postProcessDictionary: [ :dict| dict values first removeKey: 'otid' ].
	env servicePointB newDialogue
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
		
	" CHECK A: VERIFY THAT THE TR-USER WAS NOT INFORMED OF THIS EVENT AT SP A. "
	self deny: beginCalled. 
	
	" CHECK B: VERIFY THAT NO MESSAGES WERE GENERATED IN RESPONSE TO THE THE CORRUPTED BEGIN MESSAGE. "
	self assert: env servicePointB sentPackets size = 1.
	self assert: env servicePointA receivedPackets size = 1.
	
	" CHECK C: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP "
	self assert: env servicePointA isIdle.		

]

{ #category : #tests }
Q787ValidationTest >> test1_2_2_2s2 [
	| env beginCalled  abortInspector |
	beginCalled := false.
	
	env := self given: #shouldCreateTestEnvironment.
	
	env servicePointA onDialogue: [ : dialogue |
		dialogue onBegin: [ 
			beginCalled := true ]].

	env servicePointB transactionCoordinator postProcessPayload: [ :bytes| | inspect | 
		inspect := TCAPMessageInspector packet: bytes.
		inspect taggedValue elements second tag number: 13.
		inspect updatePacketFromTaggedValue; packet ].
	
	env servicePointB newDialogue
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
		
	"Misc checks"
	self assert: env servicePointB sentPackets size = 1.
	self assert: env servicePointA sentPackets size = 1.
	self deny: beginCalled. 
			
	"CHECK A: IF AN ABORT MESSAGE WAS SENT, WAS IT SENT CORRECTLY FROM SP A WITH CORRECT DTID AND CORRECT P-ABORT CAUSE VALUE? "	
	abortInspector := self checkAbort: (env servicePointA sentPackets first).
	self assert: abortInspector message abort dtid = #[1 0 0 0]. "hard coded as the begin message is corrupted"
	self assert: (abortInspector message abort reason at: 'p-abortCause') = TCAPDialoguePAbort incorrectTransactionPortion value.
		
	"CHECK B: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?"	
	self assert: env servicePointA isIdle.
			
	

]

{ #category : #tests }
Q787ValidationTest >> test1_2_2_3s1 [
	| env continueCalled  |
	continueCalled := false.
	
	env := self given: #shouldCreateTestEnvironment.
	
	env servicePointB transactionCoordinator postProcessDictionary: [ :dict| dict values first removeKey: 'otid' ].
	
	env servicePointB onDialogue: [ : dialogue |
		dialogue onBegin: [ 
			dialogue requestTcContinue ]].
	
	
	
	env servicePointA newDialogue
		onContinue: [ continueCalled := true ];
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
		
	"CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? "
	self assert: env servicePointA didSendMessage.
	self checkBegin: env servicePointA sentPackets first.
	
	"CHECK B: VERIFY THAT THE TR-USER WAS NOT INFORMED OF THE CONTINUE MESSAGE AT SP A. "
	self deny: continueCalled. 
		
	"CHECK C: VERIFY THAT NO MESSAGES WERE GENERATED BY SP A IN RESPONSE TO THE CORRUPTED CONTINUE MESSAGE? "
	self assert: env servicePointA sentPackets size = 1.
	self assert: env servicePointB sentPackets size = 1.
	
	"CHECK D: WERE TSL STATE MACHINES ASSOCIATED WITH THE TRANSACTION, PRIOR TO THE CONTINUE MESSAGE, LEFT IN THE INITIATION SENT STATE AT SP A?"
	self assert: env servicePointA dialoguesAndTransactions size = 1.
	self assert: env servicePointA dialoguesAndTransactions anyOne transaction state class = TCAPInitiationSentTransactionState

]

{ #category : #tests }
Q787ValidationTest >> test1_2_2_3s2 [
	| env continueCalled  beginInspector abortInspector |
	continueCalled := false.
	
	env := self given: #shouldCreateTestEnvironment.
	
	env servicePointB transactionCoordinator postProcessDictionary: [ :dict| dict values first removeKey: 'dtid' ].
	
	env servicePointB onDialogue: [ : dialogue |
		dialogue onBegin: [ 
			dialogue requestTcContinue  ]].
	
	
	env servicePointA newDialogue
		onContinue: [ continueCalled := true ];
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
		
	" CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? "
	beginInspector := self checkBegin: env servicePointA sentPackets first.
	
	" CHECK B: VERIFY THAT THE TR-USER WAS NOT INFORMED OF THE CONTINUE MESSAGE AT SP A. "
	self deny: continueCalled. 
	self assert: env servicePointA sentPackets size = 2.
	self assert: env servicePointB sentPackets size = 1.
	" CHECK C: WERE THE TSL STATE MACHINES ASSOCIATED WITH THE TRANSACTION, PRIOR TO THE CONTINUE MESSAGE, LEFT IN THE INITIATION SENT STATE? "
	self flag: #TBD.

	" CHECK D: IF AN ABORT MESSAGE WAS SENT, WAS IT SENT CORRECTLY FROM SP A WITH CORRECT DTID AND CORRECT P-ABORT CAUSE VALUE?"	
	abortInspector := self checkAbort: (env servicePointA sentPackets second).
	self assert: (abortInspector message abort reason at: 'p-abortCause') = TCAPDialoguePAbort incorrectTransactionPortion value.
	self assert: abortInspector message abort dtid = beginInspector message begin otid.
]

{ #category : #tests }
Q787ValidationTest >> test1_2_2_3s3 [
	| env continueCalled beginInspector abortInspector |
	continueCalled := false.
	env := self given: #shouldCreateTestEnvironment.
	
	env servicePointB transactionCoordinator postProcessPayload: [ :bytes| | insp |
		insp := TCAPMessageInspector packet: bytes.
		"duplicate OTID in tagged value structure"
		insp taggedValue elements add: insp taggedValue elements first beforeIndex: 2.
		insp updatePacketFromTaggedValue; packet ].
	
	env servicePointB onDialogue: [ : dialogue |
		dialogue onBegin: [ 
			dialogue requestTcContinue  ]].
	
	
	env servicePointA newDialogue
		onContinue: [ continueCalled := true ];
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
		

	" CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? "
	beginInspector := self checkBegin: env servicePointA sentPackets first.
	
	" CHECK B: IF AN ABORT MESSAGE WAS SENT, WAS IT SENT CORRECTLY FROM SP A WITH CORRECT DTID VALUE AND CORRECT P-ABORT CAUSE VALUE? "
	abortInspector := self checkAbort: (env servicePointA sentPackets second).
	self assert: abortInspector message abort dtid = beginInspector message begin otid.
	self assert: (abortInspector message abort reason at: 'p-abortCause') = TCAPDialoguePAbort incorrectTransactionPortion value.
	
	" CHECK C: IF THE ABORT MESSAGE AND PRIMITIVE WERE SENT, WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?"
	self assert: env servicePointA isIdle.		

	" Misc checks"
	self assert: env servicePointA sentPackets size = 2.
	self assert: env servicePointB sentPackets size = 1.
	self deny: continueCalled.

]

{ #category : #tests }
Q787ValidationTest >> test1_2_2_3s4 [
	| env  continueCalled  continueInspector abortInspector |
	continueCalled := false.
	env := self given: #shouldCreateTestEnvironment.
	
	env servicePointB transactionCoordinator postProcessPayload: [ :bytes| | insp |
		insp := TCAPMessageInspector packet: bytes.
		"duplicate dtid in tagged value"
		insp taggedValue elements add: insp taggedValue elements second beforeIndex: 3.
		insp updatePacketFromTaggedValue; packet ].
	
	env servicePointB onDialogue: [ : dialogue |
		dialogue onBegin: [ 
			dialogue requestTcContinue  ]].
	
	
	env servicePointA newDialogue
		onContinue: [ continueCalled := true ];
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
		
	" CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? "
	self checkBegin: env servicePointA sentPackets first.
		
	" CHECK B: WAS AN ABORT MESSAGE WITH CORRECT DTID VALUE AND CORRECT P-ABORT CAUSE VALUE CORRECTLY SENT FROM SP A? "
	continueInspector := (self messageInspectorOn: env servicePointB sentPackets first) ignoreErrors.
	abortInspector := self checkAbort: (env servicePointA sentPackets second).
	self assert: abortInspector message abort dtid = continueInspector message continue otid.
	self assert: (abortInspector message abort reason at: 'p-abortCause') = TCAPDialoguePAbort incorrectTransactionPortion value.
	
	" CHECK C: IF THE ABORT MESSAGE AND PRIMITIVE WERE SENT, WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?"
	self assert: env servicePointA isIdle.		

	" Other Checks"
	self assert: env servicePointA sentPackets size = 2.
	self assert: env servicePointB sentPackets size = 1.
	self deny: continueCalled.
]

{ #category : #tests }
Q787ValidationTest >> test1_2_2_3s5 [
	| env  continueCalled  continueInspector abortInspector |
	continueCalled := false.
	env := self given: #shouldCreateTestEnvironment.
	
	env servicePointB transactionCoordinator postProcessPayload: self addExtraElementAfterDtidBlock.
	
	env servicePointB onDialogue: [ : dialogue |
		dialogue onBegin: [ 
			dialogue requestTcContinue  ]].
	
	
	env servicePointA newDialogue
		onContinue: [ continueCalled := true ];
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
		
	"CHECK A: VERIFY THAT THE TR-USER WAS NOT INFORMED OF THE CONTINUE MESSAGE AT SP A. "
	self checkBegin: env servicePointA sentPackets first.
	
	"CHECK B: IF THE ABORT MESSAGE WAS SENT, WAS IT SENT CORRECTLY FROM SP A, WITH CORRECT DTID AND THE CORRECT P-ABORT CAUSE VALUE? (INCORRECT TRANSACTION PORTION) "
	continueInspector := (self messageInspectorOn: env servicePointB sentPackets first) ignoreErrors.
	abortInspector := self checkAbort: (env servicePointA sentPackets second).
	self assert: abortInspector message abort dtid = continueInspector message continue otid.
	self assert: (abortInspector message abort reason at: 'p-abortCause') = TCAPDialoguePAbort incorrectTransactionPortion value.
	
	"CHECK C: IF THE MESSAGE AND PRIMITIVE ABORT WERE SENT, WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?"
	self assert: env servicePointA isIdle.			

	" Other Checks"
	self assert: env servicePointA sentPackets size = 2.
	self assert: env servicePointB sentPackets size = 1.
	self deny: continueCalled.
]

{ #category : #tests }
Q787ValidationTest >> test1_2_2_4s1 [
	| env  continueCalled  |
	continueCalled := 0.
	env := self given: #shouldCreateTestEnvironment.
	
	env servicePointB onDialogue: [ : dialogue |
		dialogue onBegin: [ 
			dialogue requestTcContinue.
			env servicePointB transactionCoordinator postProcessDictionary: [ :dict| 
				dict continue removeKey: 'otid' ]. 
			dialogue requestTcContinue. ]].
	
	
	env servicePointA newDialogue
		onContinue: [ continueCalled := continueCalled + 1 ];
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
		
	"CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? "
	self checkBegin: env servicePointA sentPackets first.
	
	"CHECK B: WAS THE FIRST CONTINUE MESSAGE CORRECTLY RECEIVED AT SP A? "
	self checkContinue: env servicePointA receivedPackets first.
	
	"CHECK C: VERIFY THAT THE TR-USER AT SP A WAS NOT INFORMED OF THE CORRUPTED CONTINUE MESSAGE. "
	self assert: continueCalled = 1. 
	
	"CHECK D: VERIFY THAT NO MESSAGES WERE GENERATED BY SP A IN RESPONSE TO THE CORRUPTED CONTINUE MESSAGE. "
	self assert: env servicePointA sentPackets size = 1.
	self assert: env servicePointB sentPackets size = 2.
	
	"CHECK E: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION, PRIOR TO THE CORRUPTED CONTINUE MESSAGE, LEFT IN THE ACTIVE STATE AT SP A?"
	self assert: env servicePointA dialoguesAndTransactions size = 1.
	self assert: env servicePointA dialoguesAndTransactions anyOne transaction state class = TCAPActiveTransactionState

]

{ #category : #tests }
Q787ValidationTest >> test1_2_2_4s2 [
	| env  abortCalled continueInspector abortInspector |
	abortCalled := false.
	env := self given: #shouldCreateTestEnvironment.
	
	env servicePointA onDialogue: [ : dialogue |
		dialogue onBegin: [ 
			dialogue requestTcContinue ]].
	
	env servicePointB newDialogue
		onContinue: [ :cont |
			env servicePointB transactionCoordinator postProcessPayload: self addExtraElementAfterDtidBlock.
			cont dialogue requestTcContinue   ];
		onPAbort: [ abortCalled := true ];
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 

	"CHECK A: WAS THE BEGIN MESSAGE CORRECTLY RECEIVED AT SP A? "
	self checkBegin: env servicePointA receivedPackets first.
	
	"CHECK B: WAS THE FIRST CONTINUE MESSAGE CORRECTLY SENT FROM SP A? "
	continueInspector := self checkContinue: env servicePointA sentPackets first.
		
	"CHECK C: IF AN ABORT MESSAGE WAS SENT, WAS IT SENT CORRECTLY FROM SP A WITH CORRECT DTID AND CORRECT P-ABORT CAUSE VALUE? "
	self assert: abortCalled.
	abortInspector := self checkAbort: (env servicePointA sentPackets second).
	self assert: abortInspector message abort dtid = continueInspector message continue otid.
	self assert: (abortInspector message abort reason at: 'p-abortCause') = TCAPDialoguePAbort incorrectTransactionPortion value.
	
	"CHECK D: IF THE ABORT WAS SENT, WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN IDLE STATE AT SP A?"
	self assert: env servicePointA isIdle.		

	"Misc Checks"
	self assert: env servicePointA sentPackets size = 2.
	self assert: env servicePointB sentPackets size = 2.


]

{ #category : #tests }
Q787ValidationTest >> test1_2_2_5s1 [
	| env  endCalled |
	endCalled := false.
	
	env := self given: #shouldCreateTestEnvironment.
	env servicePointB transactionCoordinator postProcessDictionary: [ :dict| dict values first removeKey: 'dtid' ].
	env servicePointB onDialogue: [ : dialogue |
		dialogue onBegin: [ 
			dialogue requestTcEnd: false  ]].
	
	env servicePointA newDialogue
		onEnd: [  endCalled := true  ];
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 

	"CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? "
	self checkBegin: env servicePointA sentPackets first.

	"CHECK B: VERIFY THAT THE TR-USER WAS NOT INFORMED OF THE MESSAGE AT SP A. "
	"we got the package"
	self assert: env servicePointA receivedPackets size = 1.
	"but did not react to it"
	self deny: endCalled.

	"CHECK C: VERIFY THAT NO MESSAGES WERE GENERATED BY SP A IN RESPONSE TO THE CORRUPTED END MESSAGE? "
	self assert: env servicePointA sentPackets size = 1.
	self assert: env servicePointB sentPackets size = 1.

	"CHECK D: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION, PRIOR TO THE END MESSAGE, LEFT IN THE INITIATION SENT STATE AT SP A? "
	self assert: env servicePointA dialoguesAndTransactions size = 1.
	self assert: env servicePointA dialoguesAndTransactions anyOne transaction state class = TCAPInitiationSentTransactionState

]

{ #category : #tests }
Q787ValidationTest >> test1_2_2_6s1 [
	| env abortCalled |
	abortCalled := false.
	
	env := self given: #shouldCreateTestEnvironment.
	env servicePointB transactionCoordinator postProcessDictionary: [ :dict| dict values first removeKey: 'dtid' ].
	env servicePointB onDialogue: [ : dialogue |
		dialogue onBegin: [ 
			dialogue requestTcUAbort: nil ]].
	
	env servicePointA newDialogue
		onUAbort: [  abortCalled := true  ];
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 

	"CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? "
	self checkBegin: env servicePointA sentPackets first.
	
	"CHECK B: VERIFY THAT THE TR-USER WAS NOT INFORMED OF THE MESSAGE AT SP A. "
	self deny: abortCalled.
	
	"CHECK C: VERIFY THAT NO MESSAGES WERE GENERATED BY SP A IN RESPONSE TO THE CORRUPTED ABORT MESSAGE. "
	self assert: env servicePointA sentPackets size = 1.
	self assert: env servicePointB sentPackets size = 1.
	
	"CHECK D: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION, PRIOR TO THE ABORT MESSAGE, LEFT IN THE INITIATION SENT STATE AT SP A?"		
	self assert: env servicePointA dialoguesAndTransactions size = 1.
	self assert: env servicePointA dialoguesAndTransactions anyOne transaction state class = TCAPInitiationSentTransactionState

]

{ #category : #tests }
Q787ValidationTest >> test1_2_2_7s1 [
	| env abortCalled |
	abortCalled := false.
	
	env := self given: #shouldCreateTestEnvironment.
	
	env servicePointB onDialogue: [ : dialogue |
		dialogue onBegin: [ 
			dialogue requestTcUAbort: nil ]].
	
	env servicePointB transactionCoordinator postProcessDictionary: [ :dict |
		dict values first removeKey: 'otid' ].
	env servicePointB transactionCoordinator postProcessPayload: [ :bytes| | insp |
		insp := TCAPMessageInspector packet: bytes.
		insp taggedValue tag: (ASN1Tag clazz: 'APPLICATION' number: 3).
		insp updatePacketFromTaggedValue; packet ].
	env servicePointB newDialogue
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 

	"CHECK A: VERIFY THAT THE TR-USER WAS NOT INFORMED OF THIS EVENT AT SP A. "
	self deny: abortCalled.
	
	"CHECK B: VERIFY THAT NO MESSAGES WERE GENERATED BY SP A IN RESPONSE TO THE UNKNOWN MESSAGE. "
	self assert: env servicePointA sentPackets isEmpty.
	self assert: env servicePointB sentPackets size = 1.
	
	"CHECK C: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?"
	self assert: env servicePointA isIdle.
	

]

{ #category : #tests }
Q787ValidationTest >> test1_2_2_7s2 [
	| env abortCalled  abortInspector |
	abortCalled := false.
	
	env := self given: #shouldCreateTestEnvironment.
	
	env servicePointA onDialogue: [ : dialogue |
		dialogue onBegin: [ 
			dialogue requestTcUAbort: nil ]].
	env servicePointB transactionCoordinator postProcessPayload: [ :bytes| | insp |
		insp := TCAPMessageInspector packet: bytes.
		insp taggedValue tag: (ASN1Tag clazz: 'APPLICATION' number: 3).
		insp updatePacketFromTaggedValue; packet ].
	env servicePointB newDialogue
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 

	"Misc checks"
	self assert: env servicePointA sentPackets size = 1.
	self assert: env servicePointB sentPackets size = 1.

	"CHECK A: IF A P-ABORT MESSAGE WAS SENT, WAS IT SENT CORRECTLY FROM SP A WITH THE CORRECT DTID AND CORRECT P-ABORT CAUSE VALUE? "
	abortInspector := self checkAbort: env servicePointA sentPackets first.
	self assert: abortInspector message abort dtid = #[1 0 0 0]. "hard coded as message can not be parsed"
	self assert: (abortInspector message abort reason at: 'p-abortCause') = TCAPDialoguePAbort unrecognizedMessageType value.
	self deny: abortCalled.
	
	"CHECK B: IF THE ABORT WAS SENT, WERE TSL THE STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?"
	self assert: env servicePointA isIdle.
]

{ #category : #tests }
Q787ValidationTest >> test1_2_2_7s3 [
	| env abortCalled abortInspector |
	abortCalled := false.
	
	env := self given: #shouldCreateTestEnvironment.
	
	env servicePointB onDialogue: [ : dialogue |
		dialogue onBegin: [ 
			dialogue requestTcContinue ]].

	env servicePointB transactionCoordinator postProcessPayload: [ :bytes| | insp |
		insp := TCAPMessageInspector packet: bytes.
		insp taggedValue tag: (ASN1Tag clazz: 'APPLICATION' number: 3).
		insp updatePacketFromTaggedValue; packet ].
	
	env servicePointA newDialogue
		onPAbort: [ abortCalled := true ];
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 

	"CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? "
	self checkBegin: env servicePointA sentPackets first.
	
	"CHECK B: IF THE P-ABORT MESSAGE WAS SENT, WAS IT SENT CORRECTLY FROM SP A WITH THE CORRECT DTID AND CORRECT P-ABORT CAUSE VALUE? "
	abortInspector := self checkAbort: env servicePointA sentPackets second.
	self assert: abortInspector message abort dtid = #[1 0 0 0]. "hard coded as message can not be parsed"
	self assert: (abortInspector message abort reason at: 'p-abortCause') = TCAPDialoguePAbort unrecognizedMessageType value.
	
	"CHECK C: IF THE ABORT WAS SENT, WAS THE TR-USER AT SP A ADVISED BY A TR-P-ABORT INDICATION PRIMITIVE THAT THIS TRANSACTION HAD BEEN ABORTED? "
	self assert: abortCalled.
		
	"CHECK D: IF THE ABORT WAS SENT, WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?"		
	self assert: env servicePointA isIdle.
	
	"Misc"
	self assert: env servicePointA sentPackets size = 2.
	self assert: env servicePointB sentPackets size = 1.
]

{ #category : #tests }
Q787ValidationTest >> test1_2_3_1s1 [
	| env beginCalled abortCalled  abortInspector |
	beginCalled := false.
	abortCalled := false.
	
	env := self given: #shouldCreateTestEnvironment.
	
	env servicePointA onDialogue: [ : dialogue |
		dialogue onBegin: [ 
			beginCalled := true.
			dialogue requestTcContinue ]].

	env servicePointB transactionCoordinator postProcessPayload: [ :bytes| | insp |
		insp := TCAPMessageInspector packet: bytes.
		insp taggedValue elements add: (ASN1EncodedPrimitiveValue new tag: (ASN1Tag clazz: 'UNIVERSAL' number: 2); contents: 3) beforeIndex: 1.
		insp updatePacketFromTaggedValue; packet ].
	
	env servicePointB newDialogue
		onPAbort: [ abortCalled := true ];
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 

	"CHECK A: CHECK THAT THE USER WAS NOT INFORMED OF THE BEGIN MESSAGE. "
	self deny: beginCalled.
	
	"CHECK B: WERE THE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A? "
	self assert: env servicePointA isIdle.
	
	"CHECK C: IF AN ABORT MESSAGE WAS SENT, WAS IT SENT CORRECTLY FROM SP A WITH CORRECT DTID AND CORRECT P-ABORT CAUSE VALUE?"
	abortInspector := self checkAbort: env servicePointA sentPackets first.
	self assert: abortInspector message abort dtid = #[1 0 0 0]. "hard coded as message can not be parsed"
	self assert: (abortInspector message abort reason at: 'p-abortCause') = TCAPDialoguePAbort incorrectTransactionPortion value.
	self assert: abortCalled.

	"Misc"
	self assert: env servicePointA sentPackets size = 1.
	self assert: env servicePointB sentPackets size = 1.
]

{ #category : #tests }
Q787ValidationTest >> test1_2_3_2s1 [
	| env continueCalled abortCalled  abortInspector |
	abortCalled := false.
	continueCalled := false. 
	
	env := self given: #shouldCreateTestEnvironment.
	
	env servicePointB onDialogue: [ : dialogue |
		dialogue onBegin: [ 
			dialogue requestTcContinue ]].

	env servicePointB transactionCoordinator postProcessPayload: self addExtraElementAfterDtidBlock.
	
	env servicePointA newDialogue
		onPAbort: [ abortCalled := true ];
		onContinue: [ continueCalled := true ];
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 

	"CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT FROM SP A? "
	 self checkBegin: env servicePointA sentPackets first.
	
	"CHECK B: VERIFY THAT THE TR-USER WAS NOT INFORMED OF THE CONTINUE MESSAGE AT SP A. "
	self deny: continueCalled.
	
	"CHECK C: IF AN ABORT MESSAGE WAS SENT, WAS IT SENT CORRECTLY FROM SP A WITH CORRECT DTID AND CORRECT P-ABORT CAUSE VALUE?"
	abortInspector := self checkAbort: env servicePointA sentPackets second.
	self assert: abortInspector message abort dtid = #[1 0 0 0]. "Hard coded as continue message is not parsable"
	self assert: (abortInspector message abort reason at: 'p-abortCause') = TCAPDialoguePAbort incorrectTransactionPortion value.
	self assert: abortCalled.
	
	"Misc checks"
	self assert: env servicePointA sentPackets size = 2.
	self assert: env servicePointB sentPackets size = 1.		
	self assert: env servicePointA isIdle.		

]

{ #category : #tests }
Q787ValidationTest >> test1_3_1s1 [
	| env  continueCalled abort continue |
	continueCalled := false.
	env := self given: #shouldCreateTestEnvironment.
	
	env servicePointA onDialogue: [ :dialogue|
		dialogue onContinue: [ continueCalled := true ]].
	
	"B sends a continue message to A in idle state"
	env servicePointB newDialogue
		requestTcContinueDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
	
	"CHECK A: VERIFY THAT THE TR-USER WAS NOT INFORMED OF THE CONTINUE MESSAGE AT SP A. "
	self assert:  env servicePointA receivedPackets size = 1.
	continue := self checkContinue:  env servicePointA receivedPackets first.
	self deny: continueCalled.
	
	"CHECK B: WAS THE DTID IN THE ABORT MESSAGE EQUAL TO THE OTID IN THE CONTINUE MESSAGE? "
	abort  := self checkAbort: env servicePointA sentPackets first.
	self assert: (abort findKey: 'dtid') basicValue = (continue findKey: 'otid') basicValue.
	
	"CHECK C: WAS AN ABORT MESSAGE CORRECTLY SENT FROM SP A WITH A P-ABORT CAUSE VALUE OF UNRECOGNIZED TRANSACTION ID? "
	self assert: env servicePointA sentPackets size = 1.
	self assert: (abort message abort reason at: 'p-abortCause') = TCAPDialoguePAbort unrecognizedTransactionID value.
	
	"CHECK D: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?"
	self assert: env servicePointA isIdle.

]

{ #category : #tests }
Q787ValidationTest >> test1_3_2s1 [
	| env  endCalled  |
	endCalled := false.
	env := self given: #shouldCreateTestEnvironment.
	
	env servicePointA onDialogue: [ :dialogue|
		dialogue onEnd: [ endCalled := true ]].
	
	"B sends an end message to A in idle state"
	env servicePointB newDialogue
		requestTcEndDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
	
	"CHECK A: VERIFY THAT THE TR-USER WAS NOT INFORMED OF THE END MESSAGE AT SP A. "
	"we received the packet"
	self assert:  env servicePointA receivedPackets size = 1.
	self checkEnd:  env servicePointA receivedPackets first.
	"but did nothing"
	self deny: endCalled.

	"CHECK B: VERIFY THAT NO MESSAGES WERE GENERATED BY SP A IN RESPONSE TO THE END MESSAGE. "
	self assert: env servicePointA sentPackets isEmpty.
	
	"CHECK C: WERE TSL STATE MACHINES ASSOCIATED WITH THE TRANSACTION LEFT IN THE IDLE STATE AT SP A?"
	self assert: env servicePointA isIdle.

]

{ #category : #tests }
Q787ValidationTest >> test1_3_3s1 [
	| env  abortCalled  |
	abortCalled := false.
	env := self given: #shouldCreateTestEnvironment.
	
	env servicePointA onDialogue: [ :dialogue|
		dialogue onPAbort: [ abortCalled := true ]].
	
	"B sends an end message to A in idle state"
	env servicePointB newDialogue
		requestTcAbortDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
	
	"CHECK A: VERIFY THAT THE TR-USER WAS NOT INFORMED OF THE ABORT MESSAGE AT SP A. "
	"we received the packet"
	self assert:  env servicePointA receivedPackets size = 1.
	self checkAbort:  env servicePointA receivedPackets first.
	"but did nothing"
	self deny: abortCalled.

	"CHECK B: VERIFY THAT NO MESSAGES WERE GENERATED BY SP A IN RESPONSE TO THE END MESSAGE. "
	self assert: env servicePointA sentPackets isEmpty.
	
	"CHECK C: WERE TSL STATE MACHINES ASSOCIATED WITH THE TRANSACTION LEFT IN THE IDLE STATE AT SP A?"
	self assert: env servicePointA isIdle.

]

{ #category : #tests }
Q787ValidationTest >> test1_4_1s1 [
	| env begin1 end1 end1Called begin2 end2Called |
	
	env := self given: #shouldCreateTestEnvironment.
	end1Called := false.
	end2Called := false.
	
	env servicePointB onDialogue: [ : dialogue |
		dialogue 
			onBegin: [
				"(2) on receive of the first dialogue we initiate another dialogue by sending a begin message back"
				env servicePointB newDialogue
					onEnd: [ 
						"(5) the second dialogue received an end message"
						end1Called := true ];
					requestTcBeginDestinationAddress:  self originatingAddress
					originatingAddress:  self destinationAddress
					applicationContextName: self anyApplicationContextId.
				dialogue requestTcEnd: false.
			 ]].
	
	env servicePointA onDialogue: [ : dialogue | 
		dialogue
			"(3) received a begin message for a new dialogue"
			onBegin: [ 
				"(4) end the dialogue immediately"
				dialogue requestTcEnd: false ]].

	"(1) we send the first begin message"
	env servicePointA newDialogue
		onEnd: [ 
			"(6) the first dialogue received an end message"
			end2Called := true ];
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 
		
	
	"CHECK A: WAS THE FIRST BEGIN MESSAGE CORRECTLY SENT BY SP A? "
	begin1 := self checkBegin: env servicePointA sentPackets first.

	"CHECK B: WAS THE SECOND BEGIN MESSAGE CORRECTLY RECEIVED BY SP A? "
	begin2 := self checkBegin: env servicePointA receivedPackets first.
	
	"CHECK C: WAS THE DTID IN THE FIRST END MESSAGE THE SAME AS THE OTID IN THE SECOND BEGIN MESSAGE? "
	end1 :=  self checkEnd: env servicePointA sentPackets second.
	self assert: (end1 findKey: 'dtid') basicValue = (begin2 findKey: 'otid') basicValue.
	self assert: end1Called.
	
	"CHECK D: WAS THE SECOND END MESSAGE CORRECTLY RECEIVED BY SP A? "
	self checkEnd: env servicePointA receivedPackets second.
	self assert: end2Called.
	
	"CHECK E: WERE TSL STATE MACHINES ASSOCIATED WITH THESE TRANSACTIONS LEFT IN THE IDLE STATE AT SP A?"
	self assert: env hasInitialState.
]

{ #category : #tests }
Q787ValidationTest >> test1_4_1s2 [
	| env begin1 end1 end1Called begin2 end2Called |
	
	env := self given: #shouldCreateTestEnvironment.
	end1Called := false.
	end2Called := false.
	
	env servicePointB onDialogue: [ : dialogue |
		dialogue 
			onBegin: [
				"(2) on receive of the first dialogue we reply with continue"
				dialogue requestTcContinue.
				"(3) initiate another dialogue by sending a begin message back"
				env servicePointB newDialogue
					onEnd: [ 
						"(5) the second dialogue received an end message"
						end1Called := true ];
					requestTcBeginDestinationAddress:  self originatingAddress
					originatingAddress:  self destinationAddress
					applicationContextName: self anyApplicationContextId.
				dialogue requestTcEnd: false.
			 ]].
	
	env servicePointA onDialogue: [ : dialogue | 
		dialogue
			"(4) received a begin message for a new dialogue"
			onBegin: [ 
				"(5) end the dialogue immediately"
				dialogue requestTcEnd: false ]].

	"(1) we send the first begin message"
	env servicePointA newDialogue
		onEnd: [ 
			"(6) the first dialogue received an end message"
			end2Called := true ];
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 

	"CHECK A: WAS THE FIRST BEGIN MESSAGE CORRECTLY SENT BY SP A? "
	begin1 := self checkBegin: env servicePointA sentPackets first.

	"CHECK B: WAS THE CONTINUE MESSAGE CORRECTLY RECEIVED BY SP A? "
	 self checkContinue: env servicePointA receivedPackets first.
	
	"CHECK C: WAS THE SECOND BEGIN MESSAGE CORRECTLY RECEIVED BY SP A? "
	begin2 := self checkBegin: env servicePointA receivedPackets second.
	
	"CHECK D: WAS THE DTID IN THE FIRST END MESSAGE THE SAME AS THE OTID IN THE SECOND BEGIN MESSAGE? "
	end1 :=  self checkEnd: env servicePointA sentPackets second.
	self assert: (end1 findKey: 'dtid') basicValue = (begin2 findKey: 'otid') basicValue.
	self assert: end1Called.
	
	"CHECK E: WAS THE SECOND END MESSAGE CORRECTLY RECEIVED BY SP A? "
	self checkEnd: env servicePointA receivedPackets third.
	self assert: end2Called.
	
	"CHECK F: WERE TSL STATE MACHINES ASSOCIATED WITH THESE TRANSACTIONS LEFT IN THE IDLE STATE AT SP A?"
	self assert: env hasInitialState.
]

{ #category : #tests }
Q787ValidationTest >> test1_4_2s1 [
	| env  begin1 end1Called continue abort end2Called |
	
	env := self given: #shouldCreateTestEnvironment.
	end1Called := false.
	end2Called := false.
	
	env servicePointB onDialogue: [ : dialogue |
		dialogue 
			onBegin: [
				env servicePointB newDialogue
					requestTcContinueDestinationAddress:  self originatingAddress
					originatingAddress:  self destinationAddress
					applicationContextName: self anyApplicationContextId.
				dialogue requestTcEnd: false.
			 ]].
	
	env servicePointA onDialogue: [ : dialogue | 
		dialogue
			"(4) received a begin message for a new dialogue"
			onBegin: [ 
				"(5) end the dialogue immediately"
				dialogue requestTrAbort: false]].

	"(1) we send the first begin message"
	env servicePointA newDialogue
		onEnd: [ 
			"(6) the first dialogue received an end message"
			end2Called := true ];
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 

	"CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT BY SP A? "
	begin1 := self checkBegin: env servicePointA sentPackets first.
	
	"CHECK B: WAS THE CONTINUE MESSAGE CORRECTLY RECEIVED BY SP A? "
	continue := self checkContinue: env servicePointA receivedPackets first.
		
	"CHECK C: WAS THE DTID IN THE ABORT MESSAGE THE SAME AS THE OTID IN THE CONTINUE MESSAGE? "
	abort :=  self checkAbort: env servicePointA sentPackets second.
	self assert: (abort findKey: 'dtid') basicValue = (continue findKey: 'otid') basicValue.
	
	"CHECK D: WAS THE P-ABORT CAUSE IN THE ABORT MESSAGE THE CORRECT VALUE, (UNRECOGNIZED TRANSACTION ID)? "
	self assert: (abort message abort reason at: 'p-abortCause') = TCAPDialoguePAbort unrecognizedTransactionID value.
	
	"CHECK E: WAS THE END MESSAGE CORRECTLY RECEIVED BY SP A? "
	self checkEnd:  env servicePointA receivedPackets second.
	
	"CHECK F: WERE TSL STATE MACHINES ASSOCIATED WITH THESE TRANSACTIONS LEFT IN THE IDLE STATE AT SP A?"
	self assert: env hasInitialState.
]

{ #category : #tests }
Q787ValidationTest >> test1_4_2s2 [
	| env  begin1 end1Called continue abort end2Called |
	
	env := self given: #shouldCreateTestEnvironment.
	end1Called := false.
	end2Called := false.
	
	env servicePointB onDialogue: [ : dialogue |
		dialogue 
			onBegin: [
				dialogue requestTcContinue.
				env servicePointB newDialogue
					requestTcContinueDestinationAddress:  self originatingAddress
					originatingAddress:  self destinationAddress
					applicationContextName: self anyApplicationContextId.
				dialogue requestTcEnd: false.
			 ]].
	
	env servicePointA onDialogue: [ : dialogue | 
		dialogue
			"(4) received a begin message for a new dialogue"
			onBegin: [ 
				"(5) end the dialogue immediately"
				dialogue requestTrAbort: false]].

	"(1) we send the first begin message"
	env servicePointA newDialogue
		onEnd: [ 
			"(6) the first dialogue received an end message"
			end2Called := true ];
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: self anyApplicationContextId. 

	"CHECK A: WAS THE BEGIN MESSAGE CORRECTLY SENT BY SP A? "
	begin1 := self checkBegin: env servicePointA sentPackets first.
	
	"CHECK B: WERE THE CONTINUE MESSAGES CORRECTLY RECEIVED BY SP A? "
	self checkContinue: env servicePointA receivedPackets first.
	continue :=  self checkContinue: env servicePointA receivedPackets second.
		
	"CHECK C: WAS THE DTID IN THE ABORT MESSAGE THE SAME AS THE OTID IN THE SECOND CONTINUE MESSAGE? "
	abort :=  self checkAbort: env servicePointA sentPackets second.
	self assert: (abort findKey: 'dtid') basicValue = (continue findKey: 'otid') basicValue.
	
	"CHECK D: WAS THE P-ABORT CAUSE IN THE ABORT MESSAGE THE CORRECT VALUE, (UNRECOGNIZED TRANSACTION ID)? "
	self assert: (abort message abort reason at: 'p-abortCause') = TCAPDialoguePAbort unrecognizedTransactionID value.
	
	"CHECK E: WAS THE END MESSAGE CORRECTLY RECEIVED BY SP A? "
	self checkEnd:  env servicePointA receivedPackets third.
	
	"CHECK F: WERE TSL STATE MACHINES ASSOCIATED WITH THESE TRANSACTIONS LEFT IN THE IDLE STATE AT SP A?"
	self assert: env hasInitialState.
]

{ #category : #tests }
Q787ValidationTest >> test2_1_3_1_1 [
	| env rejectCalled  dialogue invocation |
	rejectCalled := false.
	
	env := self given: #shouldCreateTestEnvironment.
	
	env servicePointB onDialogue: [ : dialog |
		dialog onInvoke: [ :notification |
			notification invocation returnReject: nil.
			dialog requestTcContinue ]].

	dialogue := env servicePointA newDialogue.
		
	invocation := dialogue requestTcInvokeNamed: 'sendAuthenticationInfoV2' parameters:  '123456789' class: TCAPReportSuccessAndFailure timeout: 500.
	
	invocation 
		onReject: [ rejectCalled := true ].

	dialogue
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: '0.4.0.0.1.0.14.2'. 
		
	self assert: env servicePointA sentPackets size = 1.
	self assert: env servicePointB sentPackets size = 1.
	
	self flag: #todo.
	"state machine must be implemented to end the dialogue immediately on reject"
	"self deny: dialogue hasInvocations."

]
