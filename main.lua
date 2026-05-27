local GloomUI = {}

----------------------------------------------------------------
-- SERVICES
----------------------------------------------------------------

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

----------------------------------------------------------------
-- THEMES
----------------------------------------------------------------

GloomUI.Themes = {

    Amoled = {
        Background = Color3.fromRGB(10,10,10),
        Secondary = Color3.fromRGB(18,18,18),
        Accent = Color3.fromRGB(255,255,255),
        Text = Color3.fromRGB(255,255,255),
        Stroke = Color3.fromRGB(255,255,255)
    },

    Ocean = {
        Background = Color3.fromRGB(14,18,28),
        Secondary = Color3.fromRGB(20,25,36),
        Accent = Color3.fromRGB(90,170,255),
        Text = Color3.fromRGB(255,255,255),
        Stroke = Color3.fromRGB(90,170,255)
    },

    Rose = {
        Background = Color3.fromRGB(20,16,18),
        Secondary = Color3.fromRGB(32,22,28),
        Accent = Color3.fromRGB(255,120,170),
        Text = Color3.fromRGB(255,255,255),
        Stroke = Color3.fromRGB(255,120,170)
    }
}

----------------------------------------------------------------
-- HELPERS
----------------------------------------------------------------

local function Corner(obj, radius)

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 12)
    c.Parent = obj
end

local function Stroke(obj, color)

    local s = Instance.new("UIStroke")
    s.Parent = obj

    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    s.Thickness = 1

    s.Transparency = 0.4

    s.Color = color

    return s
end

local function Tween(obj, time, props)

    TweenService:Create(
        obj,
        TweenInfo.new(
            time,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        ),
        props
    ):Play()
end

----------------------------------------------------------------
-- WINDOW
----------------------------------------------------------------

