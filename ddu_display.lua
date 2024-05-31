-- 1st local search image in path - decode. 2nd local resize image to filesize
-- 3rd local defines function / sets cursor x / y position as vec2 and line 4 sets the image per Filesize

local pageRaceImage = ui.decodeImage(io.loadFromZip(ac.findFile("tex/disptex.zip"), "pageRaceImage.png"))
local pageRaceImageSize = ui.imageSize(pageRaceImage)
local function pageRace(dt)
    ui.setCursor(vec2(0, 205))
    ui.image(pageRaceImage, pageRaceImageSize)
end

-- loacl sim gets ac phys data. local car sets the car with 0 to player car. local stat gets carstate.

local sim         = ac.getSim()
local car         = ac.getCar(0)
local state       = ac.getCarState(0)
local wheelLF     = car.wheels[0]
local wheelRF     = car.wheels[1]
local wheelLR     = car.wheels[2]
local wheelRR     = car.wheels[3]
local FONT_SIZES  = {
    gears = 50,
    laptimes = 50,
    electronics = 30,
    rims = 45
}

local currentABS  = ...
local currentTC   = ...
local currentGear = ...

--ui.dwriteTextAligned(currentABS  , FONT_SIZES.electronics, ui.Alignment.Center, ui.Alignment.Center, vec2(300,100), false, color)
--ui.dwriteTextAligned(currentTC , FONT_SIZES.electronics, ui.Alignment.Center, ui.Alignment.Center, vec2(300,100), false, color)
--ui.dwriteTextAligned(currentGear , FONT_SIZES.gears, ui.Alignment.Center, ui.Alignment.Center, vec2(300,100), false, color)



-- script update is necessary to update at all. below the display image defined above is loaded
-- geartextlookup is defining the character for each gear.

