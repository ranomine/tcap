Class {
	#name : #ROSResultLast,
	#superclass : #ROSResult,
	#category : #'ROS-Core'
}

{ #category : #'initailize-release' }
ROSResultLast class >> asn1TypeName [
	^ 'ReturnResult'
]

{ #category : #'instance creation' }
ROSResultLast class >> dispatchInstanceCreationOn: aFactory [ 
	^ aFactory newROSResultLast
]

{ #category : #'as yet unclassified' }
ROSResultLast class >> isAsn1ModelClass [
	^ true
]

{ #category : #'as yet unclassified' }
ROSResultLast class >> rosMessageType [
	^ 'returnResult'
]

{ #category : #dispatching }
ROSResultLast >> dispatchTo: aDialogue [ 
	aDialogue receivedReturnLast: self 
]
