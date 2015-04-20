Class {
	#name : #TCAPComponent,
	#superclass : #ROS,
	#category : #'TCAP-Core-Model'
}

{ #category : #'instance creation' }
TCAPComponent class >> asn1TypeName [
	^ 'Component'
]

{ #category : #testing }
TCAPComponent class >> isAsn1ModelClass [
	^ true
]
