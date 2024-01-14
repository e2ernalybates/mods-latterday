require 'lib.moonloader'
local sampev = require 'lib.samp.events'
local imgui = require 'mimgui'
local ffi = require 'ffi'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

--[[LOCALs]]--
local LastActiveTime, LastActive = {}, {}
local style = 5
local renderWindow = imgui.new.bool(false)
local selectMenu, selectLovlya = imgui.new.int(1), imgui.new.int(1)
local str, sizeof = ffi.string, ffi.sizeof
local buffer1 = imgui.new.char[256](u8"Введите текст для пиара в /ad")
local buffer2 = imgui.new.char[256](u8"Введите текст для пиара в /rr")
local buffer3 = imgui.new.char[256](u8"Введите текст для пиара в /s")
local buffer4 = imgui.new.char[256]()

local adMSG = ''
local rrMSG = ''
local sMSG = ''
local nickMSG = 'Ваш никнейм'



local piar = {
    onADMSG = imgui.new.bool{false},
    onRRMSG = imgui.new.bool{false},
    onSMSG = imgui.new.bool{false},
	inputWindow2 = imgui.new.int(1),	
	inputWindow3 = imgui.new.int(1),	
}


function main()
    repeat wait(100) until isSampAvailable()
    sampAddChatMessage("[AUTO PR] {ffffff}- | Скрипт успешно загружен! | Воспользуйтесь командой - {3285a8}'/autopr' {ffffff}для открытия меню", 0xe046af)
	sampAddChatMessage("[AUTO PR] {ffffff}- | Данный скрипт был создан человеком {3285a8}7SG{ffffff} | Приятного использования {ff0000}-_-", 0xe046af)
    sampRegisterChatCommand('autopr', function() renderWindow[0] = not renderWindow[0] end)

    while true do wait(0)
        if piar.onADMSG[0] then
            sampSendChat("/ad ".. u8:decode(adMSG))
			piar.onADMSG[0] = false
        elseif piar.onRRMSG[0] then
            sampSendChat("/rr ".. u8:decode(rrMSG))
			wait(piar.inputWindow2[0]*60000)
        elseif piar.onSMSG[0] then
            sampSendChat("/s ".. u8:decode(sMSG))
            wait(piar.inputWindow3[0]*60000)
        end
    end
end

function sampev.onServerMessage(color, text)
	if string.find(text, "Отправил ".. nickMSG) then
		piar.onADMSG[0] = true
	end
	if text:find('Ваше объявление проверено и поставлено в очередь на публикацию') then
		sampSendChat('/up')
	end
end

local font = {}
imgui.OnInitialize(function()
    imgui.GetIO().IniFilename = nil
	local glyph_ranges = imgui.GetIO().Fonts:GetGlyphRangesCyrillic()
	local font_path = getFolderPath(0x14) .. '\\trebucbd.ttf'
	imgui.GetIO().Fonts:Clear()
	imgui.GetIO().Fonts:AddFontFromFileTTF(font_path, 14.0, nil, glyph_ranges)
	for k,v in pairs({8, 11, 15, 16, 20, 25}) do
		font[v] = imgui.GetIO().Fonts:AddFontFromFileTTF(font_path, v, nil, glyph_ranges)
	end
    checkstyle()
end)

