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

{ #category : #accessing }
ROSOperation >> argumentValue [
	^ self argumentType newValue
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

{ #category : #testing }
ROSOperation >> hasArgumentType [
	^ self argumentType notNil
]

{ #category : #initialize }
ROSOperation >> initializeFrom: anOperation [
	type := anOperation
]

{ #category : #'as yet unclassified' }
ROSOperation >> invokeWithArgument: anObject [
	^ self newInvocation 
		opcodeNumber: self operationCode;
		argument: anObject; yourself
]

{ #category : #accessing }
ROSOperation >> name [
	^ self type originalBindingName 
]

{ #category : #'as yet unclassified' }
ROSOperation >> newInvocation [
	^ (type modelRoot typeNamed: 'Invoke') newValue
		operation: self 
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
