//
//  Tree.swift
//  CopyOnWriteTreeExample
//
//  Created by Nate Chandler on 10/17/15.
//  Copyright © 2015 Big Nerd Ranch. All rights reserved.
//

import Foundation

var numberCreated = 0

struct Tree<T: Comparable> {
    
    private class Node {
        var data: T
        var leftChild: Node?
        var rightChild: Node?
        
        init(data: T) {
            self.data = data
            numberCreated += 1
        }
        init(data: T, leftChild: Node?, rightChild: Node?) {
            self.data = data
            self.leftChild = leftChild
            self.rightChild = rightChild
            numberCreated += 1
        }
        
        func copy() -> Node {
            return Node(data: data,
                        leftChild: leftChild?.copy(),
                        rightChild: rightChild?.copy())
        }
    }
    
    private var root: Node?
    
    mutating func insert(_ data: T) {
//        if !isKnownUniquelyReferenced(&root) {
            root = root?.copy()
//        }
        root = insert(data, at: root)
    }
    
    private func insert(_ data: T, at node: Node?) -> Node {
        if let node = node {
            if data < node.data {
                node.leftChild = insert(data, at: node.leftChild)
            } else {
                node.rightChild = insert(data, at: node.rightChild)
            }
            return node
        } else {
            return Node(data: data)
        }
    }
    
    func traverse(_ traverser: (T) -> ()) {
        traverse(root, traverser: traverser)
    }
    
    private func traverse(_ node: Node?, traverser: (T) -> ()) {
        guard let node = node else {
            return
        }
        
        traverse(node.leftChild, traverser: traverser)
        traverser(node.data)
        traverse(node.rightChild, traverser: traverser)
    }
}

struct TreeGenerator<T: Comparable> : IteratorProtocol {
    typealias Element = T
    
    var indexingGenerator: IndexingIterator<Array<T>>
    
    init(tree: Tree<T>) {
        var array: Array<T> = []
        tree.traverse { array.append($0) }
        indexingGenerator = array.makeIterator()
    }
    
    mutating func next() -> T? {
        return indexingGenerator.next()
    }
}

extension Tree: Sequence {
    func makeIterator() -> TreeGenerator<T> {
        return TreeGenerator<T>(tree: self)
    }
}

