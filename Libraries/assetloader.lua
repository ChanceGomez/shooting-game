--[[
	programmer: Chance Gomez | chance.f.gomez@gmail.com
	file: 		assetloader.lua
	purpose:	load assets from given path string when loaded and load all png/jpg/jpeg files 
				using assetloader:getImage('name of file') it will return the image data.
]]

local assetloader = {
	images = {},
	imageData = {},
  	audios = {},
}

--Retrieves image based off a name
function assetloader:getImage(name,isAnimationCall)
	local isAnimationCall = isAnimationCall or false
	--try catch
	if self.images[name] then	
		return self.images[name]
	elseif not isAnimationCall then
		print(name.. " not found settings default")
		if self.images['default'] then
			return self.images['default']
		else
			print("No Default Image loaded")
		end	
	end
end

--Retrieves imagedata based off a name
function assetloader:getImageData(name,isAnimationCall)
	local isAnimationCall = isAnimationCall or false
	--try catch
	if self.imageData[name] then	
		return self.imageData[name]
	elseif not isAnimationCall then
		print(name.. " not found settings default")
		if self.imageData['default'] then
			return self.imageData['default']
		else
			print("No Default Image loaded")
		end	
	end
end


--Retrieves audio based off a name
function assetloader:getAudio(name)
	--try catch
	if self.audios[name] then	
		return self.audios[name]:clone()
	else
		print(name.. " not found settings default")
		if self.images['default'] then
			return self.audios['default']
		else
			print("No Default Image loaded")
		end	
	end
end

--loads images from a directory
function assetloader:loadImages(filepath)
	local assetTable = love.filesystem.getDirectoryItems(filepath)
	
  print("========================================================")
  print("Loading Image Assets")
  print("========================================================")

  
	for i, asset in ipairs(assetTable) do
		--create full path to asset
		local assetsPath = filepath .. '/' .. asset
		
		local validityCheck = love.filesystem.getInfo(assetsPath)
		
		
		if validityCheck then	
			--make sure its a file and not a directory
			if validityCheck.type == 'file' then
				--get the name and extension of file	
				local name, extension = asset:match("([^.]+)(%.?.*)")
				
				if extension == '.png' or extension == '.jpg' or extension == '.jpeg' then
					local basename = string.lower(name)
					if not self.images[basename] then
						self.images[basename] = {}
						self.imageData[basename] = {}
					end
					print(i .. ': ' .. basename .. ' | loaded')
					self.images[basename] = love.graphics.newImage(assetsPath)
					self.imageData[basename] = love.image.newImageData(assetsPath)
				end
			end
		end
	end
  
    print("========================================================")

end

function assetloader:getAnimation(name)
  local tbl = {}
  local switch = true
  local i = 1
  
  while switch do
    local key = name .. i
    local image = self:getImage(key,true)
    i = i + 1
    
    if self.images[key] then
      table.insert(tbl,image)
    else
      switch = false
      break
    end
  end
  
  if #tbl == 0 then
	print("animation does not exist: ", name)
  end
  return tbl
end

function assetloader:loadAudios(filepath)
  local assetTable = love.filesystem.getDirectoryItems(filepath)
	
  print("========================================================")
  print("Loading Audio Assets")
  print("========================================================")

  
	for i, asset in ipairs(assetTable) do
		--create full path to asset
		local assetsPath = filepath .. '/' .. asset
		
		local validityCheck = love.filesystem.getInfo(assetsPath)
		
		if validityCheck then	
			--make sure its a file and not a directory
			if validityCheck.type == 'file' then
				--get the name and extension of file	
				local type, name, extension = asset:match("^([^%_]+)_([%a%d]+)(%.?.*)")
				if extension == '.wav' then
					local basename = string.lower(name)
					if not self.audios[basename] then
						self.audios[basename] = {}
					end
					print(type .. ' audio ' .. i .. ': ' .. basename .. ' | loaded')
					self.audios[basename] = love.audio.newSource(assetsPath,type)
					
				end
			end
		end
	end
  
  print("========================================================")

end
 
return assetloader