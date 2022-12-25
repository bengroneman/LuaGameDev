Object = require 'libraries/classic/classic'

function love.load()
	local object_files = {}
	recursiveEnumerate('objects', file_list)
	requireFiles(object_files)
end

function love.update(dt)
    if love.keyboard.isDown('escape') then
        love.event.push('quit')
    end
end

function love.draw(dt)
	x = 0
	y = 0
	width = 100
	height = 100

    love.graphics.setBackgroundColor(0, 0, 0, 0)
	-- First Row
	squares = { 
		love.graphics.rectangle("line", x, y, width, height),
		love.graphics.rectangle("line", x+width, y, width, height),
		love.graphics.rectangle("line", x+(2*width), y, width, height),
		-- Second Row
		love.graphics.rectangle("line", x, y+height, width, height),
		love.graphics.rectangle("line", x+width, y+height, width, height),
		love.graphics.rectangle("line", x+(2*width), y+height, width, height),
		-- Third row
		love.graphics.rectangle("line", x, y+(2*height), width, height),
		love.graphics.rectangle("line", x+width, y+(2*height), width, height),
		love.graphics.rectangle("line", x+(2*width), y+(2*height), width, height),
	}	
	end

-- Default LÖVE loop, which is the same as Variable Delta Time loop
function love.run()
	if love.math then love.math.setRandomSeed(os.time()) end
	if love.load then love.load(arg) end
	if love.timer then love.timer.step() end
 
	local dt = 0
 
	-- Main loop time.
	while true do
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end
 
		-- Update dt, as we'll be passing it to update
		if love.timer then
			love.timer.step()
			dt = love.timer.getDelta()
		end
 
		-- Call update and draw
		if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled
 
		if love.graphics and love.graphics.isActive() then
			love.graphics.clear(love.graphics.getBackgroundColor())
			love.graphics.origin()
			if love.draw then love.draw() end
			love.graphics.present()
		end
 
		if love.timer then love.timer.sleep(0.001) end
	end
end

function recursiveEnumerate(folder, file_list)
	local items = love.filesystem.getDirectoryItems(folder)
	for _, item in ipairs(items) do
		local file = folder .. '/' .. item
		if love.filesystem.isFile(file) then
			table.insert(file_list, file)
		elseif love.filesystem.isDirectory(file) then
			recursiveEnumerate(folder, file_list)
		end
	end
end

function requireFiles(files)
	for _, file in ipairs(files) do
		local file = file:sub(1, -5)
		require(file)
	end
end