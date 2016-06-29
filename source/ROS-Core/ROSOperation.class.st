Class {
	#name : #ROSOperation,
	#superclass : #ASN1AdaptiveTypeObject,
	#category : #'ROS-Core'
}

{ #category : #'instance creation' }
ROSOperation class >> on: aDictionary [
	^ self new
		initializeFrom: aDictionary 
]

{ #category : #accessing }
ROSOperation >> argumentType [
	^ type attributeAt: 'ArgumentType'
]

{ #category : #decoding }
ROSOperation >> decodeArgument: anObject [
	^ ASN1 
		read: anObject
		usingType: self argumentType.
]

{ #category : #decoding }
ROSOperation >> decodeResult: anObject [
	^ ASN1
		read: anObject 
		usingType: self resultType
]

{ #category : #accessing }
ROSOperation >> errorNamed: aString [ 
	^ self errors findElement: [ :each| each isError and: [ each originalBindingName = aString  ]]
]

{ #category : #accessing }
ROSOperation >> errors [
	^ type attributeAt: 'Errors'
]

{ #category : #testing }
ROSOperation >> hasArgumentType [
	^ self argumentType notNil
]

{ #category : #initialize }
ROSOperation >> initializeFrom: anOperation [
	type := anOperation
]

{ #category : #invokation }
ROSOperation >> invokeWithArgument: anObject [
	| invocation |
	invocation := self newInvocation 
		opcodeNumber: self operationCode.
	(invocation expandFieldNamed: 'argument') contents: anObject.
	^ invocation
]

{ #category : #accessing }
ROSOperation >> name [
	^ self type originalBindingName 
]

{ #category : #accessing }
ROSOperation >> newArgumentValue [
	^ self argumentType newValue
]

{ #category : #accessing }
ROSOperation >> newArgumentValue: anObject [
	^ self argumentType newValue: anObject
]

{ #category : #invokation }
ROSOperation >> newInvocation [
	^ (type modelRoot typeNamed: 'Invoke') newValue
		operation: self 
]

{ #category : #accessing }
ROSOperation >> newResultValue [
	^ self resultType newValue
]

{ #category : #accessing }
ROSOperation >> operationCode [
	^ type attributeAt: 'operationCode'
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
