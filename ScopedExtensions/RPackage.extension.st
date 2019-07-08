Extension { #name : #RPackage }

{ #category : #'*ScopedExtensions' }
RPackage >> addExtension: anExtension [
	self extensionData addExtension: anExtension.
	self addClassDefinition: anExtension.
	self addClass: anExtension.
]

{ #category : #'*ScopedExtensions' }
RPackage >> extensionData [
	^ RPackageExtensions for: self
]

{ #category : #'*ScopedExtensions' }
RPackage >> extensions [
	^ self extensionData extensions
]

{ #category : #'*ScopedExtensions' }
RPackage >> import: anExtension [ 
	^ self extensionData import: anExtension
]

{ #category : #'*ScopedExtensions' }
RPackage >> imports [
	^ self extensionData imports
]

{ #category : #'*ScopedExtensions' }
RPackage >> lookupScopedSelector: aSymbol [
	^ self extensionData lookupScopedSelector: aSymbol
]

{ #category : #'*ScopedExtensions' }
RPackage >> lookupScopedSelector: aSymbol forBehavior: aClass [ 
	^ self extensionData lookupScopedSelector: aSymbol forBehavior: aClass 
]

{ #category : #'*ScopedExtensions' }
RPackage >> recompileSendersOf: selectors [
	self methods do: [ :each | 
		(each messages includesAny: selectors) ifTrue: [ 
			| newMethod | 
			newMethod := ExtensionCompiler new
				source: each sourceCode;
				package: self;
				class: each origin;
				compile.
			each origin addSelectorSilently: newMethod selector withMethod: newMethod ] ]
]

{ #category : #'*ScopedExtensions' }
RPackage >> removeExtension: anExtension [ 
	^ self extensionData removeExtension: anExtension
]
