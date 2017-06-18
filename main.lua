
local physics = require( "physics" )

local centerX = display.contentCenterX
local centerY = display.contentCenterY

--電波、充電、時間などの表示を隠す
display.setStatusBar( display.HiddenStatusBar )

--物理エンジンスタート
physics.start()

--タップ用の背景
local tapScreen = display.newRect( centerX, centerY, display.contentWidth, display.contentHeight  )

--背景の空の表示
local sky = display.newImage( "sky.jpg", centerX, centerY )

local scorePoint = 0
--クリア画面の作成
local function  clear()
    local backred = display.newRect( centerX, centerY, display.contentWidth, display.contentHeight  )
    backred:setFillColor( 0, 0, 255 )
    display.newText( "Clear", centerX, centerY, nil, 40 )
    display.newText( "SCORE:"..scorePoint, centerX, centerY+100, nil, 20 )
end
--失敗画面の作成
local function falsed()
    local backblack = display.newRect( centerX, centerY, display.contentWidth, display.contentHeight  )
    backblack:setFillColor( 0, 0, 0 )
    display.newText( "False", centerX, centerY, nil, 40 )
    display.newText( "SCORE:"..scorePoint, centerX, centerY+100, nil, 20 )
end

--木１の表示
local trees1 = {}
for i=1,10 do
    trees1[i] = display.newImage( "tree1.png" )
    trees1[i].x = (centerX + 300) * i
    trees1[i].y = display.contentHeight - 40
    trees1[i].xScale = 0.5
    trees1[i].yScale = 1
end

--木１を物理エンジンに登録
for index,tree1 in pairs( trees1 ) do
    physics.addBody( tree1, "kinematic", { denisity=0, friction=0, bounce=0, shape=fishmodel, isSensor=true } )
    tree1:setLinearVelocity( -100, 0 )
end

--木２の表示
local trees2 = {}
for i=1,10 do
    trees2[i] = display.newImage( "tree2.png" )
    trees2[i].x = (centerX + 400) * i
    trees2[i].y = display.contentHeight - 40
    trees2[i].xScale = 0.3
    trees2[i].yScale = 1
end

--木２を物理エンジンに登録
for index,tree2 in pairs( trees2 ) do
    physics.addBody( tree2, "kinematic", { denisity=0, friction=0, bounce=0, shape=fishmodel, isSensor=true } )
    tree2:setLinearVelocity( -60, 0 )
end

--木３の表示
local trees3 = {}
for i=1,10 do
    trees3[i] = display.newImage( "tree3.png" )
    trees3[i].x = (centerX + 500) * i
    trees3[i].y = display.contentHeight - 100
    trees3[i].xScale = 0.5
    trees3[i].yScale = 1
end

--木３を物理エンジンに登録
for index,tree3 in pairs( trees3 ) do
    physics.addBody( tree3, "kinematic", { denisity=0, friction=0, bounce=0, shape=fishmodel, isSensor=true } )
    tree3:setLinearVelocity( -30, 0 )
end

local collisionOnGround = true

--猫シートの作成
local catImageSheet = graphics.newImageSheet( "runningcat1.png", { width=512, height=256, numFrames=8 } )
--猫のアニメーションを表示 ８フレームを0.6秒で表示
local catAnimation = display.newSprite( catImageSheet, { name="cat", start=1, count=8, time=600 } )
catAnimation.x = display.contentWidth * 0.2    --位置を指定
catAnimation.y = 250
catAnimation.xScale = 0.2      --サイズ指定
catAnimation.yScale = 0.3
local catmodel = { -30, 40, 40, 40, 40, -20, -30, -20 }--物理エンジンに登録する用の形
physics.addBody( catAnimation, { denisity=1, friction=1, bounce=0, shape=catmodel } ) --猫を物理エンジンに登録
catAnimation:play()    --再生

local function onGround(event)
    if event.phase == "began" and collisionOnGround == false then
        collisionOnGround = true
        catAnimation:play()
    end
end

--芝の下の層
local greenGround = display.newRect( 0, 0, 2000, 40 )
greenGround:setFillColor( 0x31/255, 0x5a/255, 0x18/255 )
greenGround.x = centerX
greenGround.y = 315
physics.addBody( greenGround, "static", {} ) --芝の下の層を物理エンジンに登録
greenGround:addEventListener("collision", onGround)

-- タップイベント
local function catJump( event )
    if collisionOnGround == true then  --猫の位置が地面にある時
        collisionOnGround = false
        catAnimation:pause()
        catAnimation:applyLinearImpulse( 0, -0.4, catAnimation.x, catAnimation.y )
        catAnimation.isFixedRotation = true -- 猫が回転しないようにしている
    end
