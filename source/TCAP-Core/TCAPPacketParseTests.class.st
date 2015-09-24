Class {
	#name : #TCAPPacketParseTests,
	#superclass : #ASN1PacketTest,
	#category : #'TCAP-Core-Tests'
}

{ #category : #accessing }
TCAPPacketParseTests >> asn1Model [
	^ TCAPTestModel instance
]

{ #category : #accessing }
TCAPPacketParseTests >> packet: aSymbol [
	^ TCAPExamplePackets perform: aSymbol
]

{ #category : #accessing }
TCAPPacketParseTests >> roundTripTestFor: aSymbol [
	super roundTripTestFor: (self packet: aSymbol )
]

{ #category : #accessing }
TCAPPacketParseTests >> tcapModule [
	^ self asn1Model moduleNamed: 'TCAPMessages'
]

{ #category : #'as yet unclassified' }
TCAPPacketParseTests >> testInsertSubscriberData [
	| assoc cmd  |
	assoc := self tcapModule readFrom: (self packet: #insertSubscriberData) readStream.
	self assert: (cmd := assoc continue) notNil.
	self assert: (cmd dtid) asAsn1HexString  = '510102B6'.
	

]

{ #category : #'as yet unclassified' }
TCAPPacketParseTests >> testPurgeMS [
	| assoc cmd |
	assoc := self readResolvedFrom: (self packet: #purgeMS).
	self assert: (cmd := assoc begin) notNil.
	self assert: (cmd otid) asAsn1HexString = '5101034E'.
	self assert: (cmd dialoguePortion dialogueRequest protocol_version = '1').
	self assert: (cmd dialoguePortion dialogueRequest application_context_name value = '0.4.0.0.1.0.27.3') 
	

]

{ #category : #'as yet unclassified' }
TCAPPacketParseTests >> testPurgeMSResolveContext [
	| begin applicationContextName applicationContext invoke invokeId operationCode contract consumer operation argument |
	begin := (self readResolvedFrom: (self packet: #purgeMS)) begin.
	applicationContextName := begin dialoguePortion dialogueRequest application_context_name.
	applicationContext := self asn1Model applicationContextWithOid: applicationContextName.
	contract := applicationContext attributeAt: 'associationContract'.
	consumer := contract attributeAt: 'InitiatorConsumerOf'.
	invoke := begin components first invoke.
	invokeId := invoke invokeId.
	operationCode := invoke opcode local.
	operation := consumer findElement: [ :each| each isOperation and: [ (each attributeAt: 'operationCode') = operationCode ] ].
	argument := ASN1 
		read: invoke argument 
		usingType: (operation attributeAt: 'ArgumentType').
	self assert: argument imsi asAsn1HexString = '22821848728086F9'.
	self assert: operation originalBindingName = 'purgeMSV3'.

]

{ #category : #'as yet unclassified' }
TCAPPacketParseTests >> testPurgeMSResult [
	| assoc cmd |
	assoc := self  readResolvedFrom: (self packet: #purgeMSResult).
	self assert: (cmd := assoc end) notNil.
	self assert: (cmd dtid) asAsn1HexString = '5101034E'.
	self assert: (cmd dialoguePortion dialogueResponse protocol_version = '1').
	self assert: (cmd dialoguePortion dialogueResponse application_context_name value = '0.4.0.0.1.0.27.3') 
	

]

{ #category : #'as yet unclassified' }
TCAPPacketParseTests >> testReturnResultLast [
	| assoc cmd |
	assoc := self readFrom: (self packet: #returnResultLast) readStream.
	self assert: (cmd := assoc continue) notNil.
	self assert: (cmd dtid) asAsn1HexString = 'B40001DB'.
	

]

{ #category : #tests }
TCAPPacketParseTests >> testTcapAbort [
	| assoc cmd |
	assoc := self readFrom: (self packet: #exampleTcapAbortPacket).
	self assert: (cmd := assoc abort) notNil.
	self assert: (cmd dtid) asAsn1HexString = '51010043'.
	

]

{ #category : #tests }
TCAPPacketParseTests >> testTcapBegin [
	| assoc cmd |
	assoc := self readResolvedFrom: (self packet: #exampleTcapBeginPacket).
	self assert: (cmd := assoc begin) notNil.
	self assert: (cmd otid) asAsn1HexString = '04251B7D'.
	self assert: cmd dialoguePortion dialogueRequest application_context_name contents = '0.4.0.0.1.0.25.2'.
	self assert: (cmd dialoguePortion dialogueRequest user_information) notNil.
	self assert: (cmd find: 'application-context-name' ) notNil 
]

{ #category : #tests }
TCAPPacketParseTests >> testTcapBeginRoundTrip [
	self roundTripTestFor: #exampleTcapBeginPacket
]

{ #category : #tests }
TCAPPacketParseTests >> testTcapContinue [
	| assoc cmd |
	assoc := self readResolvedFrom: (self packet: #exampleTcapContinuePacket).
	self assert: (cmd := assoc continue) notNil.
	self assert: (cmd otid) asAsn1HexString = '51010312'.
	self assert: (cmd dtid) asAsn1HexString = '04251B7D'.
	self assert: cmd dialoguePortion dialogueResponse application_context_name contents = '0.4.0.0.1.0.25.2'.
	

]

{ #category : #tests }
TCAPPacketParseTests >> testTcapContinueRoundTrip [
	self roundTripTestFor: #exampleTcapContinuePacket
]

{ #category : #tests }
TCAPPacketParseTests >> testTcapEnd [
	| assoc cmd |
	assoc := self readFrom: (self packet:  #exampleTcapEndPacket).
	self assert: (cmd := assoc end) notNil.
	self assert: (cmd dtid) asAsn1HexString = '05A51485'.
	

]

{ #category : #tests }
TCAPPacketParseTests >> testTcapEndRoundtrip [
	self roundTripTestFor: #exampleTcapEndPacket

]

{ #category : #'as yet unclassified' }
TCAPPacketParseTests >> testUpdateLocation [
	| assoc cmd |
	assoc := self readResolvedFrom: (self packet: #updateLocation).
	self assert: (cmd := assoc begin) notNil.
	self assert: (cmd otid) asAsn1HexString = '510103D3'.
	self assert: (cmd dialoguePortion dialogueRequest application_context_name contents = '0.4.0.0.1.0.1.2') 
	

]

{ #category : #'as yet unclassified' }
TCAPPacketParseTests >> testUpdateLocationResult [
	| assoc cmd |
	assoc := self readFrom: (self packet: #updateLocationResult).
	self assert: (cmd := assoc end) notNil.
	self assert: (cmd dtid) asAsn1HexString = '510103D3'.
	self assert: ((cmd components) first returnResult result opcode local = 2).
	

]
