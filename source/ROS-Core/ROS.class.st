Class {
	#name : #ROS,
	#superclass : #ASN1AdaptiveTypeObject,
	#category : #'ROS-Core'
}

{ #category : #'initailize-release' }
ROS class >> asn1TypeName [
	^ 'ROS'
]

{ #category : #'initailize-release' }
ROS class >> typedCollection [
	^ ASN1TypedCollectionType type: self
]

{ #category : #accessing }
ROS >> message [
	^ map values first
]