local newFrame = imgui.OnFrame(
    function() return renderWindow[0] end,
    function(player)
        local resX, resY = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(resX / 2.5, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(430, 150))
        imgui.Begin('AutoPiar by 7sg', renderWindow, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.AlwaysAutoResize)
		imgui.SetCursorPosX(80)
		imgui.Text(u8'СУПЕР МЕГА ПУПЕР ЕБЕЙШИЙ ПИАР ОТ 7SG')
        --[/ad]--
		imgui.SetCursorPosY(30)
        if imgui.ToggleButton('/ad', piar.onADMSG) then end
		imgui.BeginGroup()
		imgui.SetCursorPos(imgui.ImVec2(75, 30))
		if imgui.InputText('##nomer1', buffer1, sizeof(buffer1)) then
			adMSG = str(buffer1):match('(.*)')
		end
		imgui.SameLine()
		if imgui.Button(u8'Настройка', imgui.ImVec2(100, 30)) then
			activon = not activon
			if activon == true then
				menu = 2
			elseif activon == false then
				menu = 1
			end
		end
		imgui.EndGroup()
        

        --[/rr]--
		imgui.SetCursorPosY(70)
        if imgui.ToggleButton('/rr', piar.onRRMSG) then end
		imgui.BeginGroup()
		imgui.SetCursorPos(imgui.ImVec2(75, 70))
		if imgui.InputText('##nomer2', buffer2, sizeof(buffer2)) then
			rrMSG = str(buffer2):match('(.*)')
		end
		imgui.SameLine()
		imgui.PushItemWidth(100)
		if imgui.InputInt("##5", piar.inputWindow2, 1) then end
		imgui.PopItemWidth()
		imgui.EndGroup()

        --[/s]--
		imgui.SetCursorPosY(110)
        if imgui.ToggleButton('/s', piar.onSMSG) then end
		imgui.BeginGroup()
		imgui.SetCursorPos(imgui.ImVec2(75, 110))
		if imgui.InputText('##nomer3', buffer3, sizeof(buffer3)) then
			sMSG = str(buffer3):match('(.*)')
		end
		imgui.SameLine()
		imgui.PushItemWidth(100)
		if imgui.InputInt("##6", piar.inputWindow3, 1) then end
		imgui.PopItemWidth()
		imgui.EndGroup()
		
        imgui.End()
		if menu == 2 then
			imgui.SetNextWindowPos(imgui.ImVec2(resX / 1.6, resY / 2.2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.Begin('$$AutoPiar by 7sg', renderWindow, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.AlwaysAutoResize)
			imgui.Text(u8'МЕНЮ НАСТРОЙКИ /ad')
			if imgui.InputText('##nomer4', buffer4, sizeof(buffer4)) then
				nickMSG = str(buffer4):match('(.*)')
			end
			imgui.SameLine()
			imgui.Text(u8' - Введите ваш никнейм')
			imgui.End()
		end
    end
)

function checkstyle()
    imgui.SwitchContext()
    local colors = imgui.GetStyle().Colors
    local ImVec4 = imgui.ImVec4
	local ImVec2 = imgui.ImVec2
    --==[ STYLE ]==--
    imgui.GetStyle().WindowPadding = imgui.ImVec2(5, 5)
    imgui.GetStyle().FramePadding = imgui.ImVec2(5, 5)
    imgui.GetStyle().ItemSpacing = imgui.ImVec2(5, 5)
    imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2, 2)
    imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)
    imgui.GetStyle().IndentSpacing = 0
    imgui.GetStyle().ScrollbarSize = 10
    imgui.GetStyle().GrabMinSize = 10

    --==[ BORDER ]==--
    imgui.GetStyle().WindowBorderSize = 0
    imgui.GetStyle().ChildBorderSize = 0
    imgui.GetStyle().PopupBorderSize = 0
    imgui.GetStyle().FrameBorderSize = 0
    imgui.GetStyle().TabBorderSize = 0

    --==[ ROUNDING ]==--
    imgui.GetStyle().WindowRounding = 5
    imgui.GetStyle().ChildRounding = 5
    imgui.GetStyle().FrameRounding = 5
    imgui.GetStyle().PopupRounding = 5
    imgui.GetStyle().ScrollbarRounding = 5
    imgui.GetStyle().GrabRounding = 5
    imgui.GetStyle().TabRounding = 5

    --==[ ALIGN ]==--
    imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().SelectableTextAlign = imgui.ImVec2(0.5, 0.5)
    
    --==[ COLORS ]==--
    if style == 0 then
        colors[imgui.Col.Text] 					= ImVec4(0.80, 0.80, 0.83, 1.00)
		colors[imgui.Col.TextDisabled] 			= ImVec4(0.24, 0.23, 0.29, 1.00)
		colors[imgui.Col.WindowBg] 				= ImVec4(0.06, 0.05, 0.07, 0.95)
		colors[imgui.Col.ChildBg] 				= ImVec4(0.10, 0.09, 0.12, 0.50)
		colors[imgui.Col.PopupBg] 				= ImVec4(0.07, 0.07, 0.09, 1.00)
		colors[imgui.Col.Border] 					= ImVec4(0.40, 0.40, 0.53, 0.50)
		colors[imgui.Col.Separator]				= ImVec4(0.40, 0.40, 0.53, 0.50)
		colors[imgui.Col.BorderShadow] 			= ImVec4(0.92, 0.91, 0.88, 0.00)
		colors[imgui.Col.FrameBg] 				= ImVec4(0.15, 0.14, 0.16, 0.50)
		colors[imgui.Col.FrameBgHovered] 			= ImVec4(0.24, 0.23, 0.29, 1.00)
		colors[imgui.Col.FrameBgActive] 			= ImVec4(0.56, 0.56, 0.58, 1.00)
		colors[imgui.Col.TitleBg] 				= ImVec4(0.76, 0.31, 0.00, 1.00)
		colors[imgui.Col.TitleBgCollapsed] 		= ImVec4(1.00, 0.98, 0.95, 0.75)
		colors[imgui.Col.TitleBgActive] 			= ImVec4(0.80, 0.33, 0.00, 1.00)
		colors[imgui.Col.MenuBarBg] 				= ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[imgui.Col.ScrollbarBg] 			= ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[imgui.Col.ScrollbarGrab] 			= ImVec4(0.80, 0.80, 0.83, 0.31)
		colors[imgui.Col.ScrollbarGrabHovered] 	= ImVec4(0.56, 0.56, 0.58, 1.00)
		colors[imgui.Col.ScrollbarGrabActive] 	= ImVec4(0.06, 0.05, 0.07, 1.00)
		colors[imgui.Col.CheckMark] 				= ImVec4(1.00, 0.42, 0.00, 0.53)
		colors[imgui.Col.SliderGrab] 				= ImVec4(1.00, 0.42, 0.00, 0.53)
		colors[imgui.Col.SliderGrabActive] 		= ImVec4(1.00, 0.42, 0.00, 1.00)
		colors[imgui.Col.Button] 					= ImVec4(0.15, 0.14, 0.21, 0.60)
		colors[imgui.Col.ButtonHovered] 			= ImVec4(0.24, 0.23, 0.29, 1.00)
		colors[imgui.Col.ButtonActive] 			= ImVec4(0.56, 0.56, 0.58, 1.00)
		colors[imgui.Col.Header] 					= ImVec4(0.15, 0.14, 0.21, 0.60)
		colors[imgui.Col.HeaderHovered] 			= ImVec4(0.24, 0.23, 0.29, 1.00)
		colors[imgui.Col.HeaderActive] 			= ImVec4(0.56, 0.56, 0.58, 1.00)
		colors[imgui.Col.ResizeGrip] 				= ImVec4(0.00, 0.00, 0.00, 0.00)
		colors[imgui.Col.ResizeGripHovered] 		= ImVec4(0.56, 0.56, 0.58, 1.00)
		colors[imgui.Col.ResizeGripActive] 		= ImVec4(0.06, 0.05, 0.07, 1.00)
		colors[imgui.Col.PlotLines] 				= ImVec4(0.40, 0.39, 0.38, 0.63)
		colors[imgui.Col.PlotLinesHovered]		= ImVec4(0.25, 1.00, 0.00, 1.00)
		colors[imgui.Col.PlotHistogram] 			= ImVec4(0.40, 0.39, 0.38, 0.63)
		colors[imgui.Col.PlotHistogramHovered] 	= ImVec4(0.25, 1.00, 0.00, 1.00)
		colors[imgui.Col.TextSelectedBg] 			= ImVec4(0.25, 1.00, 0.00, 0.43)
		colors[imgui.Col.ModalWindowDimBg] 		= ImVec4(0.00, 0.00, 0.00, 0.30)
    elseif style == 1 then
        colors[imgui.Col.Text]				   	= ImVec4(0.95, 0.96, 0.98, 1.00)
		colors[imgui.Col.TextDisabled] 			= ImVec4(0.65, 0.65, 0.65, 0.65)
		colors[imgui.Col.WindowBg]			   	= ImVec4(0.14, 0.14, 0.14, 1.00)
		colors[imgui.Col.ChildBg]		  			= ImVec4(0.14, 0.14, 0.14, 1.00)
		colors[imgui.Col.PopupBg]					= ImVec4(0.14, 0.14, 0.14, 1.00)
		colors[imgui.Col.Border]				 	= ImVec4(1.00, 0.28, 0.28, 0.50)
		colors[imgui.Col.Separator]			 	= ImVec4(1.00, 0.28, 0.28, 0.50)
		colors[imgui.Col.BorderShadow]		   	= ImVec4(1.00, 1.00, 1.00, 0.00)
		colors[imgui.Col.FrameBg]					= ImVec4(0.22, 0.22, 0.22, 1.00)
		colors[imgui.Col.FrameBgHovered]		 	= ImVec4(0.18, 0.18, 0.18, 1.00)
		colors[imgui.Col.FrameBgActive]		  	= ImVec4(0.09, 0.12, 0.14, 1.00)
		colors[imgui.Col.TitleBg]					= ImVec4(1.00, 0.30, 0.30, 1.00)
		colors[imgui.Col.TitleBgActive]		  	= ImVec4(1.00, 0.30, 0.30, 1.00)
		colors[imgui.Col.TitleBgCollapsed]	   	= ImVec4(1.00, 0.30, 0.30, 1.00)
		colors[imgui.Col.MenuBarBg]			  	= ImVec4(0.20, 0.20, 0.20, 1.00)
		colors[imgui.Col.ScrollbarBg]				= ImVec4(0.02, 0.02, 0.02, 0.39)
		colors[imgui.Col.ScrollbarGrab]		  	= ImVec4(0.36, 0.36, 0.36, 1.00)
		colors[imgui.Col.ScrollbarGrabHovered]   	= ImVec4(0.18, 0.22, 0.25, 1.00)
		colors[imgui.Col.ScrollbarGrabActive]		= ImVec4(0.24, 0.24, 0.24, 1.00)
		colors[imgui.Col.CheckMark]			  	= ImVec4(1.00, 0.28, 0.28, 1.00)
		colors[imgui.Col.SliderGrab]			 	= ImVec4(1.00, 0.28, 0.28, 1.00)
		colors[imgui.Col.SliderGrabActive]	   	= ImVec4(1.00, 0.28, 0.28, 1.00)
		colors[imgui.Col.Button]				 	= ImVec4(1.00, 0.30, 0.30, 1.00)
		colors[imgui.Col.ButtonHovered]		  	= ImVec4(1.00, 0.25, 0.25, 1.00)
		colors[imgui.Col.ButtonActive]		   	= ImVec4(1.00, 0.20, 0.20, 1.00)
		colors[imgui.Col.Header]				 	= ImVec4(1.00, 0.28, 0.28, 1.00)
		colors[imgui.Col.HeaderHovered]		  	= ImVec4(1.00, 0.39, 0.39, 1.00)
		colors[imgui.Col.HeaderActive]		   	= ImVec4(1.00, 0.21, 0.21, 1.00)
		colors[imgui.Col.ResizeGrip]			 	= ImVec4(1.00, 0.28, 0.28, 1.00)
		colors[imgui.Col.ResizeGripHovered]	  	= ImVec4(1.00, 0.39, 0.39, 1.00)
		colors[imgui.Col.ResizeGripActive]	   	= ImVec4(1.00, 0.19, 0.19, 1.00)
		colors[imgui.Col.PlotLines]			  	= ImVec4(0.61, 0.61, 0.61, 1.00)
		colors[imgui.Col.PlotLinesHovered]	   	= ImVec4(1.00, 0.43, 0.35, 1.00)
		colors[imgui.Col.PlotHistogram]		  	= ImVec4(1.00, 0.21, 0.21, 1.00)
		colors[imgui.Col.PlotHistogramHovered]   	= ImVec4(1.00, 0.18, 0.18, 1.00)
		colors[imgui.Col.TextSelectedBg]		 	= ImVec4(1.00, 0.25, 0.25, 1.00)
		colors[imgui.Col.ModalWindowDimBg]   		= ImVec4(0.00, 0.00, 0.00, 0.30)
    elseif style == 2 then
        colors[imgui.Col.Text]					= ImVec4(0.00, 0.00, 0.00, 0.51)
		colors[imgui.Col.TextDisabled]   			= ImVec4(0.24, 0.24, 0.24, 0.30)
		colors[imgui.Col.WindowBg]				= ImVec4(1.00, 1.00, 1.00, 1.00)
		colors[imgui.Col.ChildBg]					= ImVec4(0.96, 0.96, 0.96, 1.00)
		colors[imgui.Col.PopupBg]			  		= ImVec4(0.92, 0.92, 0.92, 1.00)
		colors[imgui.Col.Border]			   		= ImVec4(0.00, 0.49, 1.00, 0.78)
		colors[imgui.Col.BorderShadow]		 	= ImVec4(0.00, 0.00, 0.00, 0.00)
		colors[imgui.Col.FrameBg]			  		= ImVec4(0.68, 0.68, 0.68, 0.50)
		colors[imgui.Col.FrameBgHovered]	   		= ImVec4(0.82, 0.82, 0.82, 1.00)
		colors[imgui.Col.FrameBgActive]			= ImVec4(0.76, 0.76, 0.76, 1.00)
		colors[imgui.Col.TitleBg]			  		= ImVec4(0.00, 0.45, 1.00, 0.82)
		colors[imgui.Col.TitleBgCollapsed]	 	= ImVec4(0.00, 0.45, 1.00, 0.82)
		colors[imgui.Col.TitleBgActive]			= ImVec4(0.00, 0.45, 1.00, 0.82)
		colors[imgui.Col.MenuBarBg]				= ImVec4(0.00, 0.37, 0.78, 1.00)
		colors[imgui.Col.ScrollbarBg]		  		= ImVec4(0.00, 0.00, 0.00, 0.00)
		colors[imgui.Col.ScrollbarGrab]			= ImVec4(0.00, 0.35, 1.00, 0.78)
		colors[imgui.Col.ScrollbarGrabHovered] 	= ImVec4(0.00, 0.33, 1.00, 0.84)
		colors[imgui.Col.ScrollbarGrabActive]  	= ImVec4(0.00, 0.31, 1.00, 0.88)
		colors[imgui.Col.CheckMark]				= ImVec4(0.00, 0.49, 1.00, 0.59)
		colors[imgui.Col.SliderGrab]		   		= ImVec4(0.00, 0.49, 1.00, 0.59)
		colors[imgui.Col.SliderGrabActive]	 	= ImVec4(0.00, 0.39, 1.00, 0.71)
		colors[imgui.Col.Button]			   		= ImVec4(0.00, 0.49, 1.00, 0.59)
		colors[imgui.Col.ButtonHovered]			= ImVec4(0.00, 0.49, 1.00, 0.71)
		colors[imgui.Col.ButtonActive]		 	= ImVec4(0.00, 0.49, 1.00, 0.78)
		colors[imgui.Col.Header]			   		= ImVec4(0.00, 0.49, 1.00, 0.78)
		colors[imgui.Col.HeaderHovered]			= ImVec4(0.00, 0.49, 1.00, 0.71)
		colors[imgui.Col.HeaderActive]		 	= ImVec4(0.00, 0.49, 1.00, 0.78)
		colors[imgui.Col.Separator]			  	= ImVec4(0.00, 0.49, 1.00, 0.78)
		colors[imgui.Col.SeparatorHovered]	   	= ImVec4(0.00, 0.00, 0.00, 0.51)
		colors[imgui.Col.SeparatorActive]			= ImVec4(0.00, 0.00, 0.00, 0.51)
		colors[imgui.Col.ResizeGrip]		   		= ImVec4(0.00, 0.39, 1.00, 0.59)
		colors[imgui.Col.ResizeGripHovered]		= ImVec4(0.00, 0.27, 1.00, 0.59)
		colors[imgui.Col.ResizeGripActive]	 	= ImVec4(0.00, 0.25, 1.00, 0.63)
		colors[imgui.Col.PlotLines]				= ImVec4(0.00, 0.39, 1.00, 0.75)
		colors[imgui.Col.PlotLinesHovered]	 	= ImVec4(0.00, 0.39, 1.00, 0.75)
		colors[imgui.Col.PlotHistogram]			= ImVec4(0.00, 0.39, 1.00, 0.75)
		colors[imgui.Col.PlotHistogramHovered]	= ImVec4(0.00, 0.35, 0.92, 0.78)
		colors[imgui.Col.TextSelectedBg]			= ImVec4(0.00, 0.47, 1.00, 0.59)
		colors[imgui.Col.ModalWindowDimBg] 		= ImVec4(0.20, 0.20, 0.20, 0.35)
    elseif style == 3 then
        colors[imgui.Col.Text]					= ImVec4(1.00, 1.00, 1.00, 1.00)
		colors[imgui.Col.WindowBg]				= ImVec4(0.14, 0.12, 0.16, 1.00)
		colors[imgui.Col.ChildBg]		 			= ImVec4(0.30, 0.20, 0.39, 0.00)
		colors[imgui.Col.PopupBg]					= ImVec4(0.05, 0.05, 0.10, 0.90)
		colors[imgui.Col.Border]					= ImVec4(0.89, 0.85, 0.92, 0.30)
		colors[imgui.Col.Separator]				= ImVec4(0.89, 0.85, 0.92, 0.30)
		colors[imgui.Col.BorderShadow]			= ImVec4(0.00, 0.00, 0.00, 0.00)
		colors[imgui.Col.FrameBg]					= ImVec4(0.30, 0.20, 0.39, 1.00)
		colors[imgui.Col.FrameBgHovered]			= ImVec4(0.41, 0.19, 0.63, 0.68)
		colors[imgui.Col.FrameBgActive]		 	= ImVec4(0.41, 0.19, 0.63, 1.00)
		colors[imgui.Col.TitleBg]			   		= ImVec4(0.41, 0.19, 0.63, 0.45)
		colors[imgui.Col.TitleBgCollapsed]	  	= ImVec4(0.41, 0.19, 0.63, 0.35)
		colors[imgui.Col.TitleBgActive]		 	= ImVec4(0.41, 0.19, 0.63, 0.78)
		colors[imgui.Col.MenuBarBg]			 	= ImVec4(0.30, 0.20, 0.39, 0.57)
		colors[imgui.Col.ScrollbarBg]		   		= ImVec4(0.30, 0.20, 0.39, 1.00)
		colors[imgui.Col.ScrollbarGrab]		 	= ImVec4(0.41, 0.19, 0.63, 0.31)
		colors[imgui.Col.ScrollbarGrabHovered]  	= ImVec4(0.41, 0.19, 0.63, 0.78)
		colors[imgui.Col.ScrollbarGrabActive]   	= ImVec4(0.41, 0.19, 0.63, 1.00)
		colors[imgui.Col.CheckMark]			 	= ImVec4(0.56, 0.61, 1.00, 1.00)
		colors[imgui.Col.SliderGrab]				= ImVec4(0.41, 0.19, 0.63, 0.24)
		colors[imgui.Col.SliderGrabActive]	  	= ImVec4(0.41, 0.19, 0.63, 1.00)
		colors[imgui.Col.Button]					= ImVec4(0.41, 0.19, 0.63, 0.44)
		colors[imgui.Col.ButtonHovered]		 	= ImVec4(0.41, 0.19, 0.63, 0.86)
		colors[imgui.Col.ButtonActive]		  	= ImVec4(0.64, 0.33, 0.94, 1.00)
		colors[imgui.Col.Header]					= ImVec4(0.41, 0.19, 0.63, 0.76)
		colors[imgui.Col.HeaderHovered]		 	= ImVec4(0.41, 0.19, 0.63, 0.86)
		colors[imgui.Col.HeaderActive]		  	= ImVec4(0.41, 0.19, 0.63, 1.00)
		colors[imgui.Col.ResizeGrip]				= ImVec4(0.41, 0.19, 0.63, 0.20)
		colors[imgui.Col.ResizeGripHovered]	 	= ImVec4(0.41, 0.19, 0.63, 0.78)
		colors[imgui.Col.ResizeGripActive]	  	= ImVec4(0.41, 0.19, 0.63, 1.00)
		colors[imgui.Col.PlotLines]			 	= ImVec4(0.89, 0.85, 0.92, 0.63)
		colors[imgui.Col.PlotLinesHovered]	  	= ImVec4(0.41, 0.19, 0.63, 1.00)
		colors[imgui.Col.PlotHistogram]		 	= ImVec4(0.89, 0.85, 0.92, 0.63)
		colors[imgui.Col.PlotHistogramHovered]  	= ImVec4(0.41, 0.19, 0.63, 1.00)
		colors[imgui.Col.TextSelectedBg]			= ImVec4(0.41, 0.19, 0.63, 0.43)
		colors[imgui.Col.ModalWindowDimBg]  		= ImVec4(0.20, 0.20, 0.20, 0.35)
    elseif style == 4 then
        colors[imgui.Col.Text]				   	= ImVec4(0.90, 0.90, 0.90, 1.00)
		colors[imgui.Col.TextDisabled]		   	= ImVec4(0.60, 0.60, 0.60, 1.00)
		colors[imgui.Col.WindowBg]			   	= ImVec4(0.08, 0.08, 0.08, 1.00)
		colors[imgui.Col.ChildBg]		  			= ImVec4(0.10, 0.10, 0.10, 1.00)
		colors[imgui.Col.PopupBg]					= ImVec4(0.08, 0.08, 0.08, 1.00)
		colors[imgui.Col.Border]				 	= ImVec4(0.70, 0.70, 0.70, 0.40)
		colors[imgui.Col.Separator]			 	= ImVec4(0.70, 0.70, 0.70, 0.40)
		colors[imgui.Col.BorderShadow]		   	= ImVec4(0.00, 0.00, 0.00, 0.00)
		colors[imgui.Col.FrameBg]					= ImVec4(0.15, 0.15, 0.15, 1.00)
		colors[imgui.Col.FrameBgHovered]		 	= ImVec4(0.19, 0.19, 0.19, 0.71)
		colors[imgui.Col.FrameBgActive]		  	= ImVec4(0.34, 0.34, 0.34, 0.79)
		colors[imgui.Col.TitleBg]					= ImVec4(0.00, 0.69, 0.33, 0.80)
		colors[imgui.Col.TitleBgActive]		  	= ImVec4(0.00, 0.74, 0.36, 1.00)
		colors[imgui.Col.TitleBgCollapsed]	   	= ImVec4(0.00, 0.69, 0.33, 0.50)
		colors[imgui.Col.MenuBarBg]			  	= ImVec4(0.00, 0.80, 0.38, 1.00)
		colors[imgui.Col.ScrollbarBg]				= ImVec4(0.16, 0.16, 0.16, 1.00)
		colors[imgui.Col.ScrollbarGrab]		  	= ImVec4(0.00, 0.69, 0.33, 1.00)
		colors[imgui.Col.ScrollbarGrabHovered]   	= ImVec4(0.00, 0.82, 0.39, 1.00)
		colors[imgui.Col.ScrollbarGrabActive]		= ImVec4(0.00, 1.00, 0.48, 1.00)
		colors[imgui.Col.CheckMark]			  	= ImVec4(0.00, 0.69, 0.33, 1.00)
		colors[imgui.Col.SliderGrab]			 	= ImVec4(0.00, 0.69, 0.33, 1.00)
		colors[imgui.Col.SliderGrabActive]	   	= ImVec4(0.00, 0.77, 0.37, 1.00)
		colors[imgui.Col.Button]				 	= ImVec4(0.00, 0.69, 0.33, 1.00)
		colors[imgui.Col.ButtonHovered]		  	= ImVec4(0.00, 0.82, 0.39, 1.00)
		colors[imgui.Col.ButtonActive]		   	= ImVec4(0.00, 0.87, 0.42, 1.00)
		colors[imgui.Col.Header]				 	= ImVec4(0.00, 0.69, 0.33, 1.00)
		colors[imgui.Col.HeaderHovered]		  	= ImVec4(0.00, 0.76, 0.37, 0.57)
		colors[imgui.Col.HeaderActive]		   	= ImVec4(0.00, 0.88, 0.42, 0.89)
		colors[imgui.Col.SeparatorHovered]	   	= ImVec4(1.00, 1.00, 1.00, 0.60)
		colors[imgui.Col.SeparatorActive]			= ImVec4(1.00, 1.00, 1.00, 0.80)
		colors[imgui.Col.ResizeGrip]			 	= ImVec4(0.00, 0.69, 0.33, 1.00)
		colors[imgui.Col.ResizeGripHovered]	  	= ImVec4(0.00, 0.76, 0.37, 1.00)
		colors[imgui.Col.ResizeGripActive]	   	= ImVec4(0.00, 0.86, 0.41, 1.00)
		colors[imgui.Col.PlotLines]			  	= ImVec4(0.00, 0.69, 0.33, 1.00)
		colors[imgui.Col.PlotLinesHovered]	   	= ImVec4(0.00, 0.74, 0.36, 1.00)
		colors[imgui.Col.PlotHistogram]		  	= ImVec4(0.00, 0.69, 0.33, 1.00)
		colors[imgui.Col.PlotHistogramHovered]   	= ImVec4(0.00, 0.80, 0.38, 1.00)
		colors[imgui.Col.TextSelectedBg]		 	= ImVec4(0.00, 0.69, 0.33, 0.72)
		colors[imgui.Col.ModalWindowDimBg]   		= ImVec4(0.17, 0.17, 0.17, 0.48)
    elseif style == 5 then
        colors[imgui.Col.Text]                   = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
        colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
        colors[imgui.Col.WindowBg]               = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
        colors[imgui.Col.ChildBg]                = imgui.ImVec4(0.14, 0.14, 0.14, 0.75)
        colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
        colors[imgui.Col.Border]                 = imgui.ImVec4(0.25, 0.25, 0.26, 0.54)
        colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
        colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.21, 0.21, 0.21, 1.00)
        colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.25, 0.25, 0.26, 1.00)
        colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.25, 0.25, 0.26, 1.00)
        colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
        colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
        colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
        colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
        colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
        colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.00, 0.00, 0.00, 1.00)
        colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
        colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0.51, 0.51, 0.51, 1.00)
        colors[imgui.Col.CheckMark]              = imgui.ImVec4(0.45, 0.45, 0.45, 1.00)
        colors[imgui.Col.SliderGrab]             = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
        colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
        colors[imgui.Col.Button]                 = imgui.ImVec4(0.28, 0.28, 0.28, 1.00)
        colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.31, 0.31, 0.31, 1.00)
        colors[imgui.Col.ButtonActive]           = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
        colors[imgui.Col.Header]                 = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
        colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
        colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.47, 0.47, 0.47, 1.00)
        colors[imgui.Col.Separator]              = imgui.ImVec4(0.28, 0.28, 0.28, 1.00)
        colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
        colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
        colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(1.00, 1.00, 1.00, 0.25)
        colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(1.00, 1.00, 1.00, 0.67)
        colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(1.00, 1.00, 1.00, 0.95)
        colors[imgui.Col.Tab]                    = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
        colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.28, 0.28, 0.28, 1.00)
        colors[imgui.Col.TabActive]              = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
        colors[imgui.Col.TabUnfocused]           = imgui.ImVec4(0.07, 0.10, 0.15, 0.97)
        colors[imgui.Col.TabUnfocusedActive]     = imgui.ImVec4(0.14, 0.26, 0.42, 1.00)
        colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.61, 0.61, 0.61, 1.00)
        colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(1.00, 0.43, 0.35, 1.00)
        colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.90, 0.70, 0.00, 1.00)
        colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(1.00, 0.60, 0.00, 1.00)
        colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(1.00, 0.00, 0.00, 0.35)
        colors[imgui.Col.DragDropTarget]         = imgui.ImVec4(1.00, 1.00, 0.00, 0.90)
        colors[imgui.Col.NavHighlight]           = imgui.ImVec4(0.26, 0.59, 0.98, 1.00)
        colors[imgui.Col.NavWindowingHighlight]  = imgui.ImVec4(1.00, 1.00, 1.00, 0.70)
        colors[imgui.Col.NavWindowingDimBg]      = imgui.ImVec4(0.80, 0.80, 0.80, 0.20)
        colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.00, 0.00, 0.00, 0.70)
    end
