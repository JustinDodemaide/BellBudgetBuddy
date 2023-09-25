extends CanvasLayer
# Price range field, get order button, order output screen, view menu button

var state_machine = null

func enter(_msg := {}) -> void:
	pass

func exit() -> void:
	reset_fields()

func reset_fields():
	$VBoxContainer/HBoxContainer/Budget.text = ""
	$VBoxContainer/Panel/Order.text = ""
	$VBoxContainer/Generate.disabled = true
	
func _on_budget_text_changed(new_text):
	if new_text == "":
		$VBoxContainer/Generate.disabled = true
		return
	$VBoxContainer/Generate.disabled = false

func _on_generate_pressed():
	if $VBoxContainer/HBoxContainer/Budget.text == "":
		# give warning message
		return
	var budget = float($VBoxContainer/HBoxContainer/Budget.text)
	if budget <= 0.0:
		# give warning
		return
	reset_fields()
	var order:Array[Item]
	if $VBoxContainer/Variety.button_pressed:
		order = knapsack(budget)
	else:
		order = unbounded_knapsack(budget)
	var total_price:float = 0.0
	var total_calories:int = 0
	for item in order:
		total_price += item.price
		total_calories += item.calories
		$VBoxContainer/Panel/Order.text += item.item_name + ", "
	$VBoxContainer/Panel/Order.text += "$" + str(total_price) + ", " + str(total_calories) + " calories."

#func decimal_to_base_n(number, base:int)->Array[int]:
#	#assert(base < 2 or base > 36, "invalid base")
#	#assert(number == 0, "invalid number")
#	var new_number:Array[int] = [0]
#
#	for i in number:
#		var position = 0
#		while new_number[position] + 1 >= base:
#			new_number[position] = 0
#			position += 1
#			if position == new_number.size():
#				new_number.append(0)
#		new_number[position] += 1
#
#		#print(new_number)
#	if new_number.back() == 0:
#		new_number.pop_back()
#	new_number.reverse()
#	print(new_number)
#	return new_number

# This does not work but I'm leaving it here as a reminder
var score_margin:int = 1
func all_combinations(budget:int):
	var items = Global.items
	var num_items = items.size()
	var num_combinations = pow(2,num_items)
	
	print(num_combinations)
	
	var best_combinations = []
	var best_score:int = 0
	
	# Traverse through every possible combination of item indices
	var combination = [0]
	for current_combination_number in range(num_combinations):
		# Each combination is a string of ints (with each int being the index of the item in Global.items)
		
		# Make a new combination
		var position = 0
		while combination[position] + 1 >= num_items:
			combination[position] = 0
			position += 1
			if position == combination.size():
				combination.append(0)
		combination[position] += 1
		
		print(combination)
		
		var total_price:float = 0.0 # The combined price of all the items in the current combination
		var total_score:int = 0
		for i in combination:
			total_price += items[i].price
			total_score += items[i].score
			
		#print("ts", total_score)

		# Check if the combination exceeds the budget
		var item_index = combination[position]
		if total_price > budget:
			continue
		
		# If its not over budget, compare the score
		if total_score > best_score + score_margin:
			# If the score for this combination is better than all the others, remove the other combinations and make this the best score
			best_score = total_score
			#print("bs", best_score)
			best_combinations.clear()
			best_combinations.append(combination)
			#print("a", combination)
			continue
		if total_score >= best_score - score_margin:
			# If the score for this combination is good enough, add it to the list of good combinations
			best_combinations.append(combination)
			#print("a", combination)
		pass
		# If the combination doesn't meet one of these possibilities, its not good enough to include, so continue to the next one
	# Best combinations has combinations of items that have the best score within the budget
	return best_combinations

func knapsack(budget:float)->Array[Item]:
	var items = Global.items
	var n: int = items.size()  # Number of items
	var weight:int = int(budget)
	var matrix: Array = []

	# Initialize a 2D array to store maximum values
	for i in range(n + 1):
		matrix.append([])
		for j in range(weight + 1):
			matrix[i].append(0)

	for i in range(1,n + 1):
		for w in range(1, weight + 1):
			var item_price:float = items[i - 1].price
			var item_score:int = items[i - 1].score
			if item_price <= w:
				# Choose the better value: the one that includes the item, or the one without it
				matrix[i][w] = max(matrix[i - 1][w], matrix[i - 1][int(w - item_price)] + item_score)
			else:
				matrix[i][w] = matrix[i - 1][w]

	var selected_items:Array[Item] = []
	var i:int = n
	var b:int = int(budget)
	while i > 0 and b > 0:
		if matrix[i][b] != matrix[i - 1][b]:
			selected_items.append(items[i - 1])
			b -= int(items[i - 1].price)
		i -= 1
	return selected_items

func _on_menu_pressed():
	state_machine.transition_to("Menu")

func unbounded_knapsack(budget)->Array[Item]:
#https://atharayil.medium.com/unbounded-knapsack-day-49-python-36d72595b957
	var n = Global.items.size()
	var wt = []
	var val = []
	var W = budget
	for i in Global.items:
		wt.append(i.price)
		val.append(i.score)
	
	var dp_table = []
	for i in range(Global.items.size() + 1):
		dp_table.append([])
		for j in range(budget + 1):
			dp_table[i].append(0)
	
	for i in range(1,dp_table.size()):
		for j in range(1, dp_table[0].size()):
			if wt[i-1] <= j:
				dp_table[i][j] = max(val[i-1]+dp_table[i][j-wt[i-1]],dp_table[i-1][j])
			elif wt[i-1] > j:
				dp_table[i][j] = dp_table[i-1][j]

# https://stackoverflow.com/questions/57903012/printing-items-selected-from-knapsack-unbounded-algorithm
	var x = val.size()
	var y = budget # possibly budget + 1
	var items:Array[Item] = []
	while(x > 0 && y > 0):
		if dp_table[x][y] == dp_table[x - 1][y]:
			x -= 1
		elif dp_table[x - 1][y] >= dp_table[x][y - wt[x - 1]] + val[x - 1]:
			x -= 1
		else:
			# print("including wt " + str(wt[x - 1]) + " with value " + str(val[x - 1]))
			items.append(find_item(wt[x - 1], val[x - 1]))
			y -= wt[x - 1]
	
	return items

func find_item(price:float,score:int)->Item:
	for i in Global.items:
		if (i.price != price):
			continue
		if (i.score != score):
			continue
		return i
	return null