end
--タップイベントの登録
tapScreen:addEventListener( "tap", catJump )

--hpの表示
local hpPoint = 300
local hpdisplay = display.newText( "HP:"..hpPoint, 0, 0, nil, 20 )
hpdisplay.x = display.contentWidth * 0.1
hpdisplay.y = display.contentHeight * 0.1

--スコアの表示
local scoredisplay = display.newText( "SCORE:"..scorePoint, 0, 0, nil, 20 )
scoredisplay.x = display.contentWidth * 0.8
scoredisplay.y = display.contentHeight * 0.1

--ネズミの表示
local mousies = {}
for i=1,10 do
mousies[i] = display.newImage( "mouse.png" )
mousies[i].x = (centerX + 550) * i
mousies[i].y = display.contentHeight * 0.85
mousies[i].xScale = 0.15
mousies[i].yScale = 0.15
end

local function onMouse( event )
    if ( event.phase == "began") then
        display.remove(event.target)
        event.target = nil
        hpPoint = hpPoint -100
        hpdisplay.text = "HP:"..hpPoint --hpの減少の更新
        if hpPoint == 0 then
            falsed()
        end
    end
end

local mousemodel = { -15, 23, 10, 23, 10, -15, -15, -15 }--物理エンジンに登録する用の形
--ネズミを物理エンジンに登録
for index,mouse in pairs( mousies ) do
    physics.addBody( mouse, "kinematic", { denisity=0, friction=1, bounce=0, shape=mousemodel, isSensor=true } )
    mouse:setLinearVelocity( -100, 0 )
    --ネズミへの接触イベントの登録
    mouse:addEventListener( "collision", onMouse )
end

--芝の表示
local grassposi = 0
local grasses = {}
for i=1,30 do	
    grasses[i] = display.newImage( "grass.png" )
    grasses[i].x = grassposi
    grasses[i].y = display.contentHeight - 40
    grassposi = centerX * i
end

--芝を物理エンジンに登録
for index,grass in pairs( grasses ) do
    physics.addBody( grass, "kinematic", { denisity=0, friction=0, bounce=0, isSensor=true } )
    grass:setLinearVelocity( -100, 0 )
end

--コインの表示
local coins = {}
for i=1,10 do
    coins[i] = display.newImage( "coin.png" )
    coins[i].x = (centerX + 350) * i
    coins[i].y = display.contentHeight * 0.5
    coins[i].xScale = 0.15
    coins[i].yScale = 0.15
end

--接触イベント
local function onCoin( event )
    if ( event.phase == "began" ) then
        display.remove(event.target)
        event.target = nil
        scorePoint = scorePoint + 50 
        scoredisplay.text = "SCORE:"..scorePoint --特典の更新
    end
end

local coinmodel = { -10, 10, 10, 10, 10, -10, -10, -10 }--物理エンジンに登録する用の形
--コインを物理エンジンに登録
for index,coin in pairs( coins ) do
    physics.addBody( coin, "kinematic", { denisity=0, friction=0, bounce=0, shape=coinmodel, isSensor=true } )
    coin:setLinearVelocity( -70, 0 )
    --コインへの接触イベントの登録
    coin:addEventListener( "collision", onCoin )
end

--魚の表示
local fishes = {}
for i=1,10 do
    fishes[i] = display.newImage( "fish.png" )
    fishes[i].x = (centerX + 600) * i
    fishes[i].y = display.contentHeight * 0.5
    fishes[i].xScale = 0.15
    fishes[i].yScale = 0.15
end

local function onFish( event )
    if ( event.phase == "began") then
        display.remove(event.target)
        event.target = nil
        hpPoint = hpPoint + 100
        hpdisplay.text = "HP:"..hpPoint --hpの上昇の更新
    end
end

local fishmodel = { -10, 10, 10, 10, 10, -10, -10, -10 }--物理エンジンに登録する用の形
--魚を物理エンジンに登録
for index,fish in pairs( fishes ) do
    physics.addBody( fish, "kinematic", { denisity=0, friction=0, bounce=0, shape=fishmodel, isSensor=true } )
    fish:setLinearVelocity( -70, 0 )
    --魚への接触イベントの登録
    fish:addEventListener( "collision", onFish )
end


local  function resultDisplay( event )
    if scorePoint > 0 and hpPoint > 0 then --コインが50以上ならクリア
        clear()
    elseif scorePoint <= 0 then --コインが0なら失敗
        falsed()
    end
end 

local DELAYTIME = 30*1000
timer.performWithDelay( DELAYTIME, resultDisplay) --DELAYTIME後に関数実行
















