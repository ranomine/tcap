Class {
	#name : #TCAPMessageInspector,
	#superclass : #TCAPObject,
	#instVars : [
		'packet',
		'message',
		'ignoreErrors',
		'asn1Model',
		'encodedValue'
	],
	#category : #'TCAP-Core'
}

{ #category : #'as yet unclassified' }
TCAPMessageInspector class >> encodedValue: aTaggedValue [ 
	^ self new
		encodedValue: aTaggedValue
]

{ #category : #'as yet unclassified' }
TCAPMessageInspector class >> message: aMessage [ 
	^ self new
		message: aMessage
]

{ #category : #'as yet unclassified' }
TCAPMessageInspector class >> packet: aByteArray [ 
	^ self new
		packet: aByteArray
]

{ #category : #accessing }
TCAPMessageInspector >> asn1Model [
	^ asn1Model ifNil: [ 
		asn1Model := ASN1CurrentContext value model ]
]

{ #category : #accessing }
TCAPMessageInspector >> asn1Model: anObject [
	asn1Model := anObject 
]

{ #category : #accessing }
TCAPMessageInspector >> encodedValue [
	^ encodedValue ifNil: [ 
		self packet 
			ifNotNil: [ 
				self updateEncodedValueFromPacket.
				encodedValue ]
			ifNil: [ 
				self message ifNotNil: [ 
					self updateEncodedValueFromMessage.
					encodedValue ] ] ]
]

{ #category : #accessing }
TCAPMessageInspector >> encodedValue: anEncodedValue [
	encodedValue := anEncodedValue
]

{ #category : #'as yet unclassified' }
TCAPMessageInspector >> encodedValueUpdated [
	self updateMessageFromEncodedValue.
	self updatePacketFromEncodedValue.
]

{ #category : #finding }
TCAPMessageInspector >> findEncodedValue: aString [
	^ self encodedValue findValueWithTag: (self messageValue type findTypeWithKey: aString) tag
]

{ #category : #finding }
TCAPMessageInspector >> findEncodedValueForTypeNamed:  aTypeName [
	^ self encodedValue findValueWithTag: (self asn1Model typeNamed: aTypeName)  tag
]

{ #category : #finding }
TCAPMessageInspector >> findKey: aString [ 
	^ self message find: aString
]

{ #category : #testing }
TCAPMessageInspector >> hasType: aString [
	^ self messageType = aString
]

{ #category : #accessing }
TCAPMessageInspector >> ignoreErrors [
	ignoreErrors := true
]

{ #category : #'initialize-release' }
TCAPMessageInspector >> initialize [
	super initialize.
	ignoreErrors := false
]

{ #category : #testing }
TCAPMessageInspector >> isAbort [
	^ self hasType: 'abort'
]

{ #category : #testing }
TCAPMessageInspector >> isBegin [
	^ self hasType: 'begin'
]

{ #category : #testing }
TCAPMessageInspector >> isContinue [
	^ self hasType: 'continue'
]

{ #category : #testing }
TCAPMessageInspector >> isEnd [
	^ self hasType: 'end'
]

{ #category : #accessing }
TCAPMessageInspector >> message [ 
	^ message ifNil: [
		self updateMessageFromEncodedValue.
		message ]
]

{ #category : #accessing }
TCAPMessageInspector >> message: aMessage [
	message := aMessage
]

{ #category : #testing }
TCAPMessageInspector >> messageContainsKey: aString [
	^ (self findKey: aString) notNil
]

{ #category : #testing }
TCAPMessageInspector >> messageHasDialoguePortion [
	^ self messageContainsKey: 'dialoguePortion'
]

{ #category : #'as yet unclassified' }
TCAPMessageInspector >> messageType [
	^ self message keys first
]

{ #category : #'as yet unclassified' }
TCAPMessageInspector >> messageUpdated [
	self updateEncodedValueFromMessage.
	self updatePacketFromEncodedValue.
]

{ #category : #accessing }
TCAPMessageInspector >> messageValue [
	^ self message soleValue
]

{ #category : #accessing }
TCAPMessageInspector >> packet [ 
	^ packet ifNil: [ 
		self encodedValue ifNotNil: [
			self updatePacketFromEncodedValue.
			packet  ] ]
]

{ #category : #accessing }
TCAPMessageInspector >> packet: aByteArray [
	packet := aByteArray
]

{ #category : #'as yet unclassified' }
TCAPMessageInspector >> packetUpdated [
	self updateEncodedValueFromPacket.
	self updateMessageFromEncodedValue.
]

{ #category : #accessing }
TCAPMessageInspector >> tcapModule [
	^ self asn1Model moduleNamed: 'TCAPMessages'
]

{ #category : #updating }
TCAPMessageInspector >> update: aBlock onError: anErrorBlock [
	[ aBlock value ]
		on: Error
		do: [ :err| 
			ignoreErrors 
				ifTrue: [ anErrorBlock value ]
				ifFalse: [ err pass ]]
]

{ #category : #updating }
TCAPMessageInspector >> updateEncodedValueFromMessage [
	self asn1Model resolveOidsWhile: [ 
		encodedValue := ASN1 
			write: self message 
			usingModule: self tcapModule ]
]

{ #category : #updating }
TCAPMessageInspector >> updateEncodedValueFromPacket [
	encodedValue := ASN1 readEncodedValuesFrom: self packet readStream
]

{ #category : #updating }
TCAPMessageInspector >> updateMessageFromEncodedValue [
	self 
		update: [ message := ASN1
			read: self encodedValue 
			usingModule: self tcapModule 
			inContext: self asn1Model ]
		onError: [
			message := ASN1
				read: self encodedValue 
				usingType: self tcapModule pdu
				inContext: self asn1Model
				skipErrors: true ]
]

{ #category : #updating }
TCAPMessageInspector >> updatePacketFromEncodedValue [
	packet := ByteArray streamContents: [ :stream |
		ASN1 
			writeEncodedValues: self encodedValue 
			on: stream  ]
]
