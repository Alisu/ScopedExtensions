"
This is a special compiler that transform the ast before normal compilation. It changes the selector of methods and message sends.
"
Class {
	#name : #ExtensionCompiler,
	#superclass : #OpalCompiler,
	#instVars : [
		'extension',
		'package'
	],
	#category : #'ScopedExtensions-Core'
}

{ #category : #'instance-creation' }
ExtensionCompiler class >> extension: anExtension [ 
	^ self new
		extension: anExtension;
		yourself
]

{ #category : #accessing }
ExtensionCompiler >> extension: anExtension [ 
	extension := anExtension
]

{ #category : #accessing }
ExtensionCompiler >> package: aRPackage [
	package := aRPackage
]

{ #category : #'public access' }
ExtensionCompiler >> parse [
	| methodNode |
	methodNode := super parse.
	methodNode compilationContext: compilationContext.
	extension ifNotNil: [ self transformMethod: methodNode ].
	methodNode nodesDo: [ :each | each isMessage ifTrue: [ self transformMessage: each ] ].
	^ methodNode
]

{ #category : #transforming }
ExtensionCompiler >> transformMessage: aMessageNode [ 
	aMessageNode selector: (package lookupScopedSelector: aMessageNode selector).
]

{ #category : #transforming }
ExtensionCompiler >> transformMethod: aMethodNode [
	aMethodNode selector: (extension ensureSelectorForMethod: aMethodNode).
]
