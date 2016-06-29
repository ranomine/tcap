Class {
	#name : #ROSResultLast,
	#superclass : #ROSResult,
	#category : #'ROS-Core'
}

{ #category : #accessing }
ROSResultLast class >> asn1TypeName [
	^ 'ReturnResult'
]

{ #category : #'instance creation' }
ROSResultLast class >> dispatchInstanceCreationOn: aFactory [ 
	^ aFactory newROSResultLast
]

{ #category : #testing }
ROSResultLast class >> isAsn1ModelClass [
	^ true
]

{ #category : #accessing }
ROSResultLast class >> rosMessageType [
	^ 'returnResult'
]

{ #category : #dispatching }
ROSResultLast >> dispatchTo: aDialogue [ 
	aDialogue receivedReturnLast: self 
]
