--conf.lua

function love.conf(t)

	t.console = true
	t.window.fullscreen = true
	t.window.width = 1920
	t.window.title = "Don't Let them out"
	t.window.height = 1080
 	t.window.borderless = true
	t.window.display = 1
	
	t.window.vsync = 0  -- 0 = off, 1 = on
end