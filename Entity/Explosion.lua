local Explosion = {
    debug=false,
    listExplosion = {},
    spriteSheet = love.graphics.newImage("Assets/Tiled/sprite/Explosion/explo.png"), -- Remplacez "chemin_vers_votre_image.png" par le chemin de votre image
    frames = {}, -- Stocke les quads pour chaque frame
    frameDuration = 0.2, -- Durée de chaque frame en secondes
}

function Explosion:new(x, y, text, delay)
    local e = {
        x = x,
        y = y,
        currentFrame = 1,
        timer = 0,
        isDestroyed = false,
    }

    table.insert(self.listExplosion, e)
    return e

end

function Explosion:init()
    -- Découpez votre image en quads de 16x16 pixels
    local frameWidth = 16
    local frameHeight = 16
    local columns = 4

    for i = 0, columns - 1 do
        local frame = love.graphics.newQuad(i * frameWidth, 0, frameWidth, frameHeight, self.spriteSheet:getDimensions())
        table.insert(self.frames, frame)
    end
end

function Explosion:update(dt)
    local numExplosions = #self.listExplosion
    for i = numExplosions, 1, -1 do
        local e = self.listExplosion[i]

        if not e.isDestroyed then
            e.timer = e.timer + dt

            if e.timer >= self.frameDuration then
                e.timer = e.timer - self.frameDuration
                e.currentFrame = e.currentFrame + 1

                if e.currentFrame > #self.frames then
                    e.isDestroyed = true
                end
            end
        else
            table.remove(self.listExplosion, i)
        end
    end
end

function Explosion:draw()
    for _, e in ipairs(self.listExplosion) do
        if not e.isDestroyed then
            love.graphics.draw(self.spriteSheet, self.frames[e.currentFrame], e.x, e.y)
        end
    end
end


function Explosion:updateAll(dt)
    for i=#self.listePopScore, 1, -1 do
        p = self.listePopScore[i]
        if p.destroy then
            table.remove(Explosion.listePopScore, i)
        else
            p:update(dt)
        end
    end
end

function Explosion:drawAll(dt)
    for i=#self.listePopScore, 1, -1 do
        p = self.listePopScore[i]
        p:draw()
    end
end

return Explosion