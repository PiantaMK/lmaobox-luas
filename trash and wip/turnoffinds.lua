local initial_ch = gui.GetValue("Crit Hack Indicator Size")
local initial_dt = gui.GetValue("Double Tap Indicator Size")

gui.SetValue("Crit Hack Indicator Size", 0)
gui.SetValue("Double Tap Indicator Size", 0)

callbacks.Register("Unload", function()
    gui.SetValue("Crit Hack Indicator Size", initial_ch)
    gui.SetValue("Double Tap Indicator Size", initial_dt)
end)