end

function imgui.CircleButton(str_id, bool, color4, radius, isimage)
	local rBool = false
	local p = imgui.GetCursorScreenPos()
	local isimage = isimage or false
	local radius = radius or 10
	local draw_list = imgui.GetWindowDrawList()
	if imgui.InvisibleButton(str_id, imgui.ImVec2(23, 23)) then
		rBool = true
	end
	
	if imgui.IsItemHovered() then
		imgui.SetMouseCursor(imgui.MouseCursor.Hand)
	end

	draw_list:AddCircleFilled(imgui.ImVec2(p.x + radius, p.y + radius), radius-3, imgui.ColorConvertFloat4ToU32(isimage and imgui.ImVec4(0,0,0,0) or color4))

	if bool then
		draw_list:AddCircle(imgui.ImVec2(p.x + radius, p.y + radius), radius, imgui.ColorConvertFloat4ToU32(color4),_,1.5)
	end

	imgui.SetCursorPosY(imgui.GetCursorPosY()+radius)
	return rBool
end

function imgui.ToggleButton(str_id, bool)
	local rBool = false

	local p = imgui.GetCursorScreenPos()
	local draw_list = imgui.GetWindowDrawList()
	local height = 20
	local width = height * 1.55
	local radius = height * 0.50
	local animTime = 0.13
	
	local color_active = imgui.GetStyle().Colors[imgui.Col.CheckMark]
	local color_inactive = imgui.ImVec4(100 / 255, 100 / 255, 100 / 255, 180 / 255)

	if imgui.InvisibleButton(str_id, imgui.ImVec2(width, height)) then
		bool[0] = not bool[0]
		rBool = true
		LastActiveTime[tostring(str_id)] = os.clock()
		LastActive[tostring(str_id)] = true
	end

	local hovered = imgui.IsItemHovered()

	imgui.SameLine()
	imgui.SetCursorPosY(imgui.GetCursorPosY()+3)
	imgui.Text(str_id)

	local t = bool[0] and 1.0 or 0.0

	if LastActive[tostring(str_id)] then
		local time = os.clock() - LastActiveTime[tostring(str_id)]
		if time <= animTime then
			local t_anim = ImSaturate(time / animTime)
			t = bool[0] and t_anim or 1.0 - t_anim
		else
			LastActive[tostring(str_id)] = false
		end
	end

	local col_bg = bringVec4To(not bool[0] and color_active or color_inactive, bool[0] and color_active or color_inactive, LastActiveTime[tostring(str_id)] or 0, animTime)

	draw_list:AddRectFilled(imgui.ImVec2(p.x, p.y + (height / 6)), imgui.ImVec2(p.x + width - 1.0, p.y + (height - (height / 6))), imgui.ColorConvertFloat4ToU32(col_bg), 10.0)
	draw_list:AddCircleFilled(imgui.ImVec2(p.x + (bool[0] and radius + 1.5 or radius - 3) + t * (width - radius * 2.0), p.y + radius), radius - 6, imgui.ColorConvertFloat4ToU32(imgui.GetStyle().Colors[imgui.Col.Text]))

	return rBool
end

function ImSaturate(f)
	return f < 0.0 and 0.0 or (f > 1.0 and 1.0 or f)
end

function bringVec4To(from, to, start_time, duration)
	local timer = os.clock() - start_time
	if timer >= 0.00 and timer <= duration then
		local count = timer / (duration / 100)
		return imgui.ImVec4(
			from.x + (count * (to.x - from.x) / 100),
			from.y + (count * (to.y - from.y) / 100),
			from.z + (count * (to.z - from.z) / 100),
			from.w + (count * (to.w - from.w) / 100)
		), true
	end
	return (timer > duration) and to or from, false
end

