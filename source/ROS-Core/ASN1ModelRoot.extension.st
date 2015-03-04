Extension { #name : #ASN1ModelRoot }

{ #category : #'*ros-core' }
ASN1ModelRoot >> allOperations [
	| col |
	col := Dictionary new.
	modules do: [:each|
		col addAll: each operations ].
	^ col 
]
