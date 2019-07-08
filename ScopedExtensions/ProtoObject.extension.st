Extension { #name : #ProtoObject }

{ #category : #'*ScopedExtensions' }
ProtoObject >> retry: aMessage [
	^  aMessage selector retryFor: self withMessage: aMessage
]
