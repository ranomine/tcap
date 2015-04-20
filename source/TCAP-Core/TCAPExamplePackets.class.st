Class {
	#name : #TCAPExamplePackets,
	#superclass : #Object,
	#category : #'TCAP-Core-Tests'
}

{ #category : #'as yet unclassified' }
TCAPExamplePackets class >> dialogueEndDtidBFBDBEEF [
	^ #[9 0 3 14 27 11 18 7 0 18 4 83 52 88 137 153 105 13 18 6 0 17 4 83 132 9 0 0 64 103 4 175 100 129 172 73 4 191 189 190 239 107 42 40 40 6 7 0 17 134 5 1 1 1 160 29 97 27 128 2 7 128 161 9 6 7 4 0 0 1 0 14 2 162 3 2 1 0 163 5 161 3 2 1 0 108 120 162 118 2 1 195 48 113 2 1 56 48 108 48 34 4 16 160 73 188 70 14 216 187 93 83 178 79 106 118 102 72 58 4 4 83 82 187 127 4 8 31 56 185 44 127 220 120 0 48 34 4 16 135 65 184 20 110 140 104 124 205 67 128 46 121 54 105 39 4 4 174 21 132 87 4 8 188 236 133 77 213 93 216 0 48 34 4 16 203 204 139 53 17 27 51 24 146 47 93 49 34 42 117 97 4 4 113 243 204 150 4 8 60 188 168 165 24 37 160 0].
]

{ #category : #'as yet unclassified' }
TCAPExamplePackets class >> exampleSessionTcapAbortPacket [
	^ #[103 9 73 4 81 1 0 67 74 1 1] 
]

{ #category : #'as yet unclassified' }
TCAPExamplePackets class >> exampleSessionTcapEndPacket [
	^  #[100 6 73 4 81 1 3 18]
]

{ #category : #'as yet unclassified' }
TCAPExamplePackets class >> exampleTcapAbortPacket [
	^ #[103 128 73 4 81 1 0 67 74 1 1 0 0]
]

{ #category : #'as yet unclassified' }
TCAPExamplePackets class >> exampleTcapBeginPacket [
	^ #[98 55 72 4 4 37 27 125 107 47 40 45 6 7 0 17 134 5 1 1 1 160 34 96 32 128 2 7 128 161 9 6 7 4 0 0 1 0 25 2 190 15 40 13 6 7 4 0 0 1 1 1 1 160 2 160 0]
]

{ #category : #'as yet unclassified' }
TCAPExamplePackets class >> exampleTcapContinuePacket [
	^ #[101 56 72 4 81 1 3 18 73 4 4 37 27 125 107 42 40 40 6 7 0 17 134 5 1 1 1 160 29 97 27 128 2 7 128 161 9 6 7 4 0 0 1 0 25 2 162 3 2 1 0 163 5 161 3 2 1 0]
]

{ #category : #'as yet unclassified' }
TCAPExamplePackets class >> exampleTcapEndPacket [
	^ #[100 6 73 4 5 165 20 133]
]

{ #category : #'as yet unclassified' }
TCAPExamplePackets class >> insertSubscriberData [
	^ #[101 129 148 72 4 180 0 1 219 73 4 81 1 2 182 108 129 133 161 129 130 2 1 68 2 1 7 48 128 167 128 160 128 4 1 43 48 128 48 6 130 1 24 132 1 4 0 0 0 0 161 37 4 1 146 48 32 48 6 131 1 16 132 1 5 48 6 131 1 32 132 1 4 48 6 130 1 16 132 1 5 48 6 130 1 24 132 1 5 163 6 4 1 66 132 1 5 163 9 4 1 17 132 1 5 129 1 1 163 11 4 1 65 132 1 5 48 3 131 1 16 163 11 4 1 65 132 1 5 48 3 130 1 16 163 11 4 1 65 132 1 5 48 3 130 1 24 0 0 0 0]
]

{ #category : #'as yet unclassified' }
TCAPExamplePackets class >> insertSubscriberDataWithBitString [
	^#[101 129 206 72 4 81 1 3 189 73 4 0 0 0 3 107 42 40 40 6 7 0 17 134 5 1 1 1 160 29 97 27 128 2 7 128 161 9 6 7 4 0 0 1 0 1 3 162 3 2 1 0 163 5 161 3 2 1 0 108 129 147 161 129 144 2 1 65 2 1 7 48 129 135 129 7 145 83 52 88 0 16 145 130 1 10 131 1 1 164 66 4 1 17 4 1 18 4 1 19 4 1 48 4 1 64 4 1 33 4 1 34 4 1 35 4 1 36 4 1 37 4 1 38 4 1 39 4 1 28 4 1 29 4 1 30 4 1 31 4 1 56 4 1 72 4 1 44 4 1 45 4 1 46 4 1 47 166 12 4 1 17 4 1 18 4 1 33 4 1 34 167 29 160 16 4 1 33 48 11 48 9 132 1 6 133 1 238 134 1 12 163 9 4 1 17 132 1 4 129 1 1 168 5 3 3 1 0 0]
]

{ #category : #'as yet unclassified' }
TCAPExamplePackets class >> purgeMS [
	^ #[98 68 72 4 81 1 3 78 107 30 40 28 6 7 0 17 134 5 1 1 1 160 17 96 15 128 2 7 128 161 9 6 7 4 0 0 1 0 27 3 108 28 161 26 2 1 64 2 1 67 163 18 4 8 34 130 24 72 114 128 134 249 128 6 145 83 132 9 0 23]
]

{ #category : #'as yet unclassified' }
TCAPExamplePackets class >> purgeMSResult [
	^ #[100 68 73 4 81 1 3 78 107 42 40 40 6 7 0 17 134 5 1 1 1 160 29 97 27 128 2 7 128 161 9 6 7 4 0 0 1 0 27 3 162 3 2 1 0 163 5 161 3 2 1 0 108 128 162 12 2 1 64 48 7 2 1 67 48 2 128 0 0 0]
]

{ #category : #'as yet unclassified' }
TCAPExamplePackets class >> returnResultLast [
	^ #[101 19 72 4 81 1 2 182 73 4 180 0 1 219 108 5 162 3 2 1 68]
]

{ #category : #'as yet unclassified' }
TCAPExamplePackets class >> updateLocation [
	^ #[98 76 72 4 81 1 3 211 107 30 40 28 6 7 0 17 134 5 1 1 1 160 17 96 15 128 2 7 128 161 9 6 7 4 0 0 1 0 1 2 108 36 161 34 2 1 64 2 1 2 48 26 4 8 130 16 16 34 67 17 8 249 129 6 145 83 132 9 0 7 4 6 145 83 132 9 0 23]
]

{ #category : #'as yet unclassified' }
TCAPExamplePackets class >> updateLocationResult [
	^ #[100 29 73 4 81 1 3 211 108 21 162 19 2 1 64 48 14 2 1 2 48 9 4 7 145 83 151 38 0 0 242]
]
