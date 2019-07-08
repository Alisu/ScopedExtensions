Class {
	#name : #OverrideExtension,
	#superclass : #CreateConflictingExtensionMethod,
	#category : #'ScopedExtensions-Tests'
}

{ #category : #'as yet unclassified' }
OverrideExtension >> setUp [
	super setUp.
	(self packageNamed: #ExtendingPackageForTests2) import: extension1.
]

{ #category : #tests }
OverrideExtension >> testObjectSendToConflictingMethodDispatchesToConflictingMethod [
	self assert: (importingClass1 new objectSend: extendedClass2 new) equals: #conflictingExtensionMethod
]

{ #category : #tests }
OverrideExtension >> testObjectSendToExtensionClassDispatchesToExtensionMethod [
	self assert: (importingClass1 new objectSend: extendedClass1 new) equals: #extensionMethod1
]

{ #category : #tests }
OverrideExtension >> testObjectSendToPolymorphicClassDispatchesToPolymorphicMethod [
	self assert: (importingClass1 new objectSend: polymorphicClass1 new) equals: #polymorphicMethod
]

{ #category : #tests }
OverrideExtension >> testScopedSelectorsOfBothExtensionMethodsAreMerged [
	self skip
	"| selector |
	selector := self importingPackage1 lookupScopedSelector: #extensionMethod1.
	self assert: (selector isKindOf: ScopedSelector).
	self assertCollection: selector wrappedSelector equals: extensionMethod1 selector.
	self assert: extensionMethod1 selector == extensionMethod2 selector"
]

{ #category : #tests }
OverrideExtension >> testSelfSendDispatchesToExtensionMethod [
	self assert: importingClass1 new selfSend equals: #extensionMethod1
]
