class_name SkillTreeNode extends Sprite2D

#func _ready() -> void:
	#for node in get_children():
		#var skill_node := node as SkillTreeNode
		#var line := Line2D.new()
		#
		#line.add_point(Vector2.ZERO)
		#line.add_point(skill_node.position)
		#
		#line.default_color = Color(1.0, 1.0, 1.0, 1.0)
		#line.width = 2.0
		##line.top_level = true
		#
		#add_child(line)
		
func _ready() -> void:
	for node in get_children():
		var skill_node := node as SkillTreeNode
		if not skill_node: 
			continue # Good practice: skips the node if it isn't a SkillTreeNode
			
		var line := Line2D.new()

		# Vector2.ZERO is (0,0), which is exactly the center of the parent
		line.add_point(Vector2.ZERO) 
		line.add_point(skill_node.position)
		line.z_index = -1

		line.default_color = Color(1.0, 1.0, 1.0, 1.0)
		line.width = 2.0

		add_child(line)
