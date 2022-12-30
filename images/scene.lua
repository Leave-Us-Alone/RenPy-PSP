function ren.func.scene(str, level)
    if ren.ground then
        ren.ground_new = nil
        ren.ground = nil
        ren.hover = nil
        ren.gui.cursor = nil
    end
    msg_clear()
    ren.pause = true
    
    local name = ren.get.name(str)
    
    ren.history.current.image = ren.get.name(str)
    
    if not ren.settings.image[name] then error2({reader.fName..'->'..reader.pos, 'No variable: '..name}) end
    
    local with = ren.get.with(str) or getNextWith() or "none"
    if with and with[1] then
        with = with[1]
        ren.block_show = true
    else
        ren.next = false
    end
    
    ren.settings.scene.images_new = ren.settings.image[name]
    IMAGE_LOAD(ren.settings.image[name])
    IMAGE_ALPHA(ren.settings.image[name], 0)
    
    local final = function()
        for _, image in ipairs(ren.settings.scene.images) do
            for __, image2 in ipairs(ren.settings.scene.images_new) do
                if image.path ~= image2.path and ren.path[image.path] then
                    ren.path[image.path] = nil
                end
            end
        end
        
        IMAGE_RESET(ren.settings.show.images)
        IMAGE_ALPHA(ren.settings.show.images_new, 255)
        ren.settings.show.images = ren.settings.show.images_new
        ren.settings.show.images_new = {}
        
        IMAGE_RESET(ren.settings.scene.images)
        IMAGE_ALPHA(ren.settings.scene.images_new, 255)
        ren.settings.scene.images = ren.settings.scene.images_new
        ren.settings.scene.images_new = {}
        
        ren.block_show = false
        ren.pause = false
        ren.next = true
        ren.gui.flash = nil
    end
    
    --фикс на случай если текущие картинки это новые
    IMAGE_ALPHA(ren.settings.scene.images, 255)
    IMAGE_ALPHA(ren.settings.show.images, 255)
    
    if not ren.effect[with] then with = "none" end
    ren.effect[with]('scene', name, final)
end