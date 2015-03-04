Class {
	#name : #ROSOperation,
	#superclass : #ASN1AdaptiveTypeObject,
	#category : #'ROS-Core'
}

{ #category : #'as yet unclassified' }
ROSOperation class >> on: aDictionary [
	^ self new
		initializeFrom: aDictionary 
]

{ #category : #accessing }
ROSOperation >> argumentType [
	^ type attributeAt: 'ArgumentType'
]

{ #category : #actions }
ROSOperation >> argumentValueFor: anObject [
	^ self argumentType newValue: anObject
]

{ #category : #'as yet unclassified' }
ROSOperation >> decodeArgument: anObject [
	^ ASN1 
		read: anObject
		usingType: self argumentType.
]

{ #category : #'as yet unclassified' }
ROSOperation >> decodeResult: anObject [
	^ ASN1
		read: anObject 
		usingType: self resultType
]

{ #category : #accessing }
ROSOperation >> errorNamed: aString [ 
	^ self errors findElement: [ :each| each isError and: [ each originalBindingName = aString  ]]
]

{ #category : #acces }
ROSOperation >> errors [
	^ type attributeAt: 'Errors'
]

{ #category : #initialize }
ROSOperation >> initializeFrom: anOperation [
	type := anOperation
]

{ #category : #actions }
ROSOperation >> invocationWithArgument: anObject [ 
	^ ASN1Dictionary new 
		at: 'opcode' put: self operationCodeDict;
		at: 'argument' put: (self argumentType newValue: anObject);
		yourself 
]

{ #category : #'as yet unclassified' }
ROSOperation >> invokeArgument: anObject on: invocation [
	invocation opcodeNumber: self operationCode.
	invocation 
		at: 'argument'
		put: (self argumentType newValue: anObject)
]

{ #category : #accessing }
ROSOperation >> operationCode [
	^ type attributeAt: 'operationCode'
]

{ #category : #accessing }
ROSOperation >> operationCodeDict [
	 ^ ASN1Dictionary new
		at: 'local' put: (type attributeAt: #operationCode);
		yourself 
		
]

{ #category : #accessing }
ROSOperation >> parameterType [
	^ type attributeAt: 'ParameterType'
]

{ #category : #printing }
ROSOperation >> printOn: aStream [
	aStream 
		nextPutAll: 'operation code: ';
		nextPutAll: (self type attributeAt: 'operationCode') asString
]

{ #category : #accessing }
ROSOperation >> resultType [
	^ type attributeAt: 'ResultType'
]
