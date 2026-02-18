local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local Players          = game:GetService("Players")
local LocalPlayer      = Players.LocalPlayer

local C = {
    bg       = Color3.fromRGB(8,   9,  12),
    surface  = Color3.fromRGB(14, 16, 24),
    panel    = Color3.fromRGB(19, 21, 31),
    border   = Color3.fromRGB(30, 32, 46),
    borderHi = Color3.fromRGB(50, 53, 72),
    accent   = Color3.fromRGB(124,106,255),
    accent2  = Color3.fromRGB(167,139,250),
    green    = Color3.fromRGB(52, 211,153),
    red      = Color3.fromRGB(248,113,113),
    text     = Color3.fromRGB(226,228,239),
    muted    = Color3.fromRGB(90, 93, 114),
    muted2   = Color3.fromRGB(58, 61, 82),
    white    = Color3.fromRGB(255,255,255),
}

local FB = Enum.Font.GothamBold
local FS = Enum.Font.GothamSemibold
local FM = Enum.Font.Code

local function tw(obj,props,t,style,dir)
    TweenService:Create(obj,TweenInfo.new(t or 0.2,style or Enum.EasingStyle.Quint,dir or Enum.EasingDirection.Out),props):Play()
end
local function sp(obj,props,t)
    TweenService:Create(obj,TweenInfo.new(t or 0.35,Enum.EasingStyle.Back,Enum.EasingDirection.Out),props):Play()
end
local function mk(class,props)
    local i=Instance.new(class)
    for k,v in pairs(props) do pcall(function() i[k]=v end) end
    return i
end
local function crn(p,r) local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r or 10); c.Parent=p end
local function str(p,col,t) local s=Instance.new("UIStroke"); s.Color=col or C.border; s.Thickness=t or 1; s.Parent=p; return s end
local function pad(p,t,b,l,r) local u=Instance.new("UIPadding"); u.PaddingTop=UDim.new(0,t or 8); u.PaddingBottom=UDim.new(0,b or 8); u.PaddingLeft=UDim.new(0,l or 10); u.PaddingRight=UDim.new(0,r or 10); u.Parent=p end
local function lst(p,gap) local l=Instance.new("UIListLayout"); l.Padding=UDim.new(0,gap or 6); l.SortOrder=Enum.SortOrder.LayoutOrder; l.Parent=p; return l end

