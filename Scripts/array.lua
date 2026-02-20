local array = {}

function flatten(tbl)
	local points = {}
		for _, point in ipairs(tbl) do
			table.insert(points, point[1]) -- x-coordinate
			table.insert(points, point[2]) -- y-coordinate
		end
	return points
end

function shuffle(tbl)
  for i = #tbl, 2, -1 do
      local j = math.random(i)
      tbl[i], tbl[j] = tbl[j], tbl[i]
  end
end

function copy(original)
    if type(original) ~= "table" then
      return
    end
    local temp = {}
    for origKey, origValue in pairs(original) do
        if type(origValue) == "table" then
            -- Recursively copy nested tables
            temp[origKey] = copy(origValue)
        else
            -- Copy simple values (numbers, strings, etc.)
            temp[origKey] = origValue
        end
    end
    return temp
end

function deepCopy(orig, seen)
  if type(orig) ~= "table" then
    return orig
  end

  if seen and seen[orig] then
    return seen[orig]
  end

  local copy = {}
  seen = seen or {}
  seen[orig] = copy

  for k, v in pairs(orig) do
    copy[deepCopy(k, seen)] = deepCopy(v, seen)
  end

  return setmetatable(copy, getmetatable(orig))
end


function findextremes(tbl)
	local maxX, minX = -math.huge, math.huge
	local maxY, minY = -math.huge, math.huge
	
	for _, point in ipairs(tbl) do
		if point[1] > maxX then
			maxX = point[1]
		end
		if point[1] < minX then
			minX = point[1]
		end
		if point[2] > maxY then
			maxY = point[2]
		end
		if point[2] < minY then
			minY = point[2]
		end
	end
	
	return maxX, minX, maxY, minY
end

function normalize(tbl)

	local maxX, minX, maxY, minY = findextremes(tbl)
	local temp = {}

	for i, point in ipairs(tbl) do
		temp[i] = {}  -- Ensure table is initialized
		temp[i][1] = (point[1] - minX) / (maxX - minX)
		temp[i][2] = (point[2] - minY) / (maxY - minY)
	end
	return temp
end

function addToAll(tbl,X,Y)
	--return if tbl is nil
	if tbl == nil then print("empty table") return end
	--check x & y
	local x = X or 0
	local y = Y or 0
	--copy table
	local temp = copy(tbl)
	--add to each point
	for i, point in pairs(temp) do
		point[1] = tbl[i][1] + x
		point[2] = tbl[i][2] + y
	end
	--return
	return temp
end

function add(tbl1,tbl2)
  local temp = {}
  for i, item in pairs(tbl1) do
    if type(item) == "number" and type(tbl2[i]) == "number" then
      temp[i] = item + tbl2[i]
    end
  end
  return temp
end

function subtract(tbl1,tbl2)
  local temp = {}
  for i, item in pairs(tbl1) do
    if type(item) == "number" and type(tbl2[i]) == "number" then
      temp[i] = item - tbl2[i]
    end
  end
  return temp
end

function scale(tbl,scaleX,scaleY)
	--return if tbl is nil
	if tbl == nil then print("empty table") return end
	--check x & y
	local sX = scaleX or 1
	local sY = scaleY or 1
	--copy
	local temp = copy(tbl)
	--apply Scale
	for i, point in pairs(temp) do
		point[1] = tbl[i][1] * sX
		point[2] = tbl[i][2] * sY
	end
	--return
	return temp
end

function rotate(a, b, cos, sin, offsetX, offsetY) -- rotate(x, y, cos, sin, translation in x, translation in y)
	if offsetX == nil then
		offsetX = 0
	end
	if offsetY == nil then
		offsetY = 0
	end
	
	if type(a) == "number" and type(b) == "number" then
		local rotateX = (a * cos - b * sin)
		local rotateY = (a * sin + b * cos) 
		return rotateX + offsetX, rotateY + offsetY
	elseif type(a) == "number" and type(b) ~= "number" then
		b = 0
		local rotateX = (a * cos - b * sin)
		return rotateX + offsetX
	elseif type(a) ~= "number" and type(b) == "number" then
		a = 0
		local rotateY = (a * sin + b * cos) 
		return rotateY + offsetY
	else
		print("error in rotate x: " .. a .. " y: " .. b)
	end
end

function rotatePoints(tbl,Angle,offsetX,offsetY)
	--return if tbl is nil
	if tbl == nil then print("empty table") return end
	--check x & y
	local angle = Angle or 0
	local cos = math.cos(angle)
	local sin = math.sin(angle)
	--check offsets
	local oX = offsetX or 0
	local oY = offsetY or 0
	--copy
	local temp = copy(tbl)
	--apply rotation
	for i, point in pairs(temp) do
		point[1],point[2] = rotate(point[1]-oX,point[2]-oY,cos,sin)
	end
	--return temp
	return temp
end

function combine(tbl1,tbl2)
	local combinedTable = {}
	local size1 = 0
	local size2 = 0
	--get the size 
	for i, instance in pairs(tbl1) do
		size1 = size1 + 1
	end
	for i, instance in pairs(tbl2) do
		size2 = size2 + 1
	end
	
	for i = 1, size1 do
		table.insert(combinedTable,tbl1[i])
	end
	
	for i = 1, size2 do
		table.insert(combinedTable,tbl2[i])
	end
	
	return combinedTable
end


return array