---@diagnostic disable-next-line: duplicate-set-field
function script.update(dt)
    pageRace(dt)
    local currentGear = car.gear
    local gearTextLookup = {
        [-1] = "R",
        [0] = "N",
        [1] = "1",
        [2] = "2",
        [3] = "3",
        [4] = "4",
        [5] = "5",
        [6] = "6",
    }

    -- 1st local puts name and uses lut table above for the currentGear function to display the characters.
    -- 2nd local puts the text for currentgear. 3rd local defines fontsize. 4rd local positions text.
    -- 5th local defines color in rgbm. set cursor puts position of the box created by dwriteTextAligned.
    -- dwritefont sets the font, name needs to be font name : file path and file name as in folder
    -- dwriteTextAligned text/function, fontsize, alignment x, alignment y, vec box size x y, newline true/false, color
    -- popdwritefont discard font.

    local currentGearText = gearTextLookup[currentGear]
    local geartext = currentGearText
    local gearfontSize = 200
    local gearposition = vec2(440, 460)
    local gearcolor = rgbm(1, 1, 1, 1)
    ui.setCursor(vec2(368, 426))
    ui.pushDWriteFont("Sui Generis Free:tex/sui_generis_free.ttf")
    ui.dwriteTextAligned(geartext, gearfontSize, ui.Alignment.Center, ui.Alignment.Center, vec2(300, 300), false,
        gearcolor)
    ui.popDWriteFont()

    local speed = ac.getCarSpeedKmh(0)
    local speedtext = string.format("%d", speed)
    local speedfontSize = 50
    local speedposition = vec2(440, 460)
    local speedcolor = rgbm(1, 1, 1, 1)
    ui.setCursor(vec2(115, 48))
    ui.pushDWriteFont("Sui Generis Free:tex/sui_generis_free.ttf")
    ui.dwriteTextAligned(speedtext, speedfontSize, ui.Alignment.Center, ui.Alignment.Center, vec2(800, 800), false,
        speedcolor)
    ui.popDWriteFont()

    local formatLapTime = function(millis)
        local seconds = math.floor(millis / 1000)
        local milliseconds = millis % 1000

        return string.format("%01d:%02d.%02d", math.floor(seconds / 60), seconds % 60, milliseconds / 10)
    end

    local lastlaptimetext = formatLapTime(car.previousLapTimeMs)
    local lastlaptimeposition = vec2(440, 460)
    local lastlaptimecolor = rgbm(1, 1, 1, 1)
    ui.setCursor(vec2(195, -274))
    ui.pushDWriteFont("Sui Generis Free:tex/sui_generis_free.ttf")
    ui.dwriteTextAligned(lastlaptimetext, FONT_SIZES.laptimes, ui.Alignment.End, ui.Alignment.End, vec2(800, 800), false,
        lastlaptimecolor)
    ui.popDWriteFont()

    local getDeltaLapTime = function()
        local milliseconds = ac.getCar(0).performanceMeter * 1000.0
        local total_seconds = milliseconds / 1000
        local seconds = math.floor(total_seconds)
        local millis = (milliseconds % 1000) / 10
        local sign = milliseconds == 0 and " " or (milliseconds > 0 and "+" or "-")
        local textColor = milliseconds > 0 and rgb(1, 0.2, 0.2) or rgb(0.2, 1, 0.2)
        return string.format("%s %02d.%02d", sign, seconds, millis), textColor
    end
    local deltaText, textColor  = getDeltaLapTime()
    ui.setCursor(vec2(195, 205))
    ui.pushDWriteFont("Sui Generis Free:tex/sui_generis_free.ttf")
    ui.dwriteTextAligned(deltaText, FONT_SIZES.laptimes, ui.Alignment.End, ui.Alignment.Center, vec2(800, 800), false, textColor)

    local formatLapTime = function(millis)
        local seconds = math.floor(millis / 1000)
        local milliseconds = millis % 1000

        return string.format("%01d:%02d.%02d", math.floor(seconds / 60), seconds % 60, milliseconds / 10)
    end

    local predlaptimetext = formatLapTime(car.estimatedLapTimeMs)
    local predlaptimeposition = vec2(440, 460)
    local predlaptimecolor = rgbm(1, 1, 1, 1)
    ui.setCursor(vec2(195, -62))
    ui.pushDWriteFont("Sui Generis Free:tex/sui_generis_free.ttf")
    ui.dwriteTextAligned(predlaptimetext, FONT_SIZES.laptimes, ui.Alignment.End, ui.Alignment.End, vec2(800, 800), false,
        predlaptimecolor)
    ui.popDWriteFont()

    local fuel = car.fuelPerLap
    local fpltext = string.format("%d", fuel)
    local fplposition = vec2(440, 460)
    local fplcolor = rgbm(1, 1, 1, 1)
    ui.setCursor(vec2(25, 469))
    ui.pushDWriteFont("Sui Generis Free:tex/sui_generis_free.ttf")
    ui.dwriteTextAligned(fpltext, FONT_SIZES.laptimes, ui.Alignment.Start, ui.Alignment.Start, vec2(800, 800), false,
        fplcolor)
    ui.popDWriteFont()

    local predlaptimetext = formatLapTime(car.estimatedLapTimeMs)
    local predlaptimeposition = vec2(440, 460)
    local predlaptimecolor = rgbm(1, 1, 1, 1)
    ui.setCursor(vec2(195, -62))
    ui.pushDWriteFont("Sui Generis Free:tex/sui_generis_free.ttf")
    ui.dwriteTextAligned(predlaptimetext, FONT_SIZES.laptimes, ui.Alignment.End, ui.Alignment.End, vec2(800, 800), false,
        predlaptimecolor)
    ui.popDWriteFont()

    local fuel = car.fuelPerLap
    local fpltext = string.format("%d", fuel)
    local fplposition = vec2(440, 460)
    local fplcolor = rgbm(1, 1, 1, 1)
    ui.setCursor(vec2(25, 575))
    ui.pushDWriteFont("Sui Generis Free:tex/sui_generis_free.ttf")
    ui.dwriteTextAligned(fpltext, FONT_SIZES.laptimes, ui.Alignment.Start, ui.Alignment.Start, vec2(800, 800), false,
        fplcolor)
    ui.popDWriteFont()

    local tracklength = ac.getSim().trackLengthM
    local fuelCons = car.fuelPerLap

    --local fuelavail = car.maxFuel
    --local fuelremain = car.fuel
    local fuelused = fuelCons == nil and 0 or string.format(math.floor(tracklength / 1000 * fuelCons / 100))
    local fplposition = vec2(440, 460)
    local fplcolor = rgbm(1, 1, 1, 1)
    ui.setCursor(vec2(25, 682))
    ui.pushDWriteFont("Sui Generis Free:tex/sui_generis_free.ttf")
    ui.dwriteTextAligned(fuelused, FONT_SIZES.laptimes, ui.Alignment.Start, ui.Alignment.Start, vec2(800, 800), false,
        fplcolor)
    ui.popDWriteFont()

    local wheelLFtext = string.format("%d", wheelLF.discTemperature)
    local wheelLFcolor = rgbm(1, 1, 1, 1)
    ui.setCursor(vec2(-382, 424))
    ui.pushDWriteFont("Sui Generis Free:tex/sui_generis_free.ttf")
    ui.dwriteTextAligned(wheelLFtext, FONT_SIZES.rims, ui.Alignment.Center, ui.Alignment.Center, vec2(1000, 800), false,
    wheelLFcolor)
    ui.popDWriteFont()

    local wheelRFtext = string.format("%d", wheelRF.discTemperature)
    local wheelRFcolor = rgbm(1, 1, 1, 1)
    ui.setCursor(vec2(-242, 424))
    ui.pushDWriteFont("Sui Generis Free:tex/sui_generis_free.ttf")
    ui.dwriteTextAligned(wheelRFtext, FONT_SIZES.rims, ui.Alignment.Center, ui.Alignment.Center, vec2(1000, 800), false,
    wheelRFcolor)
    ui.popDWriteFont()

    local wheelLRtext = string.format("%d", wheelLR.discTemperature)
    local wheelLRcolor = rgbm(1, 1, 1, 1)
    ui.setCursor(vec2(-382, 482))
    ui.pushDWriteFont("Sui Generis Free:tex/sui_generis_free.ttf")
    ui.dwriteTextAligned(wheelLRtext, FONT_SIZES.rims, ui.Alignment.Center, ui.Alignment.Center, vec2(1000, 800), false,
    wheelLRcolor)
    ui.popDWriteFont()

    local wheelRRtext = string.format("%d", wheelRR.discTemperature)
    local wheelRRcolor = rgbm(1, 1, 1, 1)
    ui.setCursor(vec2(-242, 482))
    ui.pushDWriteFont("Sui Generis Free:tex/sui_generis_free.ttf")
    ui.dwriteTextAligned(wheelRRtext, FONT_SIZES.rims, ui.Alignment.Center, ui.Alignment.Center, vec2(1000, 800), false,
    wheelRRcolor)
    ui.popDWriteFont()

    local presLFtext = string.format("%.1f", wheelLF.tyrePressure)
    local presLFcolor = rgbm(1, 1, 1, 1)
    ui.setCursor(vec2(-62, 424))
    ui.pushDWriteFont("Sui Generis Free:tex/sui_generis_free.ttf")
    ui.dwriteTextAligned(presLFtext, FONT_SIZES.rims, ui.Alignment.Center, ui.Alignment.Center, vec2(1000, 800), false,
    presLFcolor)
    ui.popDWriteFont()

    local presRFtext = string.format("%.1f", wheelRF.tyrePressure)
    local presRFcolor = rgbm(1, 1, 1, 1)
    ui.setCursor(vec2(85, 424))
    ui.pushDWriteFont("Sui Generis Free:tex/sui_generis_free.ttf")
    ui.dwriteTextAligned(presRFtext, FONT_SIZES.rims, ui.Alignment.Center, ui.Alignment.Center, vec2(1000, 800), false,
    presRFcolor)
    ui.popDWriteFont()

    local presLRtext = string.format("%.1f", wheelLR.tyrePressure)
    local presLRcolor = rgbm(1, 1, 1, 1)
    ui.setCursor(vec2(-62, 482))
    ui.pushDWriteFont("Sui Generis Free:tex/sui_generis_free.ttf")
    ui.dwriteTextAligned(presLRtext, FONT_SIZES.rims, ui.Alignment.Center, ui.Alignment.Center, vec2(1000, 800), false,
    presLRcolor)
    ui.popDWriteFont()

    local presRRtext = string.format("%.1f", wheelRR.tyrePressure)
    local presRRcolor = rgbm(1, 1, 1, 1)
    ui.setCursor(vec2(85, 482))
    ui.pushDWriteFont("Sui Generis Free:tex/sui_generis_free.ttf")
    ui.dwriteTextAligned(presRRtext, FONT_SIZES.rims, ui.Alignment.Center, ui.Alignment.Center, vec2(1000, 800), false,
    presRRcolor)
    ui.popDWriteFont()

    local tempLFtext = string.format("%d", wheelLF.tyreCoreTemperature)
    local tempLFcolor = rgbm(1, 1, 1, 1)
    ui.setCursor(vec2(272, 424))
    ui.pushDWriteFont("Sui Generis Free:tex/sui_generis_free.ttf")
    ui.dwriteTextAligned(tempLFtext, FONT_SIZES.rims, ui.Alignment.Center, ui.Alignment.Center, vec2(1000, 800), false,
    tempLFcolor)
    ui.popDWriteFont()

    local tempRFtext = string.format("%d", wheelRF.tyreCoreTemperature)
    local tempRFcolor = rgbm(1, 1, 1, 1)
    ui.setCursor(vec2(409, 424))
    ui.pushDWriteFont("Sui Generis Free:tex/sui_generis_free.ttf")
    ui.dwriteTextAligned(tempRFtext, FONT_SIZES.rims, ui.Alignment.Center, ui.Alignment.Center, vec2(1000, 800), false,
    tempRFcolor)
    ui.popDWriteFont()

    local tempLRtext = string.format("%d", wheelLR.tyreCoreTemperature)
    local tempLRcolor = rgbm(1, 1, 1, 1)
    ui.setCursor(vec2(272, 482))
    ui.pushDWriteFont("Sui Generis Free:tex/sui_generis_free.ttf")
    ui.dwriteTextAligned(tempLRtext, FONT_SIZES.rims, ui.Alignment.Center, ui.Alignment.Center, vec2(1000, 800), false,
    tempLRcolor)
    ui.popDWriteFont()

    local tempRRtext = string.format("%d", wheelRR.tyreCoreTemperature)
    local RRcolor = rgbm(1, 1, 1, 1)
    ui.setCursor(vec2(409, 482))
    ui.pushDWriteFont("Sui Generis Free:tex/sui_generis_free.ttf")
    ui.dwriteTextAligned(tempRRtext, FONT_SIZES.rims, ui.Alignment.Center, ui.Alignment.Center, vec2(1000, 800), false,
    tempRRcolor)
    ui.popDWriteFont()
end
