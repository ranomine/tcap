Class {
	#name : #HexDumpReader,
	#superclass : #Object,
	#category : #'TCAP-Core-ASN1'
}

{ #category : #'as yet unclassified' }
HexDumpReader class >> readFrom: aString [
	^ ByteArray streamContents: [ :stream |
		( Character cr split: aString )  do: [ :line |
	 		((Character space split: line) select: [ :each | 
				each size = 2 ]) do: [:value| 
					stream nextPut: ( Number readFrom: value base: 16 ) ] ] ].


]