local NotifCount=0
local function notify(title,msg,ntype,dur)
    dur=dur or 4
    local col=ntype=="green" and C.green or ntype=="red" and C.red or C.accent2
    local sg=mk("ScreenGui",{Name="AetherNotif",ResetOnSpawn=false,DisplayOrder=999,ZIndexBehavior=Enum.ZIndexBehavior.Sibling})
    pcall(function() sg.Parent=game:GetService("CoreGui") end)
    if not sg.Parent then sg.Parent=LocalPlayer:WaitForChild("PlayerGui") end
    NotifCount+=1; local slot=NotifCount; local yOff=18+(slot-1)*78
    local card=mk("Frame",{Size=UDim2.new(0,270,0,66),Position=UDim2.new(1,20,1,-(yOff+66)),BackgroundColor3=C.panel,BorderSizePixel=0,Parent=sg}); crn(card,12); str(card,C.borderHi,1)
    mk("UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(22,20,40)),ColorSequenceKeypoint.new(1,C.panel)}),Rotation=135,Parent=card})
    local dot=mk("Frame",{Size=UDim2.new(0,3,0,28),Position=UDim2.new(0,0,0.5,-14),BackgroundColor3=col,BorderSizePixel=0,Parent=card}); crn(dot,3)
    mk("TextLabel",{Size=UDim2.new(1,-22,0,18),Position=UDim2.new(0,14,0,12),BackgroundTransparency=1,Text=title,TextColor3=C.text,Font=FB,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,Parent=card})
    mk("TextLabel",{Size=UDim2.new(1,-22,0,14),Position=UDim2.new(0,14,0,33),BackgroundTransparency=1,Text=msg,TextColor3=C.muted,Font=FM,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Parent=card})
    local bar=mk("Frame",{Size=UDim2.new(1,-16,0,2),Position=UDim2.new(0,8,1,-6),BackgroundColor3=col,BorderSizePixel=0,Parent=card}); crn(bar,2)
    tw(card,{Position=UDim2.new(1,-288,1,-(yOff+66))},0.4,Enum.EasingStyle.Quint)
    tw(bar,{Size=UDim2.new(0,0,0,2)},dur,Enum.EasingStyle.Linear)
    task.delay(dur,function()
        tw(card,{Position=UDim2.new(1,20,1,-(yOff+66))},0.3,Enum.EasingStyle.Quint)
        task.wait(0.35); NotifCount=math.max(0,NotifCount-1); sg:Destroy()
    end)
end

local function CreateWindow(config)
    local W={Tabs={},ActiveTab=nil,ToggleKey=config.ToggleKey or Enum.KeyCode.RightControl}
    local sg=mk("ScreenGui",{Name="AetherUI",ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,DisplayOrder=100})
    pcall(function() sg.Parent=game:GetService("CoreGui") end)
    if not sg.Parent then sg.Parent=LocalPlayer:WaitForChild("PlayerGui") end
    W._gui=sg

    local main=mk("Frame",{Name="Main",Size=UDim2.new(0,820,0,0),Position=UDim2.new(0.5,-410,0.5,-270),BackgroundColor3=C.surface,BorderSizePixel=0,ClipsDescendants=true,Parent=sg})
    crn(main,18); str(main,C.border,1)
    mk("UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(18,16,38)),ColorSequenceKeypoint.new(1,C.surface)}),Rotation=135,Parent=main})
    sp(main,{Size=UDim2.new(0,820,0,540)},0.5)
    W._main=main

    local tb=mk("Frame",{Size=UDim2.new(1,0,0,52),BackgroundColor3=Color3.fromRGB(11,12,18),BorderSizePixel=0,ZIndex=3,Parent=main}); str(tb,C.border,1)
    mk("UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(18,14,44)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(11,12,18)),ColorSequenceKeypoint.new(1,Color3.fromRGB(8,18,14))}),Rotation=90,Parent=tb})
    local al=mk("Frame",{Size=UDim2.new(0.38,0,0,1),Position=UDim2.new(0.31,0,1,-1),BackgroundColor3=C.accent,BorderSizePixel=0,Parent=tb})
    mk("UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(0,0,0)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(0,0,0))}),Parent=al})
    for i,dc in ipairs({Color3.fromRGB(255,95,87),Color3.fromRGB(254,188,46),Color3.fromRGB(40,200,64)}) do
        local d=mk("Frame",{Size=UDim2.new(0,11,0,11),Position=UDim2.new(0,12+(i-1)*18,0.5,-5),BackgroundColor3=dc,BorderSizePixel=0,Parent=tb}); crn(d,99)
        local db=mk("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",Parent=d})
        db.MouseEnter:Connect(function() tw(d,{BackgroundTransparency=0.35},0.1) end)
        db.MouseLeave:Connect(function() tw(d,{BackgroundTransparency=0},0.1) end)
    end
    local tl=mk("TextLabel",{Size=UDim2.new(0,160,1,0),Position=UDim2.new(0,74,0,0),BackgroundTransparency=1,Text=(config.Title or "AETHER"):upper(),TextColor3=C.white,Font=FB,TextSize=15,TextXAlignment=Enum.TextXAlignment.Left,Parent=tb})
    mk("UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,C.white),ColorSequenceKeypoint.new(1,C.accent2)}),Rotation=90,Parent=tl})
    local bg=mk("TextLabel",{Size=UDim2.new(0,54,0,18),Position=UDim2.new(0,222,0.5,-9),BackgroundColor3=Color3.fromRGB(28,22,58),Text="v1.0",TextColor3=C.accent,Font=FM,TextSize=10,Parent=tb}); crn(bg,6); str(bg,Color3.fromRGB(55,44,115),1)
    mk("TextLabel",{Size=UDim2.new(0,180,1,0),Position=UDim2.new(1,-192,0,0),BackgroundTransparency=1,Text="RightCtrl to toggle",TextColor3=C.muted,Font=FM,TextSize=11,TextXAlignment=Enum.TextXAlignment.Right,Parent=tb})

    local dragging,dragStart,startPos=false,nil,nil
    tb.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true;dragStart=i.Position;startPos=main.Position end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then local d=i.Position-dragStart;main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)

    local body=mk("Frame",{Size=UDim2.new(1,0,1,-52),Position=UDim2.new(0,0,0,52),BackgroundTransparency=1,Parent=main})
    local sidebar=mk("Frame",{Size=UDim2.new(0,182,1,0),BackgroundColor3=Color3.fromRGB(10,11,17),BorderSizePixel=0,Parent=body}); str(sidebar,C.border,1)
    mk("UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(13,11,28)),ColorSequenceKeypoint.new(1,Color3.fromRGB(10,11,17))}),Rotation=180,Parent=sidebar})
    local ss=mk("ScrollingFrame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,ScrollBarThickness=0,ScrollingDirection=Enum.ScrollingDirection.Y,CanvasSize=UDim2.new(0,0,0,0),Parent=sidebar})
    local sl=lst(ss,3); pad(ss,10,10,8,8)
    sl.Changed:Connect(function() ss.CanvasSize=UDim2.new(0,0,0,sl.AbsoluteContentSize.Y+20) end)
    local content=mk("Frame",{Size=UDim2.new(1,-182,1,0),Position=UDim2.new(0,182,0,0),BackgroundTransparency=1,ClipsDescendants=true,Parent=body})
    W._content=content

    UserInputService.InputBegan:Connect(function(i,gp)
        if not gp and i.KeyCode==W.ToggleKey then
            local v=not main.Visible; main.Visible=v
            if v then main.Size=UDim2.new(0,820,0,0); sp(main,{Size=UDim2.new(0,820,0,540)},0.45) end
        end
    end)

    function W:Notify(cfg) notify(cfg.Title or "Aether",cfg.Content or "",cfg.Type or "blue",cfg.Duration or 4) end
    function W:Destroy() self._gui:Destroy() end

    function W:AddTab(cfg)
        local Tab={}
        local isFirst=#W.Tabs==0
        if isFirst then mk("TextLabel",{Size=UDim2.new(1,0,0,20),BackgroundTransparency=1,Text="NAVIGATION",TextColor3=C.muted,Font=FM,TextSize=9,TextXAlignment=Enum.TextXAlignment.Left,LayoutOrder=0,Parent=ss}) end

        local tabBtn=mk("TextButton",{Size=UDim2.new(1,0,0,36),BackgroundColor3=C.panel,BackgroundTransparency=1,Text="",AutoButtonColor=false,LayoutOrder=#W.Tabs*10+5,Parent=ss}); crn(tabBtn,9)
        local ind=mk("Frame",{Size=UDim2.new(0,2,0,20),Position=UDim2.new(0,0,0.5,-10),BackgroundColor3=C.accent,BackgroundTransparency=1,BorderSizePixel=0,Parent=tabBtn}); crn(ind,3)
        local iconL=mk("TextLabel",{Size=UDim2.new(0,18,1,0),Position=UDim2.new(0,12,0,0),BackgroundTransparency=1,Text=cfg.Icon or "•",TextColor3=C.muted,Font=FB,TextSize=14,Parent=tabBtn})
        local nameL=mk("TextLabel",{Size=UDim2.new(1,-38,1,0),Position=UDim2.new(0,34,0,0),BackgroundTransparency=1,Text=cfg.Title or "Tab",TextColor3=C.muted,Font=FS,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,Parent=tabBtn})
        local tabStr=str(tabBtn,C.border,1); tabStr.Transparency=1

        local page=mk("ScrollingFrame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,ScrollBarImageColor3=C.muted2,ScrollingDirection=Enum.ScrollingDirection.Y,CanvasSize=UDim2.new(0,0,0,0),Visible=false,Parent=content})
        local pl=lst(page,8); pad(page,20,20,20,20)
        pl.Changed:Connect(function() page.CanvasSize=UDim2.new(0,0,0,pl.AbsoluteContentSize.Y+40) end)
        Tab._page=page; Tab._btn=tabBtn; Tab._ind=ind; Tab._nameL=nameL; Tab._iconL=iconL; Tab._str=tabStr

        local function activate()
            if W.ActiveTab then
                local p=W.ActiveTab
                tw(p._btn,{BackgroundTransparency=1},0.18); tw(p._ind,{BackgroundTransparency=1},0.18)
                tw(p._nameL,{TextColor3=C.muted},0.18); tw(p._iconL,{TextColor3=C.muted},0.18)
                tw(p._str,{Transparency=1},0.18); p._page.Visible=false
            end
            W.ActiveTab=Tab
            page.Position=UDim2.new(0,16,0,0); page.Visible=true
            tw(page,{Position=UDim2.new(0,0,0,0)},0.22,Enum.EasingStyle.Quint)
            tw(tabBtn,{BackgroundTransparency=0.88},0.2); tw(ind,{BackgroundTransparency=0},0.2)
            tw(nameL,{TextColor3=C.white},0.2); tw(iconL,{TextColor3=C.accent2},0.2); tw(tabStr,{Transparency=0},0.2)
        end

        tabBtn.MouseButton1Click:Connect(activate)
        tabBtn.MouseEnter:Connect(function() if W.ActiveTab~=Tab then tw(tabBtn,{BackgroundTransparency=0.94},0.15) end end)
        tabBtn.MouseLeave:Connect(function() if W.ActiveTab~=Tab then tw(tabBtn,{BackgroundTransparency=1},0.15) end end)
        table.insert(W.Tabs,Tab); if isFirst then activate() end

        function Tab:AddSection(title)
            local Sec={}
            if title then mk("TextLabel",{Size=UDim2.new(1,0,0,20),BackgroundTransparency=1,Text=title:upper(),TextColor3=C.muted,Font=FM,TextSize=9,TextXAlignment=Enum.TextXAlignment.Left,LayoutOrder=9999,Parent=page}) end

            function Sec:AddToggle(cfg)
                local val=cfg.Default or false
                local h=cfg.Description and 54 or 46
                local row=mk("Frame",{Size=UDim2.new(1,0,0,h),BackgroundColor3=C.panel,BorderSizePixel=0,LayoutOrder=9999,Parent=page}); crn(row,9); str(row,C.border,1); pad(row,0,0,14,14)
                mk("TextLabel",{Size=UDim2.new(1,-60,0,16),Position=UDim2.new(0,0,0,cfg.Description and 6 or 15),BackgroundTransparency=1,Text=cfg.Name or "Toggle",TextColor3=C.text,Font=FS,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,Parent=row})
                if cfg.Description then mk("TextLabel",{Size=UDim2.new(1,-60,0,13),Position=UDim2.new(0,0,0,24),BackgroundTransparency=1,Text=cfg.Description,TextColor3=C.muted,Font=FM,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,Parent=row}) end
                local track=mk("Frame",{Size=UDim2.new(0,38,0,20),Position=UDim2.new(1,-38,0.5,-10),BackgroundColor3=val and C.accent or C.muted2,BorderSizePixel=0,Parent=row}); crn(track,99)
                local knob=mk("Frame",{Size=UDim2.new(0,14,0,14),Position=val and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7),BackgroundColor3=C.white,BorderSizePixel=0,Parent=track}); crn(knob,99)
                local Tog={Value=val}
                local function set(v) val=v;Tog.Value=v; sp(knob,{Position=v and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)},0.28); tw(track,{BackgroundColor3=v and C.accent or C.muted2},0.2); if cfg.Callback then cfg.Callback(v) end end
                local hb=mk("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=5,Parent=row})
                hb.MouseButton1Click:Connect(function() set(not val); tw(row,{BackgroundColor3=C.borderHi},0.07); task.delay(0.1,function() tw(row,{BackgroundColor3=C.panel},0.15) end) end)
                hb.MouseEnter:Connect(function() tw(row,{BackgroundColor3=Color3.fromRGB(22,24,34)},0.15) end)
                hb.MouseLeave:Connect(function() tw(row,{BackgroundColor3=C.panel},0.15) end)
                function Tog:Set(v) set(v) end
                return Tog
            end

            function Sec:AddSlider(cfg)
                local val=math.clamp(cfg.Default or cfg.Min or 0,cfg.Min,cfg.Max)
                local pct=(val-cfg.Min)/(cfg.Max-cfg.Min)
                local wrap=mk("Frame",{Size=UDim2.new(1,0,0,62),BackgroundColor3=C.panel,BorderSizePixel=0,LayoutOrder=9999,Parent=page}); crn(wrap,9); str(wrap,C.border,1); pad(wrap,10,10,14,14)
                local top=mk("Frame",{Size=UDim2.new(1,0,0,18),BackgroundTransparency=1,Parent=wrap})
                mk("TextLabel",{Size=UDim2.new(0.7,0,1,0),BackgroundTransparency=1,Text=cfg.Name or "Slider",TextColor3=C.text,Font=FS,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,Parent=top})
                local vl=mk("TextLabel",{Size=UDim2.new(0.3,0,1,0),Position=UDim2.new(0.7,0,0,0),BackgroundTransparency=1,Text=tostring(val)..(cfg.Suffix or ""),TextColor3=C.accent2,Font=FM,TextSize=12,TextXAlignment=Enum.TextXAlignment.Right,Parent=top})
                local track=mk("Frame",{Size=UDim2.new(1,0,0,4),Position=UDim2.new(0,0,0,32),BackgroundColor3=C.muted2,BorderSizePixel=0,Parent=wrap}); crn(track,4)
                local fill=mk("Frame",{Size=UDim2.new(pct,0,1,0),BackgroundColor3=C.accent,BorderSizePixel=0,Parent=track}); crn(fill,4)
                local knob=mk("Frame",{Size=UDim2.new(0,14,0,14),Position=UDim2.new(pct,-7,0.5,-7),BackgroundColor3=C.white,BorderSizePixel=0,ZIndex=3,Parent=track}); crn(knob,99)
                local Sli={Value=val}; local sliding=false
                local function update(x)
                    local rel=math.clamp((x-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
                    local nv
                    if (cfg.Rounding or 0)==0 then nv=math.floor(cfg.Min+(cfg.Max-cfg.Min)*rel+0.5)
                    else local f=10^cfg.Rounding; nv=math.floor((cfg.Min+(cfg.Max-cfg.Min)*rel)*f+0.5)/f end
                    Sli.Value=nv; vl.Text=tostring(nv)..(cfg.Suffix or "")
                    tw(fill,{Size=UDim2.new(rel,0,1,0)},0.06,Enum.EasingStyle.Linear)
                    tw(knob,{Position=UDim2.new(rel,-7,0.5,-7)},0.06,Enum.EasingStyle.Linear)
                    if cfg.Callback then cfg.Callback(nv) end
                end
                track.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then sliding=true;update(i.Position.X) end end)
                UserInputService.InputChanged:Connect(function(i) if sliding and i.UserInputType==Enum.UserInputType.MouseMovement then update(i.Position.X) end end)
                UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then sliding=false end end)
                knob.MouseEnter:Connect(function() sp(knob,{Size=UDim2.new(0,18,0,18)},0.22) end)
                knob.MouseLeave:Connect(function() sp(knob,{Size=UDim2.new(0,14,0,14)},0.22) end)
                return Sli
            end

            function Sec:AddButton(cfg)
                local btn=mk("TextButton",{Size=UDim2.new(1,0,0,38),BackgroundColor3=C.accent,BorderSizePixel=0,Text="",AutoButtonColor=false,LayoutOrder=9999,Parent=page}); crn(btn,9)
                mk("UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(140,120,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(100,82,220))}),Rotation=90,Parent=btn})
                mk("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text=cfg.Name or "Button",TextColor3=C.white,Font=FB,TextSize=13,Parent=btn})
                btn.MouseEnter:Connect(function() tw(btn,{BackgroundColor3=C.accent2},0.15) end)
                btn.MouseLeave:Connect(function() tw(btn,{BackgroundColor3=C.accent},0.15) end)
                btn.MouseButton1Click:Connect(function()
                    tw(btn,{BackgroundColor3=Color3.fromRGB(90,72,200)},0.07)
                    task.delay(0.12,function() tw(btn,{BackgroundColor3=C.accent},0.15) end)
                    if cfg.Callback then cfg.Callback() end
                end)
            end

            function Sec:AddDropdown(cfg)
                local val=cfg.Default or (cfg.Options and cfg.Options[1]) or ""
                local open=false; local dropFrame=nil
                local wrap=mk("Frame",{Size=UDim2.new(1,0,0,46),BackgroundColor3=C.panel,BorderSizePixel=0,LayoutOrder=9999,ClipsDescendants=false,ZIndex=5,Parent=page}); crn(wrap,9); str(wrap,C.border,1); pad(wrap,0,0,14,14)
                mk("TextLabel",{Size=UDim2.new(0.55,0,0,46),BackgroundTransparency=1,Text=cfg.Name or "Dropdown",TextColor3=C.text,Font=FS,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,Parent=wrap})
                local selL=mk("TextLabel",{Size=UDim2.new(0.42,0,0,26),Position=UDim2.new(0.56,0,0.5,-13),BackgroundColor3=C.bg,Text=val,TextColor3=C.accent2,Font=FM,TextSize=11,TextTruncate=Enum.TextTruncate.AtEnd,Parent=wrap}); crn(selL,6); str(selL,C.border,1)
                local hb=mk("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=8,Parent=wrap})
                local Drop={Value=val}
                hb.MouseButton1Click:Connect(function()
                    open=not open
                    if open then
                        dropFrame=mk("Frame",{Size=UDim2.new(1,0,0,0),Position=UDim2.new(0,0,1,4),BackgroundColor3=C.panel,BorderSizePixel=0,ClipsDescendants=true,ZIndex=20,Parent=wrap}); crn(dropFrame,9); str(dropFrame,C.border,1)
                        local dl=lst(dropFrame,2); pad(dropFrame,6,6,6,6)
                        for _,opt in ipairs(cfg.Options or {}) do
                            local item=mk("TextButton",{Size=UDim2.new(1,0,0,30),BackgroundTransparency=1,Text=opt,TextColor3=C.muted,Font=FS,TextSize=12,ZIndex=21,Parent=dropFrame}); crn(item,6)
                            item.MouseEnter:Connect(function() tw(item,{BackgroundTransparency=0.88,TextColor3=C.text},0.12) end)
                            item.MouseLeave:Connect(function() tw(item,{BackgroundTransparency=1,TextColor3=C.muted},0.12) end)
                            item.MouseButton1Click:Connect(function()
                                val=opt;Drop.Value=opt;selL.Text=opt;open=false
                                tw(dropFrame,{Size=UDim2.new(1,0,0,0)},0.18,Enum.EasingStyle.Quint)
                                task.delay(0.2,function() if dropFrame then dropFrame:Destroy() end end)
                                if cfg.Callback then cfg.Callback(opt) end
                            end)
                        end
                        local th=dl.AbsoluteContentSize.Y+14
                        tw(dropFrame,{Size=UDim2.new(1,0,0,th)},0.22,Enum.EasingStyle.Quint)
                    else
                        if dropFrame then tw(dropFrame,{Size=UDim2.new(1,0,0,0)},0.18,Enum.EasingStyle.Quint); task.delay(0.2,function() if dropFrame then dropFrame:Destroy() end end) end
                    end
                end)
                return Drop
            end

            return Sec
        end
        return Tab
    end

    notify("Aether Hub","Loaded! Press RightCtrl to toggle.","blue",5)
    return W
end

local TeleService = game:GetService("TeleportService")

local State={AutoGreen=false,GunGrabber=false,SpeedOn=false,SpeedVal=32,JumpOn=false,JumpVal=80,NoClip=false,InfStam=false,ESP=false}
local GunNames={"AK-47","AK47","M9","FAL","Shotgun","Sniper","Pistol","Rifle","Revolver"}
local Locs={["Criminal Base"]=CFrame.new(-153,3,-50),["Guard Room"]=CFrame.new(115,23,10),["Armory"]=CFrame.new(118,23,-14),["Prison Yard"]=CFrame.new(-4,3,0),["Cell Block"]=CFrame.new(-4,3,50),["Escape Route"]=CFrame.new(-200,3,-100)}

local ESPObjs={}
local FB2=Enum.Font.GothamBold; local FM2=Enum.Font.Code
local function getChar() return LocalPlayer.Character end
local function getHum() local c=getChar(); return c and c:FindFirstChildOfClass("Humanoid") end
local function getHRP() local c=getChar(); return c and c:FindFirstChild("HumanoidRootPart") end
local function teamCol(p)
    if p.Team then local t=p.Team.Name:lower()
        if t:find("criminal") then return Color3.fromRGB(255,80,80) end
        if t:find("police") or t:find("guard") then return Color3.fromRGB(80,160,255) end
    end; return C.green
end
local function rmESP(p) if ESPObjs[p] then for _,v in pairs(ESPObjs[p]) do pcall(function()v:Destroy()end) end; ESPObjs[p]=nil end end
local function mkESP(p)
    if p==LocalPlayer then return end; rmESP(p)
    local bb=Instance.new("BillboardGui"); bb.Name="_ESP_"..p.Name; bb.AlwaysOnTop=true; bb.Size=UDim2.new(0,140,0,50); bb.StudsOffset=Vector3.new(0,3.5,0)
    local nl=Instance.new("TextLabel",bb); nl.Size=UDim2.new(1,0,0.55,0); nl.BackgroundTransparency=1; nl.Text=p.Name; nl.Font=FB2; nl.TextSize=14; nl.TextColor3=teamCol(p); nl.TextStrokeTransparency=0.35
    local tl2=Instance.new("TextLabel",bb); tl2.Size=UDim2.new(1,0,0.45,0); tl2.Position=UDim2.new(0,0,0.55,0); tl2.BackgroundTransparency=1; tl2.Text=p.Team and p.Team.Name or "No Team"; tl2.Font=FM2; tl2.TextSize=11; tl2.TextColor3=Color3.fromRGB(200,200,200); tl2.TextStrokeTransparency=0.5
    local function att(c) local h=c:FindFirstChild("HumanoidRootPart"); if h then bb.Adornee=h;bb.Parent=h end end
    if p.Character then att(p.Character) end; p.CharacterAdded:Connect(att); ESPObjs[p]={bb}
end
local function refreshESP()
    if State.ESP then for _,p in ipairs(Players:GetPlayers()) do mkESP(p) end
    else for p in pairs(ESPObjs) do rmESP(p) end end
end
Players.PlayerAdded:Connect(function(p) if State.ESP then mkESP(p) end end)
Players.PlayerRemoving:Connect(rmESP)

RunService.Heartbeat:Connect(function()
    local hum=getHum()
    if hum then if State.SpeedOn then hum.WalkSpeed=State.SpeedVal end; if State.JumpOn then hum.JumpPower=State.JumpVal end end
    if State.AutoGreen then
        local c=getChar(); if c then
            for _,v in ipairs(c:GetChildren()) do if (v:IsA("Tool") or v:IsA("Accessory")) and v.Name:lower():find("cuff") then pcall(function()v:Destroy()end) end end
            local cf=c:FindFirstChild("Cuffed") or LocalPlayer:FindFirstChild("Cuffed")
            if cf and cf.Value==true then pcall(function()cf.Value=false end) end
        end
    end
    if State.GunGrabber then
        for _,t in ipairs(workspace:GetDescendants()) do
            if t:IsA("Tool") then for _,g in ipairs(GunNames) do if t.Name:lower():find(g:lower()) and t.Parent~=LocalPlayer.Backpack and t.Parent~=getChar() then pcall(function()t.Parent=LocalPlayer.Backpack end) end end end
        end
    end
    if State.InfStam then local s=LocalPlayer:FindFirstChild("Stamina") or (getChar() and getChar():FindFirstChild("Stamina")); if s then pcall(function()s.Value=s.MaxValue or 100 end) end end
end)

RunService.Stepped:Connect(function()
    if not State.NoClip then return end
    local c=getChar(); if not c then return end
    for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end
end)

local Win=CreateWindow({Title="AETHER",ToggleKey=Enum.KeyCode.RightControl})

local ESPTab=Win:AddTab({Title="ESP",Icon="◎"})
local PlrTab=Win:AddTab({Title="Player",Icon="◈"})
local CbtTab=Win:AddTab({Title="Combat",Icon="⚔"})
local TpTab =Win:AddTab({Title="Teleport",Icon="◇"})
local MscTab=Win:AddTab({Title="Misc",Icon="⊞"})

local es=ESPTab:AddSection("Visibility")
es:AddToggle({Name="Enable ESP",Description="Color-coded tags through walls",Default=false,Callback=function(v) State.ESP=v;refreshESP() end})
es:AddToggle({Name="Show Criminals",Default=true,Callback=function() refreshESP() end})
es:AddToggle({Name="Show Guards",Default=true,Callback=function() refreshESP() end})
es:AddToggle({Name="Show Inmates",Default=true,Callback=function() refreshESP() end})
es:AddSlider({Name="ESP Distance",Min=50,Max=2000,Default=500,Rounding=0,Suffix=" studs"})

local ps=PlrTab:AddSection("Movement")
ps:AddToggle({Name="Speed Hack",Default=false,Callback=function(v) State.SpeedOn=v; if not v then local h=getHum();if h then h.WalkSpeed=16 end end end})
ps:AddSlider({Name="Walk Speed",Min=16,Max=250,Default=32,Rounding=0,Callback=function(v) State.SpeedVal=v end})
ps:AddToggle({Name="High Jump",Default=false,Callback=function(v) State.JumpOn=v; if not v then local h=getHum();if h then h.JumpPower=50 end end end})
ps:AddSlider({Name="Jump Power",Min=50,Max=400,Default=80,Rounding=0,Callback=function(v) State.JumpVal=v end})
ps:AddToggle({Name="No Clip",Default=false,Callback=function(v) State.NoClip=v; if not v then local c=getChar();if c then for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=true end end end end end})
ps:AddToggle({Name="Infinite Stamina",Default=false,Callback=function(v) State.InfStam=v end})

local cs=CbtTab:AddSection("Auto Features")
cs:AddToggle({Name="Auto Green",Description="Removes handcuffs and arrested state",Default=false,Callback=function(v) State.AutoGreen=v end})
cs:AddToggle({Name="Auto Gun Grabber",Description="Auto-loots AK-47, M9, FAL and more",Default=false,Callback=function(v) State.GunGrabber=v end})
cs:AddButton({Name="Grab All Guns Now",Callback=function()
    local n=0
    for _,t in ipairs(workspace:GetDescendants()) do if t:IsA("Tool") then for _,g in ipairs(GunNames) do if t.Name:lower():find(g:lower()) and t.Parent~=LocalPlayer.Backpack and t.Parent~=getChar() then pcall(function()t.Parent=LocalPlayer.Backpack end);n+=1 end end end end
    Win:Notify({Title="Gun Grab",Content="Grabbed "..n.." weapon(s).",Type="green"})
end})

local ts=TpTab:AddSection("Locations")
for name,cf in pairs(Locs) do
    ts:AddButton({Name=name,Callback=function() local h=getHRP();if h then h.CFrame=cf end; Win:Notify({Title="Teleport",Content="Warped to "..name,Type="blue"}) end})
end
local tps=TpTab:AddSection("Teleport to Player")
local pnames={}; for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer then table.insert(pnames,p.Name) end end
if #pnames==0 then pnames={"(No players)"} end
tps:AddDropdown({Name="Select Player",Options=pnames,Callback=function(sel)
    local t=Players:FindFirstChild(sel); if t and t.Character then local h=t.Character:FindFirstChild("HumanoidRootPart"); if h then local m=getHRP();if m then m.CFrame=h.CFrame+Vector3.new(3,0,3) end; Win:Notify({Title="Teleport",Content="Warped to "..sel,Type="blue"}) end end
end})

local ms=MscTab:AddSection("Utilities")
ms:AddButton({Name="Rejoin Server",Callback=function() TeleService:Teleport(game.PlaceId,LocalPlayer) end})
ms:AddButton({Name="Copy Server ID",Callback=function() pcall(function()setclipboard(tostring(game.JobId))end); Win:Notify({Title="Copied",Content="Server ID copied to clipboard.",Type="green"}) end})
ms:AddButton({Name="Reset Character",Callback=function() local h=getHum();if h then h.Health=0 end end})
ms:AddButton({Name="Destroy Hub",Callback=function() Win:Destroy() end})
