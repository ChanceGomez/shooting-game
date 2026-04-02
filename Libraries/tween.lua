local tween = {}



--stores all the running tweens in here
tweens = {}
rotates = {}

local function rotate_update(dt)
	for i = #rotates, 1, -1 do
		local rotate = rotates[i]
		rotate.timer = rotate.timer + dt

		if rotate.timer < rotate.t then
			local timerPercentage = rotate.timer / rotate.t
			local angleDifference = rotate.dAngle - rotate.oAngle

			-- Apply tween
			if rotate.tweenType == "linear" then 
				rotate.object.angle = rotate.oAngle + angleDifference * timerPercentage
			end
		else
			rotate.object.angle = rotate.dAngle
			table.remove(rotates, i)
		end
	end
end

--this function updates all current tweens in the 'tweens' array 
local function tween_update(dt)
	for i = #tweens, 1, -1 do
		local instance = tweens[i]

		if instance.object.held then
			instance.object.tweening = false
			table.remove(tweens, i)
		else
			instance.timer = instance.timer + dt

			if instance.timer < instance.t then
			local p = instance.timer / instance.t
			local x_between = instance.dX - instance.oX
			local y_between = instance.dY - instance.oY

			if instance.tweenType == "linear" then
				instance.object.x = instance.oX + x_between * p
				instance.object.y = instance.oY + y_between * p
			elseif instance.tweenType == "quad" then
				instance.object.x = instance.oX + x_between * p * p
				instance.object.y = instance.oY + y_between * p * p
			end
			else
				instance.object.tweening = false
				instance.object.x = instance.dX
				instance.object.y = instance.dY

				if type(instance.func) == "function" then
					instance.func(instance.object)
				end

				table.remove(tweens, i)
			end
		end
	end
end

function tween:update(dt)
	--calls update function that updates current tweens
	tween_update(dt)
	rotate_update(dt)

end

--function that other script calls to start tween of an object 
function tweenTo(object, t, tween, x, y,func) 
	local t = t or 1
	local x = x or 0
	local y = y or 0
	local func = func or function() end
  
  
  
	if object.x == x and object.y == y then
    	return
	end
  
  --error checking
	if object == nil then
		print("tween object is nil")
    return
	end
	if t > 0 then
		--print("time for tween is not valid number")
	end
	if tween ~= "linear" and tween ~= "quad" then
		error("not a valid tween")
    	return
	end

	--removes old tween and replaces with the new tween.
	for i = #tweens, 1, -1 do
		if tweens[i].object == object then
			table.remove(tweens, i)
		end
	end

	--for the original x & y
	local objectX = object.x
	local objectY = object.y
	--insert tween into the tween array
	object.tweening = true
	table.insert(tweens, 
		{
			object = object,
			tweenType = tween, -- tween types "linear", "quad"
			timer = 0, -- timer for tween
			t = t, -- how long to finish tween needs to be a positive #
			dX = x, -- destination x
			dY = y, -- destination y
			oX = objectX, -- original x 
			oY = objectY, -- original y
      func = func, -- function on finish if tween has one
	})
end

function rotate(object, t, tween, endAngle) 

	local repeating = false
	
	for i, instance in ipairs(rotates) do
		if instance.object == object then
			repeating = true
		end
	end
--error checking
	if not repeating then
		if object == nil then
			print("tween object is nil")
		end
		if t > 0 then
			--print("time for tween is not valid number")
		end
		if tween ~= "linear" then
			print("not a valid tween")
		end
		local originalAngle = object.angle
		local eAngle = object.angle + endAngle
		table.insert(rotates,
			{
				object = object,
				tweenType = tween,
				timer = 0,
				t = t,
				dAngle = eAngle,
				oAngle = originalAngle,
			})
	end
end



return tween