function GloomUI:CreateWindow(cfg)

    cfg = cfg or {}

    local Theme =
        GloomUI.Themes[cfg.Theme or "Amoled"]

    local EnableGlow = cfg.Glow or false
    local EnableBlur = cfg.Blur or false

    ------------------------------------------------------------
    -- BLUR
    ------------------------------------------------------------

    if EnableBlur then

        if not Lighting:FindFirstChild("gloom_blur") then

            local Blur = Instance.new("BlurEffect")
            Blur.Name = "gloom_blur"
            Blur.Size = 14
            Blur.Parent = Lighting
        end
    end

    ------------------------------------------------------------
    -- GLOW
    ------------------------------------------------------------

    local function ApplyGlow(obj)

        if not EnableGlow then
            return
        end

        local Glow = Instance.new("UIStroke")
        Glow.Parent = obj

        Glow.Thickness = 1.2

        Glow.Transparency = 0.35

        Glow.Color = Theme.Accent

        task.spawn(function()

            while Glow.Parent do

                TweenService:Create(
                    Glow,
                    TweenInfo.new(
                        2,
                        Enum.EasingStyle.Sine,
                        Enum.EasingDirection.InOut
                    ),
                    {
                        Transparency = 0.75
                    }
                ):Play()

                task.wait(2)

                TweenService:Create(
                    Glow,
                    TweenInfo.new(
                        2,
                        Enum.EasingStyle.Sine,
                        Enum.EasingDirection.InOut
                    ),
                    {
                        Transparency = 0.35
                    }
                ):Play()

                task.wait(2)
            end
        end)
    end

    ------------------------------------------------------------
    -- GUI
    ------------------------------------------------------------

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "gloomui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui

    ------------------------------------------------------------
    -- MAIN
    ------------------------------------------------------------

    local Main = Instance.new("Frame")
    Main.Parent = ScreenGui

    Main.Size = UDim2.new(0, 640, 0, 460)

    Main.Position = UDim2.new(
        0.5,
        -320,
        0.5,
        -230
    )

    Main.BackgroundColor3 = Theme.Background

    Corner(Main, 16)
    Stroke(Main, Theme.Stroke)
    ApplyGlow(Main)

    ------------------------------------------------------------
    -- SHADOW
    ------------------------------------------------------------

    local Shadow = Instance.new("ImageLabel")
    Shadow.Parent = Main

    Shadow.BackgroundTransparency = 1

    Shadow.Size = UDim2.new(1,55,1,55)

    Shadow.Position = UDim2.new(0,-27,0,-27)

    Shadow.Image = "rbxassetid://6015897843"

    Shadow.ImageTransparency = 0.5

    Shadow.ScaleType = Enum.ScaleType.Slice

    Shadow.SliceCenter = Rect.new(49,49,450,450)

    Shadow.ZIndex = 0

    ------------------------------------------------------------
    -- TOPBAR
    ------------------------------------------------------------

    local Topbar = Instance.new("Frame")
    Topbar.Parent = Main

    Topbar.Size = UDim2.new(1,0,0,52)

    Topbar.BackgroundTransparency = 1

    local Title = Instance.new("TextLabel")
    Title.Parent = Topbar

    Title.BackgroundTransparency = 1

    Title.Position = UDim2.new(0,18,0,0)

    Title.Size = UDim2.new(1,-20,1,0)

    Title.Font = Enum.Font.GothamBold

    Title.Text = cfg.Title or "gloomui"

    Title.TextSize = 18

    Title.TextColor3 = Theme.Text

    Title.TextXAlignment = Enum.TextXAlignment.Left

    ------------------------------------------------------------
    -- SIDEBAR
    ------------------------------------------------------------

    local Sidebar = Instance.new("Frame")
    Sidebar.Parent = Main

    Sidebar.Size = UDim2.new(0,180,1,-52)

    Sidebar.Position = UDim2.new(0,0,0,52)

    Sidebar.BackgroundTransparency = 1

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Parent = Sidebar

    SidebarLayout.Padding = UDim.new(0,8)

    ------------------------------------------------------------
    -- CONTAINER
    ------------------------------------------------------------

    local Container = Instance.new("Frame")
    Container.Parent = Main

    Container.Size = UDim2.new(1,-195,1,-67)

    Container.Position = UDim2.new(0,190,0,60)

    Container.BackgroundTransparency = 1

    ------------------------------------------------------------
    -- MOBILE SUPPORT
    ------------------------------------------------------------

    if UIS.TouchEnabled then

        Main.Size = UDim2.new(0.92,0,0.75,0)

        Main.Position = UDim2.new(
            0.04,
            0,
            0.12,
            0
        )
    end

    ------------------------------------------------------------
    -- DRAGGING
    ------------------------------------------------------------

    local dragging = false
    local dragStart
    local startPos

    Topbar.InputBegan:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)

        if dragging then

            if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then

                local delta = input.Position - dragStart

                Main.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end
    end)

    UIS.InputEnded:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

            dragging = false
        end
    end)

    ------------------------------------------------------------
    -- WINDOW API
    ------------------------------------------------------------

    local Window = {}

    function Window:Tab(cfg)

        --------------------------------------------------------
        -- TAB BUTTON
        --------------------------------------------------------

        local TabButton = Instance.new("TextButton")
        TabButton.Parent = Sidebar

        TabButton.Size = UDim2.new(1,-16,0,42)

        TabButton.BackgroundColor3 = Theme.Secondary

        TabButton.Text = cfg.Title or "Tab"

        TabButton.Font = Enum.Font.GothamMedium

        TabButton.TextSize = 14

        TabButton.TextColor3 = Theme.Text

        Corner(TabButton, 10)
        Stroke(TabButton, Theme.Stroke)
        ApplyGlow(TabButton)

        --------------------------------------------------------
        -- PAGE
        --------------------------------------------------------

        local Page = Instance.new("ScrollingFrame")
        Page.Parent = Container

        Page.Size = UDim2.new(1,0,1,0)

        Page.CanvasSize = UDim2.new(0,0,0,0)

        Page.ScrollBarThickness = 0

        Page.BackgroundTransparency = 1

        Page.Visible = false

        Page.AutomaticCanvasSize =
            Enum.AutomaticSize.Y

        local Layout = Instance.new("UIListLayout")
        Layout.Parent = Page

        Layout.Padding = UDim.new(0,10)

        Layout:GetPropertyChangedSignal(
            "AbsoluteContentSize"
        ):Connect(function()

            Page.CanvasSize = UDim2.new(
                0,
                0,
                0,
                Layout.AbsoluteContentSize.Y + 20
            )
        end)

        --------------------------------------------------------
        -- TAB SWITCH
        --------------------------------------------------------

        TabButton.MouseButton1Click:Connect(function()

            for _, v in pairs(Container:GetChildren()) do

                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end

            Page.Visible = true
        end)

        --------------------------------------------------------
        -- TAB API
        --------------------------------------------------------

        local Tab = {}

        --------------------------------------------------------
        -- SECTION
        --------------------------------------------------------

        function Tab:Section(cfg)

            local Section = Instance.new("TextLabel")
            Section.Parent = Page

            Section.Size = UDim2.new(1,-8,0,26)

            Section.BackgroundTransparency = 1

            Section.Font = Enum.Font.GothamBold

            Section.Text = cfg.Title or "Section"

            Section.TextSize = 15

            Section.TextColor3 = Theme.Accent

            Section.TextXAlignment =
                Enum.TextXAlignment.Left
        end

        --------------------------------------------------------
        -- LABEL
        --------------------------------------------------------

        function Tab:Label(cfg)

            local Label = Instance.new("TextLabel")
            Label.Parent = Page

            Label.Size = UDim2.new(1,-8,0,32)

            Label.BackgroundTransparency = 1

            Label.Font = Enum.Font.Gotham

            Label.Text = cfg.Title or "Label"

            Label.TextSize = 14

            Label.TextColor3 = Theme.Text

            Label.TextXAlignment =
                Enum.TextXAlignment.Left

            return {

                Set = function(_, text)
                    Label.Text = text
                end
            }
        end

        --------------------------------------------------------
        -- PARAGRAPH
        --------------------------------------------------------

        function Tab:Paragraph(cfg)

            local Holder = Instance.new("Frame")
            Holder.Parent = Page

            Holder.Size = UDim2.new(1,-8,0,72)

            Holder.BackgroundColor3 =
                Theme.Secondary

            Corner(Holder, 10)
            Stroke(Holder, Theme.Stroke)
            ApplyGlow(Holder)

            local Title = Instance.new("TextLabel")
            Title.Parent = Holder

            Title.BackgroundTransparency = 1

            Title.Position = UDim2.new(0,12,0,8)

            Title.Size = UDim2.new(1,-20,0,18)

            Title.Font = Enum.Font.GothamBold

            Title.Text = cfg.Title or "Paragraph"

            Title.TextSize = 14

            Title.TextColor3 = Theme.Text

            Title.TextXAlignment =
                Enum.TextXAlignment.Left

            local Desc = Instance.new("TextLabel")
            Desc.Parent = Holder

            Desc.BackgroundTransparency = 1

            Desc.Position = UDim2.new(0,12,0,28)

            Desc.Size = UDim2.new(1,-20,1,-32)

            Desc.Font = Enum.Font.Gotham

            Desc.Text = cfg.Desc or "Description"

            Desc.TextWrapped = true

            Desc.TextYAlignment =
                Enum.TextYAlignment.Top

            Desc.TextSize = 13

            Desc.TextColor3 =
                Color3.fromRGB(190,190,190)

            Desc.TextXAlignment =
                Enum.TextXAlignment.Left

            return {

                SetTitle = function(_, text)
                    Title.Text = text
                end,

                SetDesc = function(_, text)
                    Desc.Text = text
                end
            }
        end

        --------------------------------------------------------
        -- BUTTON
        --------------------------------------------------------

        function Tab:Button(cfg)

            local Button = Instance.new("TextButton")
            Button.Parent = Page

            Button.Size = UDim2.new(1,-8,0,42)

            Button.BackgroundColor3 =
                Theme.Secondary

            Button.Text = cfg.Title or "Button"

            Button.Font = Enum.Font.GothamMedium

            Button.TextSize = 14

            Button.TextColor3 = Theme.Text

            Corner(Button, 10)
            Stroke(Button, Theme.Stroke)
            ApplyGlow(Button)

            Button.MouseButton1Click:Connect(function()

                Tween(
                    Button,
                    0.15,
                    {
                        BackgroundTransparency = 0.2
                    }
                )

                task.wait(0.15)

                Tween(
                    Button,
                    0.15,
                    {
                        BackgroundTransparency = 0
                    }
                )

                if cfg.Callback then
                    cfg.Callback()
                end
            end)
        end

        --------------------------------------------------------
        -- TOGGLE
        --------------------------------------------------------

        function Tab:Toggle(cfg)

            local Enabled =
                cfg.Default or false

            local Toggle = Instance.new("TextButton")
            Toggle.Parent = Page

            Toggle.Size = UDim2.new(1,-8,0,42)

            Toggle.BackgroundColor3 =
                Theme.Secondary

            Toggle.Text = ""

            Corner(Toggle, 10)
            Stroke(Toggle, Theme.Stroke)
            ApplyGlow(Toggle)

            local Label = Instance.new("TextLabel")
            Label.Parent = Toggle

            Label.BackgroundTransparency = 1

            Label.Position = UDim2.new(0,14,0,0)

            Label.Size = UDim2.new(1,-60,1,0)

            Label.Font = Enum.Font.GothamMedium

            Label.Text = cfg.Title or "Toggle"

            Label.TextSize = 14

            Label.TextColor3 = Theme.Text

            Label.TextXAlignment =
                Enum.TextXAlignment.Left

            local Indicator = Instance.new("Frame")
            Indicator.Parent = Toggle

            Indicator.Size = UDim2.new(0,18,0,18)

            Indicator.Position = UDim2.new(
                1,
                -30,
                0.5,
                -9
            )

            Indicator.BackgroundColor3 =
                Enabled
                and Theme.Accent
                or Color3.fromRGB(60,60,60)

            Corner(Indicator, 99)

            Toggle.MouseButton1Click:Connect(function()

                Enabled = not Enabled

                Tween(
                    Indicator,
                    0.2,
                    {
                        BackgroundColor3 =
                            Enabled
                            and Theme.Accent
                            or Color3.fromRGB(60,60,60)
                    }
                )

                if cfg.Callback then
                    cfg.Callback(Enabled)
                end
            end)
        end

        --------------------------------------------------------
        -- SLIDER
        --------------------------------------------------------

        function Tab:Slider(cfg)

            local Min = cfg.Min or 0
            local Max = cfg.Max or 100

            local Value =
                cfg.Default or Min

            local Dragging = false

            local Slider = Instance.new("Frame")
            Slider.Parent = Page

            Slider.Size = UDim2.new(1,-8,0,54)

            Slider.BackgroundColor3 =
                Theme.Secondary

            Corner(Slider, 10)
            Stroke(Slider, Theme.Stroke)
            ApplyGlow(Slider)

            local Label = Instance.new("TextLabel")
            Label.Parent = Slider

            Label.BackgroundTransparency = 1

            Label.Position = UDim2.new(0,12,0,6)

            Label.Size = UDim2.new(1,-24,0,18)

            Label.Font = Enum.Font.GothamMedium

            Label.Text =
                (cfg.Title or "Slider")
                .. " : "
                .. tostring(Value)

            Label.TextSize = 14

            Label.TextColor3 = Theme.Text

            Label.TextXAlignment =
                Enum.TextXAlignment.Left

            local Bar = Instance.new("Frame")
            Bar.Parent = Slider

            Bar.Position = UDim2.new(0,12,1,-18)

            Bar.Size = UDim2.new(1,-24,0,6)

            Bar.BackgroundColor3 =
                Color3.fromRGB(45,45,45)

            Corner(Bar, 99)

            local Fill = Instance.new("Frame")
            Fill.Parent = Bar

            Fill.Size = UDim2.new(
                (Value - Min) / (Max - Min),
                0,
                1,
                0
            )

            Fill.BackgroundColor3 = Theme.Accent

            Corner(Fill, 99)

            local function Update(input)

                local sizeX =
                    math.clamp(
                        (input.Position.X
                        - Bar.AbsolutePosition.X)
                        / Bar.AbsoluteSize.X,
                        0,
                        1
                    )

                Fill.Size = UDim2.new(sizeX,0,1,0)

                Value =
                    math.floor(
                        ((Max - Min) * sizeX)
                        + Min
                    )

                Label.Text =
                    (cfg.Title or "Slider")
                    .. " : "
                    .. tostring(Value)

                if cfg.Callback then
                    cfg.Callback(Value)
                end
            end

            Bar.InputBegan:Connect(function(input)

                if input.UserInputType
                    == Enum.UserInputType.MouseButton1
                or input.UserInputType
                    == Enum.UserInputType.Touch then

                    Dragging = true
                    Update(input)
                end
            end)

            UIS.InputChanged:Connect(function(input)

                if Dragging then

                    if input.UserInputType
                        == Enum.UserInputType.MouseMovement
                    or input.UserInputType
                        == Enum.UserInputType.Touch then

                        Update(input)
                    end
                end
            end)

            UIS.InputEnded:Connect(function(input)

                if input.UserInputType
                    == Enum.UserInputType.MouseButton1
                or input.UserInputType
                    == Enum.UserInputType.Touch then

                    Dragging = false
                end
            end)
        end

        --------------------------------------------------------
        -- DROPDOWN
        --------------------------------------------------------

        function Tab:Dropdown(cfg)

            local Options = cfg.Options or {}

            local Selected =
                cfg.Default
                or Options[1]
                or "None"

            local Open = false

            local Holder = Instance.new("Frame")
            Holder.Parent = Page

            Holder.Size = UDim2.new(1,-8,0,42)

            Holder.BackgroundColor3 =
                Theme.Secondary

            Holder.ClipsDescendants = true

            Corner(Holder, 10)
            Stroke(Holder, Theme.Stroke)
            ApplyGlow(Holder)

            local Layout = Instance.new("UIListLayout")
            Layout.Parent = Holder

            Layout.Padding = UDim.new(0,4)

            local Button = Instance.new("TextButton")
            Button.Parent = Holder

            Button.Size = UDim2.new(1,0,0,42)

            Button.BackgroundTransparency = 1

            Button.Text =
                (cfg.Title or "Dropdown")
                .. " : "
                .. tostring(Selected)

            Button.Font = Enum.Font.GothamMedium

            Button.TextSize = 14

            Button.TextColor3 = Theme.Text

            Button.MouseButton1Click:Connect(function()

                Open = not Open

                TweenService:Create(
                    Holder,
                    TweenInfo.new(0.2),
                    {
                        Size = UDim2.new(
                            1,
                            -8,
                            0,
                            Open
                            and (42 + (#Options * 34))
                            or 42
                        )
                    }
                ):Play()
            end)

            for _, option in pairs(Options) do

                local Option = Instance.new("TextButton")
                Option.Parent = Holder

                Option.Size = UDim2.new(1,-10,0,30)

                Option.BackgroundColor3 =
                    Color3.fromRGB(32,32,32)

                Option.Text = option

                Option.Font = Enum.Font.Gotham

                Option.TextSize = 13

                Option.TextColor3 = Theme.Text

                Corner(Option, 8)

                Option.MouseButton1Click:Connect(function()

                    Selected = option

                    Button.Text =
                        (cfg.Title or "Dropdown")
                        .. " : "
                        .. tostring(option)

                    Open = false

                    TweenService:Create(
                        Holder,
                        TweenInfo.new(0.2),
                        {
                            Size = UDim2.new(1,-8,0,42)
                        }
                    ):Play()

                    if cfg.Callback then
                        cfg.Callback(option)
                    end
                end)
            end
        end

        return Tab
    end

    return Window
end

return GloomUI
