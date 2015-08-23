Class {
	#name : #TCAPMessageInspector,
	#superclass : #TCAPObject,
	#instVars : [
		'packet',
		'taggedValue',
		'message',
		'ignoreErrors',
		'asn1Model'
	],
	#category : #'TCAP-Core'
}

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

{ #category : #'as yet unclassified' }
TCAPMessageInspector class >> taggedValue: aTaggedValue [ 
	^ self new
		taggedValue: aTaggedValue
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

{ #category : #finding }
TCAPMessageInspector >> findKey: aString [ 
	^ self message find: aString
]

{ #category : #finding }
TCAPMessageInspector >> findTaggedValue: aString [
	^ self taggedValue findValueWithTag: (self messageValue type findTypeWithKey: aString) tag
]

{ #category : #finding }
TCAPMessageInspector >> findTaggedValueForTypeNamed:  aTypeName [
	^ self taggedValue findValueWithTag: (self asn1Model typeNamed: aTypeName)  tag
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
		self updateMessageFromTaggedValue.
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
	self updateTaggedValueFromMessage.
	self updatePacketFromTaggedValue.
]

{ #category : #accessing }
TCAPMessageInspector >> messageValue [
	^ self message soleValue
]

{ #category : #accessing }
TCAPMessageInspector >> packet [ 
	^ packet ifNil: [ 
		self taggedValue ifNotNil: [
			self updatePacketFromTaggedValue.
			packet  ] ]
]

{ #category : #accessing }
TCAPMessageInspector >> packet: aByteArray [
	packet := aByteArray
]

{ #category : #'as yet unclassified' }
TCAPMessageInspector >> packetUpdated [
	self updateTaggedValueFromPacket.
	self updateMessageFromTaggedValue.
]

{ #category : #accessing }
TCAPMessageInspector >> taggedValue [
	^ taggedValue ifNil: [ 
		self packet 
			ifNotNil: [ 
				self updateTaggedValueFromPacket.
				taggedValue ]
			ifNil: [ 
				self message ifNotNil: [ 
					self updateTaggedValueFromMessage.
					taggedValue ] ] ]
]

{ #category : #accessing }
TCAPMessageInspector >> taggedValue: aTaggedValue [
	taggedValue := aTaggedValue
]

{ #category : #'as yet unclassified' }
TCAPMessageInspector >> taggedValueUpdated [
	self updateMessageFromTaggedValue.
	self updatePacketFromTaggedValue.
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
TCAPMessageInspector >> updateMessageFromTaggedValue [
	self 
		update: [ message := ASN1
			read: self taggedValue 
			usingModule: self tcapModule 
			inContext: self asn1Model ]
		onError: [
			message := ASN1
				read: self taggedValue 
				usingType: self tcapModule pdu
				inContext: self asn1Model
				skipErrors: true ]
]

{ #category : #updating }
TCAPMessageInspector >> updatePacketFromTaggedValue [
	packet := ByteArray streamContents: [ :stream |
		ASN1 
			writeTaggedValues: self taggedValue 
			on: stream  ]
]

{ #category : #updating }
TCAPMessageInspector >> updateTaggedValueFromMessage [
	self asn1Model resolveOidsWhile: [ 
		taggedValue := ASN1 
			write: self message 
			usingModule: self tcapModule ]
]

{ #category : #updating }
TCAPMessageInspector >> updateTaggedValueFromPacket [
	taggedValue := ASN1 readTaggedValuesFrom: self packet readStream
]
