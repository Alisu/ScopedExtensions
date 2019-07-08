"
This is an abstract class for object that can be used as lookup key during the lookup algorithm but that are not symbols.
"
Class {
	#name : #AbstractSelector,
	#superclass : #Object,
	#category : #'ScopedExtensions-Core'
}

{ #category : #accessing }
AbstractSelector class >> keyword [
	^ self subclassResponsibility
]

{ #category : #'symbol-polymorphism' }
AbstractSelector >> = aSelector [
	^ self wrappedSymbol = aSelector
]

{ #category : #converting }
AbstractSelector >> asString [
	^ self wrappedSymbol asString
]

{ #category : #'symbol-polymorphism' }
AbstractSelector >> asSymbol [
	"Some code calls asSymbol on a method selector. This method ensure that the wrapped selector is not returned instead of the receiver"
	^ self
]

{ #category : #'symbol-polymorphism' }
AbstractSelector >> at: index [
	"To avoid not indexable errors"
	^ self wrappedSymbol at: index
]

{ #category : #'symbol-polymorphism' }
AbstractSelector >> basicAt: index [
	"To avoid not indexable errors"
	^ self wrappedSymbol basicAt: index
]

{ #category : #'symbol-polymorphism' }
AbstractSelector >> doesNotUnderstand: aMessage [
	"Polymorphic with Symbol, just resend the message to the wrapped selector"
	^ aMessage sendTo: self wrappedSymbol 
]

{ #category : #'symbol-polymorphism' }
AbstractSelector >> flushCache [
	"Needs to be implemented here because that's the receiver (a scoped selector) that's in the method lookup cache not the wrapped selector (a symbol)"
	<primitive: 119>
]

{ #category : #'symbol-polymorphism' }
AbstractSelector >> hash [
	^ self wrappedSymbol hash
]

{ #category : #testing }
AbstractSelector >> isScopedSelector [
	^ true
]

{ #category : #'symbol-polymorphism' }
AbstractSelector >> isString [
	^ true
]

{ #category : #'handling DNU' }
AbstractSelector >> notUnderstoodBy: receiver withMessage: aMessage [
	^ self subclassResponsibility
]

{ #category : #printing }
AbstractSelector >> printOn: aStream [
	self wrappedSymbol printOn: aStream
		
]

{ #category : #streaming }
AbstractSelector >> putOn:aStream [
	self wrappedSymbol putOn: aStream
]

{ #category : #'symbol-polymorphism' }
AbstractSelector >> size [
	"To avoid not indexable errors"
	^ self wrappedSymbol size
]

{ #category : #printing }
AbstractSelector >> storeOn: aStream [
	self wrappedSymbol storeOn: aStream
]

{ #category : #accessing }
AbstractSelector >> wrappedSymbol [ 
	^ self subclassResponsibility
]
