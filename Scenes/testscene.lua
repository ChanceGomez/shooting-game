 local testscene = {}

 function testscene:load()

 end

 function testscene:update(dt)

 end

 function testscene:draw()
    ct:draw({
        text = "{.1,.2,.9,1}Maxed Out",
        x = 100,
        y = 100,
    })
    
    ct:draw({
        text = "{.0,.0,.9,1}Maxed Out",
        x = 100,
        y = 200,
    })
    ct:draw({
        text = "{0.9,0,.9,1}Maxed Out",
        x = 100,
        y = 300,
    })
        
 end

 return testscene