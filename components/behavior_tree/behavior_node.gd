@abstract
extends Node
class_name BehaviorNode

enum Result {SUCCESS, FAILURE, WAIT}

@abstract func step() -> Result
